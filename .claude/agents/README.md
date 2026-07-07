# My Personal AI Agents

This folder holds my Claude Code **subagents**. Each `.md` file *is* an agent.
Claude Code reads them automatically — no config, no restart.

## The anatomy of an agent

```markdown
---
name: research-scout          # how you invoke it / how Claude refers to it
description: When to use me.   # Claude reads THIS to decide when to call the agent
tools: WebSearch, WebFetch     # what it's allowed to do (omit = inherit all tools)
model: sonnet                  # sonnet (fast/cheap) | opus (deep) | haiku (quick)
---

You are ...                    # <-- everything below is the SYSTEM PROMPT.
                               #     This is where your prompt-engineering skill goes.
```

That's the whole thing. **The frontmatter is the "when + what". The body is the "how".**

## How to invoke an agent

- **Automatically:** just describe the task ("research the best note-taking apps").
  Claude picks the agent whose `description` matches. This is why a sharp,
  trigger-word-rich `description` matters most.
- **Explicitly:** `@research-scout look into X` or ask Claude to "use the
  research-scout agent".

## The recipe for a new agent (5 min each)

1. Copy an existing file → rename it `.claude/agents/<name>.md`.
2. Rewrite `name` + `description` (put the *trigger words* you'd naturally type).
3. Set `tools` to the minimum it needs (fewer = safer, faster).
4. Write the body: role, how-it-works steps, a fixed **output format**, and rules.
5. Test it on a real task. Tune the prompt. Done.

## My roadmap (5 agents)

- [x] `research-scout` — deep research → cited brief
- [ ] `daily-planner` — calendar + tasks → prioritized day plan
- [ ] `content-writer` — drafts in my voice
- [ ] `inbox-triage` — summarize + draft email replies
- [ ] `meeting-notes` — transcript → action items

## Tips (from someone who already knows prompts)

- The `description` is a *router*, not documentation. Write it the way you'd
  ask for the task out loud.
- Give every agent a **fixed output format** — consistency is what makes an
  assistant feel like an assistant.
- Restrict `tools`. A writer doesn't need web access; a researcher doesn't need Write.
- Keep bodies focused. One agent = one job. Compose them, don't bloat them.
