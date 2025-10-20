-- =========================================================================
-- COR.lua — Full Set Skeleton (Using Your Current THF Gear)
-- All major sets defined & documented with TODO checklists per slot.
-- Keeps your current gear when a set is empty.
-- HUD + Toggles + Capacity Ring alert + Debuff warnings + Day/Weather helper
-- =========================================================================

texts = require('texts')

-- ===========================
-- State / Toggles
-- ===========================
Weapon_Mode   = "Melee"     -- "Melee" | "Gun"
Melee_Mode    = "Tauret"    -- "Tauret" | "Shijo" | "Naegling"
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
    Melee_Mode = (Melee_Mode == 'Tauret') and 'Shijo'
                 or (Melee_Mode == 'Shijo' and 'Naegling' or 'Tauret')
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
-- Sets (Using THF gear where available)
-- ===========================
function get_sets()
  update_hud()
  sets = {}

  ---------------------------------------------------------------------------
  -- IDLE / DEFENSIVE
  ---------------------------------------------------------------------------
  sets.idle = {
    main= "Tauret",
    sub= "Gleti's Knife",
    --range= "", ammo="",
    head= "Adhemar Bonnet +1",  -- you have this
    body= "Adhemar Jacket +1",  -- if you have it; else placeholder
    hands= "Adhemar Wristbands +1",  -- if you have
    legs= "Mummu Kecks +1",  -- you have this
    feet= "Adhemar Gamashes +1",  -- if you have
    neck= "Regal Necklace",  -- placeholder if not
    ear1= "Suppanomimi",  -- common THF ear
    ear2= "Telos Earring",  -- placeholder/highAcc ear
    ring1= "Defending Ring",
    ring2= "Moonlight Ring",
    back= "Toutatis's Cape",
    waist= "Reiki Yotai"
    -- Notes: Use your current gear for idle until COR-specific upgrades
  }

  sets.dt = {
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    neck= "Warder's Charm +1",
    ear1= "Suppanomimi",
    ear2= "Telos Earring",
    ring1= "Defending Ring",
    ring2= "Moonlight Ring",
    back= "Toutatis's Cape",
    waist= "Carrier's Sash"
    -- Notes: Replace with Malignance/Nyame later.
  }

  sets.eva = {
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    neck= "Warder's Charm +1",
    ring1= "Defending Ring",
    ring2= "Moonlight Ring",
    back= "Toutatis's Cape",
    waist= "Flume Belt +1"
  }

  ---------------------------------------------------------------------------
  -- ENGAGED (MELEE TP)
  ---------------------------------------------------------------------------
  sets.engaged = {
    main= "Tauret",
    sub= "Gleti's Knife",
    ammo= "Aurgelmir Orb +1",
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    neck= "Asn. Gorget +2",
    ear1= "Sherida Earring",
    ear2= "Suppanomimi",
    ring1= "Epona's Ring",
    ring2= "Chirich Ring +1",
    back= "Toutatis's Cape",
    waist= "Sailfi Belt +1"
    -- Notes: Your current TP melee gear from THF applies until you upgrade.
  }
  sets.engaged.Acc     = set_combine(sets.engaged, {
    -- TODO Add ACC-specific items here when you have them
  })
  sets.engaged.AccMid  = set_combine(sets.engaged.Acc, {
    -- TODO Mid-ACC variant
  })
  sets.engaged.AccHigh = set_combine(sets.engaged.AccMid, {
    -- TODO High-ACC variant
  })

  ---------------------------------------------------------------------------
  -- RANGED TP (AutoRA)
  ---------------------------------------------------------------------------
  sets.ranged = {
    range= "Fomalhaut",  -- if you have; else replace with placeholder gun
    ammo= "Devastating Bullet",
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    neck= "Iskur Gorget",
    ear1= "Telos Earring",
    ear2= "Crepuscular Earring",
    ring1= "Regal Ring",
    ring2= "Epaminondas’s Ring",
    back= "Camulus’s Mantle",
    waist= "Orpheus’s Sash"
    -- Notes: Use THF gear where applicable until COR ranged upgrade.
  }
  sets.ranged.Acc     = set_combine(sets.ranged, {
    -- TODO Add Ranged ACC gear when you have them
  })
  sets.ranged.HighAcc = set_combine(sets.ranged.Acc, {
    -- TODO Max ACC Ranged gear
  })

  ---------------------------------------------------------------------------
  -- PRECAST / MIDCAST (GUN)
  ---------------------------------------------------------------------------
  sets.precast = {}
  sets.precast.RA = {
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    back= "Toutatis's Cape",
    waist= "Yemaya Belt"
    -- Notes: Snapshot gear not yet fully COR-specific.
  }
  sets.midcast = {}
  sets.midcast.RA = {
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    neck= "Iskur Gorget",
    ear1= "Telos Earring",
    ear2= "Crepuscular Earring",
    ring1= "Regal Ring",
    ring2= "Epaminondas’s Ring",
    back= "Camulus’s Mantle",
    waist= "Orpheus’s Sash"
  }

  ---------------------------------------------------------------------------
  -- ROLLS / UTILITY
  ---------------------------------------------------------------------------
  sets.JA = {
    ["Phantom Roll"] = {
      head= "Lanun Tricorne +3",
      body= "Chasseur’s Vest +3",
      hands= "Chasseur’s Gants +3",
      feet= "Lanun Bottes +3",
      neck= "Regal Necklace",
      back= "Camulus’s Mantle",
      ring1= "Defending Ring",
      ring2= "Moonlight Ring"
    },
    ["Double-Up"] = {
      -- TODO Use same or lighter gear
      head= "Lanun Tricorne +3",
      body= "Chasseur’s Vest +3",
      hands= "Chasseur’s Gants +3",
      feet= "Lanun Bottes +3"
    },
    ["Random Deal"] = {
      -- TODO Fast Cast/DT
      head= "Adhemar Bonnet +1",
      body= "Adhemar Jacket +1",
      hands= "Adhemar Wristbands +1"
    },
    ["Wild Card"]   = {
      head= "Adhemar Bonnet +1",
      body= "Adhemar Jacket +1",
      hands= "Adhemar Wristbands +1"
    },
    ["Snake Eye"]   = {
      head= "Adhemar Bonnet +1",
      body= "Adhemar Jacket +1",
      hands= "Adhemar Wristbands +1"
    },
    ["Fold"]        = {
      head= "Adhemar Bonnet +1",
      body= "Adhemar Jacket +1",
      hands= "Adhemar Wristbands +1"
    },
  }

  ---------------------------------------------------------------------------
  -- QUICK DRAW
  ---------------------------------------------------------------------------
  sets.QD = {
    ammo= "Animikii Bullet",
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    neck= "Baetyl Pendant",
    ear1= "Friomisi Earring",
    ear2= "Moonshade Earring",
    ring1= "Dingir Ring",
    ring2= "Regal Ring",
    back= "Camulus’s Mantle",
    waist= "Hachirin-no-Obi"
  }

  ---------------------------------------------------------------------------
  -- WEAPON SKILLS
  ---------------------------------------------------------------------------
  sets.ws = {}

  sets.ws["Leaden Salute"] = {
    range= "Death Penalty",
    ammo= "Animikii Bullet",
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    neck= "Baetyl Pendant",
    ear1= "Friomisi Earring",
    ear2= "Moonshade Earring",
    ring1= "Dingir Ring",
    ring2= "Regal Ring",
    back= "Camulus’s Mantle",
    waist= "Orpheus’s Sash"
  }

  sets.ws["Last Stand"] = {
    range= "Fomalhaut",
    ammo= "Devastating Bullet",
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    neck= "Fotia Gorget",
    ear1= "Ishvara Earring",
    ear2= "Moonshade Earring",
    ring1= "Ilabrat Ring",
    ring2= "Regal Ring",
    back= "Camulus’s Mantle",
    waist= "Fotia Belt"
  }

  sets.ws["Savage Blade"] = {
    main= "Tauret",
    sub= "Gleti's Knife",
    ammo= "Aurgelmir Orb +1",
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    neck= "Fotia Gorget",
    ear1= "Ishvara Earring",
    ear2= "Moonshade Earring",
    ring1= "Epaminondas’s Ring",
    ring2= "Regal Ring",
    back= "Camulus’s Mantle",
    waist= "Sailfi Belt +1"
  }

  sets.ws["Wildfire"] = {
    range= "Fomalhaut",
    ammo= "Devastating Bullet",
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    neck= "Baetyl Pendant",
    ear1= "Friomisi Earring",
    ear2= "Moonshade Earring",
    ring1= "Dingir Ring",
    ring2= "Regal Ring",
    back= "Camulus’s Mantle",
    waist= "Hachirin-no-Obi"
  }

  sets.ws.Default = {
    head= "Adhemar Bonnet +1",
    body= "Adhemar Jacket +1",
    hands= "Adhemar Wristbands +1",
    legs= "Mummu Kecks +1",
    feet= "Adhemar Gamashes +1",
    neck= "Regal Necklace",
    ear1= "Suppanomimi",
    ear2= "Telos Earring",
    ring1= "Defending Ring",
    ring2= "Moonlight Ring"
  }

  ---------------------------------------------------------------------------
  -- ELEMENTAL DAY/WEATHER SUPPORT
  ---------------------------------------------------------------------------
  sets.Obi = {
    waist="Hachirin-no-Obi"
    -- Notes: Use when owned for day/weather boost
  }

