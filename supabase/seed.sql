-- ==============================================================================
-- Tallybook Seed Data: Built-in Templates for 5 Business Categories
-- ==============================================================================

INSERT INTO public.templates (id, business_id, name, business_type, version, is_builtin, columns)
VALUES
  -- 1. Custom Bakery & Confectionery
  (
    '11111111-1111-1111-1111-111111111001',
    NULL,
    'Custom Bakery & Confectionery',
    'Food & Baking',
    1,
    TRUE,
    '[
      {"id": "col_customer", "label": "Customer Name", "type": "text", "required": true, "is_formula": false},
      {"id": "col_contact", "label": "Contact / Phone", "type": "tel", "required": false, "is_formula": false},
      {"id": "col_item_desc", "label": "Cake / Item Description", "type": "long_text", "required": true, "is_formula": false},
      {"id": "col_flavor", "label": "Flavor / Filling", "type": "dropdown", "required": false, "is_formula": false, "options": ["Vanilla Bean", "Dutch Chocolate", "Red Velvet", "Salted Caramel", "Lemon Curd", "Strawberry Shortcake", "Custom Mixed"]},
      {"id": "col_tiers", "label": "Tiers / Servings", "type": "number", "required": false, "is_formula": false},
      {"id": "col_pickup_time", "label": "Pickup Slot / Delivery Time", "type": "time", "required": false, "is_formula": false},
      {"id": "col_dietary", "label": "Dietary Flags", "type": "dropdown", "required": false, "is_formula": false, "options": ["Standard", "Gluten-Free", "Vegan", "Nut-Free", "Eggless", "Sugar-Free"]},
      {"id": "col_deposit_paid", "label": "Deposit Paid", "type": "currency", "required": false, "is_formula": false},
      {"id": "col_balance_pending", "label": "Balance Pending", "type": "formula", "required": false, "is_formula": true, "formula_expr": "selling_price - paid_amount"}
    ]'::jsonb
  ),

  -- 2. Crochet & Knitwear Studio
  (
    '11111111-1111-1111-1111-111111111002',
    NULL,
    'Crochet & Knitwear Studio',
    'Handmade Crafts',
    1,
    TRUE,
    '[
      {"id": "col_customer", "label": "Customer Name", "type": "text", "required": true, "is_formula": false},
      {"id": "col_pattern", "label": "Pattern / Item Style", "type": "text", "required": true, "is_formula": false},
      {"id": "col_yarn_details", "label": "Yarn Brand / Colorway", "type": "text", "required": false, "is_formula": false},
      {"id": "col_yarn_cost", "label": "Yarn Skeins Cost", "type": "currency", "required": false, "is_formula": false},
      {"id": "col_hours", "label": "Labor Hours Spent", "type": "number", "required": false, "is_formula": false},
      {"id": "col_hourly_rate", "label": "Hourly Rate", "type": "currency", "required": false, "is_formula": false},
      {"id": "col_production_stage", "label": "Production Stage", "type": "dropdown", "required": false, "is_formula": false, "options": ["Yarn Sourced", "Started", "Body Done", "Finishing / Blocking", "Packaged", "Delivered"]},
      {"id": "col_total_profit", "label": "Calculated Profit", "type": "formula", "required": false, "is_formula": true, "formula_expr": "selling_price - total_cost"}
    ]'::jsonb
  ),

  -- 3. Boutique Apparel & Tailoring
  (
    '11111111-1111-1111-1111-111111111003',
    NULL,
    'Boutique Apparel & Tailoring',
    'Fashion & Textiles',
    1,
    TRUE,
    '[
      {"id": "col_customer", "label": "Client Name", "type": "text", "required": true, "is_formula": false},
      {"id": "col_garment_type", "label": "Garment Type", "type": "dropdown", "required": true, "is_formula": false, "options": ["Evening Gown", "Bespoke Suit", "Traditional Wear", "Blouse / Top", "Trousers", "Alteration / Repair"]},
      {"id": "col_measurements", "label": "Measurements Reference", "type": "long_text", "required": false, "is_formula": false},
      {"id": "col_fabric_cost", "label": "Fabric & Linings Cost", "type": "currency", "required": false, "is_formula": false},
      {"id": "col_notions_cost", "label": "Notions / Buttons / Zippers", "type": "currency", "required": false, "is_formula": false},
      {"id": "col_fitting_date", "label": "First Fitting Date", "type": "date", "required": false, "is_formula": false},
      {"id": "col_fitting_status", "label": "Fitting Status", "type": "dropdown", "required": false, "is_formula": false, "options": ["Pending Trial", "Adjustments Needed", "Approved", "Finalized"]}
    ]'::jsonb
  ),

  -- 4. Custom Woodwork & Carpentry
  (
    '11111111-1111-1111-1111-111111111004',
    NULL,
    'Custom Woodwork & Carpentry',
    'Craftsmanship & Goods',
    1,
    TRUE,
    '[
      {"id": "col_customer", "label": "Client Name", "type": "text", "required": true, "is_formula": false},
      {"id": "col_timber_species", "label": "Timber / Wood Species", "type": "dropdown", "required": false, "is_formula": false, "options": ["White Oak", "Black Walnut", "Hard Maple", "Teak", "Cherry", "Pine / Softwood", "Plywood / MDF"]},
      {"id": "col_dimensions", "label": "Dimensions (L x W x H)", "type": "text", "required": false, "is_formula": false},
      {"id": "col_hardware_cost", "label": "Hardware / Fasteners / Finish", "type": "currency", "required": false, "is_formula": false},
      {"id": "col_lumber_cost", "label": "Lumber Board Feet Cost", "type": "currency", "required": false, "is_formula": false},
      {"id": "col_finish_type", "label": "Finish", "type": "dropdown", "required": false, "is_formula": false, "options": ["Natural Oil", "Matte Polyurethane", "Satin Varnish", "Stained", "Painted"]},
      {"id": "col_install_required", "label": "Installation Included", "type": "checkbox", "required": false, "is_formula": false},
      {"id": "col_margin_pct", "label": "Profit Margin %", "type": "formula", "required": false, "is_formula": true, "formula_expr": "ROUND((profit / selling_price) * 100, 2)"}
    ]'::jsonb
  ),

  -- 5. Event Decor & Floral Styling
  (
    '11111111-1111-1111-1111-111111111005',
    NULL,
    'Event Decor & Floral Styling',
    'Event Services',
    1,
    TRUE,
    '[
      {"id": "col_customer", "label": "Host / Client Name", "type": "text", "required": true, "is_formula": false},
      {"id": "col_event_type", "label": "Event Type", "type": "dropdown", "required": true, "is_formula": false, "options": ["Wedding", "Corporate Gala", "Birthday Party", "Baby Shower", "Anniversary", "Pop-up / Exhibition"]},
      {"id": "col_venue", "label": "Venue Location & Address", "type": "text", "required": false, "is_formula": false},
      {"id": "col_call_time", "label": "Setup Call Time", "type": "time", "required": false, "is_formula": false},
      {"id": "col_stem_count", "label": "Floral Wholesale Cost", "type": "currency", "required": false, "is_formula": false},
      {"id": "col_rental_cost", "label": "Rental Vessels / Arches", "type": "currency", "required": false, "is_formula": false},
      {"id": "col_strike_time", "label": "Teardown / Strike Time", "type": "time", "required": false, "is_formula": false},
      {"id": "col_setup_status", "label": "Setup Status", "type": "dropdown", "required": false, "is_formula": false, "options": ["Planned", "Packed", "En Route", "Decorating", "Complete", "Struck"]}
    ]'::jsonb
  )
ON CONFLICT (id) DO UPDATE
SET
  name = EXCLUDED.name,
  business_type = EXCLUDED.business_type,
  version = EXCLUDED.version,
  columns = EXCLUDED.columns,
  is_builtin = EXCLUDED.is_builtin,
  updated_at = NOW();

