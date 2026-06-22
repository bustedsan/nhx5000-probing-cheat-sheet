#!/usr/bin/env python3
"""
Feeds & Speeds Agent — NHX5000 / 13-8 PH Stainless
Usage:
  python3 feeds_speeds_agent.py                  # full recommendation table
  python3 feeds_speeds_agent.py seco_1in         # single tool
  python3 feeds_speeds_agent.py seco_1in 250 0.004  # custom SFM + IPT
  python3 feeds_speeds_agent.py --list           # list tool keys
"""

import math
import sys

# ── Tool library ──────────────────────────────────────────────────────────────
TOOLS = {
    "sandvik_1in": {
        "label":    "Sandvik CoroMill 390 1\"",
        "body":     "RA390-025M25-11M",
        "diameter": 1.000,
        "inserts":  2,
        "max_doc":  0.394,
        "lead_deg": 90,
        "insert":   "R390-11T308M-PM 1025",
        "brand":    "Sandvik",
    },
    "sandvik_2in": {
        "label":    "Sandvik CoroMill 390 2\"",
        "body":     "RA390-051R19-11M",
        "diameter": 2.000,
        "inserts":  5,
        "max_doc":  0.394,
        "lead_deg": 90,
        "insert":   "R390-11T308M-PM 1025",
        "brand":    "Sandvik",
    },
    "kennametal_1in": {
        "label":    "Kennametal Mill 1-18 1\"",
        "body":     "M1D100E1803W100L275",
        "diameter": 1.000,
        "inserts":  3,
        "max_doc":  0.560,
        "lead_deg": 90,
        "insert":   "EDPT11T308PDPR KCPM40",
        "brand":    "Kennametal",
    },
    "seco_1in": {
        "label":    "Seco Square 6 1\"",
        "body":     "R217.96-01.00-3-04-5A",
        "diameter": 1.000,
        "inserts":  5,
        "max_doc":  0.157,
        "lead_deg": 90,
        "insert":   "XNEX040308TR-M08 F40M",
        "brand":    "Seco",
    },
    "iscar_1in": {
        "label":    "Iscar HM90 E90A 1\"",
        "body":     "E90A-D1.00-4-W.75",
        "diameter": 1.000,
        "inserts":  4,
        "max_doc":  0.394,
        "lead_deg": 90,
        "insert":   "APKT 1003PDR-HM IC808",
        "brand":    "Iscar",
    },
    "sandvik_345_3in": {
        "label":    "Sandvik CoroMill 345 3\" (6z)",
        "body":     "A345-076R25-13M",
        "diameter": 3.000,
        "inserts":  6,
        "max_doc":  0.236,
        "lead_deg": 45,
        "insert":   "345R-1305M-PM 1030",
        "brand":    "Sandvik",
    },
    "sandvik_345_3in_8z": {
        "label":    "Sandvik CoroMill 345 3\" (8z XCP)",
        "body":     "A345-076R25-13H",
        "diameter": 3.000,
        "inserts":  8,
        "max_doc":  0.236,
        "lead_deg": 45,
        "insert":   "345R-1305M-PM 1030",
        "brand":    "Sandvik",
    },
    "seco_r220_3in": {
        "label":    "Seco Octamill 3\" (6z)",
        "body":     "R220.53-03.00-12-6A",
        "diameter": 3.000,
        "inserts":  6,
        "max_doc":  0.236,
        "lead_deg": 45,
        "insert":   "SEEX1204AFN-M08 F40M",
        "brand":    "Seco",
    },
    "kennametal_dodeka_3in_5z": {
        "label":    "Kennametal Dodeka Mini 3\" (5z)",
        "body":     "4130494",
        "diameter": 3.000,
        "inserts":  5,
        "max_doc":  0.127,
        "lead_deg": 45,
        "insert":   "HNGJ0604 KCSM40",
        "brand":    "Kennametal",
    },
    "kennametal_dodeka_3in_8z": {
        "label":    "Kennametal Dodeka Mini 3\" (8z)",
        "body":     "4130495",
        "diameter": 3.000,
        "inserts":  8,
        "max_doc":  0.127,
        "lead_deg": 45,
        "insert":   "HNGJ0604 KCSM40",
        "brand":    "Kennametal",
    },
}

# ── Recommended starting cuts for 13-8 PH (H950/H1000) ─────────────────────
# Conservative start — go faster once tool life is confirmed at H1050
RECS = {
    1.000: {"sfm_lo": 200, "sfm_hi": 300, "ipt_lo": 0.003, "ipt_hi": 0.004},
    2.000: {"sfm_lo": 200, "sfm_hi": 300, "ipt_lo": 0.003, "ipt_hi": 0.004},
    3.000: {"sfm_lo": 250, "sfm_hi": 350, "ipt_lo": 0.004, "ipt_hi": 0.005},
}


