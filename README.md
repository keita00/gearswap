# THF GearSwap Configuration

This is a complete GearSwap `.lua` setup for **Thief (THF)** in *Final Fantasy XI*, customized for gameplay quality, flexibility, and advanced HUD feedback.

## Features

### Core Gear Logic
- Accuracy Mode Toggle (`//gs c toggleAcc`)
  - Cycles through: Default, Acc, AccMid, AccHigh
- Treasure Hunter Toggle (`//gs c toggleTH`)
  - Enables or disables TH gear logic
- WeaponSkill Gear by Name:
  - Aeolian Edge
  - Evisceration
  - Exenterator
- Weapon switching: Shijo (WS & TP), Tauret (Evisceration)

### Windower Addon Integration
- Uses `texts` for HUD display
- Uses `timers` addon for Job Ability durations
- Uses `send_command` to manage macros and timers

### HUD Display
- TH status (ON/OFF)
- Accuracy Mode
- Current Subjob (SJ: XXX)
- Active Trusts (Kupipi, Qultada, etc.)

### Automation Features
- Subjob-based gear handling
- Real-time detection and alerts for:
  - **Doom**
  - **Silence**
  - **Paralysis**
- **Day/Weather Match Alert** for WS
- **Capacity Ring detection**
- Smart logic for applying TH to appropriate abilities

## Files

- `THF.lua`: Primary GearSwap logic and configuration
- Compatible with Windower 4 and modern FFXI clients

## Planned / Optional Features
- Lockstyle automation
- Macro book/set automation
- Job Point scaling logic
- Idle refresh gear switching

---
