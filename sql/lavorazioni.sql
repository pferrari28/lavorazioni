-- =====================================================================
-- Lavorazioni · tabella delle giornate (17/11/2026)
--
-- Supabase → SQL Editor → New query → incolla questo script → Run.
-- Si può rieseguire senza problemi. Crea solo una tabella nuova
-- (lav_giornate): non tocca il registro lotti né il magazzino.
--
-- Accesso: solo l'utente Paolo (admin@lotti.local, stessa password del
-- registro lotti). Una riga per giornata: tutte le 5 lavorazioni stanno
-- in "dati"; in "totali" ci sono già i conti per il riepilogo mensile,
-- così il riepilogo scarica pochissimi dati.
-- =====================================================================

create table if not exists public.lav_giornate (
  data          date primary key,
  dati          jsonb not null default '{}'::jsonb,
  totali        jsonb not null default '{}'::jsonb,
  aggiornato_il timestamptz not null default now()
);

alter table public.lav_giornate enable row level security;

drop policy if exists lav_giornate_paolo on public.lav_giornate;
create policy lav_giornate_paolo on public.lav_giornate
  for all to authenticated
  using (lower(coalesce(auth.jwt() ->> 'email', '')) = 'admin@lotti.local')
  with check (lower(coalesce(auth.jwt() ->> 'email', '')) = 'admin@lotti.local');

revoke all on public.lav_giornate from anon;
grant select, insert, update, delete on public.lav_giornate to authenticated;

-- ---------------------------------------------------------------------
-- Matricole (pagina Matricole del sito) — 17/11/2026
-- (le 132 matricole iniziali sono state caricate direttamente)
-- ---------------------------------------------------------------------
create table if not exists public.lav_matricole (
  matricola text primary key,
  creata_il timestamptz not null default now()
);
alter table public.lav_matricole enable row level security;
drop policy if exists lav_matricole_paolo on public.lav_matricole;
create policy lav_matricole_paolo on public.lav_matricole
  for all to authenticated
  using (lower(coalesce((select auth.jwt()) ->> 'email', '')) = 'admin@lotti.local')
  with check (lower(coalesce((select auth.jwt()) ->> 'email', '')) = 'admin@lotti.local');
revoke all on public.lav_matricole from anon;
grant select, insert, update, delete on public.lav_matricole to authenticated;

-- ---------------------------------------------------------------------
-- Bozze (tasto «Salva bozza») — 17/11/2026
-- ---------------------------------------------------------------------
create table if not exists public.lav_bozze (
  data          date primary key,
  dati          jsonb not null default '{}'::jsonb,
  aggiornato_il timestamptz not null default now()
);
alter table public.lav_bozze enable row level security;
drop policy if exists lav_bozze_paolo on public.lav_bozze;
create policy lav_bozze_paolo on public.lav_bozze
  for all to authenticated
  using (lower(coalesce((select auth.jwt()) ->> 'email', '')) = 'admin@lotti.local')
  with check (lower(coalesce((select auth.jwt()) ->> 'email', '')) = 'admin@lotti.local');
revoke all on public.lav_bozze from anon;
grant select, insert, update, delete on public.lav_bozze to authenticated;
