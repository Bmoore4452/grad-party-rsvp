# Graduation Party RSVP

Free, static RSVP site for Brian L. Moore's Mercer University graduation party (July 18, 2026, 4 PM · Essence Event Center · Winnsboro, SC). RSVPs requested by July 4, 2026.

**Stack:** GitHub Pages (host) · Supabase (database + auth) · vanilla HTML/JS + Tailwind via CDN
**Cost:** $0

## Live URLs

| Page | Audience | URL |
|---|---|---|
| Public RSVP form | Guests | https://bmoore4452.github.io/grad-party-rsvp/ |
| Admin dashboard | Brian, mom, sister | https://bmoore4452.github.io/grad-party-rsvp/admin.html |
| Supabase project | Brian | https://supabase.com/dashboard/project/fltcdlizijkelvolldtc |
| GitHub repo | — | https://github.com/Bmoore4452/grad-party-rsvp |

## Files

- `index.html` — public RSVP page guests submit (hero photo, party details, RSVP form, floating "Scroll to RSVP" cue)
- `admin.html` — password-protected dashboard with totals, sort/search, "contacted" checkbox, CSV export, and an owner-only delete column
- `mercer-logo.png` · `grad.jpg` — branding + hero photo
- `supabase/` — config + version-controlled SQL migrations:
  - `20260514040709_init_rsvps_table.sql` — `rsvps` table + RLS insert policy for anonymous users
  - `20260514042141_add_admin_access.sql` — `admins` whitelist table, `contacted` tracking columns, admin SELECT/UPDATE policies
  - `20260514043659_brian_delete_policy.sql` — DELETE policy gated to `brianlmoore803@gmail.com` only

## Security model (how the live site stays safe)

- The Supabase **anon key** is checked into both HTML files. That's intentional — it's designed to be public. **RLS** is what protects the data:
  - **Anonymous** (RSVP form): can INSERT new rsvps. Cannot SELECT, UPDATE, or DELETE.
  - **Authenticated admin** (email in `public.admins`): can SELECT and UPDATE rsvps. UPDATE is used for the "contacted" checkbox.
  - **Authenticated owner** (`brianlmoore803@gmail.com` only): can also DELETE rsvps.
- The Supabase **service_role key** is not used anywhere in this site.
- Public sign-ups are **disabled** in Supabase (Authentication → Sign In / Providers → "Allow new users to sign up" = OFF), so no random Google account can register and probe RLS.

## Contact numbers (intentionally split)

- **Public RSVP page** points guests to mom Virginia at **803-727-7751** (the party planner).
- **Admin login page** points mom and sister to Brian at **803-727-7750** for password resets.

## Operational tasks

### Add or remove an admin

```sql
-- Add
insert into public.admins (email) values ('newperson@example.com');
-- Remove
delete from public.admins where email = 'oldperson@example.com';
```

Run in Supabase SQL Editor. Also create/delete the matching user in **Authentication → Users**.

### Reset someone's password

Supabase Dashboard → Authentication → Users → click the user → "Send password recovery" (or set a new one directly with "Reset password").

### Make a schema change

```bash
supabase migration new your_change_name
# edit the new file in supabase/migrations/
supabase db push --include-all
git add supabase/migrations/ && git commit -m "..." && git push
```

### Deploy a code change

Just `git push` to `main`. GitHub Pages rebuilds automatically (~1 minute). Watch builds at https://github.com/Bmoore4452/grad-party-rsvp/actions.

## Local testing

Double-click `index.html` or `admin.html`. Both talk to the live Supabase project — no local server needed. Submitting an RSVP from a local file writes to the same database as production.

## After the party (cleanup)

- Delete the Supabase project: Project Settings → General → Delete project.
- Archive the GitHub repo: Settings → scroll to "Danger Zone" → Archive.
- $0 spent.
