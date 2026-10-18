# Standing Rules for Tallybook

- Work on ONLY the current phase. Never start later phases.
- Inspect existing code before changing anything. Never rewrite unrelated files. Preserve working code.
- Create only files the phase needs. No placeholder files.
- Never trust the client for authorization, businessId, role, or money totals. Tenant isolation is enforced by Supabase RLS.
- Never put secrets in frontend code. Only the anon key is allowed client-side. The service-role key lives only in Edge Function secrets.
- No eval or new Function for formulas. No plaintext passwords/PINs. No tokens or secrets in QR codes.
- One database table per concept, never per month. All DB changes go in numbered files in supabase/migrations.
- Run lint, tests and build before finishing. Report errors honestly, never hide them.
- At the end: list files changed, explain what you did in simple words, list what the human must do manually, then STOP.
- Design: follow src/styles/tokens.css (Ink and Marigold). No generic blue SaaS look.
