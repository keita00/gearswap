-- =========================================================================
-- COR.lua — Full Set Skeleton (Using Your Current THF Gear)
-- All major sets defined & documented with TODO checklists per slot.
-- Keeps your current gear when a set is empty.
-- HUD + Toggles + Capacity Ring alert + Debuff warnings + Day/Weather helper
-- =========================================================================

texts = require('texts')

local S = S or require('sets').S

send_command('bind f9 gs c toggleWeapon')
send_command('bind f10 gs c toggleMelee')
send_command('bind f11 gs c toggleAcc')
send_command('bind f12 gs c toggleRacc')
send_command('bind ^f9 gs c toggleDT')        -- ^ = Ctrl
send_command('bind !f9 gs c toggleMovement')  -- ! = Alt\
send_command('bind ^f10 gs c gun')    -- Ctrl+F10 → force Gun mode
send_command('bind ^f11 gs c melee')  -- Ctrl+F11 → force Melee mode

-- Debug: Check if binds registered
send_command('input /echo [DEBUG] Binds registered — COR.lua loaded')

-- Also list all current binds (useful to see if F9 is bound elsewhere)
send_command('input //listbinds')

-- ===========================
-- State / Toggles
-- ===========================
Weapon_Mode   = "Melee"     -- "Melee" | "Gun"
Melee_Mode    = "Rostam"    -- "Rostam" | "Shijo" | "Naegling"
Racc_Array    = {"Default","Acc","HighAcc"}
Racc_Index    = 1
Acc_Array     = {"Default","Acc","AccMid","AccHigh"}
Acc_Index     = 1
DT_Modes      = {"Normal","DT","EVA"}
DT_Mode_Index = 1
Movement_Mode = false

-- =========================
-- Camulus’s Mantle (COR Capes)
-- =========================

-- 1️⃣ Magic WS (Leaden Salute / Wildfire)
Camulus_Leaden = {
    name="Camulus's Mantle",
    augments={
        'AGI+20',
        'Mag. Acc+20 / Mag. Dmg.+20',
        'Magic Damage +10',
        'Weapon skill damage +10%',
        'Phys. dmg. taken -10%',
    },
}

-- 2️⃣ Melee / TP Cape (Rostam + Exeter)
Camulus_TP = {
    name="Camulus's Mantle",
    augments={
        'DEX+20',
        'Accuracy+30',
        'Attack+20',
        'Fast Cast+10%',
        'Damage taken -5%',
    },
}

-- 3️⃣ Roll / Utility Cape
Camulus_Roll = {
    name="Camulus's Mantle",
    augments={
        'CHR+20',
        'Accuracy+20',
        'Attack+20',
        'Mag. Evasion+15',
    },
}

-- Categorize WS
local WS_MAGIC_GUN   = S{'Leaden Salute','Wildfire','Trueflight'}
local WS_RANGED_PHYS = S{'Last Stand','Detonator','Slug Shot','Sniper Shot','Split Shot'}
local WS_MELEE_MAGIC = S{'Aeolian Edge'}
local WS_MELEE_PHYS  = S{
  'Savage Blade','Rudra\'s Storm','Requiescat','Vorpal Blade','Circle Blade',
  'Mercy Stroke','Dancing Edge','Shark Bite','Fast Blade','Flat Blade'
}

