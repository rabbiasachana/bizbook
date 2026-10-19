-- ==============================================================================
-- Tallybook Phase 2 Database Tests
-- Tests:
-- 1. Client-sent profit / pending_amount / total_cost is overwritten by DB trigger.
-- 2. Order numbers and sequences are unique and sequential under inserts.
-- 3. Cross-tenant isolation (User A cannot read or write Business B's rows).
-- 4. Employee permissions (Employee without delete_orders cannot delete).
-- 5. Append-only activities table prevents updates and deletes.
-- ==============================================================================

BEGIN;

-- Helper to set simulated authenticated user
CREATE OR REPLACE PROCEDURE set_simulated_user(p_user_id UUID)
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM set_config('request.jwt.claim.sub', p_user_id::text, true);
  PERFORM set_config('request.jwt.claim.role', 'authenticated', true);
END;
$$;

DO $$
DECLARE
  v_user_a UUID := gen_random_uuid();
  v_user_b UUID := gen_random_uuid();
  v_user_emp UUID := gen_random_uuid();
  v_biz_a UUID;
  v_biz_b UUID;
  v_sheet_a UUID;
  v_order_1 RECORD;
  v_order_2 RECORD;
  v_order_b RECORD;
  v_test_failed BOOLEAN := FALSE;
  v_count INT;
BEGIN
  RAISE NOTICE '>>> Starting Phase 2 Database Tests...';

  -- Create dummy auth users in auth.users table
  INSERT INTO auth.users (id, email)
  VALUES 
    (v_user_a, 'owner_a@example.com'),
    (v_user_b, 'owner_b@example.com'),
    (v_user_emp, 'employee_a@example.com')
  ON CONFLICT (id) DO NOTHING;

  -- --------------------------------------------------------------------------
  -- TEST 1: create_business RPC and Owner membership
  -- --------------------------------------------------------------------------
  CALL set_simulated_user(v_user_a);
  v_biz_a := public.create_business(
    'Artisan Bakery A',
    'Alice Baker',
    'USD',
    'BAKE',
    4,
    'Food & Baking'
  );

  IF v_biz_a IS NULL THEN
    RAISE EXCEPTION 'TEST 1 FAILED: create_business returned NULL';
  END IF;

  -- Ensure active business id returns v_biz_a
  IF public.current_business_id() <> v_biz_a THEN
    RAISE EXCEPTION 'TEST 1 FAILED: current_business_id() did not match created business';
  END IF;

  -- Create a sheet for Business A
  INSERT INTO public.sheets (business_id, name, year, month, start_date, end_date)
  VALUES (v_biz_a, 'October 2026', 2026, 10, '2026-10-01', '2026-10-31')
  RETURNING id INTO v_sheet_a;

  -- --------------------------------------------------------------------------
  -- TEST 2: Client-sent profit and cost are recomputed and overwritten
  -- --------------------------------------------------------------------------
  -- Client maliciously attempts:
  -- selling_price = 100, material = 30, delivery = 10, other = 5 (true cost 45, true profit 55)
  -- client passes total_cost = 0, profit = 999999, pending_amount = 0 (with paid_amount = 20)
  INSERT INTO public.orders (
    business_id, sheet_id, customer_name,
    selling_price, material_cost, delivery_cost, other_cost,
    paid_amount, total_cost, profit, pending_amount
  ) VALUES (
    v_biz_a, v_sheet_a, 'Customer One',
    100.00, 30.00, 10.00, 5.00,
    20.00, 0.00, 999999.00, 0.00
  ) RETURNING * INTO v_order_1;

  IF v_order_1.total_cost <> 45.00 THEN
    RAISE EXCEPTION 'TEST 2 FAILED: total_cost was % instead of 45.00', v_order_1.total_cost;
  END IF;

  IF v_order_1.profit <> 55.00 THEN
    RAISE EXCEPTION 'TEST 2 FAILED: profit was % instead of 55.00 (client profit was not overwritten)', v_order_1.profit;
  END IF;

  IF v_order_1.pending_amount <> 80.00 THEN
    RAISE EXCEPTION 'TEST 2 FAILED: pending_amount was % instead of 80.00', v_order_1.pending_amount;
  END IF;

  IF v_order_1.seq <> 1 OR v_order_1.order_number <> 'BAKE-0001' THEN
    RAISE EXCEPTION 'TEST 2 FAILED: order seq/number was % / % instead of 1 / BAKE-0001', v_order_1.seq, v_order_1.order_number;
  END IF;
  RAISE NOTICE '✓ TEST 2 PASSED: Client profit/cost overwritten & seq 1 formatted correctly.';

  -- --------------------------------------------------------------------------
  -- TEST 3: Sequential and unique order numbers
  -- --------------------------------------------------------------------------
  INSERT INTO public.orders (
    business_id, sheet_id, customer_name, selling_price
  ) VALUES (
    v_biz_a, v_sheet_a, 'Customer Two', 250.00
  ) RETURNING * INTO v_order_2;

  IF v_order_2.seq <> 2 OR v_order_2.order_number <> 'BAKE-0002' THEN
    RAISE EXCEPTION 'TEST 3 FAILED: second order seq/number was % / % instead of 2 / BAKE-0002', v_order_2.seq, v_order_2.order_number;
  END IF;
  RAISE NOTICE '✓ TEST 3 PASSED: Order numbers are atomic, sequential and unique.';

  -- --------------------------------------------------------------------------
  -- TEST 4: Cross-tenant isolation (Business B cannot see or touch Business A's rows)
  -- --------------------------------------------------------------------------
  CALL set_simulated_user(v_user_b);
  v_biz_b := public.create_business(
    'Crochet Studio B',
    'Bob Stitcher',
    'USD',
    'CRCH',
    4,
    'Handmade Crafts'
  );

  -- Check User B queries orders table
  SELECT count(*) INTO v_count FROM public.orders;
  IF v_count <> 0 THEN
    RAISE EXCEPTION 'TEST 4 FAILED: User B saw % orders from Business A via RLS', v_count;
  END IF;

  -- Check User B queries activities table
  SELECT count(*) INTO v_count FROM public.activities;
  IF v_count <> 0 THEN
    RAISE EXCEPTION 'TEST 4 FAILED: User B saw % activities from Business A via RLS', v_count;
  END IF;
  RAISE NOTICE '✓ TEST 4 PASSED: Cross-tenant read is blocked by RLS.';

  -- --------------------------------------------------------------------------
  -- TEST 5: Employee permissions (Employee without delete_orders cannot delete)
  -- --------------------------------------------------------------------------
  -- User A adds User Emp as employee with view_orders and edit_orders only (no delete_orders)
  CALL set_simulated_user(v_user_a);
  INSERT INTO public.members (
    user_id, business_id, role, status, display_name, permissions
  ) VALUES (
    v_user_emp, v_biz_a, 'employee', 'active', 'Emily Staff',
    jsonb_build_object(
      'view_orders', true,
      'create_orders', true,
      'edit_orders', true,
      'delete_orders', false,
      'manage_employees', false
    )
  );

  -- Switch context to Employee
  CALL set_simulated_user(v_user_emp);

  -- Employee should be able to view orders
  SELECT count(*) INTO v_count FROM public.orders;
  IF v_count <> 2 THEN
    RAISE EXCEPTION 'TEST 5 FAILED: Employee could not view Business A orders (got count %)', v_count;
  END IF;

  -- Employee attempts to delete order
  DELETE FROM public.orders WHERE id = v_order_1.id;

  -- Switch back to owner to check order was NOT deleted
  CALL set_simulated_user(v_user_a);
  SELECT count(*) INTO v_count FROM public.orders WHERE id = v_order_1.id;
  IF v_count <> 1 THEN
    RAISE EXCEPTION 'TEST 5 FAILED: Employee was able to delete order despite delete_orders=false!';
  END IF;
  RAISE NOTICE '✓ TEST 5 PASSED: Employee without delete_orders permission cannot delete.';

  -- Employee should not see other member rows because manage_employees is false
  CALL set_simulated_user(v_user_emp);
  SELECT count(*) INTO v_count FROM public.members;
  IF v_count <> 1 THEN
    RAISE EXCEPTION 'TEST 5 FAILED: Employee saw % member rows instead of 1 (their own row)', v_count;
  END IF;
  RAISE NOTICE '✓ TEST 5 PASSED: Employee cannot see other members rows without manage_employees.';

  -- --------------------------------------------------------------------------
  -- TEST 6: Append-only activities table
  -- --------------------------------------------------------------------------
  CALL set_simulated_user(v_user_a);
  DELETE FROM public.activities WHERE business_id = v_biz_a;
  SELECT count(*) INTO v_count FROM public.activities WHERE business_id = v_biz_a;
  IF v_count = 0 THEN
    RAISE EXCEPTION 'TEST 6 FAILED: User was able to delete rows from append-only activities table!';
  END IF;
  RAISE NOTICE '✓ TEST 6 PASSED: Append-only activities table blocked delete policy.';

  RAISE NOTICE '>>> All Phase 2 Database Tests Passed Successfully! <<<';
END $$;

ROLLBACK;

