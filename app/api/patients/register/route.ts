import { NextRequest, NextResponse } from "next/server";
import { admin } from '@/lib/supabase/admin';
import { validateEmail, validateName, normalizeEmail } from '../../../../utils/validators';
import { validateStoredMedicalID } from '../../../../utils/medical-id';
import { isUniqueMedicalID, generateUniqueMedicalID } from '../../../../utils/check-id-uniqueness';

/**
 * Medical ID preservation is critical. According to CentralHealth System requirements:
 * - Medical IDs must NEVER be regenerated for existing patients
 * - Each patient receives ONE permanent medical ID for their lifetime
 * - All medical IDs must follow NHS-style 5-character alphanumeric format
 * - Medical IDs must be stored consistently in the mrn field
 */

function createPatientName(firstName: string, lastName: string) {
  return `${firstName} ${lastName}`;
}

/**
 * Patient Registration API Endpoint (Supabase Auth backed).
 * Creates the auth user (public "User" row is synced by the on_auth_user_created
 * trigger) and the linked Patient record with a permanent medical ID.
 */
export async function POST(req: NextRequest) {
  console.log('Patient registration API called');

  try {
    const body = await req.json();

    if (!body) {
      return NextResponse.json(
        { success: false, error: "Invalid registration request" },
        { status: 400 }
      );
    }

    return await handleBasicRegistration(body, req);
  } catch (error) {
    console.error('Registration error:', error instanceof Error ? error.message : 'Unknown error');
    return NextResponse.json(
      { success: false, error: "Registration failed. Please try again." },
      { status: 500 }
    );
  }
}

async function handleBasicRegistration(body: any, req: NextRequest) {
  try {
    const { firstName, lastName, email, password, phone, gender, birthDate, profilePicture, medicalId } = body;

    if (!firstName || !lastName || !email || !password) {
      return NextResponse.json(
        { success: false, error: "Missing required fields" },
        { status: 400 }
      );
    }

    if (!validateEmail(email)) {
      return NextResponse.json(
        { success: false, error: "Invalid email format" },
        { status: 400 }
      );
    }

    const normalizedEmail = normalizeEmail(email);

    if (!validateName(firstName) || !validateName(lastName)) {
      return NextResponse.json(
        { success: false, error: "Invalid name format" },
        { status: 400 }
      );
    }

    // Determine the permanent medical ID
    let finalMedicalId = medicalId;
    if (!finalMedicalId) {
      try {
        finalMedicalId = await generateUniqueMedicalID();
        console.log('Generated medical ID:', finalMedicalId);
      } catch (idGenerationError) {
        console.error('Failed to generate medical ID:', idGenerationError);
        return NextResponse.json(
          { success: false, error: "Failed to generate medical ID" },
          { status: 500 }
        );
      }
    } else {
      if (!validateStoredMedicalID(finalMedicalId)) {
        return NextResponse.json(
          { success: false, error: "Invalid medical ID format" },
          { status: 400 }
        );
      }

      const isUnique = await isUniqueMedicalID(finalMedicalId);
      if (!isUnique) {
        return NextResponse.json(
          { success: false, error: "Medical ID already in use" },
          { status: 400 }
        );
      }
    }

    // 1. Create the Supabase auth user (trigger syncs public."User")
    const { data: authData, error: authError } = await admin.auth.admin.createUser({
      email: normalizedEmail,
      password,
      email_confirm: true,
      user_metadata: {
        name: createPatientName(firstName, lastName),
        role: 'PATIENT',
      },
    });

    if (authError) {
      const code = authError.message?.toLowerCase().includes('already') ? 'EMAIL_IN_USE' : 'AUTH_ERROR';
      return NextResponse.json(
        { success: false, error: code === 'EMAIL_IN_USE' ? "Email already in use" : "Failed to create account" },
        { status: 400 }
      );
    }

    const userId = authData.user.id;
    console.log('Auth user created:', userId);

    // 2. Create the Patient record linked to the auth user
    const birthDateObj = birthDate ? new Date(birthDate) : null;

    const { error: patientError } = await admin.from('Patient').insert({
      mrn: finalMedicalId,
      name: createPatientName(firstName, lastName),
      dateOfBirth: birthDateObj ? birthDateObj.toISOString() : null,
      gender: gender || 'unknown',
      onboardingCompleted: true,
      userId,
    });

    if (patientError) {
      console.error('Failed to create patient:', patientError.message);
      // Roll back the auth user
      await admin.auth.admin.deleteUser(userId).catch(() => {});
      return NextResponse.json(
        { success: false, error: 'Registration failed: Patient record could not be created.' },
        { status: 500 }
      );
    }

    // Fetch the created patient for the response
    const { data: newPatientRecord } = await admin
      .from('Patient')
      .select('id, mrn, name')
      .eq('userId', userId)
      .maybeSingle();

    // 3. Create PatientEmail record - non-blocking
    if (newPatientRecord?.id) {
      const { error: emailError } = await admin.from('patient_emails').insert({
        email: normalizedEmail,
        patientId: newPatientRecord.id,
        verified: false,
        primary: true,
      });
      if (emailError) console.warn('Failed to create email record:', emailError.message);

      // 4. Create phone record if provided - non-blocking
      if (phone && newPatientRecord.id) {
        const { error: phoneError } = await admin.from('patient_phones').insert({
          patientId: newPatientRecord.id,
          phone,
          type: 'mobile',
          primary: true,
          verified: false,
        });
        if (phoneError) console.warn('Failed to create phone record:', phoneError.message);
      }
    }

    console.log('Patient registration complete successfully!');

    return NextResponse.json({
      success: true,
      message: "Registration successful",
      redirect: "/auth/login?registered=true&email=" + encodeURIComponent(normalizedEmail),
      patient: {
        id: newPatientRecord?.id,
        name: createPatientName(firstName, lastName),
        email: normalizedEmail,
      },
    });
  } catch (error) {
    console.error('Registration error:', error instanceof Error ? error.message : 'Unknown error');
    return NextResponse.json({
      success: false,
      error: "Registration failed. Please try again."
    }, { status: 500 });
  }
}
