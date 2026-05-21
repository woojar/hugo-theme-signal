# Signal

A modern Hugo blog theme for technical writers and engineers.

## Demo

[https://woojar.com](https://woojar.com)

## Features

- **Dark mode** — with system-preference detection and manual toggle + localStorage persistence
- **Inline search** — client-side JSON search index, keyboard shortcut (`/`)
- **Reading progress bar** — throttled scroll listener
- **Back-to-top** button
- **Giscus comments** — optional, fully configurable via site params
- **Social sharing** — Twitter, LinkedIn, Facebook, copy-link
- **Author bio** — configurable with avatar, name, bio, and social links
- **Newsletter signup** — optional, any form action URL
- **Related posts** — tag-based matching with graceful fallback
- **Post navigation** — prev / next in section
- **Word count & reading time**
- **Breadcrumbs**
- **Schema.org structured data** — BlogPosting / WebSite JSON-LD
- **OG & Twitter cards** — with featured image support
- **OpenAPI spec** — includes `index.json` for search indexing
- **Print styles** — hides interactive chrome, resets typography
- **Reduced-motion** — respects `prefers-reduced-motion`
- **Skip-link** — accessibility
- **Responsive** — mobile-first, 3 breakpoints

## Installation

### Hugo Version

**Recommended:** Hugo **v0.134.0 or later** for proper `.Summary` rendering with paragraph tags.

**Known Issue:** Hugo versions before 0.134.0 may output `.Summary` as plain text without `<p>` tags, which can affect the styling of post summaries on listing pages.

### As Hugo Module (recommended)

```bash
hugo mod init your.site
```

Add to `hugo.toml`:

```toml
[module]
  [[module.imports]]
    path = "github.com/woojar/hugo-theme-signal"
```

```bash
hugo mod tidy
```

### As a submodule

```bash
git submodule add -b main https://github.com/woojar/hugo-theme-signal.git themes/signal
```

### As a direct clone

```bash
git clone https://github.com/woojar/hugo-theme-signal.git themes/signal
```

Set `theme = "signal"` in your `hugo.toml`.

## Configuration

### Required minimum (`hugo.toml`)

```toml
baseURL = "https://your.site/"
languageCode = "en-us"
title = "Your Site"

[params]
  author = "Your Name"
  description = "What this site is about"

[outputs]
  home = ["HTML", "RSS", "JSON"]

[menus]
  [[menus.main]]
    name = "Home"
    url = "/"
    weight = 1
  [[menus.main]]
    name = "Posts"
    url = "/posts/"
    weight = 2
  # ... more menu items
```

### Giscus comments

```toml
[params.comments]
  enable = true

[params.giscus]
  repo = "your-username/your-repo"
  repoId = "R_kg..."
  category = "General"
  categoryId = "DIC_kw..."
  mapping = "pathname"
  reactionsEnabled = "1"
  inputPosition = "bottom"
  theme = "preferred_color_scheme"
  lang = "en"
```

### Author bio

```toml
[params.authorBio]
  enable = true
  avatar = "/avatar.jpg"
  bio = "Short bio text"

[params.social]
  name = "GitHub"
  url = "https://github.com/your-username"
```

### Newsletter

```toml
[params.newsletter]
  enable = true
  url = "https://your-form-url.com"
```

### Social sharing

```toml
[params.share]
  enable = true
```

### Analytics (GA4)

```toml
[params.analytics]
  id = "G-XXXXXXXXXX"
```

### Footer Customization

```toml
[params]
  footerTitle = "Site Name"
  footerDescription = "Short description for the footer."
  disableBreadcrumb = true  # Hide breadcrumbs on pages
```

## Content

### Posts

Create new posts with:

```bash
hugo new posts/my-post.md
```

### Front-matter fields

| Field | Required | Description |
|---|---|---|
| `title` | yes | Post title |
| `date` | yes | Publish date |
| `draft` | yes | `false` to publish |
| `summary` | no | Short description |
| `tags` | no | List of tags |
| `categories` | no | List of categories |
| `featured_image` | no | OG/twitter cover image URL |

## Style customization

Override CSS variables in your site's custom stylesheet or by adding to `hugo.toml` params (requires a small layout override for staging — the theme ships with sensible defaults via `--primary`, `--accent`, `--radius`).

| CSS variable | Default |
|---|---|
| `--primary` | `#2563eb` |
| `--accent` | `#10b981` |
| `--bg` | `#f8fafc` |
| `--text` | `#1e293b` |
| `--bg-card` | `#ffffff` |
| `--bg-header` | `#0f172a` |
| `--code-bg` | `#1e293b` |
| `--radius` | `8px` |

## Using the Example Site

The `exampleSite` directory contains a complete demo site you can run locally to explore the theme:

```bash
hugo server -D -s exampleSite -t ../..
```

This starts a local server (usually at `http://localhost:1313`) with sample content including:
- Homepage listing posts
- About page
- Sample posts demonstrating dark mode and Giscus comments
- Dark mode toggle test

The example uses `theme = "signal"` and includes a minimal config with author bio and social sharing enabled.

## License

MIT © Woojar
