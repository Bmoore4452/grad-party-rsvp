-- Admin access for Brian + mom (Virginia) + sister.
-- Adds follow-up tracking columns, an admins whitelist, and RLS policies
-- that let only whitelisted (logged-in) users read/update RSVPs.

-- 1. Follow-up tracking on rsvps
alter table public.rsvps
  add column if not exists contacted boolean not null default false,
  add column if not exists contacted_at timestamptz,
  add column if not exists contacted_by text;

-- 2. Admins whitelist
create table if not exists public.admins (
  email text primary key,
  added_at timestamptz not null default now()
);

insert into public.admins (email) values
  ('brianlmoore803@gmail.com'),
  ('anyhow853@gmail.com'),
  ('mishondycharles04@gmail.com')
on conflict (email) do nothing;

-- 3. RLS for admins table — a logged-in user can see their OWN admin row only.
-- (Used by the admin page to verify "am I allowed in?")
alter table public.admins enable row level security;

drop policy if exists "users can see own admin row" on public.admins;
create policy "users can see own admin row"
  on public.admins for select
  to authenticated
  using (email = auth.jwt() ->> 'email');

-- 4. Admins can SELECT all rsvps.
drop policy if exists "admins can read rsvps" on public.rsvps;
create policy "admins can read rsvps"
  on public.rsvps for select
  to authenticated
  using (
    exists (
      select 1 from public.admins
      where email = auth.jwt() ->> 'email'
    )
  );

-- 5. Admins can UPDATE rsvps (used for the "contacted" checkbox).
drop policy if exists "admins can update rsvps" on public.rsvps;
create policy "admins can update rsvps"
  on public.rsvps for update
  to authenticated
  using (
    exists (
      select 1 from public.admins
      where email = auth.jwt() ->> 'email'
    )
  )
  with check (
    exists (
      select 1 from public.admins
      where email = auth.jwt() ->> 'email'
    )
  );
