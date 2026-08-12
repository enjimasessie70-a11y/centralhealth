# CentralHealth Backend (DEPRECATED)

This FastAPI backend was the original auth/data API. The project has moved to
**Supabase** (PostgreSQL + Auth + Storage + Realtime) deployed alongside the
Next.js app on Vercel.

- **Do not** run or extend this backend for new work.
- Endpoints previously served here are being replaced:
  - `POST /api/auth/mobile/login` → `supabase.auth.signInWithPassword`
  - `GET /api/patients/profile` → Supabase `Patient`/`User` tables
  - `GET/POST /api/hospitals` → Supabase `Hospital` table + Next.js API routes
- `backend/setup_db.sql` and `backend/main.py` are kept for reference only.

The mobile app no longer depends on this server (see `mobile_app/README.md`).
