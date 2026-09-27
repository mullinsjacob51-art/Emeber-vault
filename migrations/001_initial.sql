CREATE TABLE IF NOT EXISTS users(
 id TEXT PRIMARY KEY,
 email TEXT UNIQUE NOT NULL,
 password_hash TEXT NOT NULL,
 email_verified_at TIMESTAMPTZ,
 created_at TIMESTAMPTZ DEFAULT now(),
 updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS vaults(
 id TEXT PRIMARY KEY,
 owner_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 state JSONB NOT NULL,
 updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS vault_members(
 vault_id TEXT NOT NULL REFERENCES vaults(id) ON DELETE CASCADE,
 user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 slot INT NOT NULL,
 PRIMARY KEY(vault_id,user_id), UNIQUE(vault_id,slot)
);
CREATE TABLE IF NOT EXISTS rooms(
 code TEXT PRIMARY KEY,
 vault_id TEXT NOT NULL REFERENCES vaults(id) ON DELETE CASCADE,
 p1_user TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 p2_user TEXT REFERENCES users(id) ON DELETE SET NULL,
 last_active TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS sessions(
 id TEXT PRIMARY KEY,
 user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 token_hash TEXT UNIQUE NOT NULL,
 expires_at TIMESTAMPTZ NOT NULL,
 revoked_at TIMESTAMPTZ,
 replaced_by TEXT,
 created_at TIMESTAMPTZ DEFAULT now(),
 last_used_at TIMESTAMPTZ DEFAULT now(),
 ip INET,
 user_agent TEXT
);
CREATE TABLE IF NOT EXISTS email_tokens(
 id TEXT PRIMARY KEY,
 user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
 token_hash TEXT UNIQUE NOT NULL,
 purpose TEXT NOT NULL CHECK(purpose IN ('verify','reset')),
 expires_at TIMESTAMPTZ NOT NULL,
 used_at TIMESTAMPTZ,
 created_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS audit_events(
 id BIGSERIAL PRIMARY KEY,
 user_id TEXT REFERENCES users(id) ON DELETE SET NULL,
 vault_id TEXT REFERENCES vaults(id) ON DELETE SET NULL,
 action TEXT NOT NULL,
 payload_hash TEXT,
 metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
 created_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE IF NOT EXISTS schema_migrations(
 version TEXT PRIMARY KEY,
 applied_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX IF NOT EXISTS sessions_user_idx ON sessions(user_id,expires_at);
CREATE INDEX IF NOT EXISTS email_tokens_lookup_idx ON email_tokens(user_id,purpose,expires_at);
CREATE INDEX IF NOT EXISTS audit_events_vault_idx ON audit_events(vault_id,created_at DESC);
CREATE INDEX IF NOT EXISTS audit_events_user_idx ON audit_events(user_id,created_at DESC);
