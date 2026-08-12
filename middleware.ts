import { type NextRequest } from 'next/server';
import { updateSession } from '@/lib/supabase/middleware';

// SECURITY ENFORCEMENT - Per CentralHealth System Requirements
const ENFORCE_STRICT_AUTH = true; // This must ALWAYS be true in production

// Middleware handles all route protection logic
export async function middleware(request: NextRequest) {
  const path = request.nextUrl.pathname;

  // Define public paths that should always be accessible
  const publicPaths = [
    '/',
    '/auth/login',
    '/auth/patient-login',
    '/auth/patient-signup',
    '/auth/signup',
    '/auth/forgot-password',
    '/auth/reset-password',
    '/_next',
    '/api',
    '/admin/auth/login',
    '/superadmin',
    '/onboarding',
    '/login',
    '/register',
    '/privacy',
    '/terms',
    '/clear-cache.html',
  ];

  // Always allow access to public paths
  if (publicPaths.some(pp => path === pp || path.startsWith(pp + '/'))) {
    return await updateSession(request);
  }

  // Registration page is public (session check happens on the client)
  if (path === '/register' || path.startsWith('/register')) {
    return await updateSession(request);
  }

  // Handle Supabase session refresh + protection for all other routes
  const supabaseResponse = await updateSession(request);

  // updateSession already redirects unauthenticated users away from
  // protected routes (/patient, /hospitals, /admin).
  return supabaseResponse;
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|_next/data|favicon.ico|public\/|.*\\.(?:svg|png|jpg|jpeg|gif|webp|ico|css|js|map)$).*)',
  ],
}
