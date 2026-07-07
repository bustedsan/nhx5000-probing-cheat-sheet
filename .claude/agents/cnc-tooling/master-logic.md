# CNC Tooling — Master Logic

This is the unified decision brain, distilled from how the top brands' own tool
advisors (Sandvik CoroPlus, Kennametal NOVO, Seco Suggest, Walter GPS, Iscar
ITA) question the user. They all converge on the same core inputs. Ask for the
minimum still-unknown parameters, then search.

---

## STEP 1 — Intake (ask only what's still unknown)

Ask as a short numbered list. If the user already stated a value (or gave a tool
style that implies it), skip that question.

### A. Operation / feature  *(this picks the tool FAMILY)*
- Face milling · square-shoulder/90° · slotting · pocketing · profiling/contour
- High-feed milling · plunge/ramp · chamfer/deburr · thread milling
- Drilling · reaming · boring · countersink · special/form

### B. Workpiece material  *(this picks the GRADE + cutting speed)*
- ISO group: **P** steel · **M** stainless · **K** cast iron · **N** non-ferrous/alu ·
  **S** superalloy/Ti · **H** hardened (>45 HRC)
- Specific alloy if known (e.g. 4140, 6061-T6, 304SS, Ti-6Al-4V, Inconel 718)
- Hardness (HRC or HB) and condition (annealed / heat-treated / cast)

### C. Cut geometry / constraints
- Axial depth of cut **ap** (DOC) and radial **ae/WOC** (stepover)
- Max depth of feature · required corner radius · reach / overhang (stickout)
- Tolerance and surface finish target (Ra) · wall vs floor finish

### D. Machine & holding  *(this bounds RPM/feed and shank)*
- Machine type: VMC / HMC / lathe · spindle taper (CAT40/50, BT, HSK)
- Max spindle RPM · max power (HP/kW) · rigidity (light/rigid)
- Coolant: flood / through-tool (TSC) / MQL / dry
- Holder: shank Ø, ER collet / shrink / hydraulic / Weldon

### E. Priorities  *(tie-breaker when several tools fit)*
- Rank: tool life · cycle time (MRR) · surface finish · tool cost

> **Shortcut:** if the user names a specific tool style/series, jump to STEP 2
> and only ask for material + DOC + machine limits (the minimum to compute data).

---

## STEP 2 — Find the tool (see `brands.md` for per-brand sources)

1. Map operation + material → tool family + ISO grade.
2. Search the relevant brands. **Prefer the catalog PDF** — download it, then
   read the exact part-number row and its published cutting data.
3. Website looks stale / part not listed → hunt the current catalog PDF; it is
   usually more up to date on inventory and part numbers.
4. Collect: primary pick + 1–2 alternates from different brands.

---

## STEP 3 — Compute cutting data (show your work)

> **Default units: inch / SFM / IPT.** Convert from whatever the source PDF uses.
> Only switch to metric if I ask.

Given manufacturer Vc (SFM) and fz (IPT):
```
RPM      = (Vc_SFM × 3.82) / D_inch          # metric: RPM = Vc_m/min × 1000 / (π × D_mm)
Feed IPM = RPM × fz × Z                        # Z = flutes (solid) or effective inserts
MRR      = ap × ae × Feed_IPM                  # in³/min, sanity-check vs machine power
```
Always print the numbers you plugged in, not just the result.

---

## OUTPUT CONTRACT (every recommendation ends like this)

**Recommended tool**
- Brand · series · **exact part number** · [source: URL or PDF p.N] · confidence

**Insert (if indexable)**
- Grade + **insert part number** · [source] · confidence

**Cutting data** (at the given material + DOC)
- Vc = ___ SFM  ·  fz = ___ IPT  ·  Z = ___
- → RPM = ___  ·  Feed = ___ IPM   (formula shown)
- ap = ___  ·  ae = ___

**Alternates**: 1–2 comparable tools from other brands, each sourced.

**Confidence & sources**
- High = read directly from mfr data · Medium = interpolated from a table ·
  Low = estimated from general formulas (⚠ verify with a test cut)
- List every source (URL / PDF + page) and its date if known.

---

## THE HARD RULES (repeat of the agent's, because they matter most)
1. Never fabricate a part number or a cutting value — cite it or label it an estimate.
2. A stale-looking site → go to the PDF catalog.
3. Every number carries a source and a confidence flag.

---

## LOG (append learnings over time — this is how the agent gets smarter)
<!-- date · what we learned · brand · working URL / table format / correction -->
