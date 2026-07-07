# 📱 Option 3 — Run the real agent from your phone (Claude Code, cloud)

This runs the **actual `cnc-tooling` agent** (with its self-updating knowledge
base) from the **Claude app → Code tab**, in a cloud environment — no computer.
The only setup that matters is giving the environment **internet access to the
tooling sites**, because by default it's walled off.

Docs: [Claude Code on the web](https://code.claude.com/docs/en/claude-code-on-the-web)

---

## STEP 1 — Open the environment's Network access
In the Claude app **Code** tab (or `claude.ai/code`):
1. Go to your **environments / settings** for this repo.
2. **Edit** the environment → find **Network access**.
3. Default is **Trusted** (package registries only — this is why scraping fails).
4. Keep Trusted, but **add the custom allowed domains below** (or, if your plan
   offers it, pick a broader access level). Then save.

## STEP 2 — Paste these allowed domains
The brands + distributors the agent actually uses (add subdomains too if the
field requires exact hosts):

```
# Manufacturers
sandvik.coromant.com
cdn2.sandvik.coromant.com
kennametal.com
iscar.com
secotools.com
walter-tools.com
mac.walter-tools.com
mmc-carbide.com
mitsubishicarbide.com
kyocera-sgstool.com
osgtool.com
guhring.com
tungaloy.com
yg1usa.com
harveytool.com
helicaltool.com
harveyperformance.com
map.harveyperformance.com
harveyperformance.widen.net

# Distributors / mirrors (often where the real part# + PDFs live)
mscdirect.com
www1.mscdirect.com
dgisupply.com
productivity.com
freertool.com
grovesindustrial.com
cdn.grovesindustrial.com
sourceatlantic.ca
penntoolco.com
```

> Add more as the agent discovers them — each live run, if a source is blocked,
> note the domain and add it here next time.

## STEP 3 — Make sure the agent files are in the session
The agent lives on branch **`claude/personal-ai-agents-learning-qwj37c`**.
When you start a Code session, **select that branch** (or merge it to your
default branch so it's always present). The `.claude/agents/` files load
automatically — no extra config.

## STEP 4 — Run it
In the Code session on your phone, just type the job, e.g.:
> *1.25" indexable, 13-8 PH at 45 HRC, 4"+ stickout, rigid CAT40 VMC — find the cutter + inserts + feeds/speeds.*

The `cnc-tooling` agent fires, asks anything missing, and now that the domains
are allowed, it can **download catalog PDFs and read the exact Vc/fz tables** —
the gap that WebSearch-only couldn't close.

---

## What still won't work (and that's OK)
- **Sandvik ToolGuide / Kennametal NOVO** are JS apps / login-walled — even with
  network access the agent can't log in as you. It falls back to catalog PDFs +
  distributor listings and flags confidence. That's by design.
- If a domain you need is missing from the allow-list, the agent will say the
  source was unreachable rather than guess — add that domain and re-run.

## Fallback
If your plan/org won't let you widen network access, use the **Claude Project**
(`PHONE-PROJECT-PROMPT.md`) instead — its web search isn't subject to this
environment's network policy.
