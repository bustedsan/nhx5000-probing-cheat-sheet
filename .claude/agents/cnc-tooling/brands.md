# CNC Tooling — Brand Playbook (Top 12, US milling)

Per-brand: how they recommend tools, what data is retrievable, and where the
catalog PDFs live. **All URLs below were gathered via web search, NOT verified
by direct download** (this build environment blocks outbound fetches — see the
"Runtime requirement" note at the bottom). On the FIRST live run from a
network-capable machine, confirm each URL, then update it here with a ✅ and the
date. That is how this file earns its trust.

> Retrieval reality: manufacturer "advisor" apps (Sandvik ToolGuide, Kennametal
> NOVO, Harvey MAP, Walter GPS/WMC, Seco Assistant) are JS apps and several are
> **login-walled**. The dependable machine-readable source is almost always the
> **catalog / speeds-feeds PDF** or a **server-rendered HTML table**. Prefer those.

---

## Retrievability ranking (attack easiest first)

| Tier | Brands | Why |
|---|---|---|
| 🟢 Easiest | **Guhring**, **Iscar** | Guhring = public HTML speeds/feeds tables at predictable URLs. Iscar = server-rendered `.aspx` E-CAT + patterned catalog PDFs. |
| 🟡 Medium | **Harvey/Helical**, **Kyocera/SGS**, **OSG**, **Mitsubishi**, **Kennametal**, **Tungaloy**, **YG-1** | Static catalog / S&F PDFs (some on distributor mirrors). Harvey PDFs need a page→PDF hash resolve. |
| 🔴 Hardest | **Sandvik**, **Walter**, **Seco** | Data locked in JS apps / logins. Use the ISO 13399 API (Sandvik) or PDF-parse only. |

> **Units:** default output is **inch / SFM / IPT**. Convert from whatever the
> source PDF uses; only switch to metric if the user asks.
> **Threading note:** Emuge-Franken was dropped from the general-milling 12 — it
> is the go-to only for **taps / thread-milling**. If a thread-milling job comes
> up, consult Emuge separately (`emuge-franken-group.com/us/en/brochures`).

---

## The 12 brands

