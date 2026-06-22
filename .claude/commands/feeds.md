Run the feeds_speeds_agent.py script for the NHX5000 / 13-8 PH stainless tooling library.

If the user provided arguments after /feeds, pass them to the script:
- No args → run `python3 feeds_speeds_agent.py --table` and show the full table
- A tool key (e.g. `seco_1in`) → run `python3 feeds_speeds_agent.py <key>`
- A tool key + SFM + IPT (e.g. `seco_1in 250 0.004`) → run `python3 feeds_speeds_agent.py <key> <SFM> <IPT>`
- `list` → run `python3 feeds_speeds_agent.py --list`
- A raw calc (e.g. `calc 1.0 5 250 0.004`) → pipe `calc 1.0 5 250 0.004\nquit\n` to `python3 feeds_speeds_agent.py`

Always run from the project root: /home/user/nhx5000-probing-cheat-sheet/
Show the full output to the user.
