-- RSVP table for Brian's graduation party (July 18, 2026).
-- Free-tier Supabase. Public site uses the anon key to insert; reads happen
-- via the service_role key from a Google Apps Script (never on the website).

create table if not exists public.rsvps (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null check (length(trim(name)) >= 2),
  attending boolean not null,
  -- 0 = "not attending" (party of zero); 1-20 otherwise.
  guest_count int not null default 1 check (guest_count between 0 and 20),
  contact text not null check (length(trim(contact)) >= 5),
  message text check (message is null or length(message) <= 500)
);

create index if not exists rsvps_created_at_idx on public.rsvps (created_at);

-- Row Level Security: anonymous visitors can submit but NOT read or modify.
alter table public.rsvps enable row level security;

create policy "anon can insert rsvps"
  on public.rsvps for insert
  to anon
  with check (true);

-- No select/update/delete policy for anon = no read access from the public site.
-- The Apps Script reads with the service_role key (RLS bypassed).
