import { NextRequest } from 'next/server';
import { createServerClient } from '@supabase/ssr';
import { getSessionUser, loadUserProfile } from '@/lib/supabase/session';

export interface AuthUser {
  id: string;
  email: string;
  role: string;
  hospitalId?: string;
  isHospitalAdmin?: boolean;
  isSuperAdmin?: boolean;
  patientId?: string;
  mrn?: string;
  name?: string;
}

export interface AuthResult {
  authenticated: boolean;
  user?: AuthUser;
  error?: string;
}

/**
 * Gets authentication info from the Supabase session (cookies) or,
 * as a fallback, the Authorization header (Supabase access token).
 */
export async function getAuth(request: NextRequest): Promise<AuthResult> {
  try {
    // Preferred path: server client reads the session cookie.
    let sessionUser = await getSessionUser();

    // Fallback: a Bearer token from the client (Supabase access token).
    if (!sessionUser && request.headers.get('authorization')) {
      const supabase = createServerClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
        {
          cookies: {
            getAll: () => [],
            setAll: () => {},
          },
        }
      );
      const token = request.headers.get('authorization')!.replace('Bearer ', '');
      const { data } = await supabase.auth.getUser(token);
      if (data.user) {
        sessionUser = await loadUserProfile(data.user.id);
      }
    }

    if (!sessionUser) {
      return { authenticated: false, error: 'No valid Supabase session found' };
    }

    const user: AuthUser = {
      id: sessionUser.id,
      email: sessionUser.email,
      role: sessionUser.role,
      hospitalId: sessionUser.hospitalId || undefined,
      isHospitalAdmin: sessionUser.isHospitalAdmin,
      isSuperAdmin: sessionUser.isSuperAdmin,
      patientId: sessionUser.patientId || undefined,
      mrn: sessionUser.mrn || undefined,
      name: sessionUser.name,
    };

    return { authenticated: true, user };
  } catch (error) {
    console.error('Authentication error:', error);
    return { authenticated: false, error: 'Invalid or expired authentication' };
  }
}
