############################################################
#  NH550SX 4th Axis — NX 2412 Post Processor Template
#  Machine   : Toyoda NH550SX Horizontal Machining Center
#  Control   : Fanuc 30i-B
#  Axes      : X Y Z B (B = rotary table, +Y vector)
#  Units     : Metric (mm) — change G21→G20 and formats for inch
#  Author    : Generated for NX 2412 Post Builder
############################################################

# ── Global machine parameters ─────────────────────────────
set mom_machine_type            "milling"
set mom_4th_axis_type           "table"
set mom_4th_axis_letter         "B"
set mom_4th_axis_min_limit      -180.0
set mom_4th_axis_max_limit       180.0
set mom_4th_axis_resolution       0.001
set mom_rotary_shortest_path      1
set mom_b_clamp_code            "M10"
set mom_b_unclamp_code          "M11"
set mom_b_home_angle              0.0

# ── Output format ─────────────────────────────────────────
# X Y Z : 4 decimal places (0.0001 mm resolution)
# B     : 3 decimal places (0.001 deg resolution)
# F     : integer (mm/min)
# S     : integer (RPM)
set mom_output_format(X)        "%+10.4f"
set mom_output_format(Y)        "%+10.4f"
set mom_output_format(Z)        "%+10.4f"
set mom_output_format(B)        "%+9.3f"
set mom_output_format(F)        "%.0f"
set mom_output_format(S)        "%.0f"

# ── Program start / header ────────────────────────────────
proc PB_start_of_program { } {
    global mom_part_name mom_date

    MOM_output_literal "%"
    MOM_output_literal "O0001 (NH550SX 4-AXIS PROGRAM)"
    MOM_output_literal "(MACHINE  : TOYODA NH550SX)"
    MOM_output_literal "(CONTROL  : FANUC 30I-B)"
    MOM_output_literal "(DATE     : $mom_date)"
    MOM_output_literal "(PART     : $mom_part_name)"
    MOM_output_literal "(NX 2412 POST : nh550sx_fanuc30i)"
    MOM_output_literal "G17 G21 G40 G49 G80 G90"
    MOM_output_literal "G91 G28 Z0."
    MOM_output_literal "G91 G28 X0. Y0."
    MOM_output_literal "M11"
    MOM_output_literal "G90 G00 B0."
    MOM_output_literal "M10"
}

# ── Program end / footer ──────────────────────────────────
proc PB_end_of_program { } {
    MOM_output_literal "G91 G28 Z0."
    MOM_output_literal "G91 G28 X0. Y0."
    MOM_output_literal "M11"
    MOM_output_literal "G90 G00 B0."
    MOM_output_literal "M10"
    MOM_output_literal "M05"
    MOM_output_literal "M30"
    MOM_output_literal "%"
}

# ── Tool change ────────────────────────────────────────────
proc PB_tool_change { } {
    global mom_tool_number mom_tool_name mom_tool_length_offset
    global mom_tool_diameter_offset

    MOM_output_literal ""
    MOM_output_literal "( TOOL : T$mom_tool_number  $mom_tool_name )"
    MOM_output_literal "G91 G28 Z0."
    MOM_output_literal "T$mom_tool_number M06"
    MOM_output_literal "G90 G43 H$mom_tool_length_offset"
}

# ── Spindle start ──────────────────────────────────────────
proc PB_spindle_on { } {
    global mom_spindle_speed mom_spindle_direction

    if { $mom_spindle_direction == "CLW" } {
        MOM_output_literal "S$mom_spindle_speed M03"
    } else {
        MOM_output_literal "S$mom_spindle_speed M04"
    }
    MOM_output_literal "M08"
}

# ── Spindle stop ───────────────────────────────────────────
proc PB_spindle_off { } {
    MOM_output_literal "M09"
    MOM_output_literal "M05"
}

# ── B-Axis Index (3+1 Indexed Mode) ───────────────────────
#    Called whenever NX detects a B angle change between ops
proc MOM_rotary_axis_index { } {
    global mom_b_angle mom_prev_b_angle
    global mom_b_clamp_code mom_b_unclamp_code

    # Skip if B hasn't changed
    if { abs($mom_b_angle - $mom_prev_b_angle) < 0.0005 } { return }

    # 1. End coolant before retract
    MOM_output_literal "M09"

    # 2. Retract Z to machine home
    MOM_output_literal "G91 G28 Z0."

    # 3. Retract X to machine home (for tombstone / tall fixture)
    MOM_output_literal "G91 G28 X0. Y0."

    # 4. Unclamp B
    MOM_output_literal $mom_b_unclamp_code

    # 5. Rapid B to target
    MOM_output_literal "G90 G00 B[format %.3f $mom_b_angle]"

    # 6. Optional dwell for B axis settle (uncomment if needed)
    # MOM_output_literal "G04 P300"

    # 7. Clamp B
    MOM_output_literal $mom_b_clamp_code

    # Update previous angle
    set mom_prev_b_angle $mom_b_angle
}