def get_rec(diameter):
    closest = min(RECS.keys(), key=lambda d: abs(d - diameter))
    return RECS[closest]


# ── Core calc ─────────────────────────────────────────────────────────────────
def calc(diameter_in, inserts, sfm, ipt):
    rpm = (sfm * 12) / (math.pi * diameter_in)
    ipm = ipt * inserts * rpm
    return round(rpm, 0), round(ipm, 1)


# ── Formatters ────────────────────────────────────────────────────────────────
SEP  = "─" * 72
SEP2 = "═" * 72

def print_tool(key, sfm=None, ipt=None):
    t = TOOLS[key]
    rec = get_rec(t["diameter"])

    sfm_lo = sfm  if sfm  else rec["sfm_lo"]
    sfm_hi = sfm  if sfm  else rec["sfm_hi"]
    ipt_lo = ipt  if ipt  else rec["ipt_lo"]
    ipt_hi = ipt  if ipt  else rec["ipt_hi"]

    rpm_lo, ipm_lo = calc(t["diameter"], t["inserts"], sfm_lo, ipt_lo)
    rpm_hi, ipm_hi = calc(t["diameter"], t["inserts"], sfm_hi, ipt_hi)

    print(SEP)
    print(f"  {t['label']}   [{key}]")
    print(f"  Body : {t['body']}   |  Insert: {t['insert']}")
    print(f"  Dia  : {t['diameter']:.3f}\"  Z={t['inserts']}  Lead={t['lead_deg']}°  MaxDOC={t['max_doc']:.3f}\"")
    print()
    print(f"  {'SFM':>6}  {'IPT':>7}  {'RPM':>8}  {'IPM':>8}")
    print(f"  {'─'*6}  {'─'*7}  {'─'*8}  {'─'*8}")
    print(f"  {sfm_lo:>6}  {ipt_lo:>7.4f}  {rpm_lo:>8.0f}  {ipm_lo:>8.1f}   ← conservative (H950/H1000)")
    if sfm_lo != sfm_hi or ipt_lo != ipt_hi:
        print(f"  {sfm_hi:>6}  {ipt_hi:>7.4f}  {rpm_hi:>8.0f}  {ipm_hi:>8.1f}   ← moderate    (H1050)")

    doc_warn = " ⚠ EXCEEDS MAX DOC" if 0.125 > t["max_doc"] else ""
    print(f"\n  Min DOC target: 0.125\"  |  Tool max DOC: {t['max_doc']:.3f}\"{doc_warn}")
    print(f"  Coolant: FLOOD required  |  No dwell in cut")


def print_table_all():
    print(SEP2)
    print("  FEEDS & SPEEDS — 13-8 PH Stainless (H950/H1000)  |  NHX5000 G20")
    print(SEP2)
    print(f"\n  {'Key':<28} {'Dia':>5} {'Z':>3} {'Lead':>5} {'SFM':>5} {'IPT':>6} {'RPM':>7} {'IPM':>7}  Insert Grade")
    print(f"  {'─'*28} {'─'*5} {'─'*3} {'─'*5} {'─'*5} {'─'*6} {'─'*7} {'─'*7}  {'─'*20}")

    for key, t in TOOLS.items():
        rec = get_rec(t["diameter"])
        rpm, ipm = calc(t["diameter"], t["inserts"], rec["sfm_lo"], rec["ipt_lo"])
        grade = t["insert"].split()[-1]
        print(
            f"  {key:<28} {t['diameter']:>5.3f} {t['inserts']:>3} "
            f"{t['lead_deg']:>4}° {rec['sfm_lo']:>5} {rec['ipt_lo']:>6.4f} "
            f"{rpm:>7.0f} {ipm:>7.1f}  {grade}"
        )

    print(f"\n  All values are CONSERVATIVE start points for H950/H1000.")
    print(f"  For H1050 add ~25% SFM and bump IPT to high end.")
    print(SEP2)


# ── Main ──────────────────────────────────────────────────────────────────────
def main():
    args = sys.argv[1:]

    if not args:
        print_table_all()
        return

    if args[0] in ("--list", "-l", "list"):
        print("\nAvailable tool keys:")
        for k, t in TOOLS.items():
            print(f"  {k:<30}  {t['label']}  ({t['brand']})")
        return

    key = args[0]
    if key not in TOOLS:
        print(f"Unknown tool key '{key}'. Use --list to see options.")
        sys.exit(1)

    sfm = float(args[1]) if len(args) > 1 else None
    ipt = float(args[2]) if len(args) > 2 else None

    print_tool(key, sfm, ipt)
    print(SEP)


if __name__ == "__main__":
    main()
