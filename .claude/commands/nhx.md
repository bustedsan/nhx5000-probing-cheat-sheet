---
description: Write/edit NHX 5000 Fanuc 31i-B code or Renishaw probing routines via the nhx5000-programmer agent
argument-hint: e.g. probe a 2.000 bore on the front face, write to G55
---
Use the **nhx5000-programmer** subagent for the request below. Have it load its
machine profile (`.claude/agents/nhx5000/machine-profile.md`) and the repo's
cheat-sheet HTML for exact macro tables, follow the shop conventions and the
safety hard-rules (no invented macro args / return vars; save #185–#189 to
#10500+; state B-axis face + work offset), and finish with its output contract
(what it does · type-in-ready code · returns · first-run checklist · any ⚠ VERIFY).

Request: $ARGUMENTS
