# CentralHealth Mobile App (Flutter)

Patient-facing mobile app. Authentication now runs on **Supabase Auth**;
data flows through the Supabase REST API and the Next.js API routes.

## Supabase configuration

Credentials live in `lib/core/constants/app_constants.dart`
(`supabaseUrl`, `supabaseAnonKey`). Update them if you point the app at a
different Supabase project. For production, prefer injecting these via
`flutter_dotenv` instead of hardcoding.

## Auth migration status

- [x] `Supabase.initialize` in `lib/main.dart`
- [x] `AuthService.login` → `supabase.auth.signInWithPassword`
- [x] `AuthService.register` → `supabase.auth.signUp`
- [x] `AuthService.logout` → `supabase.auth.signOut`
- [x] `AuthService.verifyToken` / `_refreshToken` → Supabase
- [x] `AuthService.isAuthenticated` checks the live Supabase session
- [ ] Data screens (patients, appointments, profile) still talk to the legacy
      FastAPI endpoints via `ApiClient` — migrate these to Supabase queries or
      the Vercel-hosted Next.js API routes.

## Running

```bash
flutter pub get
flutter run
```
