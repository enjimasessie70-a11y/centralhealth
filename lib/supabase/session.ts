import { createClient } from './server'
import { admin } from './admin'

export interface SupabaseSessionUser {
  id: string
  email: string
  role: string
  name: string
  hospitalId?: string | null
  isHospitalAdmin: boolean
  isSuperAdmin: boolean
  phone?: string | null
  photo?: string | null
  patientId?: string | null
  mrn?: string | null
}

/**
 * Get the current authenticated app user from the Supabase session.
 * Server-side only. Reads session cookies via @supabase/ssr.
 */
export async function getSessionUser(): Promise<SupabaseSessionUser | null> {
  try {
    const supabase = await createClient()
    const {
      data: { user },
    } = await supabase.auth.getUser()

    if (!user) return null

    return await loadUserProfile(user.id)
  } catch (error) {
    console.error('getSessionUser error:', error)
    return null
  }
}

/**
 * Load the app "User" row (public schema) plus linked patient for an auth user id.
 */
export async function loadUserProfile(userId: string): Promise<SupabaseSessionUser | null> {
  const { data: appUser, error } = await admin
    .from('User')
    .select('id, email, name, role, hospitalId, isHospitalAdmin, isSuperAdmin, phone, photo')
    .eq('id', userId)
    .maybeSingle()

  if (error || !appUser) return null

  // Look up linked patient record (Patient.userId -> User.id)
  const { data: patient } = await admin
    .from('Patient')
    .select('id, mrn')
    .eq('userId', userId)
    .maybeSingle()

  return {
    id: userId,
    email: appUser.email,
    name: appUser.name,
    role: appUser.role,
    hospitalId: appUser.hospitalId,
    isHospitalAdmin: appUser.isHospitalAdmin,
    isSuperAdmin: appUser.isSuperAdmin,
    phone: appUser.phone,
    photo: appUser.photo,
    patientId: patient?.id ?? null,
    mrn: patient?.mrn ?? null,
  }
}

/**
 * Create a Supabase auth user with app metadata (role, hospital, flags).
 * Returns the auth user. The public "User" row is created by the
 * on_auth_user_created trigger.
 */
export async function createAuthUser(params: {
  email: string
  password: string
  name: string
  role?: string
  hospitalId?: string | null
  isSuperAdmin?: boolean
  isHospitalAdmin?: boolean
}) {
  return admin.auth.signUp({
    email: params.email.toLowerCase().trim(),
    password: params.password,
    options: {
      data: {
        name: params.name,
        role: params.role || 'PATIENT',
        hospitalId: params.hospitalId || '',
        isSuperAdmin: params.isSuperAdmin || false,
        isHospitalAdmin: params.isHospitalAdmin || false,
      },
    },
  })
}
