# Supabase setup

1. Open the Supabase SQL Editor and run [`schema.sql`](schema.sql).
2. In Supabase Auth, enable Email. Magic links are used so no password is stored in the site.
3. Sign in once through `admin-live.html`.
4. In the SQL Editor, add that account to the admin allow-list:

```sql
insert into public.admin_users (user_id)
select id from auth.users where email = 'your-admin-email@example.com'
on conflict do nothing;
```

The publishable key in `supabase-config.js` is intended for browser use. Never put a secret or service-role key in this repository.
