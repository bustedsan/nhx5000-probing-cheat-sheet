---
description: Recommend a CNC milling tool (exact part number + feeds/speeds) via the cnc-tooling agent
argument-hint: e.g. 1.25 indexable, 13-8 at 45 HRC, 4in stickout, CAT40 VMC
---
Use the **cnc-tooling** subagent to recommend a milling tool for the job below.
Have it follow its knowledge base (`master-logic.md`, `brands.md`), ask me only
for parameters still missing, obey the no-fabrication / cite-everything rules,
and finish with its full output contract (primary pick + alternates + feeds &
speeds with the formula shown + sources & confidence).

Job: $ARGUMENTS
