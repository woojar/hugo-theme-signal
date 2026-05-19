---
title: "Configuring Giscus Comments"
date: 2024-02-01
draft: false
tags: ["configuration", "giscus"]
categories: ["Guide"]
---

The Signal theme supports **Giscus** — a comments system powered by GitHub Discussions.

## Setup

1. Enable Giscus on your GitHub repo at [giscus.app](https://giscus.app)
2. Add the generated config to your `hugo.toml`:

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

That's it — comments will appear at the bottom of every post.
