# Ember Vault: Afterlight — Live HTTPS Deployment

This project is prepared for a public HTTPS deployment on Render.

## What gets deployed

- Node.js web service serving the game UI and API
- Secure WebSocket endpoint on the same HTTPS origin
- Render PostgreSQL database for persistent accounts, vaults, rooms and audit data
- Render Key Value (Redis-compatible) service for cross-instance synchronization and server tick locking
- Automatic `https://<service>.onrender.com` address
- Automatic HTTPS/TLS at the Render edge
- Database migrations run when the Node service starts

Render web services provide a public `onrender.com` URL and support inbound WebSockets. The browser automatically switches to `wss://` when the page is HTTPS.

## Deploy

1. Put this project in a GitHub, GitLab, or Bitbucket repository. Keep `render.yaml` at the repository root.
2. In Render, choose **New → Blueprint** and select the repository.
3. Render reads `render.yaml` and creates the web service, PostgreSQL database, and Redis-compatible Key Value service.
4. During the Blueprint setup, provide the four SMTP values marked `sync: false`:
   - `SMTP_HOST`
   - `SMTP_USER`
   - `SMTP_PASS`
   - `SMTP_FROM`
5. Deploy the Blueprint.
6. Open the generated `https://...onrender.com` address from the Render service page.

The service's `PUBLIC_URL` is automatically populated from Render's `RENDER_EXTERNAL_URL`, so verification and password-reset links use the deployed HTTPS address.

## Important free-tier note

Render currently offers free web services and free Postgres/Key Value options for testing and hobby projects, but its free services have limitations and are not intended for production workloads. Free web services can spin down after inactivity.

For a larger public game, move the web service/database/cache to paid plans and enable durable database recovery/backups.

## Custom domain

After the generated site is working, a custom domain can be attached to the Render web service. Render provides managed TLS for the public service.

## Local run

```bash
npm install
# configure DATABASE_URL and JWT_SECRET in .env/environment
npm start
```

Then open `http://localhost:8080`.

## Security

Never commit `.env`, SMTP credentials, database credentials, JWT secrets, backup keys, or database dumps.
