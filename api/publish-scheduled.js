export default async function handler(request, response) {
  const expected = process.env.CRON_SECRET;
  const authorization = request.headers.authorization;
  if (!expected || authorization !== `Bearer ${expected}`) {
    return response.status(401).json({ error: 'Unauthorized' });
  }

  const projectUrl = process.env.SUPABASE_URL;
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!projectUrl || !serviceKey) {
    return response.status(500).json({ error: 'Supabase cron environment is not configured' });
  }

  const today = new Date().toISOString().slice(0, 10);
  const result = await fetch(`${projectUrl}/rest/v1/stories?status=eq.scheduled&publish_date=lte.${today}`, {
    method: 'PATCH',
    headers: {
      apikey: serviceKey,
      Authorization: `Bearer ${serviceKey}`,
      'Content-Type': 'application/json',
      Prefer: 'return=representation'
    },
    body: JSON.stringify({ status: 'published', updated_at: new Date().toISOString() })
  });

  if (!result.ok) {
    return response.status(502).json({ error: await result.text() });
  }

  const published = await result.json();
  return response.status(200).json({ published: published.length });
}
