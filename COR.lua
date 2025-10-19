-- =========================================================================
-- COR.lua — Full Set Skeleton (NO ITEMS YET)
-- All major sets defined & documented with TODO checklists per slot.
-- Keeps your current gear when a set is empty.
-- HUD + Toggles + Capacity Ring alert + Debuff warnings + Day/Weather helper
-- =========================================================================

texts = require('texts')

-- ===========================
-- State / Toggles
-- ===========================
Weapon_Mode   = "Melee"     -- "Melee" | "Gun"
Melee_Mode    = "Tauret"    -- "Tauret" | "Shijo" | "Naegling" (when you get it)
Racc_Array    = {"Default","Acc","HighAcc"}
Racc_Index    = 1
Acc_Array     = {"Default","Acc","AccMid","AccHigh"}
Acc_Index     = 1
DT_Modes      = {"Normal","DT","EVA"}
DT_Mode_Index = 1
Movement_Mode = false

-- ===========================
-- HUD
-- ===========================
hud = texts.new('COR HUD', {pos={x=1120,y=36}, bg={alpha=0}, fg={alpha=255}, text={size=12}})
local function update_hud()
  local L = {}
  L[#L+1] = ('Weapon:%s(%s)'):format(Weapon_Mode, Melee_Mode)
  L[#L+1] = ('ACC:%s|RACC:%s'):format(Acc_Array[Acc_Index], Racc_Array[Racc_Index])
  L[#L+1] = ('DT:%s'):format(DT_Modes[DT_Mode_Index])
  L[#L+1] = ('MOV:%s'):format(Movement_Mode and 'ON' or 'OFF')
  if player and player.sub_job then L[#L+1] = ('SJ:%s'):format(player.sub_job) end
  hud:text(table.concat(L,'  |  ')); hud:show()
end

-- ===========================
-- Commands
-- ===========================
function self_command(cmd)
  if cmd == 'toggleWeapon' then
    Weapon_Mode = (Weapon_Mode == 'Melee') and 'Gun' or 'Melee'
  elseif cmd == 'toggleMelee' then
    Melee_Mode = (Melee_Mode == 'Tauret') and 'Shijo' or (Melee_Mode == 'Shijo' and 'Naegling' or 'Tauret')
  elseif cmd == 'toggleAcc' then
    Acc_Index  = (Acc_Index % #Acc_Array) + 1
  elseif cmd == 'toggleRacc' then
    Racc_Index = (Racc_Index % #Racc_Array) + 1
  elseif cmd == 'toggleDT' then
    DT_Mode_Index = (DT_Mode_Index % #DT_Modes) + 1
  elseif cmd == 'toggleMovement' then
    Movement_Mode = not Movement_Mode
  end
  add_to_chat(122, ('Mode: %s | Melee: %s | ACC:%s | RACC:%s | DT:%s | MOV:%s'):format(
    Weapon_Mode, Melee_Mode, Acc_Array[Acc_Index], Racc_Array[Racc_Index],
    DT_Modes[DT_Mode_Index], Movement_Mode and 'ON' or 'OFF'
  ))
  update_hud()
  aftercast({})
end

-- ===========================
-- Sets (EMPTY, with TODOs to guide you)
-- ===========================
function get_sets()
  update_hud()
  sets = {}

  ---------------------------------------------------------------------------
  -- IDLE / DEFENSIVE
  ---------------------------------------------------------------------------
  sets.idle = {
    -- TODO Idle/Refresh Baseline:
    -- main= , sub= , range= , ammo=
    -- head= , body= , hands= , legs= , feet=
    -- neck= , ear1= , ear2= , ring1= , ring2= , back= , waist=
    -- Notes: Aim for Refresh+ and some DT. Malignance/Nyame later; Warder's/Defending early.
  }

  sets.dt = {
    -- TODO PDT/MDT Hybrid:
    -- head= , body= , hands= , legs= , feet= , ring1= , ring2= , back= , neck= , waist= , ear1= , ear2=
    -- Notes: 50% total DT target with gear+rolls; Malignance/Nyame standard.
  }

  sets.eva = {
    -- TODO Evasion build:
    -- head= , body= , hands= , legs= , feet= , neck= , back= , ring1= , ring2=
  }

  ---------------------------------------------------------------------------
  -- ENGAGED (MELEE TP)
  ---------------------------------------------------------------------------
  sets.engaged = {
    -- TODO Melee TP (Store TP/Haste/Acc/DT hybrid):
    -- main= , sub= , ammo=
    -- head= , body= , hands= , legs= , feet=
    -- neck= , ear1= , ear2= , ring1= , ring2= , back= , waist=
    -- Notes: Use Tauret/Shijo now; Naegling later. Sailfi+1/Fotia, Epona/Chirich, Telos/Suppa are fine starters.
  }
  sets.engaged.Acc     = set_combine(sets.engaged, { -- TODO small acc bumps here
  })
  sets.engaged.AccMid  = set_combine(sets.engaged.Acc, { -- TODO more acc/less DA
  })
  sets.engaged.AccHigh = set_combine(sets.engaged.AccMid, { -- TODO cap hit-rate builds
  })

  ---------------------------------------------------------------------------
  -- RANGED TP (AutoRA)
  ---------------------------------------------------------------------------
  sets.ranged = {
    -- TODO Ranged TP baseline:
    -- range= , ammo=
    -- head= , body= , hands= , legs= , feet=
    -- neck= , ear1= , ear2= , ring1= , ring2= , back= , waist=
    -- Notes: Snapshot/Rapid Shot for precast, then R.Attk/Acc/STP in midcast. Meghanada+2 entry → Malignance/Nyame.
  }
  sets.ranged.Acc     = set_combine(sets.ranged, { -- TODO add R.Acc pieces
  })
  sets.ranged.HighAcc = set_combine(sets.ranged.Acc, { -- TODO max R.Acc
  })

  ---------------------------------------------------------------------------
  -- PRECAST / MIDCAST (GUN)
  ---------------------------------------------------------------------------
  sets.precast = {}
  sets.precast.RA = {
    -- TODO Snapshot/Rapid Shot (precast only):
    -- head= , body= , hands= , legs= , feet= , back= , waist=
    -- Note: Chasseur's +3 legs (Snapshot+10), Lanun Bottes +3, Desultor Tassets (aug), Ambu capes with Snapshot.
  }
  sets.midcast = {}
  sets.midcast.RA = {
    -- TODO Midcast Ranged (R.Acc/R.Attk/STP):
    -- head= , body= , hands= , legs= , feet= , neck= , ear1= , ear2= , ring1= , ring2= , back= , waist=
  }

  ---------------------------------------------------------------------------
  -- ROLLS (JA) / UTILITY
  ---------------------------------------------------------------------------
  sets.JA = {
    ["Phantom Roll"] = {
      -- TODO Roll potency/duration/CHR/DT:
      -- head= (Lanun +3) , body= (Chasseur +3) , hands= (Chasseur +3) , feet= (Lanun +3)
      -- neck= (Loricate+1/Regal) , back= (Camulus CHR/DT/FC) , ring= (DT/utility)
    },
    ["Double-Up"] = { -- same as Phantom Roll or lighter DT
    },
    ["Random Deal"] = { -- TODO Fast Cast/DT
    },
    ["Wild Card"]   = { -- TODO DT/Enmity-
    },
    ["Snake Eye"]   = { -- TODO FC/DT
    },
    ["Fold"]        = { -- TODO FC/DT
    },
  }

  ---------------------------------------------------------------------------
  -- QUICK DRAW (magical shot)
  ---------------------------------------------------------------------------
  sets.QD = {
    -- TODO MAB/M.Acc/INT/QD recast:
    -- ammo= , head= (Lanun/Chasseur/Nyame) , body= (Lanun Frac +3) , hands= (Carmine+1/Nyame) ,
    -- legs= (Chasseur +3) , feet= (Lanun +3) , neck= (Baetyl) , ears= (Friomisi/Crematio) ,
    -- rings= (Dingir/Regal/Weatherspoon) , back= (Camulus MAB/MDmg/WSdmg) , waist= (Orpheus/Hachirin)
  }

  ---------------------------------------------------------------------------
  -- WEAPON SKILLS
  ---------------------------------------------------------------------------
  sets.ws = {}

  -- Leaden Salute (Magic WS)
  sets.ws["Leaden Salute"] = {
    -- TODO Magic WS (AGI/MAB/MDmg/Dark affinity):
    -- range= , ammo=
    -- head= (Pixie+1) , body= (Lanun Frac +3) , hands= (Carmine+1/Nyame) ,
    -- legs= (Chasseur +3) , feet= (Lanun +3) ,
    -- neck= (Baetyl) , ear1= (Friomisi) , ear2= (Crematio/Moonshade) ,
    -- ring1= (Archon/Dingir) , ring2= (Regal) ,
    -- back= (Camulus MAB/MDmg/WSdmg) , waist= (Orpheus / Hachirin-no-Obi on Dark day/weather)
  }

  -- Last Stand (Physical Ranged WS)
  sets.ws["Last Stand"] = {
    -- TODO Physical Ranged WS (AGI/R.Attk/WSdmg):
    -- range= , ammo=
    -- head/body/hands/legs/feet= (Nyame set baseline) ,
    -- neck= (Fotia) , waist= (Fotia) ,
    -- ears= (Ishvara/Telos) , rings= (Ilabrat/Regal) , back= (Camulus AGI/R.Attk/WSdmg)
  }

  -- Savage Blade (Melee WS)
  sets.ws["Savage Blade"] = {
    -- TODO STR/MND/WSdmg:
    -- main= (Naegling eventually), sub= , ammo=
    -- head/body/hands/legs/feet= (Nyame set baseline) ,
    -- neck= (Fotia) or Sailfi+1 at low atk ,
    -- ear1= (Ishvara) , ear2= (Moonshade) ,
    -- rings= (Epaminondas’s/Regal) , back= (Camulus STR/WSdmg) , waist= (Sailfi+1 or Fotia)
  }

  -- Wildfire (Magic WS, optional if you use it)
  sets.ws["Wildfire"] = {
    -- TODO MAB/MDmg/AGI:
    -- very similar shell to Leaden but Fire-element setup; Orpheus situational.
  }

  -- Generic fallback (will equip whatever you add)
  sets.ws.Default = {
    -- TODO all-purpose fallback WS set
  }

  ---------------------------------------------------------------------------
  -- ELEMENTAL DAY/WEATHER SUPPORT
  ---------------------------------------------------------------------------
  sets.Obi = {
    -- TODO waist="Hachirin-no-Obi" (if owned) — otherwise your Orpheus logic will be enough
  }

end

-- ===========================
-- Helpers
-- ===========================
local function equip_melee_weapons()
  if Melee_Mode == "Shijo" then
    equip({main={name="Shijo", augments={'Path: D'}}, sub="Gleti's Knife"})
  elseif Melee_Mode == "Naegling" then
    equip({main="Naegling", sub="Gleti's Knife"}) -- equips only if you own it
  else
    equip({main="Tauret", sub="Gleti's Knife"})
  end
end

local function equip_gun()
  -- Equip whatever best gun you own. Since sets are empty, we only set the slot.
  if player.equipment.range ~= 'empty' then
    equip({range=player.equipment.range}) -- keep current gun
  end
end

local function check_capacity_ring()
  local eq = windower.ffxi.get_items().equipment
  if eq and eq.ring1 == 28540 then
    add_to_chat(122,'Capacity Ring equipped.')
  end
end

local function check_debuffs()
  for _,d in ipairs({"Doom","Silence","Paralysis"}) do
    if buffactive[d] then add_to_chat(123,'Debuff: '..d..' — remedy it!') end
  end
end

local function leaden_dayweather_boost()
  if world.weather_element == 'Dark' or world.day_element == 'Dark' then
    equip(sets.Obi) -- uses Hachirin if you add it later
  end
end

-- ===========================
-- Casting
-- ===========================
function precast(spell)
  if sets.JA[spell.english] then
    equip(sets.JA[spell.english]); return
  end

  if spell.type == 'WeaponSkill' then
    if spell.english == "Leaden Salute" then
      equip(sets.ws["Leaden Salute"]); leaden_dayweather_boost()
    else
      equip(sets.ws[spell.english] or sets.ws.Default)
    end
    add_to_chat(122,'WS: '..spell.english)
  elseif spell.action_type == 'Ranged Attack' then
    -- Precast Snapshot
    equip(sets.precast.RA)
  end
end

function midcast(spell)
  if spell.action_type == 'Ranged Attack' then
    local racc = Racc_Array[Racc_Index]
    if     racc == "HighAcc" then equip(sets.midcast.RA and sets.ranged.HighAcc or {})
    elseif racc == "Acc"     then equip(sets.midcast.RA and sets.ranged.Acc     or {})
    else                           equip(sets.midcast.RA and sets.ranged        or {})
    end
  end
end

function aftercast(spell)
  if player.status == 'Engaged' then
    local acc = Acc_Array[Acc_Index]
    equip(sets.engaged[acc] or sets.engaged)
    if Weapon_Mode == "Melee" then equip_melee_weapons() else equip_gun() end
  else
    local m = DT_Modes[DT_Mode_Index]
    if     m == "DT"  then equip(sets.dt)
    elseif m == "EVA" then equip(sets.eva)
    else                   equip(sets.idle)
    end
    if Weapon_Mode == "Melee" then equip_melee_weapons() else equip_gun() end
  end

  if Movement_Mode then
    -- TODO add your movement feet when you decide which (e.g., Hermes' Sandals)
  end

  check_debuffs()
  check_capacity_ring()
end

function status_change(new, old)
  aftercast({})
end

-- ===========================
-- Suggested keybinds (type once or put in init.txt)
-- ===========================
-- //gs c toggleWeapon
-- //gs c toggleMelee
-- //gs c toggleAcc
-- //gs c toggleRacc
-- //gs c toggleDT
-- //gs c toggleMovement
