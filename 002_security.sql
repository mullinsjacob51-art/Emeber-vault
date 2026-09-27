ALTER TABLE users ADD COLUMN IF NOT EXISTS email_verified_at TIMESTAMPTZ;
ALTER TABLE sessions ADD COLUMN IF NOT EXISTS replaced_by TEXT;
CREATE INDEX IF NOT EXISTS email_tokens_hash_idx ON email_tokens(token_hash);
