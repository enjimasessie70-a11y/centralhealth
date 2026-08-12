/**
 * Health check for the Supabase connection.
 * Run: node scripts/test-supabase.js
 * Loads .env.local, verifies the DB + storage + auth are reachable.
 */
require('dotenv').config({ path: require('path').join(__dirname, '..', '.env.local') });
const { createClient } = require('@supabase/supabase-js');

const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!url || !anonKey || !serviceKey) {
  console.error('Missing Supabase env vars. Create .env.local first.');
  process.exit(1);
}

const admin = createClient(url, serviceKey, { auth: { autoRefreshToken: false, persistSession: false } });

(async () => {
  const { data: users, error } = await admin.from('User').select('id').limit(1);
  console.log('DB  :', error ? 'ERROR ' + error.message : 'OK (' + users.length + ' user row(s))');

  const { error: bucketErr } = await admin.storage.getBucket('profiles');
  console.log('STORAGE:', bucketErr ? 'ERROR ' + bucketErr.message : 'OK profiles bucket');

  const { error: authErr } = await admin.auth.admin.listUsers({ page: 1, perPage: 1 });
  console.log('AUTH :', authErr ? 'ERROR ' + authErr.message : 'OK auth API reachable');

  if (error || bucketErr || authErr) process.exit(1);
  console.log('\nSupabase connection verified.');
})();
