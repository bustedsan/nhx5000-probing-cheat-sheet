# NHX 5000 — Machine Profile & Programming Conventions

Ground truth for the `nhx5000-programmer` agent. Distilled from this repo's
`README.md` + `probing-cheat-sheet.html`. When you need exact macro argument
tables or full subprogram examples, **Grep/Read the HTML** — it is authoritative.

> ⚠️ This is a live reference — append confirmed details (macro args, return
> vars, conventions) as you learn them. Never overwrite a confirmed fact with a guess.

## Machine / control
- **Machine:** DMG Mori NHX 5000 — **horizontal** machining center, B-axis pallet.
- **Control:** Fanuc 31i-B (custom macro B available).
- **Probe:** Renishaw Inspection Plus, spindle probe. **Probe tool = H1.**
- **Units:** Inch, **G20**. All tolerances in inches.
- **Probe enable/disable:** **M28** = probe on · **M29** = probe off.
- **Work offsets:** G54 / G55 (extend to G54.1 P__ only if confirmed in use).

## Horizontal-specific discipline (don't assume vertical)
- Always state the **B-axis orientation** and **which work offset** a routine
  assumes for each face of the part / tombstone.
- Runout / multi-face checks rotate B (0 / 90 / 180 / 270) — see the Runout tab.
- Coordinate rotation via **G68** where the cheat sheet uses it (parallelism/angle).

## Renishaw Inspection Plus — macro quick reference
(Range P9810–P9842. Confirm arguments against the HTML and your Inspection Plus
version before running — the README explicitly warns return vars can vary.)

| Macro | Purpose | Key return vars |
|---|---|---|
| P9810 | Protected positioning move | — |
| P9811 | Single-surface probe | #187 error · #188 position |
| P9812 | Two-opposite-surface (pocket/web) | #185 X err · #186 Y err · #188 center · #189 fail flag |
| P9814 | 4-point bore/boss | #187 dia err · #188 measured dia · #185/#186 center |
| P9817 | 3-point bore | #187 dia err · #188 measured dia |
| P9832 | Pattern hole probing | #185/#186 position errors |
| P9833 | Angle probing | #187 angle error |

## Subprogram / numbering scheme (match this)
- Setup routines pair a caller + sub: e.g. **O1000/O1001** (corner+back),
  **O1010/O1011** (center+front), **O1020/O1021** (bore P9814),
  **O1030/O1031** (pocket center P9812), **O1002/O1003** (stock check).
- In-Process Inspection: thickness uses **#187/#188**; width = X & Y; hole size
  via P9814/P9817; runout via B rotation; parallelism via 4-corner Z or G68.

## Variable discipline (safety)
- **Immediately** copy `#185–#189` into dedicated globals **`#10500+`** after each
  macro call — Renishaw reuses those system vars and will overwrite them.
- Never rely on a return var surviving past the next probe move.

## Standard probe sequence (new-operator checklist, from README)
1. `M28` (probe enable)
2. `T1 M06` → `G43 H1` (load probe tool)
3. `G0 Z4.` (safe Z)
4. `G0 X_ Y_` (to part)
5. `G65 P9811 ...` (call macro)
6. `M29` (probe disable)
7. Verify `#188` written to the work offset

## First-run safety (put a tailored version at the end of every routine)
- Dry-run / single-block first; feed-hold ready.
- Confirm **M28** active and **G43 H1** (probe) loaded.
- Save `#185–#189` to `#10500+` right after each call.
- **Dry-run any automatic offset write** before live use.
- Consistent approach direction (always from the same side).
- Confirm return-variable meaning against your exact Inspection Plus version.

## LOG (append confirmed learnings · what · where verified)
<!-- e.g. P9814 arg B__ = nominal bore dia; confirmed in probing-cheat-sheet.html Bore tab -->
