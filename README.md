# CentralHealth — National Health System Platform

Sierra Leone's national health platform. Web (Next.js), mobile (Flutter), backed by **Supabase** (PostgreSQL + Auth + Storage + Realtime) and deployed on **Vercel**.

## Architecture

```
┌─────────────────────┐   ┌──────────────────────┐
│  Next.js web app    │   │  Flutter mobile app  │
│  (Vercel)           │   │                      │
└─────────┬───────────┘   └──────────┬───────────┘
          │        Supabase          │
          └──────────────────────────┘
              ├── PostgreSQL (PostgREST + RLS)
              ├── Auth (email/password, JWT sessions)
              ├── Storage (profile images bucket: `profiles`)
              └── Realtime (chat / messages)
```

- **Supabase** is the backend: database, auth, storage, realtime, RLS.
- The **Next.js app** talks to Supabase via `@supabase/ssr` (server + browser clients).
- The **FastAPI backend** (`backend/`) is being deprecated; its endpoints are re-homed as Supabase-managed data + Next.js API routes.
- **Prisma** is being removed; `supabase/migrations/*.sql` is the schema source of truth.

## Prerequisites

- Node.js 18+ / npm
- Supabase CLI (`npm i -g supabase`)
- Flutter SDK (mobile)

## Setup

### 1. Create `.env.local`

```bash
cp .env.example .env.local
```

Fill in your Supabase project values (Dashboard → Project Settings → API).

### 2. Link the Supabase project

```bash
supabase login
npm run supabase:link   # links ftfiqabnvlztnoaiogms
```

### 3. Push the schema

```bash
npm run db:push
```

Migrations live in `supabase/migrations/`:
1. `20260812000000_init.sql` — full schema generated from the Prisma models
2. `20260812000001_auth_sync.sql` — `auth.users` → `public."User"` sync triggers + role handling
3. `20260812000002_rls_storage.sql` — RLS policies + `profiles` storage bucket
4. `20260812000003_uuid_defaults.sql` — DB-level UUID defaults for `id` columns
5. `20260812000004_updatedat_defaults.sql` — `updatedAt` defaults
6. `20260812000005_auth_delete_cascade.sql` — cascade cleanup on auth user deletion

### 4. Verify the connection

```bash
npm run test:supabase
```

### 5. Run the web app

```bash
npm install
npm run dev
```

## Key Directories

| Path | Purpose |
|------|---------|
| `supabase/` | Schema migrations, config, storage |
| `lib/supabase/` | Client helpers (browser, server, middleware, admin, session) |
| `app/api/` | Next.js API routes (Supabase-backed) |
| `prisma/` | Legacy Prisma schema (source of the SQL migration, being removed) |
| `backend/` | Legacy FastAPI backend (being deprecated) |
| `mobile_app/` | Flutter app |

## Auth Flow

- Sign-up → `POST /api/patients/register` creates a Supabase auth user (trigger syncs `public."User"`) + linked `Patient` record with a permanent medical ID.
- Sign-in → `POST /api/patients/login` signs in via Supabase; session cookies are set by `@supabase/ssr`.
- Session checks → `lib/auth.ts` / `lib/supabase/session.ts` resolve the app user from the Supabase session.
- Route protection → `middleware.ts` (`lib/supabase/middleware.ts`).

## Deploying to Vercel

1. Push the repo to GitHub.
2. Import into Vercel; set the three Supabase env vars (`NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`).
3. Build command `npm run build`, output `Next.js`.
4. No serverless Postgres or FastAPI instance required — Supabase hosts everything.

## Mobile App (Flutter)

The Flutter app authenticates via Supabase Auth and reads data through the Supabase REST API.
See `mobile_app/README.md` for the migration status and configuration.

## Troubleshooting

- **`supabase db push` needs the DB password** — use the Supabase dashboard (SQL Editor) to apply `supabase/migrations/*.sql` directly, or run the CLI from a machine with the project password configured.
- **RLS blocking reads** — `lib/supabase/admin.ts` uses the service-role key (bypasses RLS) for server-side admin operations; the browser/server clients use the anon key so RLS applies.
