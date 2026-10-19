-- ==============================================================================
-- Tallybook Schema Migration: 20261019000001_core_schema.sql
-- Phase 2: Tables, Functions, Triggers, RLS Policies, and Storage
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. HELPER FUNCTIONS: updated_at trigger function
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- ==============================================================================
-- 3. TABLES DEFINITION
-- ==============================================================================

-- 3.1 businesses table
CREATE TABLE IF NOT EXISTS public.businesses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  logo_path TEXT,
  owner_name TEXT,
  started_on DATE DEFAULT CURRENT_DATE,
  type TEXT,
  description TEXT,
  model TEXT,
  address TEXT,
  country TEXT DEFAULT 'US',
  currency TEXT NOT NULL DEFAULT 'USD',
  timezone TEXT DEFAULT 'UTC',
  contact_email TEXT,
  phone TEXT,
  instagram_username TEXT,
  instagram_url TEXT,
  facebook_username TEXT,
  facebook_url TEXT,
  default_status TEXT DEFAULT 'New',
  default_template_id UUID,
  order_prefix TEXT NOT NULL DEFAULT 'ORD',
  order_padding INT NOT NULL DEFAULT 4,
  next_seq BIGINT NOT NULL DEFAULT 1,
  margin_warn_pct NUMERIC(5,2) DEFAULT 20.00,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_businesses_updated_at
BEFORE UPDATE ON public.businesses
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 3.2 members table
CREATE TABLE IF NOT EXISTS public.members (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  business_id UUID NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('owner', 'employee')),
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'disabled')),
  display_name TEXT NOT NULL,
  permissions JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_members_business_id ON public.members(business_id);
CREATE INDEX IF NOT EXISTS idx_members_status ON public.members(status);

CREATE TRIGGER trg_members_updated_at
BEFORE UPDATE ON public.members
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 3.3 templates table (business_id is NULL for built-in templates)
CREATE TABLE IF NOT EXISTS public.templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID REFERENCES public.businesses(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  business_type TEXT NOT NULL,
  version INT NOT NULL DEFAULT 1,
  columns JSONB NOT NULL DEFAULT '[]'::jsonb,
  is_builtin BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_templates_business_id ON public.templates(business_id);
CREATE INDEX IF NOT EXISTS idx_templates_builtin ON public.templates(is_builtin);

CREATE TRIGGER trg_templates_updated_at
BEFORE UPDATE ON public.templates
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Add foreign key constraint for default_template_id now that templates table exists
ALTER TABLE public.businesses
  DROP CONSTRAINT IF EXISTS fk_businesses_default_template,
  ADD CONSTRAINT fk_businesses_default_template
  FOREIGN KEY (default_template_id) REFERENCES public.templates(id) ON DELETE SET NULL;

-- 3.4 sheets table (one shared sheets table, never per-month tables)
CREATE TABLE IF NOT EXISTS public.sheets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  year INT NOT NULL,
  month INT NOT NULL CHECK (month BETWEEN 1 AND 12),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  template_id UUID REFERENCES public.templates(id) ON DELETE SET NULL,
  schema_snapshot JSONB NOT NULL DEFAULT '[]'::jsonb,
  schema_version INT NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sheets_business_year_month ON public.sheets(business_id, year, month);

CREATE TRIGGER trg_sheets_updated_at
BEFORE UPDATE ON public.sheets
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 3.5 orders table
CREATE TABLE IF NOT EXISTS public.orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  sheet_id UUID NOT NULL REFERENCES public.sheets(id) ON DELETE CASCADE,
  seq BIGINT NOT NULL,
  order_number TEXT NOT NULL,
  order_date DATE NOT NULL DEFAULT CURRENT_DATE,
  due_date DATE,
  customer_name TEXT NOT NULL,
  customer_contact TEXT,
  details TEXT,
  quantity NUMERIC(12,2) NOT NULL DEFAULT 1,
  selling_price NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  material_cost NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  delivery_cost NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  other_cost NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  total_cost NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  profit NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  order_status TEXT NOT NULL DEFAULT 'New',
  payment_status TEXT NOT NULL DEFAULT 'Unpaid',
  paid_amount NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  pending_amount NUMERIC(12,2) NOT NULL DEFAULT 0.00,
  custom JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  row_version INT NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_orders_business_seq UNIQUE (business_id, seq)
);

