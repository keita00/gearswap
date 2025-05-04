# THF and COR GearSwap for FFXI

Feature-rich, modular GearSwap script for Thief (/DNC) and COR in Final Fantasy XI.

## Features

- BiS gear sets with subjob and Trust-based logic
- HUD display via Windower `texts`
- Automation:
  - Weapon Skill selection based on equipped weapon
  - TP Bonus logic (waist or weapon)
  - Ammo/Ranged fallback
  - Trust-aware idle and engaged sets
- Notifications (WS, TP threshold, TH tagging)
- Event hooks (zoning, equip changes)
- Modularized Lua files

## Installation

1. Clone or download this repo.
2. Place `THF.lua` in your Windower `addons/GearSwap/data` directory.
3. Create a `data/` folder and place `gear.lua`, `functions.lua`, and `hud.lua` inside it.
4. Load your character with `//gs load THF`.

## Requirements

- Windower4 with GearSwap
- `texts` addon loaded
