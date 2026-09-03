# Inspire Stars Academy Rwanda — Website Handover

Everything needed to host, edit, and maintain the site. No prior contact
with the original developer is required.

**Live preview at time of handover:** https://inspire-stars-academy-rw-preview.netlify.app/

---

## 1. What this is

A single-page static website. There is **no build step, no framework, no
database, and no server code**. The entire site is one HTML file plus a
folder of images.

That means:

- You can open `index.html` in any text editor and change it directly.
- You can host it anywhere that serves files — Netlify, Vercel, Cloudflare
  Pages, GitHub Pages, or ordinary cPanel shared hosting.
- Nothing can "break the build", because there isn't one.

### Files

```
index.html            The entire website — HTML, CSS and JavaScript in one file
404.html              Shown when someone visits a URL that doesn't exist
images/               All photos, logos and the hero video (33 files)

favicon.ico           Browser-tab icon
favicon-96x96.png     Higher-resolution tab icon
apple-touch-icon.png  Icon used when the site is saved to an iPhone home screen
site.webmanifest      Name, colours and icons for phone home-screen installs

robots.txt            Tells search engines they may index the site
sitemap.xml           Lists the site's URL for Google

netlify.toml          Caching + security headers (Netlify)
_headers              Caching + security headers (Netlify / Cloudflare Pages)
.htaccess             Caching + security headers + 404 routing (Apache / cPanel)

HANDOFF.md            This document
```

The three config files are host-specific. **Keep all three** — each host
reads the one it understands and ignores the others.

---

## 2. Publishing the site

### Netlify (easiest — this is how it is deployed today)

Drag-and-drop:
1. Sign in at https://app.netlify.com
2. Go to **Sites** → drag this whole folder onto the drop area.
3. It goes live in about 20 seconds on a `*.netlify.app` address.

To update later, drag the folder on again. That replaces the whole site.

Better for the long run — connect a Git repository:
1. Put this folder in a GitHub repo.
2. Netlify → **Add new site** → **Import an existing project**.
3. Build command: **leave empty**. Publish directory: **`.`**
4. Every push to the main branch republishes automatically.

### Vercel / Cloudflare Pages

Same as above. Framework preset: **Other** / **None**. Build command
empty, output directory `.`.

### GitHub Pages

Push the folder to a repo → **Settings** → **Pages** → deploy from branch,
root folder. Note that GitHub Pages ignores `_headers` and `.htaccess`, so
you lose the caching rules. Everything else works.

### cPanel / traditional shared hosting

Upload the contents of this folder into `public_html` via FTP or the File
Manager. Make sure `.htaccess` is uploaded too — it is a hidden file, so
enable "show hidden files" in the File Manager first. It handles the 404
page, compression and caching.

---

## 3. Where enrollment enquiries go

**Every submission is emailed to `rodriguenzeye53@gmail.com`.**