CREATE INDEX IF NOT EXISTS idx_orders_sheet_id ON public.orders(sheet_id);
CREATE INDEX IF NOT EXISTS idx_orders_business_id ON public.orders(business_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON public.orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_customer_name ON public.orders(customer_name);

CREATE TRIGGER trg_orders_updated_at
BEFORE UPDATE ON public.orders
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 3.6 saved_views table
CREATE TABLE IF NOT EXISTS public.saved_views (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  config JSONB NOT NULL DEFAULT '{}'::jsonb,
  shared BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_saved_views_business ON public.saved_views(business_id);

CREATE TRIGGER trg_saved_views_updated_at
BEFORE UPDATE ON public.saved_views
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 3.7 activities table (Append-only)
CREATE TABLE IF NOT EXISTS public.activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  actor_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id UUID,
  old_values JSONB,
  new_values JSONB,
  meta JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_activities_business_date ON public.activities(business_id, created_at DESC);

-- 3.8 Future infrastructure tables: trusted_devices, pairing_challenges, import_jobs
CREATE TABLE IF NOT EXISTS public.trusted_devices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  device_name TEXT NOT NULL,
  device_fingerprint TEXT NOT NULL,
  last_used_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_trusted_devices_updated_at
BEFORE UPDATE ON public.trusted_devices
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE IF NOT EXISTS public.pairing_challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  challenge_token_hash TEXT NOT NULL,
  short_code TEXT NOT NULL,
  device_info JSONB DEFAULT '{}'::jsonb,
  ip_address TEXT,
  expires_at TIMESTAMPTZ NOT NULL,
  used BOOLEAN NOT NULL DEFAULT FALSE,
  approved_by UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.import_jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_id UUID NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  filename TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
  total_rows INT DEFAULT 0,
  imported_rows INT DEFAULT 0,
  failed_rows INT DEFAULT 0,
  errors JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_import_jobs_updated_at
BEFORE UPDATE ON public.import_jobs
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ==============================================================================
-- 4. SECURITY DEFINER FUNCTIONS
-- ==============================================================================

-- 4.1 current_business_id(): gets the active business_id for auth.uid()
CREATE OR REPLACE FUNCTION public.current_business_id()
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
DECLARE
  v_business_id UUID;
BEGIN
  IF auth.uid() IS NULL THEN
    RETURN NULL;
  END IF;

  SELECT m.business_id INTO v_business_id
  FROM public.members m
  WHERE m.user_id = auth.uid()
    AND m.status = 'active'
  LIMIT 1;

  RETURN v_business_id;
END;
$$;

-- 4.2 has_perm(text): checks permission for auth.uid()
-- Owner implicitly has all permissions.
CREATE OR REPLACE FUNCTION public.has_perm(p_permission TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
DECLARE
  v_role TEXT;
  v_perms JSONB;
BEGIN
  IF auth.uid() IS NULL THEN
    RETURN FALSE;
  END IF;

  SELECT m.role, m.permissions INTO v_role, v_perms
  FROM public.members m
  WHERE m.user_id = auth.uid()
    AND m.status = 'active'
  LIMIT 1;

  IF v_role IS NULL THEN
    RETURN FALSE;
  END IF;

  -- Owner implicitly has all permissions
  IF v_role = 'owner' THEN
    RETURN TRUE;
  END IF;

  -- Employee checks boolean key in permissions jsonb
  IF v_perms ? p_permission AND (v_perms ->> p_permission)::boolean = TRUE THEN
    RETURN TRUE;
  END IF;

  RETURN FALSE;
END;
$$;

-- 4.3 create_business(...): creates business and owner member exactly once
CREATE OR REPLACE FUNCTION public.create_business(
  p_name TEXT,
  p_owner_name TEXT,
  p_currency TEXT DEFAULT 'USD',
  p_order_prefix TEXT DEFAULT 'ORD',
  p_order_padding INT DEFAULT 4,
  p_type TEXT DEFAULT NULL,
  p_country TEXT DEFAULT 'US',
  p_timezone TEXT DEFAULT 'UTC'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID;
  v_existing_member RECORD;
  v_business_id UUID;
BEGIN
  v_user_id := auth.uid();
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required to create a business.';
  END IF;

  -- Prevent user from creating multiple businesses if already an active member
  SELECT * INTO v_existing_member
  FROM public.members
  WHERE user_id = v_user_id;

  IF v_existing_member.user_id IS NOT NULL THEN
    RAISE EXCEPTION 'User is already associated with an existing business.';
  END IF;

  -- Insert new business
  INSERT INTO public.businesses (
    name,
    owner_name,
    currency,
    order_prefix,
    order_padding,
    type,
    country,
    timezone
  ) VALUES (
    p_name,
    p_owner_name,
    COALESCE(p_name, 'USD'),
    COALESCE(p_order_prefix, 'ORD'),
    COALESCE(p_order_padding, 4),
    p_type,
    COALESCE(p_country, 'US'),
    COALESCE(p_timezone, 'UTC')
  ) RETURNING id INTO v_business_id;

  -- Insert owner membership
  INSERT INTO public.members (
    user_id,
    business_id,
    role,
    status,
    display_name,
    permissions
  ) VALUES (
    v_user_id,
    v_business_id,
    'owner',
    'active',
    COALESCE(p_owner_name, 'Owner'),
    jsonb_build_object(
      'view_orders', true,
      'create_orders', true,
      'edit_orders', true,
      'delete_orders', true,
      'manage_templates', true,
      'view_analytics', true,
      'import_export', true,
      'view_activity', true,
      'manage_employees', true,
      'manage_settings', true
    )
  );

  RETURN v_business_id;
END;
$$;

-- ==============================================================================
-- 5. BUSINESS TRIGGERS FOR ORDERS (Money Recompute, Business ID, Sequence Atomicity)
-- ==============================================================================

-- 5.1 BEFORE INSERT / UPDATE on orders: recompute money and force business_id
CREATE OR REPLACE FUNCTION public.trg_orders_calc_and_protect()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_current_bid UUID;
BEGIN
  -- Always force business_id = current_business_id() (client value ignored)
  -- For service-role or triggers without auth context, preserve existing business_id on update
  v_current_bid := public.current_business_id();
  IF v_current_bid IS NOT NULL THEN
    NEW.business_id := v_current_bid;
  ELSIF TG_OP = 'INSERT' AND NEW.business_id IS NULL THEN
    RAISE EXCEPTION 'Cannot insert order without active business context.';
  END IF;

  -- Recompute money columns: treating NULL as 0
  -- total_cost = material + delivery + other
  NEW.material_cost := COALESCE(NEW.material_cost, 0.00);
  NEW.delivery_cost := COALESCE(NEW.delivery_cost, 0.00);
  NEW.other_cost := COALESCE(NEW.other_cost, 0.00);
  NEW.selling_price := COALESCE(NEW.selling_price, 0.00);
  NEW.paid_amount := COALESCE(NEW.paid_amount, 0.00);

  NEW.total_cost := NEW.material_cost + NEW.delivery_cost + NEW.other_cost;
  NEW.profit := NEW.selling_price - NEW.total_cost;
  NEW.pending_amount := NEW.selling_price - NEW.paid_amount;

  -- Maintain audit user references & row_version
  IF TG_OP = 'INSERT' THEN
    NEW.created_by := COALESCE(auth.uid(), NEW.created_by);
    NEW.updated_by := COALESCE(auth.uid(), NEW.updated_by);
  ELSIF TG_OP = 'UPDATE' THEN
    NEW.updated_by := COALESCE(auth.uid(), NEW.updated_by);
    NEW.row_version := OLD.row_version + 1;
  END IF;

  RETURN NEW;
END;
$$;

-- 5.2 BEFORE INSERT on orders: assigns seq atomically & formats order_number
CREATE OR REPLACE FUNCTION public.trg_orders_assign_seq()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_prefix TEXT;
  v_padding INT;
  v_assigned_seq BIGINT;
BEGIN
  -- Atomically increment and get next_seq from businesses table
  UPDATE public.businesses
  SET next_seq = businesses.next_seq + 1
  WHERE id = NEW.business_id
  RETURNING (businesses.next_seq - 1), businesses.order_prefix, businesses.order_padding
  INTO v_assigned_seq, v_prefix, v_padding;

  IF v_assigned_seq IS NULL THEN
    RAISE EXCEPTION 'Business % does not exist for order assignment.', NEW.business_id;
  END IF;

  NEW.seq := v_assigned_seq;
  NEW.order_number := COALESCE(v_prefix, 'ORD') || '-' || LPAD(v_assigned_seq::text, COALESCE(v_padding, 4), '0');

  RETURN NEW;
END;
$$;

-- Bind triggers to orders (Ordering: calc_and_protect sets/verifies business_id first, then assign_seq runs)
DROP TRIGGER IF EXISTS trg_1_orders_calc ON public.orders;
CREATE TRIGGER trg_1_orders_calc
BEFORE INSERT OR UPDATE ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.trg_orders_calc_and_protect();

DROP TRIGGER IF EXISTS trg_2_orders_seq ON public.orders;
CREATE TRIGGER trg_2_orders_seq
BEFORE INSERT ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.trg_orders_assign_seq();

-- ==============================================================================
-- 6. ACTIVITY LOGGING TRIGGERS (Append-only on orders, templates, sheets, members, businesses)
-- ==============================================================================

CREATE OR REPLACE FUNCTION public.trg_log_activity()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_business_id UUID;
  v_entity_id UUID;
  v_old JSONB := NULL;
  v_new JSONB := NULL;
  v_action TEXT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    v_business_id := NEW.business_id;
    v_entity_id := NEW.id;
    v_action := 'CREATE';
    v_new := to_jsonb(NEW);
  ELSIF TG_OP = 'UPDATE' THEN
    v_business_id := NEW.business_id;
    v_entity_id := NEW.id;
    v_action := 'UPDATE';
    v_old := to_jsonb(OLD);
    v_new := to_jsonb(NEW);
  ELSIF TG_OP = 'DELETE' THEN
    v_business_id := OLD.business_id;
    v_entity_id := OLD.id;
    v_action := 'DELETE';
    v_old := to_jsonb(OLD);
  END IF;

  -- For members table, the primary key is user_id
  IF TG_TABLE_NAME = 'members' THEN
    IF TG_OP = 'DELETE' THEN
      v_entity_id := OLD.user_id;
    ELSE
      v_entity_id := NEW.user_id;
    END IF;
  END IF;

  -- For businesses table, business_id is its own id
  IF TG_TABLE_NAME = 'businesses' THEN
    IF TG_OP = 'DELETE' THEN
      v_business_id := OLD.id;
    ELSE
      v_business_id := NEW.id;
    END IF;
  END IF;

  IF v_business_id IS NOT NULL THEN
    INSERT INTO public.activities (
      business_id,
      actor_id,
      action,
      entity_type,
      entity_id,
      old_values,
      new_values,
      meta
    ) VALUES (
      v_business_id,
      auth.uid(),
      v_action,
      TG_TABLE_NAME,
      v_entity_id,
      v_old,
      v_new,
      jsonb_build_object('table', TG_TABLE_NAME, 'op', TG_OP)
    );
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS trg_act_orders ON public.orders;
CREATE TRIGGER trg_act_orders AFTER INSERT OR UPDATE OR DELETE ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.trg_log_activity();

DROP TRIGGER IF EXISTS trg_act_templates ON public.templates;
CREATE TRIGGER trg_act_templates AFTER INSERT OR UPDATE OR DELETE ON public.templates
FOR EACH ROW EXECUTE FUNCTION public.trg_log_activity();

DROP TRIGGER IF EXISTS trg_act_sheets ON public.sheets;
CREATE TRIGGER trg_act_sheets AFTER INSERT OR UPDATE OR DELETE ON public.sheets
FOR EACH ROW EXECUTE FUNCTION public.trg_log_activity();

DROP TRIGGER IF EXISTS trg_act_members ON public.members;
CREATE TRIGGER trg_act_members AFTER INSERT OR UPDATE OR DELETE ON public.members
FOR EACH ROW EXECUTE FUNCTION public.trg_log_activity();

DROP TRIGGER IF EXISTS trg_act_businesses ON public.businesses;
CREATE TRIGGER trg_act_businesses AFTER UPDATE ON public.businesses
FOR EACH ROW EXECUTE FUNCTION public.trg_log_activity();

-- ==============================================================================
-- 7. ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

-- Enable RLS on all tables
ALTER TABLE public.businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sheets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trusted_devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pairing_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.import_jobs ENABLE ROW LEVEL SECURITY;

-- 7.1 businesses policies
DROP POLICY IF EXISTS "Users can view their own business" ON public.businesses;
CREATE POLICY "Users can view their own business"
ON public.businesses
FOR SELECT
USING (id = public.current_business_id());

DROP POLICY IF EXISTS "Owners can update business settings" ON public.businesses;
CREATE POLICY "Owners can update business settings"
ON public.businesses
FOR UPDATE
USING (id = public.current_business_id() AND public.has_perm('manage_settings'))
WITH CHECK (id = public.current_business_id() AND public.has_perm('manage_settings'));

-- 7.2 members policies
-- Employees never see member rows beyond their own unless they have manage_employees permission.
DROP POLICY IF EXISTS "View members policy" ON public.members;
CREATE POLICY "View members policy"
ON public.members
FOR SELECT
USING (
  business_id = public.current_business_id() AND (
    user_id = auth.uid() OR public.has_perm('manage_employees')
  )
);

DROP POLICY IF EXISTS "Manage members insert" ON public.members;
CREATE POLICY "Manage members insert"
ON public.members
FOR INSERT
WITH CHECK (
  business_id = public.current_business_id() AND public.has_perm('manage_employees')
);

DROP POLICY IF EXISTS "Manage members update" ON public.members;
CREATE POLICY "Manage members update"
ON public.members
FOR UPDATE
USING (
  business_id = public.current_business_id() AND public.has_perm('manage_employees')
)
WITH CHECK (
  business_id = public.current_business_id() AND public.has_perm('manage_employees')
);

DROP POLICY IF EXISTS "Manage members delete" ON public.members;
CREATE POLICY "Manage members delete"
ON public.members
FOR DELETE
USING (
  business_id = public.current_business_id() AND public.has_perm('manage_employees')
);

-- 7.3 templates policies
-- Built-in templates (is_builtin = true or business_id is NULL) are readable by any authenticated user.
-- Custom templates are scoped to business_id.
DROP POLICY IF EXISTS "Select templates policy" ON public.templates;
CREATE POLICY "Select templates policy"
ON public.templates
FOR SELECT
USING (
  is_builtin = TRUE
  OR business_id IS NULL
  OR business_id = public.current_business_id()
);

DROP POLICY IF EXISTS "Insert templates policy" ON public.templates;
CREATE POLICY "Insert templates policy"
ON public.templates
FOR INSERT
WITH CHECK (
  business_id = public.current_business_id()
  AND public.has_perm('manage_templates')
  AND is_builtin = FALSE
);

DROP POLICY IF EXISTS "Update templates policy" ON public.templates;
CREATE POLICY "Update templates policy"
ON public.templates
FOR UPDATE
USING (
  business_id = public.current_business_id()
  AND public.has_perm('manage_templates')
  AND is_builtin = FALSE
)
WITH CHECK (
  business_id = public.current_business_id()
  AND public.has_perm('manage_templates')
  AND is_builtin = FALSE
);

DROP POLICY IF EXISTS "Delete templates policy" ON public.templates;
CREATE POLICY "Delete templates policy"
ON public.templates
FOR DELETE
USING (
  business_id = public.current_business_id()
  AND public.has_perm('manage_templates')
  AND is_builtin = FALSE
);

-- 7.4 sheets policies
DROP POLICY IF EXISTS "Select sheets policy" ON public.sheets;
CREATE POLICY "Select sheets policy"
ON public.sheets
FOR SELECT
USING (business_id = public.current_business_id());

DROP POLICY IF EXISTS "Insert sheets policy" ON public.sheets;
CREATE POLICY "Insert sheets policy"
ON public.sheets
FOR INSERT
WITH CHECK (
  business_id = public.current_business_id()
  AND public.has_perm('manage_templates')
);

DROP POLICY IF EXISTS "Update sheets policy" ON public.sheets;
CREATE POLICY "Update sheets policy"
ON public.sheets
FOR UPDATE
USING (
  business_id = public.current_business_id()
  AND public.has_perm('manage_templates')
)
WITH CHECK (
  business_id = public.current_business_id()
  AND public.has_perm('manage_templates')
);

DROP POLICY IF EXISTS "Delete sheets policy" ON public.sheets;
CREATE POLICY "Delete sheets policy"
ON public.sheets
FOR DELETE
USING (
  business_id = public.current_business_id()
  AND public.has_perm('manage_templates')
);

-- 7.5 orders policies
DROP POLICY IF EXISTS "Select orders policy" ON public.orders;
CREATE POLICY "Select orders policy"
ON public.orders
FOR SELECT
USING (
  business_id = public.current_business_id()
  AND public.has_perm('view_orders')
);

DROP POLICY IF EXISTS "Insert orders policy" ON public.orders;
CREATE POLICY "Insert orders policy"
ON public.orders
FOR INSERT
WITH CHECK (
  business_id = public.current_business_id()
  AND public.has_perm('create_orders')
);

DROP POLICY IF EXISTS "Update orders policy" ON public.orders;
CREATE POLICY "Update orders policy"
ON public.orders
FOR UPDATE
USING (
  business_id = public.current_business_id()
  AND public.has_perm('edit_orders')
)
WITH CHECK (
  business_id = public.current_business_id()
  AND public.has_perm('edit_orders')
);

DROP POLICY IF EXISTS "Delete orders policy" ON public.orders;
CREATE POLICY "Delete orders policy"
ON public.orders
FOR DELETE
USING (
  business_id = public.current_business_id()
  AND public.has_perm('delete_orders')
);

-- 7.6 saved_views policies
DROP POLICY IF EXISTS "Select saved_views policy" ON public.saved_views;
CREATE POLICY "Select saved_views policy"
ON public.saved_views
FOR SELECT
USING (
  business_id = public.current_business_id()
  AND (created_by = auth.uid() OR shared = TRUE)
);

DROP POLICY IF EXISTS "Insert saved_views policy" ON public.saved_views;
CREATE POLICY "Insert saved_views policy"
ON public.saved_views
FOR INSERT
WITH CHECK (
  business_id = public.current_business_id()
  AND created_by = auth.uid()
);

DROP POLICY IF EXISTS "Update saved_views policy" ON public.saved_views;
CREATE POLICY "Update saved_views policy"
ON public.saved_views
FOR UPDATE
USING (
  business_id = public.current_business_id()
  AND created_by = auth.uid()
)
WITH CHECK (
  business_id = public.current_business_id()
  AND created_by = auth.uid()
);

DROP POLICY IF EXISTS "Delete saved_views policy" ON public.saved_views;
CREATE POLICY "Delete saved_views policy"
ON public.saved_views
FOR DELETE
USING (
  business_id = public.current_business_id()
  AND created_by = auth.uid()
);

-- 7.7 activities policies (Append-only: SELECT and INSERT only, NO update/delete)
DROP POLICY IF EXISTS "Select activities policy" ON public.activities;
CREATE POLICY "Select activities policy"
ON public.activities
FOR SELECT
USING (
  business_id = public.current_business_id()
  AND public.has_perm('view_activity')
);

DROP POLICY IF EXISTS "Insert activities policy" ON public.activities;
CREATE POLICY "Insert activities policy"
ON public.activities
FOR INSERT
WITH CHECK (
  business_id = public.current_business_id()
);

-- 7.8 trusted_devices & import_jobs policies
DROP POLICY IF EXISTS "Trusted devices policy" ON public.trusted_devices;
CREATE POLICY "Trusted devices policy"
ON public.trusted_devices
FOR ALL
USING (
  business_id = public.current_business_id()
  AND user_id = auth.uid()
);

DROP POLICY IF EXISTS "Import jobs select policy" ON public.import_jobs;
CREATE POLICY "Import jobs select policy"
ON public.import_jobs
FOR SELECT
USING (
  business_id = public.current_business_id()
  AND public.has_perm('import_export')
);

DROP POLICY IF EXISTS "Import jobs insert policy" ON public.import_jobs;
CREATE POLICY "Import jobs insert policy"
ON public.import_jobs
FOR INSERT
WITH CHECK (
  business_id = public.current_business_id()
  AND public.has_perm('import_export')
);

-- ==============================================================================
-- 8. STORAGE BUCKET 'logos' (Private per business folder)
-- ==============================================================================

INSERT INTO storage.buckets (id, name, public)
VALUES ('logos', 'logos', FALSE)
ON CONFLICT (id) DO NOTHING;

-- RLS for logos storage
DROP POLICY IF EXISTS "Users can view logos in their business folder" ON storage.objects;
CREATE POLICY "Users can view logos in their business folder"
ON storage.objects
FOR SELECT
USING (
  bucket_id = 'logos'
  AND (storage.foldername(name))[1] = public.current_business_id()::text
);

DROP POLICY IF EXISTS "Owners can upload logos to their business folder" ON storage.objects;
CREATE POLICY "Owners can upload logos to their business folder"
ON storage.objects
FOR INSERT
WITH CHECK (
  bucket_id = 'logos'
  AND (storage.foldername(name))[1] = public.current_business_id()::text
  AND public.has_perm('manage_settings')
);

DROP POLICY IF EXISTS "Owners can update logos in their business folder" ON storage.objects;
CREATE POLICY "Owners can update logos in their business folder"
ON storage.objects
FOR UPDATE
USING (
  bucket_id = 'logos'
  AND (storage.foldername(name))[1] = public.current_business_id()::text
  AND public.has_perm('manage_settings')
);

DROP POLICY IF EXISTS "Owners can delete logos in their business folder" ON storage.objects;
CREATE POLICY "Owners can delete logos in their business folder"
ON storage.objects
FOR DELETE
USING (
  bucket_id = 'logos'
  AND (storage.foldername(name))[1] = public.current_business_id()::text
  AND public.has_perm('manage_settings')
);

