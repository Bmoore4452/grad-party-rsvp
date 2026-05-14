-- Only Brian (the host) can delete RSVPs. Mom and sister are read/update only.

drop policy if exists "brian can delete rsvps" on public.rsvps;
create policy "brian can delete rsvps"
  on public.rsvps for delete
  to authenticated
  using (auth.jwt() ->> 'email' = 'brianlmoore803@gmail.com');
