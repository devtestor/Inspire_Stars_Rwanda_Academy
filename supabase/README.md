# Supabase setup

1. Open the Supabase SQL Editor and run [`schema.sql`](schema.sql).
2. In Supabase Auth, enable Email. Magic links are used so no password is stored in the site.
3. Sign in once through `/admin`.
4. In the SQL Editor, add that account to the admin allow-list:

```sql
insert into public.admin_users (user_id)
select id from auth.users where email = 'your-admin-email@example.com'
on conflict do nothing;
```

For the deployed site, add `https://inspire-stars-academy-website.vercel.app/admin` to Supabase Auth URL Configuration.

The publishable key in `supabase-config.js` is intended for browser use. Never put a secret or service-role key in this repository.

The schema supports `draft`, `scheduled`, and `published` stories. Public pages only query `published` records, so a scheduled story stays private until its status is changed by the admin workflow.

## Scheduled publishing

The Vercel cron endpoint runs every 15 minutes and promotes scheduled stories whose `publish_date` has arrived. Add these Vercel environment variables before enabling it:

```text
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-server-only-secret-key
CRON_SECRET=a-long-random-value
```

Never put `SUPABASE_SERVICE_ROLE_KEY` in `supabase-config.js` or the repository.