# ── Rapid move ─────────────────────────────────────────────
proc MOM_rapid_move { } {
    global mom_pos

    set x [format "%+.4f" [lindex $mom_pos 0]]
    set y [format "%+.4f" [lindex $mom_pos 1]]
    set z [format "%+.4f" [lindex $mom_pos 2]]

    MOM_output_literal "G90 G00 X$x Y$y Z$z"
}

# ── Linear move (3-axis) ───────────────────────────────────
proc MOM_linear_move { } {
    global mom_pos mom_feed_rate

    set x [format "%+.4f" [lindex $mom_pos 0]]
    set y [format "%+.4f" [lindex $mom_pos 1]]
    set z [format "%+.4f" [lindex $mom_pos 2]]
    set f [format "%.0f" $mom_feed_rate]

    MOM_output_literal "G01 X$x Y$y Z$z F$f"
}

# ── Linear move (4-axis simultaneous) ─────────────────────
proc MOM_linear_move_4axis { } {
    global mom_pos mom_b_angle mom_feed_rate

    set x [format "%+.4f" [lindex $mom_pos 0]]
    set y [format "%+.4f" [lindex $mom_pos 1]]
    set z [format "%+.4f" [lindex $mom_pos 2]]
    set b [format "%+.3f" $mom_b_angle]
    set f [format "%.0f" $mom_feed_rate]

    MOM_output_literal "G01 X$x Y$y Z$z B$b F$f"
}

# ── Circular move ──────────────────────────────────────────
proc MOM_arc_move { } {
    global mom_pos mom_arc_center mom_feed_rate mom_arc_direction

    set x [format "%+.4f" [lindex $mom_pos 0]]
    set y [format "%+.4f" [lindex $mom_pos 1]]
    set z [format "%+.4f" [lindex $mom_pos 2]]
    set i [format "%+.4f" [lindex $mom_arc_center 0]]
    set j [format "%+.4f" [lindex $mom_arc_center 1]]
    set f [format "%.0f" $mom_feed_rate]

    if { $mom_arc_direction == "CLW" } {
        set g "G02"
    } else {
        set g "G03"
    }

    MOM_output_literal "$g X$x Y$y Z$z I$i J$j F$f"
}

# ── Work offset output ─────────────────────────────────────
proc MOM_set_csys { } {
    global mom_csys_name

    # Map NX CSYS names to G54-G59
    switch -glob -- $mom_csys_name {
        "*G54*" { MOM_output_literal "G54" }
        "*G55*" { MOM_output_literal "G55" }
        "*G56*" { MOM_output_literal "G56" }
        "*G57*" { MOM_output_literal "G57" }
        "*G58*" { MOM_output_literal "G58" }
        "*G59*" { MOM_output_literal "G59" }
        default { MOM_output_literal "G54" }
    }
}

# ── Canned cycle — drill ───────────────────────────────────
proc MOM_drill { } {
    global mom_pos mom_feed_rate mom_cycle_rapid_to mom_cycle_bottom

    set x [format "%+.4f" [lindex $mom_pos 0]]
    set y [format "%+.4f" [lindex $mom_pos 1]]
    set z [format "%+.4f" $mom_cycle_bottom]
    set r [format "%+.4f" $mom_cycle_rapid_to]
    set f [format "%.0f" $mom_feed_rate]

    MOM_output_literal "G98 G81 X$x Y$y Z$z R$r F$f"
}

# ── Canned cycle — peck drill ──────────────────────────────
proc MOM_drill_deep { } {
    global mom_pos mom_feed_rate mom_cycle_rapid_to mom_cycle_bottom
    global mom_cycle_step1

    set x [format "%+.4f" [lindex $mom_pos 0]]
    set y [format "%+.4f" [lindex $mom_pos 1]]
    set z [format "%+.4f" $mom_cycle_bottom]
    set r [format "%+.4f" $mom_cycle_rapid_to]
    set q [format "%.4f" $mom_cycle_step1]
    set f [format "%.0f" $mom_feed_rate]

    MOM_output_literal "G98 G83 X$x Y$y Z$z R$r Q$q F$f"
}

# ── Cancel canned cycle ────────────────────────────────────
proc MOM_cycle_off { } {
    MOM_output_literal "G80"
}

# ── Operation start / end comments ────────────────────────
proc MOM_operation_start { } {
    global mom_operation_name mom_tool_name

    MOM_output_literal ""
    MOM_output_literal "( OP: $mom_operation_name )"
    MOM_output_literal "( TOOL: $mom_tool_name )"
}

proc MOM_operation_end { } {
    MOM_output_literal "G80"
    MOM_output_literal "M09"
}

# ── End of file ────────────────────────────────────────────
