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
- **Catalog PDFs (best-retrievable, distributor-hosted):**
  - Face mills master: `productivity.com/wp-content/uploads/pdfs/Kennametal%20Facemills%20-%20Master%20Catalog.pdf`
  - Milling 6050: `productivity.com/wp-content/uploads/pdfs/Kennametal%20Milling%20Catalog%206050.pdf`
  - Solid carbide end mill inch master (2023): `productivity.com/wp-content/uploads/2022/08/Kennametal-2023-Solid-Carbide-End-Milling-Inch-Master-Catalog-Interactive.pdf`
  - Speeds/feeds (MSC): `www1.mscdirect.com/images/solutions/kennametal/endMillSpeedFeed.pdf`, `.../millingTechInfoFormulas.pdf`
- **Worked example (real numbers):** AISI 4140 @220 HB → **Vc = 450 SFM, fz = 0.008 IPT** (table is by material class, not per part#). Part# example: KSSM8+ shell mill order `5420150` (`KSSM87D200SN440S075Z05`).

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
