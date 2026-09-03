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
