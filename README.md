# NHX 5000 Probing Cheat Sheet

> Interactive HTML reference for Fanuc 31i-B with Renishaw Inspection Plus probing

---

## Machine Setup

- **Machine:** DMG Mori NHX 5000
- **Control:** Fanuc 31i-B
- **Probe:** Renishaw Inspection Plus (Spindle Probe)
- **Scale:** Inch (G20)
- **M-Codes:** M28 (Probe Enable) / M29 (Probe Disable)
- **Work Offsets:** G54 / G55
- **Probe Tool:** H1 (Probe in tool library)

---

## Contents

### Setup & Reference

| Tab | Description |
|-----|-------------|
| Machine Setup | M-codes, work offsets, zero datum |
| Macro Reference | P9811, P9812, P9814, P9817 argument tables |
| Corner + Back | Stock setup with O1000/O1001 |
| Center + Front | Web-center method with O1010/O1011 |
| Bore / Hole | P9814 4-point bore with O1020/O1021 |
| Pocket Center | P9812 pocket center with O1030/O1031 |
| Stock Check | Tolerance verification O1002/O1003 |
| Subprograms | Call map and example main program |
| Clean Code | Type-in-ready compact code |

### In-Process Inspection

| Tab | Description |
|-----|-------------|
| Thickness | Two-face probe thickness (#187/#188) |
| Width | Pocket/web width X and Y measurement |
| Hole Size | Bore diameter with P9814 / P9817 |
| Runout | TIR via B-axis rotation (0/90/180/270) |
| Parallelism | 4-corner Z probe or angle + G68 correction |

---

## File Structure

```
nhx5000-probing-cheat-sheet/
├── README.md
├── probing-cheat-sheet.html     # Full interactive sheet (15 tabs)
├── probing-ipi-cheat-sheet.html # In-Process Inspection only (5 tabs)
└── clean-code/
    └── *.txt                    # Individual .txt files for each subprogram
```

---

## Key Macros

| Macro | Description | Key Returns |
|-------|-------------|-------------|
| P9811 | Single-surface probe | #187 error, #188 position |
| P9812 | Two-opposite-surface pocket/web | #185 X err, #186 Y err, #188 center, #189 fail flag |
| P9814 | 4-point bore | #187 dia err, #188 measured dia, #185/#186 center |
| P9817 | 3-point bore | #187 dia err, #188 measured dia |
| P9832 | Pattern hole probing | #185/#186 position errors |
| P9833 | Angle probing | #187 angle error |

---

## Verification Checklist

Before running any in-process inspection macro:

- [ ] Verify M28/M29 probe enable/disable
- [ ] Confirm G43 H[probe tool] active
- [ ] Save #185/#186/#187/#188/#189 immediately after each macro call
- [ ] Use dedicated global variables (#10500+) to avoid Renishaw conflicts
- [ ] Confirm return variables against your exact Inspection Plus version
- [ ] All tolerances in INCHES under G20
- [ ] Dry-run automatic offset writes before live use
- [ ] Confirm approach direction discipline (always from same side)

---

## Usage

1. Download both HTML files from this repo
2. Open `probing-cheat-sheet.html` in any web browser
3. Navigate tabs via the left sidebar
4. Use the Copy button on any code block to grab subprograms
5. For shop-floor use, open in full-screen mode (F11)

---

## Checklist for New Operators

| Step | Action |
|------|--------|
| 1 | Enable probe: M28 |
| 2 | Load probe tool: T1 M06 G43 H1 |
| 3 | Go to safe Z: G0 Z4. |
| 4 | Go to part: G0 X_Y_ |
| 5 | Call probe macro: G65 P9811 ... |
| 6 | Disable probe: M29 |
| 7 | Verify #188 saved to work offset |

---

## Version

- **Repo:** bustedsan/nhx5000-probing-cheat-sheet
- **Created:** 2025
- **Scale:** Inch (G20)
- **Control:** Fanuc 31i-B
- **Inspection Plus:** Macros P9810–P9842

---

*Built for manufacturing engineers and machinists running NHX 5000 setups with Renishaw spindle probes.*
