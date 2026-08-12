-- Supabase Auth -> public."User" sync
-- Passwords are managed exclusively by Supabase Auth (auth.users);
-- public."User".password is kept nullable and unused.

ALTER TABLE "User" ALTER COLUMN "password" DROP NOT NULL;

-- Function to sync a new auth user into the application users table
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  user_role "UserRole";
  user_name TEXT;
  super_admin BOOLEAN;
  hospital_admin BOOLEAN;
BEGIN
  user_name := COALESCE(
    NEW.raw_user_meta_data->>'name',
    NEW.raw_user_meta_data->>'full_name',
    split_part(NEW.email, '@', 1)
  );

  user_role := COALESCE(
    (NEW.raw_user_meta_data->>'role')::"UserRole",
    'STAFF'::"UserRole"
  );

  super_admin := COALESCE(
    (NEW.raw_user_meta_data->>'isSuperAdmin')::BOOLEAN,
    (NEW.raw_user_meta_data->>'is_super_admin')::BOOLEAN,
    false
  );

  hospital_admin := COALESCE(
    (NEW.raw_user_meta_data->>'isHospitalAdmin')::BOOLEAN,
    (NEW.raw_user_meta_data->>'is_hospital_admin')::BOOLEAN,
    false
  );

  INSERT INTO "User" (
    "id",
    "email",
    "password",
    "name",
    "role",
    "isSuperAdmin",
    "isHospitalAdmin",
    "hospitalId",
    "phone",
    "photo",
    "specialties",
    "createdAt",
    "updatedAt"
  )
  VALUES (
    NEW.id::TEXT,
    NEW.email,
    NULL,
    user_name,
    user_role,
    super_admin,
    hospital_admin,
    NULLIF(NEW.raw_user_meta_data->>'hospitalId', ''),
    NULLIF(NEW.raw_user_meta_data->>'phone', ''),
    NULLIF(NEW.raw_user_meta_data->>'photo', ''),
    ARRAY[]::TEXT[],
    NEW.created_at,
    NEW.updated_at
  );

  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Function to update the application user row when auth profile changes
CREATE OR REPLACE FUNCTION public.handle_user_update()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE "User"
  SET
    "email" = NEW.email,
    "name" = COALESCE(
      NEW.raw_user_meta_data->>'name',
      NEW.raw_user_meta_data->>'full_name',
      split_part(NEW.email, '@', 1)
    ),
    "role" = COALESCE(
      (NEW.raw_user_meta_data->>'role')::"UserRole",
      "role"
    ),
    "isSuperAdmin" = COALESCE(
      (NEW.raw_user_meta_data->>'isSuperAdmin')::BOOLEAN,
      (NEW.raw_user_meta_data->>'is_super_admin')::BOOLEAN,
      "isSuperAdmin"
    ),
    "isHospitalAdmin" = COALESCE(
      (NEW.raw_user_meta_data->>'isHospitalAdmin')::BOOLEAN,
      (NEW.raw_user_meta_data->>'is_hospital_admin')::BOOLEAN,
      "isHospitalAdmin"
    ),
    "hospitalId" = COALESCE(
      NULLIF(NEW.raw_user_meta_data->>'hospitalId', ''),
      "hospitalId"
    ),
    "updatedAt" = NEW.updated_at
  WHERE "id" = NEW.id::TEXT;

  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_updated
  AFTER UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_user_update();