-- Ensure a stackable bullet is present (Exeter needs a bullet equipped even if it won't be consumed)
local function ensure_stackable_ammo(fallback)
  if player.equipment.ammo and player.equipment.ammo ~= 'empty' then return true end
  equip({ammo=fallback or "Bronze Bullet"})  -- any stackable bullet name you own
  -- after the equip request, we trust it's queued; still warn once:
  if player.equipment.ammo == 'empty' then
    add_to_chat(123,'[WS] No stackable bullets equipped. Equip Bronze/Iron/Silver/Chrono.')
    return false
  end
  return true
end

-- ===========================
-- HUD
-- ===========================
hud = texts.new('COR HUD', {pos={x=1120,y=36}, bg={alpha=0}, fg={alpha=255}, text={size=12}})
local function update_hud()
  local L = {}
  L[#L+1] = ('Mode:%s  Melee:%s'):format(Weapon_Mode, Melee_Mode)
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
    Melee_Mode = (Melee_Mode == 'Rostam') and 'Shijo'
                 or (Melee_Mode == 'Shijo' and 'Naegling' or 'Rostam')
  elseif cmd == 'gun' then
    Weapon_Mode = 'Gun'
    add_to_chat(122,'Weapon Mode: Gun')
    update_hud()
    aftercast({})
  elseif cmd == 'melee' then
    Weapon_Mode = 'Melee'
    add_to_chat(122,'Weapon Mode: Melee')
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
	  main="Rostam", sub="Gleti's Knife",
	  head="Adhemar Bonnet +1",
	  body="Pillager's Vest +3",
	  hands="Adhemar Wrist. +1",
	  legs="Mummu Kecks +1",
	  feet="Adhe. Gamashes +1",
	  neck="Asn. Gorget +2",
	  ear1="Suppanomimi", ear2="Telos Earring",
	  ring1="Defending Ring", ring2="Moonlight Ring",
	  back=Camulus_Roll,  -- safe DT/utility cape for idle
	  waist="Reiki Yotai",
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
    back= "Camulus_TP",
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
    back= "Camulus_Roll",
    waist= "Flume Belt +1"
  }

  ---------------------------------------------------------------------------
  -- ENGAGED (MELEE TP)
  ---------------------------------------------------------------------------
  sets.engaged = {
    main= "Rostam",
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
    back= "Camulus_TP",
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
  
	sets.engaged_gun = {
	  -- light hybrid while you’re in Gun mode (between shots)
	  head="Adhemar Bonnet +1",
	  body="Pillager's Vest +3",
	  hands="Adhemar Wrist. +1",
	  legs="Pill. Culottes +3",
	  feet="Adhe. Gamashes +1",
	  neck="Asn. Gorget +2",
	  ear1="Cessance Earring", ear2="Moonshade Earring",
	  ring1="Regal Ring", ring2="Chirich Ring +1",
	  waist="Sailfi Belt +1",
	  back=Camulus_TP,
	}


  ---------------------------------------------------------------------------
  -- RANGED TP (AutoRA)
  ---------------------------------------------------------------------------
  sets.ranged = {
    range= "Exeter",  -- if you have; else replace with placeholder gun
    ammo= "Bronze Bullet",
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

-- =========================
-- RANGED ATTACK (RA) SETS
-- =========================

-- Precast: Snapshot/Rapid Shot (we'll just keep it lightweight with your gear)
sets.precast = sets.precast or {}
sets.precast.RA = {
    -- You don't own dedicated Snapshot yet; keep it minimal/fast.
    -- Back helps keep your TP/JA identity consistent.
    back=Camulus_TP,
    waist="Reiki Yotai",          -- small haste/QA QoL (placeholder)
}

-- Midcast: actual hits (R.Acc/R.Atk/AGI help). Use accuracy tiers via Racc_Array.
sets.midcast = sets.midcast or {}
sets.midcast.RA = {
  head="Adhemar Bonnet +1",
  body="Pillager's Vest +3",
  hands="Adhemar Wrist. +1",
  legs="Pill. Culottes +3",
  feet="Adhe. Gamashes +1",
  neck="Asn. Gorget +2",
  ear1="Cessance Earring",
  ear2="Moonshade Earring",
  ring1="Regal Ring",
  ring2="Chirich Ring +1",
  waist="Sailfi Belt +1",
  back=Camulus_TP,
}

-- Acc tier bumps using your Mummu pieces (AGI/RA acc leaning)
sets.midcast.RA_Acc = set_combine(sets.midcast.RA, {
    head="Mummu Bonnet +2",
    hands="Mummu Wrists +2",
    legs="Mummu Kecks +1",
    feet="Mummu Gamash. +2",
})

sets.midcast.RA_HighAcc = set_combine(sets.midcast.RA_Acc, {
    -- keep Camulus_TP; you're already at your best with current items
})

  ---------------------------------------------------------------------------
  -- ROLLS / UTILITY
  ---------------------------------------------------------------------------
sets.JA = {
  ["Phantom Roll"] = {
    head="Adhemar Bonnet +1",
    body="Pillager's Vest +3",
    hands="Adhemar Wrist. +1",
    legs="Pill. Culottes +3",
    feet="Adhe. Gamashes +1",
    neck="Asn. Gorget +2",
    ring1="Defending Ring",
    ring2="Moonlight Ring",
    back=Camulus_Roll,    -- use your roll/utility cape
  },
  ["Double-Up"] = { back=Camulus_Roll },
  ["Random Deal"] = {
    head="Adhemar Bonnet +1", body="Pillager's Vest +3", hands="Adhemar Wrist. +1",
    back=Camulus_Roll
  },
  ["Wild Card"] = {
    head="Adhemar Bonnet +1", body="Pillager's Vest +3", hands="Adhemar Wrist. +1",
    back=Camulus_Roll
  },
  ["Snake Eye"] = {
    head="Adhemar Bonnet +1", body="Pillager's Vest +3", hands="Adhemar Wrist. +1",
    back=Camulus_Roll
  },
  ["Fold"] = {
    head="Adhemar Bonnet +1", body="Pillager's Vest +3", hands="Adhemar Wrist. +1",
    back=Camulus_Roll
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
-- =========================
-- COR Weapon Skill Sets
-- Using ONLY your THF gear + your Camulus capes
-- =========================
sets.ws = sets.ws or {}

-- 1) Magic gun WS: Leaden / Wildfire  (AGI/MAB; we’ll lean on your Leaden cape + Orpheus)
sets.ws["Leaden Salute"] = {
    head="Mummu Bonnet +2",            -- AGI
    body="Pillager's Vest +3",
    hands="Pill. Armlets +3",          -- WSD on SA/TA but still your best
    legs="Pill. Culottes +3",
    feet="Plun. Pulaines +1",
    neck="Asn. Gorget +2",             -- (no Baetyl yet)
    ear1="Odr Earring",                -- (no Friomisi yet)
    ear2="Moonshade Earring",
    ring1="Regal Ring",
    ring2="Epaminondas's Ring",
    waist="Orpheus's Sash",
    back=Camulus_Leaden,               -- AGI/MAB/WSdmg/PDT
}

sets.ws["Wildfire"] = set_combine(sets.ws["Leaden Salute"], {
    -- Same idea – uses Camulus_Leaden and Orpheus
})

-- 2) Physical gun WS: Last Stand (AGI-based; we’ll lean on your Adhemar/Mummu/Adhe. pieces)
sets.ws["Last Stand"] = {
    head="Adhemar Bonnet +1",
    body="Pillager's Vest +3",
    hands="Adhemar Wrist. +1",
    legs="Pill. Culottes +3",
    feet="Adhe. Gamashes +1",
    neck="Asn. Gorget +2",
    ear1="Cessance Earring",
    ear2="Moonshade Earring",
    ring1="Regal Ring",
    ring2="Epaminondas's Ring",
    waist="Sailfi Belt +1",
    back=Camulus_TP,                   -- AGI cape would be ideal, but TP cape is fine for now
}

-- 3) Melee physical WS: Savage Blade (your THF pieces actually work fine)
sets.ws["Savage Blade"] = {
    head="Pill. Bonnet +3",
    body="Pillager's Vest +3",
    hands="Pill. Armlets +3",
    legs="Pill. Culottes +3",
    feet="Plun. Pulaines +1",
    neck="Asn. Gorget +2",
    ear1="Ishvara Earring",
    ear2="Moonshade Earring",
    ring1="Epaminondas's Ring",
    ring2="Regal Ring",
    waist="Sailfi Belt +1",
    back=Camulus_TP,                   -- (Leaden cape has WSD+10, but we’ll keep TP cape for melee identity)
}

-- 4) Melee magical WS: Aeolian Edge (INT/MAB; we’ll rely on Leaden cape + Orpheus)
sets.ws["Aeolian Edge"] = {
    head="Mummu Bonnet +2",
    body="Pillager's Vest +3",
    hands="Pill. Armlets +3",
    legs="Pill. Culottes +3",
    feet="Plun. Pulaines +1",
    neck="Asn. Gorget +2",
    ear1="Odr Earring",
    ear2="Moonshade Earring",
    ring1="Regal Ring",
    ring2="Epaminondas's Ring",
    waist="Orpheus's Sash",
    back=Camulus_Leaden,
}

-- 5) Fallback WS set (used if a WS name isn’t covered)
sets.ws["Default"] = {
    head="Adhemar Bonnet +1",
    body="Pillager's Vest +3",
    hands="Adhemar Wrist. +1",
    legs="Pill. Culottes +3",
    feet="Adhe. Gamashes +1",
    neck="Asn. Gorget +2",
    ear1="Cessance Earring",
    ear2="Moonshade Earring",
    ring1="Epona's Ring",
    ring2="Chirich Ring +1",
    waist="Sailfi Belt +1",
    back=Camulus_TP,
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
    equip({main="Rostam", sub="Gleti's Knife"})
  end
end

-- Keep gun on & TP bullet (Exeter won’t consume stackable ammo)
local function equip_gun()
  if player.equipment.range == 'empty' or player.equipment.range == nil then
    equip({range="Exeter"})
  end
  equip({ammo="Chrono Bullet"})  -- any stackable bullet you actually own
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
function pretarget(spell)
  if spell.type == 'WeaponSkill' then
    -- If this is a gun WS, force Gun mode + gun equip
    if WS_MAGIC_GUN:contains(spell.english) or WS_RANGED_PHYS:contains(spell.english) then
      if Weapon_Mode ~= "Gun" or player.equipment.range == 'empty' then
        Weapon_Mode = "Gun"
        equip_gun()
        add_to_chat(122,'[Auto] Switched to Gun mode for '..spell.english)
      end
    else
      -- Melee WS -> force Melee mode
      if Weapon_Mode ~= "Melee" then
        Weapon_Mode = "Melee"
        equip_melee_weapons()
        add_to_chat(122,'[Auto] Switched to Melee mode for '..spell.english)
      end
    end
    -- If fishing mode accidentally locked a rod, bail gracefully
    if Fishing and Fishing.state and Fishing.state.FishingMode and player.equipment.range ~= 'Exeter' then
      add_to_chat(123,'[WS] Fishing rod is locked. Toggle fishing OFF to use WS.')
      cancel_spell()
      return
    end
  end
end

function precast(spell)
  -- JA block stays as you had it
  if sets.JA[spell.english] then
    equip(sets.JA[spell.english]); return
  end

  -- Ranged attack precast
  if spell.action_type == 'Ranged Attack' then
    equip(sets.precast.RA)
    equip_gun()
    return
  end

  -- Weapon Skills
  if spell.type == 'WeaponSkill' then
    -- Make sure bullets exist for gun WS
    if WS_MAGIC_GUN:contains(spell.english) or WS_RANGED_PHYS:contains(spell.english) then
      if not ensure_stackable_ammo("Chrono Bullet") then
        cancel_spell(); return
      end
    end

    -- Equip your WS set then force the correct cape+ammo
    if WS_MAGIC_GUN:contains(spell.english) then
      equip(sets.ws[spell.english] or sets.ws["Default"])
      equip({ammo="Hauksbok Bullet", back=Camulus_Leaden})
    elseif WS_RANGED_PHYS:contains(spell.english) then
      equip(sets.ws[spell.english] or sets.ws["Last Stand"] or sets.ws["Default"])
      equip({ammo="Chrono Bullet", back=Camulus_TP})
    elseif WS_MELEE_MAGIC:contains(spell.english) then
      equip(sets.ws[spell.english] or sets.ws["Default"])
      equip({ammo="Aurgelmir Orb +1", back=Camulus_Leaden})
    elseif WS_MELEE_PHYS:contains(spell.english) then
      equip(sets.ws[spell.english] or sets.ws["Savage Blade"] or sets.ws["Default"])
      equip({ammo="Aurgelmir Orb +1", back=Camulus_TP})
    else
      equip(sets.ws["Default"]); equip({ammo="Aurgelmir Orb +1", back=Camulus_TP})
    end
	
    -- Handle Rolls (use CHR cape)
    if spell.english:contains('Roll') or S{'Random Deal','Wild Card'}:contains(spell.english) then
        equip(sets.JA[spell.english] or sets.JA["Phantom Roll"] or {})
        equip({back=Camulus_Roll})
        return
    end

    -- Element bonus for Leaden
    if spell.english == "Leaden Salute" and (world.weather_element == 'Dark' or world.day_element == 'Dark') then
      equip({waist="Hachirin-no-Obi"})
    end
    return
  end
end

function midcast(spell)
    if spell.action_type == 'Ranged Attack' then
        local mode = Racc_Array and Racc_Array[Racc_Index] or "Default"
        if mode == "HighAcc" then
            equip(sets.midcast.RA_HighAcc)
        elseif mode == "Acc" then
            equip(sets.midcast.RA_Acc)
        else
            equip(sets.midcast.RA)
        end
        return
    end
end

function aftercast(spell)
  if player.status == 'Engaged' then
    if Weapon_Mode == "Gun" then
      equip(sets.engaged_gun); equip_gun()
    else
      local acc = Acc_Array[Acc_Index]
      equip(sets.engaged[acc] or sets.engaged); equip_melee_weapons()
    end
  else
    local m = DT_Modes[DT_Mode_Index]
    if     m == "DT"  then equip(sets.dt)
    elseif m == "EVA" then equip(sets.eva)
    else                   equip(sets.idle)
    end
    if Weapon_Mode == "Gun" then equip_gun() else equip_melee_weapons() end
  end
end

function status_change(new, old)
  if new == 'Engaged' then
    if Weapon_Mode == "Gun" then
      equip(sets.engaged_gun); equip_gun()
    else
      local acc = Acc_Array[Acc_Index]
      equip(sets.engaged[acc] or sets.engaged); equip_melee_weapons()
    end
  else
    local m = DT_Modes[DT_Mode_Index]
    if     m == "DT"  then equip(sets.dt)
    elseif m == "EVA" then equip(sets.eva)
    else                   equip(sets.idle)
    end
    if Weapon_Mode == "Gun" then equip_gun() else equip_melee_weapons() end
  end
end



function status_change(new, old)
  if new == 'Engaged' then
    if Weapon_Mode == "Gun" then
      equip(sets.engaged_gun)
      equip_gun()
    else
      local acc = Acc_Array[Acc_Index]
      equip(sets.engaged[acc] or sets.engaged)
      equip_melee_weapons()
    end
  else
    local m = DT_Modes[DT_Mode_Index]
    if     m == "DT"  then equip(sets.dt)
    elseif m == "EVA" then equip(sets.eva)
    else                   equip(sets.idle)
    end
    if Weapon_Mode == "Gun" then equip_gun() else equip_melee_weapons() end
  end
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
