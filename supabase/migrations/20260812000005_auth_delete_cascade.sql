-- Cascade cleanup: when an auth user is deleted, remove the linked
-- public "User" row. The Patient row is not FK-bound (Prisma managed
-- relations client-side), so we clean it up explicitly.
CREATE OR REPLACE FUNCTION public.handle_user_delete()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  DELETE FROM "Patient" WHERE "userId" = OLD.id::TEXT;
  DELETE FROM "User" WHERE "id" = OLD.id::TEXT;
  RETURN OLD;
END;
$$;

CREATE TRIGGER on_auth_user_deleted
  AFTER DELETE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_user_delete();