The form uses **FormSubmit** (https://formsubmit.co) — a free service that
emails static-site form submissions. There is no account, no dashboard and
no server code, and it works identically on every host.

### ⚠️ One-time activation — do this before launch

FormSubmit will not deliver anything until the recipient address is
confirmed. This has to be done once:

1. Open the live site and send **one test enquiry** through the form.
2. FormSubmit emails `rodriguenzeye53@gmail.com` asking to confirm the
   address. **Check the spam folder** — it often lands there.
3. Click the confirmation link in that email.
4. Send a second test enquiry. It should now arrive in the inbox as a
   formatted table.

**Until step 3 is done, enquiries will not be delivered.** Do this before
telling the client the site is live.

### Changing the recipient address

Open `index.html`, search for `ENROLLMENT FORM`, and edit these two lines:

```js
var FORM_ENDPOINT       = 'https://formsubmit.co/ajax/rodriguenzeye53@gmail.com';
var FORM_FALLBACK_EMAIL = 'rodriguenzeye53@gmail.com';
```

Change the address in **both**. A new address needs its own activation
(repeat the steps above).

### Recommended: hide the address from spam bots

Once activated, FormSubmit gives you a random alias so the email address
is no longer visible in the page source. Find it at
https://formsubmit.co → "Get your form's unique URL", then change
`FORM_ENDPOINT` to:

```js
var FORM_ENDPOINT = 'https://formsubmit.co/ajax/YOUR_RANDOM_ALIAS';
```

Leave `FORM_FALLBACK_EMAIL` as the real address.

### What happens if the service is down

The form never fails silently. If the request doesn't go through, the page
shows an error, opens the visitor's own email app with all their details
pre-filled, and displays the academy's WhatsApp number and phone number.
An enquiry can't be lost without the visitor seeing that it wasn't sent.

### Using a different service instead

The form posts a plain JSON object, so swapping providers is a one-line
change to `FORM_ENDPOINT`:

| Service | Endpoint | Notes |
|---|---|---|
| **Formspree** | `https://formspree.io/f/YOUR_ID` | Free tier ~50 submissions/month. Needs an account. |
| **Web3Forms** | `https://api.web3forms.com/submit` | Free, unlimited. Add an `access_key` hidden field. |
| **Netlify Forms** | — | Netlify only. Add `netlify` and `name="enroll"` to the `<form>` tag and remove the `fetch()` block so the form posts normally. 100 submissions/month free. |

---

## 4. Pointing a domain at the site

The site is currently on a `*.netlify.app` address. When the client's
domain is ready:

1. **On the host**, add the custom domain (Netlify: Site → Domain
   management → Add a domain) and follow its DNS instructions. Enable the
   free HTTPS certificate — Netlify, Vercel and Cloudflare do this
   automatically; on cPanel use AutoSSL / Let's Encrypt.

2. **In `index.html`**, find and replace every occurrence of
   `inspirestars.rw` with the real domain. It appears in the canonical
   tag, the social-sharing tags and the structured data near the top of
   the file.

3. **In `robots.txt` and `sitemap.xml`**, change the same domain.

4. **On cPanel only**, uncomment the "Force HTTPS" block at the bottom of
   `.htaccess`.

> The site does not break if you skip steps 2–3. A small script in
> `index.html` corrects the canonical and social-preview URLs at runtime
> to whatever domain the site is actually served from, so link previews
> work on any host out of the box. Doing the find-and-replace makes it
> correct for search-engine crawlers too, which is worth doing properly
> once the domain is final.

---

## 5. Editing content

Open `index.html` in a text editor (VS Code, Notepad++, Sublime). The file
is organised top to bottom in the same order as the page, with commented
section banners like:

```html
<!-- ============================================================
     GALLERY
     ============================================================ -->
```

### Common edits

**Phone number** — search for `789921727`. It appears in the WhatsApp
float button, the WhatsApp link, the contact section and the structured
data. Change every occurrence.

**Email address shown on the page** — search for `info@inspirestars.rw`.
(This is separate from where the *form* sends enquiries — see section 3.)

**Locations** — search for `Amahoro Stadium` in the Contact section.

**Add a gallery photo** — put the image in `images/`, then copy an
existing tile and change the three values:

```html
<div class="gallery-item" role="listitem">
  <img src="images/your-photo.jpg" alt="Describe the photo" loading="lazy"
       width="732" height="752" decoding="async" />
  <div class="gallery-overlay">Your caption</div>
</div>
```

Set `width` and `height` to the image's real pixel dimensions — this stops
the page jumping around while photos load. The `alt` text matters for
accessibility and search.

**Add a partner logo** — put the logo in `images/`, then add this line to
**both** `.marquee-group` blocks (they are identical copies, which is what
makes the scrolling loop seamless):

```html
<img class="marquee-logo" src="images/partner-name.png" alt="Partner name"
     width="230" height="240" decoding="async" />
```

**Add a coach** — copy a whole `.coach-card` block in the Coaches section
and change the photo, name, role and bio.

**Colours** — every colour is defined once at the top of the `<style>`
block, under `:root`. Change `--navy` or `--gold` there and it updates
across the whole site.

**Copyright year** — updates itself automatically. Leave it alone.

### Replacing the hero video

`images/hero.mp4` (823 KB) plays silently behind the headline. Keep any
replacement under about 2 MB or mobile visitors on slow connections will
see the still image for a long time. `images/hero.jpg` is the poster shown
while the video loads and to anyone who has reduced-motion enabled.

---

## 6. Search engine setup

Once the real domain is live:

1. Go to https://search.google.com/search-console
2. Add the domain and verify ownership (DNS record or HTML tag).
3. Submit `https://yourdomain.com/sitemap.xml`.
4. Do the same at https://www.bing.com/webmasters if you want Bing.

The page already includes a title, meta description, Open Graph tags for
WhatsApp/Facebook link previews, Twitter Card tags, and
`SportsOrganization` structured data listing the academy's name, address,
phone, sports and social profiles.

To check how a shared link looks:
- Facebook / WhatsApp — https://developers.facebook.com/tools/debug/
- Twitter / X — https://cards-dev.twitter.com/validator

---

## 7. Testing changes before publishing

Double-clicking `index.html` opens it in a browser and mostly works, but
the form and the manifest behave slightly differently over `file://`. To
preview it properly, run a local server from inside this folder:

```bash
npx serve .
```

Then open the address it prints (usually http://localhost:3000).

If you have Python instead:

```bash
python -m http.server 8000
```

---

## 8. Known points worth a decision

None of these are faults — they are choices the client may want to revisit.

- **Partner marquee.** It currently shows the academy's own logo
  alternating with the DFI logo, repeated three times to fill the strip.
  If real sponsors come on board, replace them (section 5). If not, the
  section can be deleted entirely — remove the `<section id="partners">`
  block.

- **Gallery photos aren't clickable.** They are display-only, with a
  caption on hover. There is no full-size lightbox. Adding one is a
  reasonable future enhancement.

- **Images are JPEG/PNG, not WebP.** The whole image folder is about
  3.6 MB, which is fine. Converting to WebP would roughly halve it if page
  speed becomes a priority.

- **Google Fonts** (Sora and Inter) load from Google's servers. If the
  client needs the site to work fully offline or wants to avoid the
  third-party request, the fonts can be downloaded and served locally.

---

## 9. Quick pre-launch checklist

- [ ] Site uploaded and loading on the host
- [ ] **Form activated** — test enquiry sent, FormSubmit confirmation link
      clicked, second test enquiry received (section 3)
- [ ] Custom domain connected and HTTPS certificate active
- [ ] `inspirestars.rw` replaced with the real domain in `index.html`,
      `robots.txt` and `sitemap.xml`
- [ ] Phone number, email and locations confirmed correct with the client
- [ ] Checked on a real phone, not just a resized desktop browser
- [ ] Sitemap submitted to Google Search Console
- [ ] Link preview checked with the Facebook debugger
