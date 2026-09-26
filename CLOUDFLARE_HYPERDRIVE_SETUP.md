# Cloudflare Workers → Cloudflare Hyperdrive → Aiven PostgreSQL Guide

This document explains how to connect your Cloudflare Worker to an **Aiven PostgreSQL database** using **Cloudflare Hyperdrive** connection pooling and caching.

---

## 🏛️ Architecture

```text
Browser / API Client
       ↓
Cloudflare Worker (src/index.ts)
       ↓
Cloudflare Hyperdrive (Global Connection Pooler & Query Cache)
       ↓ (TLS / SSL)
Aiven PostgreSQL (Primary Source of Truth)
```

---

## 📋 Prerequisites

1. **Aiven PostgreSQL Service**:
   - Host (e.g. `pg-xyz-yourproject.aivencloud.com`)
   - Port (e.g. `24586`)
   - Database name (e.g. `defaultdb`)
   - Username (e.g. `avnadmin`)
   - Password
   - SSL Mode: Required / TLS

2. **Cloudflare Account & Wrangler CLI**:
   - `wrangler` installed (`npm install` in this folder)

---

## 🛠️ Step 1: Initialize Database Schema in Aiven PostgreSQL

Open your Aiven console SQL Editor (or connect with `psql` / DBeaver) and run the table creation script from [`schema.sql`](./schema.sql):

```sql
-- Creates Word Macros, Word Shortcuts, Scripts, Categories, and Version History
\i schema.sql
```

---

## 🚀 Step 2: Create Cloudflare Hyperdrive Config

Run the Wrangler command to link Cloudflare Hyperdrive to your Aiven PostgreSQL instance:

```bash
npx wrangler hyperdrive create aiven-postgres \
  --connection-string="postgresql://avnadmin:YOUR_PASSWORD@pg-xyz-yourproject.aivencloud.com:24586/defaultdb?sslmode=require"
```

Cloudflare will return an output like:

```text
✨ Created Hyperdrive configuration:
  ID: 8a7c2b4e9f104321abcd1234ef567890
  Name: aiven-postgres
```

---

## ⚙️ Step 3: Update `wrangler.jsonc`

Open [`wrangler.jsonc`](./wrangler.jsonc) and paste the generated Hyperdrive ID into the `hyperdrive` section:

```jsonc
{
  "name": "macro-script-manager-worker",
  "main": "src/index.ts",
  "compatibility_date": "2026-09-27",
  "compatibility_flags": [
    "nodejs_compat"
  ],

  "hyperdrive": [
    {
      "binding": "HYPERDRIVE",
      "id": "8a7c2b4e9f104321abcd1234ef567890" // Paste your Hyperdrive ID here
    }
  ]
}
```

---

## 🔒 Step 4: Local Development & Secrets

For local development with `wrangler dev`, create a `.dev.vars` file (which is git-ignored):

```env
# .dev.vars
HYPERDRIVE_CONNECTION_STRING="postgresql://avnadmin:YOUR_PASSWORD@pg-xyz.aivencloud.com:24586/defaultdb?sslmode=require"
```

---

## 🧪 Step 5: Test Connection Queries

Start the local worker:

```bash
npx wrangler dev
```

Test the database connection endpoint:

```bash
curl http://localhost:8787/api/test-db
```

Expected response:
```json
{
  "status": "success",
  "message": "Successfully connected to Aiven PostgreSQL via Cloudflare Hyperdrive!",
  "current_time": "2026-09-27T00:45:00.123Z",
  "database_version": "PostgreSQL 16.2 on x86_64-pc-linux-gnu ...",
  "hyperdrive": {
    "host": "proxied-by-hyperdrive",
    "database": "defaultdb"
  }
}
```

---

## 🚀 Step 6: Deploy to Cloudflare

```bash
npx wrangler deploy
```

Your Worker is now deployed globally across Cloudflare edge locations, pooling connections through Cloudflare Hyperdrive directly into Aiven PostgreSQL.