### 1. Sandvik Coromant  🔴
- **Advisor:** CoroPlus **ToolGuide** (public JS SPA, data via encoded JSON API) + Cutting Data Calculator. Sanctioned path: **open ISO 13399 API** — use this over scraping.
- **Intake:** material (ISO P/M/K/N/S/H + grade/hardness) → operation → application req → machine (rpm/feed/power/torque) → priority. Outputs Vc, fz, ap, ae.
- **Catalog PDFs:** hub `sandvik.coromant.com/en-us/downloads`; volumes = Turning / **Rotating (milling+drilling)** / Solid Round. Own CDN uses **opaque GUID paths** (non-guessable). Softer targets = distributor mirrors, e.g. `dcngli4g50fhp.cloudfront.net/.../sandvik_5747275_catalog.pdf`, `cdn.grovesindustrial.com/pdf/sds/Sandvik_5747275_Catalog.pdf`.
- **Worked example (part# only; Vc/fz gated):** CoroMill 245 face mill `R245-250Q60-12M`; insert `R245-12 T3 M-PH 4330` (grade GC4330, ISO P).

### 2. Kennametal  🟡
- **Advisor:** **NOVO** "Tool Advisor" (rules engine). ⚠ **Login-walled JS app** — not reachable without the user's account.
- **Intake:** machining feature (shoulder/pocket/slot/face…) → feature req → sequence (rough/finish) → material (ANSI/ISO / KMT master #). Outputs speeds & feeds report.
- **Indexable END-MILL families (sweep ALL of these — don't stop at the first hit):**
  Mill 1-10 · **Mill 1-14** · **Mill 4-11** (4-edge double-sided, shoulder — very common) ·
  Mill 4-15 · KOR (high-feed) · KSSM/KSSR shell mills. Each family comes in
  **Weldon, screw-on, AND cylindrical-shank** styles, and several in **long-length**
  versions. If the job specifies OAL/reach or a cylindrical shank, search the
  family's **cylindrical-shank + long-length** variant by name — that's where the
  5" OAL / shrink-fit configs live.
- **Catalog PDFs (best-retrievable, distributor-hosted):**
  - Face mills master: `productivity.com/wp-content/uploads/pdfs/Kennametal%20Facemills%20-%20Master%20Catalog.pdf`
  - Milling 6050: `productivity.com/wp-content/uploads/pdfs/Kennametal%20Milling%20Catalog%206050.pdf`
  - Solid carbide end mill inch master (2023): `productivity.com/wp-content/uploads/2022/08/Kennametal-2023-Solid-Carbide-End-Milling-Inch-Master-Catalog-Interactive.pdf`
  - Speeds/feeds (MSC): `www1.mscdirect.com/images/solutions/kennametal/endMillSpeedFeed.pdf`, `.../millingTechInfoFormulas.pdf`
- **Worked example (real numbers):** AISI 4140 @220 HB → **Vc = 450 SFM, fz = 0.008 IPT** (table is by material class, not per part#). Part# example: KSSM8+ shell mill order `5420150` (`KSSM87D200SN440S075Z05`).
- **Mill 4-11 part-number GRAMMAR** (decode/validate/construct a config):
  `M4 · D<dia×100> · L11 · <#inserts, 2-digit> · <shank: C=cyl / W=Weldon / A=screw-on><dia×100> · L<OAL×100>`
  Example ✅ `M4D125L1105C100L500` = Mill 4-11, **1.25" dia**, LN11 inserts, **5 inserts**,
  **cylindrical 1.00" shank**, **5.00" OAL** (2.25" shank len). Matches a 1.25"/5"-OAL/
  shrink-fit ask perfectly. [Kennametal Mill 4-11 family](https://www.kennametal.com/us/en/products/metalworking-tools/milling/indexable-milling/shoulder-mills/mill-4-11.html)
  → **Lesson:** learn each brand's part-number grammar so you can recognize a valid
  config, validate a number a rep gives, and search for the exact variant a spec implies.

### 3. Iscar  🟢  *(richest structured data)*
- **Advisor:** **ITA / NEO-ITA** (no login to browse). Returns up to 25 ranked tools each with Vc, fz/fn, ap, ae, spindle power, MRR, cutting time. Calculators: `iscar.com/ITC/Calculators.aspx?units=M`. Materials web service: `iscar.com/wsMaterials/service.asmx` (SOAP).
- **Intake:** material ISO group + operation (face/shoulder/slot) + key dims/DOC (minimal); optional machine/holding/stability.
- **E-CAT (server-rendered .aspx, scrape-friendly):** Family `iscar.com/eCatalog/Family.aspx?fnum=<fam>&mapp=ML&GFSTYP=M` (2593=H600 WXCU, 2574=SEM-C fast feed). Handle ViewState/cookies.
- **Catalog PDF pattern:** `iscar.com/Catalogs/Publication/english_1/<PUB>/<PUB>-en.pdf` — e.g. `FAST_FEED_MILL_Brochure_INCH/FAST_FEED_MILL_Brochure_INCH_2022.pdf`, `MILLING_CATALOG_INCH_2022/MILLING_CATALOG_INCH_2022_P229-P360.pdf`.
- **Worked example (real order#s + feed):** HELIDO H600 fast-feed face-mill inserts — `H600 WXCU 05T312HP` grade IC830 order **EH5606000** (max 0.0268 in/tooth); `...05T312T` order **EH5606349** (max 0.0406); `...080612T` IC810 order **EH5606036** (max 0.0539). Distributor cross-ref: `freertool.com`.

### 4. Seco Tools  🔴
- **Advisor:** **Seco Assistant** app (includes "Suggest" + calculators). Website surfaces articles, not machine-readable tables → hardest to pull. Calculators hub `secotools.com/article/114063`.
- **Approach:** PDF-parse the machining navigator / catalog PDFs; treat live site as non-scrapeable.

### 5. Walter Tools  🔴
- **Advisor:** **Walter GPS** selector + **Walter Machining Calculator (WMC)** at `mac.walter-tools.com` (web app). Base feeds/speeds page: `walter-tools.com/en-us/news-and-media/media-library/apps-and-software/feeds-and-speeds-base-values`.
- **Approach:** data lives in the app; PDF/base-value pages are the fallback.

### 6. Mitsubishi Materials  🟡
- **Advisor:** web catalog cutting-condition search + Cutting Calculation app.
- **Catalog PDFs:** US downloads `mmc-carbide.com/us/download/catalog`; technical `mmc-carbide.com/us/technical_information`; direct `mitsubishicarbide.com/mmus/catalog/pdf/catalog_en/c007a_k.pdf`.

### 7. Kyocera / SGS  🟡
- **Advisor:** **SGS Tool Wizard** (speeds/feeds).
- **Direct S&F PDFs (clean tables):** `kyocera-sgstool.com/uploads/products/downloads/serz5_SF.pdf` (Series Z5/Z5CR). Full catalog PDF on Kyocera CDN (`asia.kyocera.com/products/cuttingtools/.../2021-SGS-Kyocera-Catalog...pdf`).

### 8. OSG  🟡
- **Advisor:** High-Speed Machining Guide + per-product tech pages.
- **PDFs:** catalogs index `osgtool.com/literature/catalogs/`; tech PDF e.g. `osgtool.com/content/literature/8002024CA/Tech Pg. Standard 4Fl & 6FL HSS-Co.pdf`.

### 9. Guhring  🟢  *(easiest to scrape)*
- **Advisor:** Milling Performance Optimizer (endmillcalc).
- **Public HTML speeds/feeds tables (predictable URLs):** `guhring.com/SpeedsAndFeeds/SpeedFeed/ToolChart?toolType=Milling+Cutters`; hub `guhring.com/Support/Speeds-Feeds-Charts`; catalogs `guhring.com/Catalog`.

### 10. Harvey Tool / Helical Solutions  🟡  *(US machinist favorite)*
- **Advisor:** **Machining Advisor Pro (MAP)** `map.harveyperformance.com` (covers both). Inputs: Tool# → Material(type/subgroup/condition, hardness auto) → Operation (slot/rough/HEM/finish) → Machine (max rpm/ipm, holder, workholding) + stickout/axial/radial DOC. ⚠ **Free login required**, no public API.
- **Per-tool S&F:** product pages `harveytool.com/products/tool-details-<num>` / `helicaltool.com/products/tool-details-<num>` (JS app). Real S&F PDFs on **Widen DAM** `harveyperformance.widen.net/content/<hash>/pdf/SF_<series>.pdf` — hash is opaque, resolve from the product page. PDFs are per-family.
- **Worked examples:** Harvey `#907122` (metric mini square EM); Helical `#45249/#59890` HEV-5 (5-flute variable helix, to 65 HRC). 6061 ≈ 800–1500 SFM, ~0.002–0.004 IPT (starting). Distributor fallbacks with plain HTML + part#s: `dgisupply.com`, `mscdirect.com`.

### 11. Tungaloy  🟡  *(indexable-milling specialist)*
- Real US entity (Tungaloy-NTK America). Strong high-feed/face/shoulder indexable line. Milling landing `tungaloy.com/us/products/milling/`.
- Advisor: Tungaloy has cutting-condition tables in its milling catalog PDFs; parse those. WIDIA is intentionally excluded (it's Kennametal's sub-brand — overlaps #2).

### 12. YG-1  🟡  *(high-volume solid end mills)*
- World's largest carbide round-tool maker; US ops in Vernon Hills, IL. Site `yg1usa.com`.
- Advisor: speeds/feeds published in product catalogs (X-Power, i-Xmill, etc.). Parse the catalog PDFs; good value/solid-endmill coverage complementing Harvey/Helical.

---

## Runtime requirement (read this)
This agent needs **outbound internet** and, for the JS-app sites, a **headless
browser (Chromium/Playwright)**. It will NOT work in a network-restricted
sandbox (e.g. a locked-down web session). Run it from **local Claude Code** on a
machine with normal internet access. Strategy per site:
- 🟢 HTML tables / server-rendered → `curl` with a real browser User-Agent, then parse.
- 🟡 Static PDFs → `curl -L` into `./research/pdfs/`, then Read the page range.
- 🔴 JS app / login → Playwright headless with realistic headers, or (Sandvik) the ISO 13399 API. If truly walled and no account → say so, don't guess.

## LOG (append per live run: ✅ confirmed URL · date · what the table looked like)
<!-- e.g. 2026-07-08 ✅ guhring milling ToolChart returns clean HTML table, cols: dia, SFM, IPT by material -->

<!-- 2026-07-07 · via WebSearch (fetch/curl blocked in sandbox) · PH-stainless 1.25" indexable shoulder mill run -->
- Sandvik CoroMill 390 Weldon-shank 1.25" bodies (confirmed dims via distributor listings):
  - RA390-032M32-17M · order 5740189 · 1.25" dia, 1.25" Weldon, size-17 insert, max ap 0.618" (Source Atlantic / Groves).
  - RA390-032M32-45L (LONG EDGE) · order 5740192 · 1.25" dia, 1.25" Weldon, OAL 4.66", max ap 1.77", uses R390-11 long-edge inserts (Groves Industrial SAN 5740192).
  - Insert R390-11T308M-PM found in grade 1130 (MSC 54733282) and grade 1030 "steel/stainless" (cuttingtoolpickers). -PM = medium chipbreaker.
- Iscar HELIMILL: HM90 E90A D1.25-5-W1.00 · 1.25" dia, 5 inserts, 1.00" Weldon, OAL 3.74" (Penn Tool). Uses HM90 APKT 1003PDR. Grade IC808 order 5606393 (TiAlN, ISO M/S/H — good for PH stainless).
- Kennametal Mill 1-14 Weldon inch: M1D125E1404W125L225 · order 2479506 · 1.25" dia, 1.25" Weldon (kennametal.com). Insert family EDCT-E.GD; stainless grade KC725M.
- Sandvik Silent Tools milling adapters: damped, rated for overhang 4–14× coupling dia; the go-to for 4"+ reach in tough material (sandvik.coromant.com/.../silent-tools-milling).
- Cutting-data anchor: Machining Doctor 17-4PH page — base milling Vc 330–440 SFM @28 HRC; multiply ×0.69 for 43 HRC → ~228–304 SFM. Coarse pitch + light ap advised for PH.

<!-- 2026-07-07 (run 2) · CORRECTIONS confirmed via WebSearch · 13-8PH ~45HRC 1.25" indexable shoulder mill -->
- CORRECTION to run-1 note: RA390-032M32-**17M** takes size-**17** inserts (R390-17xx), NOT the R390-11 insert. R390-11 fits the -11H body only. Do not mix.
- RA390-032M32-17M · order 5740189 · CONFIRMED: 1.25" dia, 1.25" Weldon, **Z=3 inserts (close pitch)**, through-coolant, OAL 4.001", max ap 0.618"/15.7mm (MSC 54965421, Penn Tool, Source Atlantic, Sandvik).
- Correct insert for -17M in stainless/PH: **R390-170408M-PM grade 1130** · order **6971850** · AlTiCrN Zertivo, ISO M/P, PM medium chipbreaker, corner rad 0.031" (DGI Supply SVK6971850, ScottDirect, Amazon). GS4130 HRSA grade also exists in R390-11 size for tougher/hardened PH.
- Iscar HM90 E90A-D1.25-5-W1.00 · Iscar order **3101941** (Travers 19-242-206) · 1.25" dia, 1.0" Weldon, Z=5, OAL 3.74". Insert HM90 APKT 1003PDR grade IC808 confirmed widely available (denser 5-insert pitch = more heat in PH; coarse Sandvik 3-insert preferred for tough PH).
- Kennametal Mill 1-14 body M1D125E1404W125L225 · order 2479506 · flagged "no longer available / long lead" on kennametal.com — demote to last alternate. Inserts EDCT-E.GD, stainless grade KCSM40 (e.g. EC1408EGD 6171518 / EC1416EGD 6171520).
- No manufacturer-published Vc/fz for 13-8PH (S13800) @45HRC found via search. Web anchors only: 17-4PH reduce to 120-180 SFM @higher hardness (tirapid); stainless fz 0.002-0.006 IPT, keep chipload >0.001-0.0015" to avoid work-hardening/rubbing (cncoptimization). Estimate used: Vc 150 SFM, fz 0.004 IPT → LOW confidence, verify with test cut.

<!-- 2026-07-07 (run 3) · KEY WIN: cylindrical-shank / 5"-OAL bodies for shrink-fit · confirmed via WebSearch -->
- LESSON: prior runs (RA390 Weldon, HM90 W1.00 Weldon) FAILED the shrink-fit test — Weldon shank ≠ shrink/hydraulic. Family sweep MUST reach the cylindrical-shank variant. Logged the right ones below.
- PRIMARY (perfect 1.25"/5"-OAL/shrink-fit): Kennametal Mill 4-11 **M4D125L1105C125L500 · order 6140058** · CONFIRMED 1.25" cutting dia, **1.25" CYLINDRICAL shank**, **5.000" OAL**, LNGU11 inserts, Z=5 (kennametal.com p.6140058, distributor ~$185). Grammar decode matched exactly (C=cyl, L500=5.00 OAL).
- Insert for PH stainless: Kennametal **LNGU11-SGE Medium grade KCSM40 · order 6201291** (kennametal.com). KCSM40 = PVD TiAlN/TiN for stainless/Ti/superalloys, wet machining — right grade for ISO M/S PH. Lighter geo LNGU11-EGE (order 6201351/6201354) for lower forces/finish. KCPM40 = steel+stainless alt.
- ALT cylindrical (Iscar): **HM90 E90A-D1.25-4-C1.25LB** (webshop item 1894780) · 1.25" dia, **1.25" cylindrical shank**, Z=4, holds HM90 AP1003. ⚠ OAL from search snippet claimed 10.0" (LB = long body) — likely OVERSHOOTS the 5" ask; VERIFY exact OAL before quoting. Insert HM90 AP1003 grade IC808/IC830 (ISO M/S).
- KCSM40 published data is Ti-centric: Ti6Al4V 155-270 SFM, ~0.0067 IPT (CTE/MSC/aero-mag). No 13-8PH-specific mfr value. For S13800 @45HRC used conservative Vc 130 SFM / fz 0.004 IPT (tool-life priority) → LOW confidence, verify test cut. Watch chip thinning at light ae — bump programmed fz to keep actual chip >0.002".

<!-- 2026-07-07 (run 4) · NEW REGIME: 1/4" SOLID CARBIDE long-reach roughing, 13-8PH · WebSearch only (fetch/curl 403) -->
- SCOPE NOTE: at 0.25" dia there are NO indexable inserts — solid carbide only. Prior runs were 1.25" indexable; different playbook.
- EXTREME-REACH families confirmed (correct FAMILY, exact 3.5"-reach EDP NOT resolvable via search snippets — JS product pages blocked):
  - Harvey Tool **Miniature End Mills – Square – Long Reach, STUB FLUTE**: solid carbide, up to **10" OAL, 17 reach lengths**, reduced neck (avoids heeling). This is the go-to for max reach at small dia. (harveytool.com/products/miniature-end-mills---square---long-reach-stub-flute)
  - Data point proving 1/4" reaches deep: Harvey **#966116** = 1/4" dia ball, .375 LOC, **2.500" reach**, 3 fl (suncoasttools). So 2.5"+ reach at 1/4" is real; 3.0–3.5" plausible in stub-flute line but VERIFY exact EDP.
  - Harvey **Extended Reach Tool Holder** reaches up to ~6" deeper — pair a SHORT necked cutter with a slim extended holder instead of one 14×D carbide stick (process-security move).
- MATERIAL-fit families for 13-8PH (ISO S/M, tough/gummy ~45HRC):
  - Helical **4 Flute – Square – Variable Pitch – Reduced Neck (Tplus coating)**: stainless/hi-temp/hardened to 65 Rc, eccentric relief, var pitch (chatter). Also **Corner-Radius Reduced Neck** and **Chipbreaker Rougher Reduced Neck** variants exist. (helicaltool.com/products/4-flute-square-variable-pitch-reduced-neck)
  - Harvey **Variable Helix End Mills for High Temp Alloys – Square – Reduced Shank** (AlTiN Nano, var helix) — reduced SHANK (clearance) not reduced-neck long reach; LOC standard.
  - Helical part-number grammar seen: H35AL-RN-M-30125 (tool #04032, 1/8" 3FL RN). "RN" = reduced neck. Tplus square RN family = "H__RN" style.
- SHANK: 1/4" Harvey/Helical miniature EMs have a plain **cylindrical 1/4" h6 shank** → shrink-fit / hydraulic compatible (consistency check passes).
- CUTTING DATA: still NO mfr-published Vc/fz for S13800@45HRC. Conservative HEM start (tool-life priority, 1/4" 4FL): Vc 130 SFM (→ ~1990 RPM), target chip 0.0010–0.0015 IPT, light ae 5–8% D, ap ≤1.5×D per pass; apply radial chip-thinning so ACTUAL chip stays ≥0.001". LOW confidence — run Harvey/Helical **Machining Advisor Pro (MAP)** with the real tool# + stickout (MAP derates for overhang, which is the whole game here), then test-cut.
- BLOCKER logged: harveytool.com & helicaltool.com tool-details are JS SPAs → WebFetch 403; distributor **suncoasttools.com/crm/ItemPage.aspx** DOES render full dim specs in text and shows in search — use it to resolve exact reach/EDP rows next live run. Harvey catalog PDF mirror: technitoolinc.com/wp-content/uploads/2021/06/MillingCutters/Harvey%20Tool%20Catalog.pdf
