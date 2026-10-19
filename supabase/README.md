# Tallybook Supabase Database & Testing Guide

This directory contains database migrations, seed data, and SQL test suites for Tallybook.

## Structure

- `migrations/20261019000001_core_schema.sql`: Core schema, functions, triggers, and Row Level Security (RLS) policies.
- `seed.sql`: Built-in templates for the 5 PRD business categories (Bakery, Crochet, Apparel, Woodworking, Events).
- `tests/phase2_rls_test.sql`: Automated SQL test script validating tenant isolation, money recalculations, sequential order numbering, and employee permissions.

---

## How to Run Migrations and Tests

### 1. Local Development (with Docker)

If you have Docker Desktop running:

```bash
# 1. Start local Supabase containers
supabase start

# 2. Reset database and run all migrations + seed.sql
supabase db reset

# 3. Run the SQL test suite
supabase db execute --file supabase/tests/phase2_rls_test.sql
```

### 2. Remote Supabase Project

If testing against your linked remote Supabase project:

```bash
# 1. Link your remote Supabase project (if not already linked)
supabase link --project-ref <your-project-ref>

# 2. Push migrations to remote database
supabase db push

# 3. Seed built-in templates
supabase db execute --file supabase/seed.sql

# 4. Run the Phase 2 test suite
supabase db execute --file supabase/tests/phase2_rls_test.sql
```

Alternatively, open your **Supabase Dashboard -> SQL Editor**, paste the contents of `supabase/tests/phase2_rls_test.sql`, and click **Run**. The transaction executes all assertions inside a `ROLLBACK` block, leaving your database completely clean while outputting test confirmations.

