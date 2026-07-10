# Nexus AI meeting — AI talk backup kit

Backup materials for the ~3-minute AI opener before the Nexus AI demo. Every
file here is a **single self-contained HTML file** — double-click it and it
opens in your browser with no internet, no shop wifi, no Python, no server,
nothing to install.

## The three files

1. **`job-market-visualizer-offline.html`** — the *pristine* backup.
   Andrej Karpathy's US Job Market Visualizer (karpathy.ai/jobs) exactly as
   published, all 342 BLS occupations and all four color layers, data inlined.
   This is your safety net if the live site or wifi is down. Nothing customized.

2. **`our-shop-ai-exposure.html`** — the **"Where AI Hits Our Shop"** scorecard.
   A purpose-built one-screen slide ranking our 7 roles by AI exposure (9 → 2)
   with a one-line rationale each, plus the landing line and the
   "reshaped, not replaced" caveat. This is the strongest single visual for the
   room — it names *our* jobs directly. Recommended as your main custom slide.

3. **`job-market-visualizer-OURSHOP.html`** — the *recolored* treemap.
   The full Karpathy map, but the shop-relevant tiles are re-scored to our
   aerospace/defense lens and their click-through rationales rewritten in
   shop language. Changed tiles: Machinists 4→3, Metal/plastic machine workers
   4→3, Assemblers 3→2. Click "Machinists and tool and die makers," "Drafters,"
   etc. during the demo and the pop-up speaks about spindles, setups, proveout,
   CAM files.

## Our 7 roles (the scores in file #2)

| Role | Score | One-liner |
|------|:---:|------|
| CAD drafter | 9 | Pure digital file — model, drawing, GD&T. Highest exposure. |
| CNC programmer | 8 | G-code / CAM is a digital file; proveout on exotic alloys holds it below 9. |
| Manufacturing engineer | 7 | Digital deliverables AI can draft, anchored by shop-floor judgment. |
| CMM programmer | 7 | Offline inspection routines from CAD, coupled to physical metrology. |
| Quality inspector | 5 | Hands-on measurement + digital docs. Mid-scale. |
| Machinist / operator | 3 | Hands-on the spindle. One of the safest jobs on the board. |
| Assembler | 2 | Almost entirely physical/manual. Lowest exposure. |

Scores follow Karpathy's exact 0–10 rubric and physical-vs-digital logic; the
gradient (drafter/programmer/engineer high, operator/assembler low) maps
directly onto the "look around this room" beat.

## How to run the talk

- **Primary:** the live site, **https://karpathy.ai/jobs/**. Tab 1 = *BLS
  Outlook*, Tab 2 = *Digital AI Exposure*. Read exposure scores **live off the
  screen** (Drafters, Mechanical engineers) rather than from memory.
- **If wifi/site fails:** open `job-market-visualizer-offline.html` — same tool,
  same LAYER buttons, fully offline.
- **To make it about *our* room:** show `our-shop-ai-exposure.html` (the
  scorecard), or switch to `job-market-visualizer-OURSHOP.html` and click our
  tiles.

## Getting these onto your laptop tonight

This kit lives on the `claude/ai-talk-nexus-meeting-vxgtc0` branch:

```
git clone <this-repo-url>
git checkout claude/ai-talk-nexus-meeting-vxgtc0
```

Then open the files in `nexus-ai-demo/`. Or download any single file directly
from GitHub (open it → **Raw → Save As**) — each one is fully standalone.

> Note: these were built and verified inside a remote cloud container, so any
> `localhost` URL from that session will NOT work on your laptop. That's why the
> deliverable is these self-contained files, not a running server.
