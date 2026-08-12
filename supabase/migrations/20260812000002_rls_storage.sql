-- Storage: profile images bucket (public so profile URLs work everywhere)
insert into storage.buckets (id, name, public) values ('profiles', 'profiles', true);

-- Baseline RLS policies for the CentralHealth public schema
-- Strictest rules on User/Patient; permissive-but-authenticated access elsewhere.

alter table "User" enable row level security;
create policy "Users read own row" on "User" for select using (auth.uid()::text = "id");
create policy "Users update own row" on "User" for update using (auth.uid()::text = "id");

alter table "Patient" enable row level security;
create policy "Patients read own row" on "Patient" for select using (auth.uid()::text = "userId");
create policy "Patients update own row" on "Patient" for update using (auth.uid()::text = "userId");

alter table "AntenatalRecord" enable row level security;
create policy "Authenticated access on AntenatalRecord" on "AntenatalRecord" for all to authenticated using (true) with check (true);

alter table "Appointment" enable row level security;
create policy "Authenticated access on Appointment" on "Appointment" for all to authenticated using (true) with check (true);

alter table "Hospital" enable row level security;
create policy "Authenticated access on Hospital" on "Hospital" for all to authenticated using (true) with check (true);

alter table "MedicalRecord" enable row level security;
create policy "Authenticated access on MedicalRecord" on "MedicalRecord" for all to authenticated using (true) with check (true);

alter table "NeonatalRecord" enable row level security;
create policy "Authenticated access on NeonatalRecord" on "NeonatalRecord" for all to authenticated using (true) with check (true);

alter table "password_resets" enable row level security;
create policy "Authenticated access on password_resets" on "password_resets" for all to authenticated using (true) with check (true);

alter table "security_audit_logs" enable row level security;
create policy "Authenticated access on security_audit_logs" on "security_audit_logs" for all to authenticated using (true) with check (true);

alter table "profile_pictures" enable row level security;
create policy "Authenticated access on profile_pictures" on "profile_pictures" for all to authenticated using (true) with check (true);

alter table "patient_emails" enable row level security;
create policy "Authenticated access on patient_emails" on "patient_emails" for all to authenticated using (true) with check (true);

alter table "patient_phones" enable row level security;
create policy "Authenticated access on patient_phones" on "patient_phones" for all to authenticated using (true) with check (true);

alter table "Department" enable row level security;
create policy "Authenticated access on Department" on "Department" for all to authenticated using (true) with check (true);

alter table "DepartmentMembership" enable row level security;
create policy "Authenticated access on DepartmentMembership" on "DepartmentMembership" for all to authenticated using (true) with check (true);

alter table "StaffProfile" enable row level security;
create policy "Authenticated access on StaffProfile" on "StaffProfile" for all to authenticated using (true) with check (true);

alter table "PatientHospitalAccess" enable row level security;
create policy "Authenticated access on PatientHospitalAccess" on "PatientHospitalAccess" for all to authenticated using (true) with check (true);

alter table "PatientSearchIndex" enable row level security;
create policy "Authenticated access on PatientSearchIndex" on "PatientSearchIndex" for all to authenticated using (true) with check (true);

alter table "DoctorAvailability" enable row level security;
create policy "Authenticated access on DoctorAvailability" on "DoctorAvailability" for all to authenticated using (true) with check (true);

alter table "PatientWidgetPreference" enable row level security;
create policy "Authenticated access on PatientWidgetPreference" on "PatientWidgetPreference" for all to authenticated using (true) with check (true);

alter table "Referral" enable row level security;
create policy "Authenticated access on Referral" on "Referral" for all to authenticated using (true) with check (true);

alter table "StatusHistory" enable row level security;
create policy "Authenticated access on StatusHistory" on "StatusHistory" for all to authenticated using (true) with check (true);

alter table "Ambulance" enable row level security;
create policy "Authenticated access on Ambulance" on "Ambulance" for all to authenticated using (true) with check (true);

alter table "AmbulanceDispatch" enable row level security;
create policy "Authenticated access on AmbulanceDispatch" on "AmbulanceDispatch" for all to authenticated using (true) with check (true);

alter table "AmbulanceRequest" enable row level security;
create policy "Authenticated access on AmbulanceRequest" on "AmbulanceRequest" for all to authenticated using (true) with check (true);

alter table "Wallet" enable row level security;
create policy "Authenticated access on Wallet" on "Wallet" for all to authenticated using (true) with check (true);

alter table "WalletTransaction" enable row level security;
create policy "Authenticated access on WalletTransaction" on "WalletTransaction" for all to authenticated using (true) with check (true);

alter table "Billing" enable row level security;
create policy "Authenticated access on Billing" on "Billing" for all to authenticated using (true) with check (true);

alter table "Payment" enable row level security;
create policy "Authenticated access on Payment" on "Payment" for all to authenticated using (true) with check (true);

alter table "Conversation" enable row level security;
create policy "Authenticated access on Conversation" on "Conversation" for all to authenticated using (true) with check (true);

alter table "Message" enable row level security;
create policy "Authenticated access on Message" on "Message" for all to authenticated using (true) with check (true);

alter table "BirthRecord" enable row level security;
create policy "Authenticated access on BirthRecord" on "BirthRecord" for all to authenticated using (true) with check (true);

alter table "DeathRecord" enable row level security;
create policy "Authenticated access on DeathRecord" on "DeathRecord" for all to authenticated using (true) with check (true);

alter table "MarketplaceVendor" enable row level security;
create policy "Authenticated access on MarketplaceVendor" on "MarketplaceVendor" for all to authenticated using (true) with check (true);

alter table "MarketplaceProduct" enable row level security;
create policy "Authenticated access on MarketplaceProduct" on "MarketplaceProduct" for all to authenticated using (true) with check (true);

alter table "MarketplaceOrder" enable row level security;
create policy "Authenticated access on MarketplaceOrder" on "MarketplaceOrder" for all to authenticated using (true) with check (true);

alter table "OrderItem" enable row level security;
create policy "Authenticated access on OrderItem" on "OrderItem" for all to authenticated using (true) with check (true);

alter table "CartItem" enable row level security;
create policy "Authenticated access on CartItem" on "CartItem" for all to authenticated using (true) with check (true);

alter table "SavedVendor" enable row level security;
create policy "Authenticated access on SavedVendor" on "SavedVendor" for all to authenticated using (true) with check (true);

alter table "Prescription" enable row level security;
create policy "Authenticated access on Prescription" on "Prescription" for all to authenticated using (true) with check (true);

alter table "_DoctorPatients" enable row level security;
create policy "Authenticated access on _DoctorPatients" on "_DoctorPatients" for all to authenticated using (true) with check (true);

