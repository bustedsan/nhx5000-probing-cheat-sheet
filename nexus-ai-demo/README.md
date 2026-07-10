# Nexus AI meeting — AI talk backup kit

Backup materials for the ~3-minute AI opener before the Nexus AI demo.

## Files

- **`job-market-visualizer-offline.html`** — Andrej Karpathy's US Job Market
  Visualizer (karpathy.ai/jobs), packaged as a **single self-contained file**.
  All 342 BLS occupations, all four color layers (BLS Outlook, Median Pay,
  Education, Digital AI Exposure), and all data are embedded inside this one
  HTML file.

## How to use it (the offline backup)

1. Get this file onto your laptop (see "Getting it onto your laptop" below).
2. **Double-click it.** It opens in your default browser — no internet, no
   shop wifi, no Python, no server, nothing to install.
3. Use the **LAYER** buttons at the top to switch between:
   - *BLS Outlook* — the government 10-year growth outlook (your Tab 1).
   - *Digital AI Exposure* — the AI-exposure coloring (your Tab 2).
4. Click any tile to read that occupation's detail. Read exposure scores
   **live off the screen** during the talk (e.g. Drafters, Mechanical
   engineers) rather than quoting from memory.

Because everything is inline, this is your guaranteed backup if the live
site or the shop wifi is down.

## Getting it onto your laptop

This kit lives on the `claude/ai-talk-nexus-meeting-vxgtc0` branch. On your
laptop:

```
git clone <this-repo-url>
git checkout claude/ai-talk-nexus-meeting-vxgtc0
```

Then open `nexus-ai-demo/job-market-visualizer-offline.html`. Or just
download that one file directly from GitHub (Raw → Save As) — it is fully
standalone.

## Live site (primary)

Primary plan is still the live site: **https://karpathy.ai/jobs/**
Use the offline file only as the fallback.