end

-- ===========================
-- Helpers
-- ===========================
local function equip_melee_weapons()
  if Melee_Mode == "Shijo" then
    equip({main="Shijo", sub="Gleti's Knife"})
  elseif Melee_Mode == "Naegling" then
    equip({main="Naegling", sub="Gleti's Knife"})
  else
    equip({main="Tauret", sub="Gleti's Knife"})
  end
end

local function equip_gun()
  if player.equipment.range ~= 'empty' then
    equip({range=player.equipment.range})
  end
end

local function check_capacity_ring()
  local eq = windower.ffxi.get_items().equipment
  if eq and eq.ring1 == 28540 then
    add_to_chat(122,'Capacity Ring equipped.')
  end
end

local function check_debuffs()
  for _, d in ipairs({"Doom","Silence","Paralysis"}) do
    if buffactive[d] then add_to_chat(123,'Debuff: '..d..' — remedy it!') end
  end
end

local function leaden_dayweather_boost()
  if world.weather_element == 'Dark' or world.day_element == 'Dark' then
    equip(sets.Obi)
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
    equip(sets.precast.RA)
  end
end

function midcast(spell)
  if spell.action_type == 'Ranged Attack' then
    local racc = Racc_Array[Racc_Index]
    if     racc == "HighAcc" then equip(sets.midcast.RA and sets.ranged.HighAcc or {})
    elseif racc == "Acc"     then equip(sets.midcast.RA and sets.ranged.Acc or {})
    else                           equip(sets.midcast.RA and sets.ranged or {}) end
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
    else                   equip(sets.idle) end
    if Weapon_Mode == "Melee" then equip_melee_weapons() else equip_gun() end
  end

  if Movement_Mode then
    -- TODO add movement feet (e.g., Hermes' Sandals)
  end

  check_debuffs()
  check_capacity_ring()
end

function status_change(new, old)
  aftercast({})
end

-- ===========================
-- Suggested keybinds
-- ===========================
-- //gs c toggleWeapon
-- //gs c toggleMelee
-- // //gs c toggleAcc
-- // //gs c toggleRacc
-- // //gs c toggleDT
-- // //gs c toggleMovement
