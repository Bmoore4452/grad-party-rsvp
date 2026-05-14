# Graduation Party RSVP

Free, static RSVP site for Brian's graduation party (July 18, 2026).

**Stack:** GitHub Pages (host) · Supabase (database + auth) · vanilla HTML/JS
**Cost:** $0

## Files

- `index.html` — public RSVP page guests submit
- `admin.html` — password-protected dashboard for Brian, mom, and sister to view/manage RSVPs
- `mercer-logo.png` · `grad.jpg` — assets
- `supabase/` — Supabase config + SQL migrations (version-controlled schema)

## Setup checklist

The Supabase project is already created and linked: `fltcdlizijkelvolldtc`.

### 1. Database (✅ done if you ran `supabase db push`)

Schema lives in `supabase/migrations/`. To re-apply or apply on a fresh project:

```bash
supabase link --project-ref fltcdlizijkelvolldtc
supabase db push --include-all
```

### 2. Create admin accounts (one-time, ~2 min)

In the Supabase Dashboard → Authentication → Users → "Add user" → "Create new user":

| Email | Who | Password |
|---|---|---|
| `brianlmoore803@gmail.com` | Brian | Choose a strong one |
| `anyhow853@gmail.com` | Mom (Virginia) | Choose one, share with her |
| `mishondycharles04@gmail.com` | Sister | Choose one, share with her |

For each user, **check "Auto Confirm User"** so they can log in without clicking an email link.

### 3. Lock down sign-ups (one-time)

By default Supabase lets anyone sign up. We want only the three accounts above to exist.

Supabase Dashboard → Authentication → Providers → **Email** → toggle **"Enable Signups"** off → Save.

(The admins whitelist also blocks unauthorized accounts from seeing data, but disabling open sign-ups is defense in depth.)

### 4. GitHub Pages (5 min)

1. Create a new **public** GitHub repo (e.g. `grad-party-rsvp`).
2. Push these files.
3. Repo Settings → Pages → Source: `main` branch, `/root`. Save.
4. Site goes live at `https://YOURUSER.github.io/REPO/` in ~1 min.
5. Admin URL: `https://YOURUSER.github.io/REPO/admin.html`

## How the security model works

- The Supabase **anon key** is in `index.html` and `admin.html`. It's safe to expose — RLS policies enforce what it can do:
  - Anonymous (RSVP form): can INSERT new rsvps, nothing else.
  - Authenticated admins (in the `admins` table): can SELECT and UPDATE rsvps.
- The **service_role key** is never used in this site. We don't need it.
- Admin emails are stored in the `admins` table. Adding a new admin = inserting one row + creating that user in Supabase Auth.

## Adding or removing an admin later

```sql
-- Add
insert into public.admins (email) values ('newperson@example.com');
-- Remove
delete from public.admins where email = 'oldperson@example.com';
```

Run that in the Supabase SQL Editor. (Also create/delete the matching user in Authentication → Users.)

## After the party

- Delete the Supabase project (Project Settings → General → Delete project).
- Archive the GitHub repo.
- $0 spent.

## Local testing

Just double-click `index.html` or `admin.html`. They talk to your live Supabase project directly. Sign in to `admin.html` as `brianlmoore803@gmail.com` to verify the dashboard works.
