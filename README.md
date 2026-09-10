# Kontakt-Tracker (Team-Version)

Statische Webseite ohne Build-Schritt. Backend ist Supabase (eine Tabelle `people`), Hosting läuft über Netlify direkt aus einem GitHub-Repo.

## 1. Supabase-Projekt anlegen

1. Auf [supabase.com](https://supabase.com) ein neues Projekt anlegen.
   - **Region: möglichst eine EU-Region wählen** (z.B. Frankfurt), damit die Kontaktdaten aus DSGVO-Sicht in der EU bleiben.
2. Im Projekt zu **SQL Editor** gehen, den Inhalt von `supabase-schema.sql` einfügen und ausführen. Das legt die Tabelle `people` an und setzt eine Zugriffs-Policy.
3. Zu **Project Settings → API** gehen und dort kopieren:
   - **Project URL** (z.B. `https://abcdefgh.supabase.co`)
   - **anon public key** (langer Text, beginnt meist mit `eyJ...`)

## 2. Zugangsdaten eintragen

In `index.html` ganz oben im `<script>`-Block:

```js
const SUPABASE_URL = "https://YOUR-PROJECT.supabase.co";
const SUPABASE_ANON_KEY = "YOUR-ANON-KEY";
```

durch die eigenen Werte aus Schritt 1 ersetzen. Das Passwort ist dort ebenfalls hinterlegt:

```js
const SITE_PASSWORD = "telefonie";
```

## 3. Auf GitHub veröffentlichen

```bash
git init
git add .
git commit -m "Kontakt-Tracker Web-Version"
git branch -M main
git remote add origin <URL deines GitHub-Repos>
git push -u origin main
```

## 4. Mit Netlify verbinden

1. Auf [netlify.com](https://netlify.com) → **Add new site → Import an existing project**.
2. Das GitHub-Repo auswählen.
3. Build-Einstellungen: **kein Build-Command nötig**, Publish-Directory ist der Projekt-Root (`.` bzw. leer lassen — es gibt keinen `netlify.toml`-Build-Schritt, die Datei hier setzt das nur explizit).
4. Deploy klicken. Nach ein paar Sekunden ist die Seite unter einer `*.netlify.app`-URL erreichbar (später auf eine eigene Domain umstellbar).

## Passwortschutz — wichtiger Hinweis zur Sicherheit

Das Passwort `telefonie` ist ein **reiner UI-Schutz**: Es verhindert, dass jemand ohne Passwort die Bedienoberfläche sieht, und wird lokal im Browser gemerkt (kein erneutes Eintippen bei jedem Besuch). Es ist **keine echte Zugriffskontrolle** auf Datenbankebene:

- Der `anon`-Key in `index.html` ist im öffentlichen Quellcode der Seite sichtbar (das ist bei Supabase so vorgesehen).
- Die Policy in `supabase-schema.sql` erlaubt aktuell jedem mit diesem Key vollen Lese-/Schreibzugriff auf die Tabelle `people` — unabhängig vom Webseiten-Passwort, falls jemand direkt mit der Supabase-API spricht statt über die Webseite.

Für ein kleines, vertrauenswürdiges Team (wie hier) ist das ein akzeptabler Kompromiss für ein schnelles internes Tool. Für einen stärkeren Schutz später in Frage kommen:
- Netlify **Password Protection** / **Visitor Access** (auf kostenpflichtigen Plänen), das die Seite bereits auf Server-Ebene sperrt, bevor überhaupt JavaScript lädt.
- Echtes **Supabase Auth** (z.B. Magic-Link-Login) statt eines geteilten Passworts.
- Eine restriktivere RLS-Policy, sobald es echte Nutzer-Accounts gibt.

## Funktionsumfang

- Kontakt-Tracking (WhatsApp / Telefon) mit geführtem Dialog
- Antwort-Tracking zur Auflösung offener Stapel (BHV-Termin / Kein BHV-Termin)
- Erfolgsquote, erfolgreichster Kontaktweg, beste Kontaktzeiten (Wochentag + Uhrzeit)
- Mehrbenutzer: eigene Ansicht pro Person + Gesamtübersicht fürs ganze Team
- Adminbereich zum Verwalten (Hinzufügen/Entfernen/Zurücksetzen) der Namen
- CSV-/JSON-Export

Alle Daten liegen ausschließlich in eurem eigenen Supabase-Projekt — nicht bei Anthropic oder Claude.
