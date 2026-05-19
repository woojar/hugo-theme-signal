---
title: "Customizing the Dark Mode"
date: 2024-03-10
draft: false
tags: ["css", "customization"]
categories: ["Guide"]
---

Signal ships with a beautiful dark mode that automatically respects the user's system preference. You can also override individual CSS variables.

## CSS Variables

The theme uses CSS custom properties for every colour. Override any of these by adding your own stylesheet:

```css
:root {
  --primary: #2563eb;
  --accent: #10b981;
  --text: #1e293b;
  --bg: #f8fafc;
  --bg-card: #ffffff;
}
```

The `data-theme="dark"` attribute is set on `<html>` when dark mode is active, so you can further scope:

```css
[data-theme="dark"] {
  --primary: #3b82f6;
  --accent: #34d399;
}
```
