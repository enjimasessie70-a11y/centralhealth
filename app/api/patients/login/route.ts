import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';
import { admin } from '@/lib/supabase/admin';

function generateRequestId(): string {
  return `login-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
}

/**
 * Patient login via Supabase Auth.
 * On success the @supabase/ssr server client writes the session cookies
 * to the response, so subsequent requests carry a valid session.
 */
export async function POST(req: NextRequest) {
  const requestId = req.headers.get('X-Request-ID') || generateRequestId();

  try {
    let body;
    try {
      body = await req.json();
    } catch {
      return NextResponse.json(
        { success: false, message: 'Invalid JSON in request body', error: 'INVALID_JSON' },
        { status: 400 }
      );
    }

    const { email, password } = body || {};

    if (!email || !password) {
      return NextResponse.json(
        { success: false, message: 'Email and password are required', error: 'MISSING_CREDENTIALS' },
        { status: 400 }
      );
    }

    const normalizedEmail = email.toLowerCase().trim();
    console.log(`[${requestId}] Authenticating: ${normalizedEmail.substring(0, 3)}**** via Supabase`);

    const supabase = await createClient();
    const { data, error } = await supabase.auth.signInWithPassword({
      email: normalizedEmail,
      password,
    });

    if (error || !data.user) {
      console.log(`[${requestId}] Login failed: ${error?.message}`);
      const code = error?.status === 400 ? 'INVALID_PASSWORD' : 'USER_NOT_FOUND';
      return NextResponse.json(
        {
          success: false,
          message: 'Invalid email or password',
          error: code,
          details: error?.message || 'Authentication failed',
        },
        { status: 401 }
      );
    }

    const authUserId = data.user.id;
    console.log(`[${requestId}] Authenticated user: ${authUserId}`);

    // Look up the linked patient record (Patient.userId -> User.id)
    const { data: patient, error: patientError } = await admin
      .from('Patient')
      .select('*')
      .eq('userId', authUserId)
      .maybeSingle();

    if (patientError) {
      console.error(`[${requestId}] Error loading patient:`, patientError.message);
    }

    if (!patient) {
      return NextResponse.json(
        {
          success: false,
          message: 'No patient profile is linked to this account. Please contact your hospital.',
          error: 'PATIENT_NOT_LINKED',
        },
        { status: 404 }
      );
    }

    const userEmail = data.user.email || normalizedEmail;

    return NextResponse.json({
      success: true,
      presentationMode: true,
      token: data.session?.access_token || '',
      patient: {
        id: patient.id,
        userId: authUserId,
        mrn: patient.mrn,
        name: patient.name,
        gender: patient.gender,
        dateOfBirth: patient.dateOfBirth,
        email: userEmail,
        onboardingCompleted: patient.onboardingCompleted ?? false,
      },
      message: 'Login successful',
    });
  } catch (error: any) {
    console.error(`[${requestId}] Login error:`, error);
    return NextResponse.json(
      {
        success: false,
        message: 'An error occurred during login',
        error: 'SERVER_ERROR',
        details: error?.message || 'Unknown error',
      },
      { status: 500 }
    );
  }
}
