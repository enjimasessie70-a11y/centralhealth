-- Add CURRENT_TIMESTAMP default to every updatedAt column
-- Prisma previously supplied these values client-side via @updatedAt.
DO $$
DECLARE
  tbl TEXT;
  col TEXT;
BEGIN
  FOR tbl, col IN
    SELECT c.table_name::TEXT, c.column_name::TEXT
    FROM information_schema.columns c
    JOIN information_schema.tables t
      ON t.table_schema = c.table_schema AND t.table_name = c.table_name
    WHERE c.table_schema = 'public'
      AND t.table_type = 'BASE TABLE'
      AND c.column_name IN ('updatedAt', 'updated_at')
      AND c.column_default IS NULL
      AND c.is_nullable = 'NO'
  LOOP
    EXECUTE format('ALTER TABLE %I ALTER COLUMN %I SET DEFAULT CURRENT_TIMESTAMP', tbl, col);
  END LOOP;
END $$;
