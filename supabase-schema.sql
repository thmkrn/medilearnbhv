-- Im Supabase SQL-Editor ausführen (Project -> SQL Editor -> New query)

create table if not exists people (
  slug text primary key,
  name text not null,
  active boolean not null default true,
  contacts jsonb not null default '[]'::jsonb,
  resolutions jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

-- Row Level Security aktivieren
alter table people enable row level security;

-- Da dieses Tool ohne eigenes Supabase-Auth-System arbeitet (nur das
-- Passwort auf der Webseite schützt den Zugriff), braucht der anon-Key
-- vollen Lese-/Schreibzugriff auf diese Tabelle. Siehe README.md für
-- Hinweise zu den Sicherheitsgrenzen dieses Ansatzes.
create policy "allow all for anon" on people
  for all
  using (true)
  with check (true);
