/**
 * Supabase seed script.
 * Run: npm run db:seed (or node scripts/seed-supabase.js)
 *
 * Creates the system hospital, a demo hospital, a super admin, and a demo
 * patient account. Idempotent (skips anything that already exists).
 */
require('dotenv').config({ path: require('path').join(__dirname, '..', '.env.local') });
const { createClient } = require('@supabase/supabase-js');

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!url || !key) {
  console.error('Missing Supabase env vars. Create .env.local first.');
  process.exit(1);
}

const sb = createClient(url, key, { auth: { autoRefreshToken: false, persistSession: false } });

async function upsertHospital(data) {
  const { data: existing } = await sb.from('Hospital').select('id').eq('subdomain', data.subdomain).maybeSingle();
  if (existing) { console.log(`  hospital ${data.subdomain} exists, skipping`); return existing.id; }
  const { data: created, error } = await sb.from('Hospital').insert(data).select('id').single();
  if (error) { console.error(`  FAILED to create hospital ${data.subdomain}:`, error.message); return null; }
  console.log(`  created hospital ${data.subdomain}`);
  return created.id;
}

async function upsertAuthUser({ email, password, name, role, hospitalId, isSuperAdmin }) {
  // Check if auth user exists
  const { data: existing } = await sb.auth.admin.listUsers({ page: 1, perPage: 1000 });
  const found = existing.users.find(u => u.email === email);
  if (found) {
    console.log(`  user ${email} exists, updating metadata`);
    await sb.auth.admin.updateUserById(found.id, {
      user_metadata: { name, role, hospitalId: hospitalId || '', isSuperAdmin: !!isSuperAdmin },
    });
    return found.id;
  }
  const { data, error } = await sb.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
    user_metadata: { name, role, hospitalId: hospitalId || '', isSuperAdmin: !!isSuperAdmin },
  });
  if (error) { console.error(`  FAILED to create user ${email}:`, error.message); return null; }
  console.log(`  created user ${email}`);
  return data.user.id;
}

async function main() {
  console.log('Seeding Supabase project...');

  console.log('1. Hospitals');
  const systemHospitalId = await upsertHospital({
    name: 'Central Patient System',
    subdomain: 'system',
    description: 'Central patient management system - not a physical hospital',
    settings: { isSystemHospital: true, features: { appointments: true, records: true } },
    branding: { logo: null, colors: { primary: '#0070f3', secondary: '#ff0080' } },
    isActive: true,
  });
  const demoHospitalId = await upsertHospital({
    name: 'Central Medical Center',
    subdomain: 'central',
    description: 'Demo hospital for CentralHealth',
    settings: { features: { appointments: true, records: true, billing: true } },
    branding: { logo: null, colors: { primary: '#0070f3', secondary: '#16a34a' } },
    code: 'CMC',
    isActive: true,
  });

  console.log('2. Users');
  const adminId = await upsertAuthUser({
    email: 'admin@example.com',
    password: 'admin123',
    name: 'System Administrator',
    role: 'ADMIN',
    hospitalId: demoHospitalId || systemHospitalId,
    isSuperAdmin: true,
  });
  const patientUserId = await upsertAuthUser({
    email: 'patient@example.com',
    password: 'password123',
    name: 'Demo Patient',
    role: 'PATIENT',
  });

  console.log('3. Demo patient record');
  if (patientUserId) {
    const { data: existingPatient } = await sb.from('Patient').select('id').eq('userId', patientUserId).maybeSingle();
    if (existingPatient) {
      console.log('  patient record exists, skipping');
    } else {
      const mrn = 'DEMO1';
      const { error } = await sb.from('Patient').insert({
        mrn,
        name: 'Demo Patient',
        gender: 'unknown',
        onboardingCompleted: true,
        userId: patientUserId,
        hospitalId: demoHospitalId || null,
      });
      if (error) console.error('  FAILED to create patient:', error.message);
      else console.log(`  created patient record mrn=${mrn}`);
    }
  }

  console.log('\nSeed complete.');
  console.log('\nTest accounts:');
  console.log('  admin@example.com / admin123  (super admin)');
  console.log('  patient@example.com / password123');
}

main().catch((e) => { console.error('Seed failed:', e); process.exit(1); });
