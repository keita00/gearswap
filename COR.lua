-- === COR.lua (melee-only) ================================================
-- Uses ONLY gear present in your THF.lua (no new items added).
-- Melee TP + WS (Savage/Evisceration/Exenterator/DE) with Toggles + HUD.
-- ========================================================================

texts = require('texts')

-- ========= State / Toggles =========
Weapon_Mode   = "Melee"            -- melee-only (no gun sets since no bullets/gun listed)
Melee_Mode    = "Tauret"           -- "Tauret" | "Shijo"
Acc_Array     = {"Default","Acc","AccMid","AccHigh"}
Acc_Index     = 1
DT_Modes      = {"Normal","DT","EVA"}
DT_Mode_Index = 1
Movement_Mode = false

-- ========= Your shared items (from THF.lua) =========
Tauret        = "Tauret"
Shijo_TP      = { name="Shijo", augments={'Path: D'} }
Shijo_WS      = { name="Shijo", augments={'Path: C'} }
Gleti_Off     = "Gleti's Knife"

Aurgelmir     = "Aurgelmir Orb +1"
Yetshila      = "Yetshila +1"

-- Earrings / Rings / Belts / Necks you own
ear_Telos     = "Telos Earring"
ear_Suppa     = "Suppanomimi"
ear_Sherida   = "Sherida Earring"
ear_Ishvara   = "Ishvara Earring"
ear_Odr       = "Odr Earring"
ear_Moonshade = "Moonshade Earring"

ring_Epona    = "Epona's Ring"
ring_Chirich  = "Chirich Ring +1"
ring_Regal    = "Regal Ring"
ring_Epamin   = "Epaminondas's Ring"
ring_Def      = "Defending Ring"
ring_Moon     = "Moonlight Ring"

belt_Sailfi   = "Sailfi Belt +1"
belt_Kentarch = "Kentarch Belt +1"
belt_Reiki    = "Reiki Yotai"
belt_Flume    = "Flume Belt +1"
belt_Orpheus  = "Orpheus's Sash"

neck_Warder   = "Warder's Charm +1"
-- (Asn. Gorget +2 is THF-only → do NOT use on COR)

-- ========= HUD =========
hud = texts.new('COR', {pos={x=1120,y=36}, bg={alpha=0}, fg={alpha=255}, text={size=12}})
local function update_hud()
  local L = {}
  L[#L+1] = ('Mode:%s-%s'):format(Weapon_Mode, Melee_Mode)
  L[#L+1] = ('ACC:%s'):format(Acc_Array[Acc_Index])
  L[#L+1] = ('DT:%s'):format(DT_Modes[DT_Mode_Index])
  L[#L+1] = ('MOV:%s'):format(Movement_Mode and 'ON' or 'OFF')
  if player and player.sub_job then L[#L+1] = ('SJ:%s'):format(player.sub_job) end
  hud:text(table.concat(L,'  |  ')); hud:show()
end

-- ========= Commands =========
function self_command(cmd)
  if cmd == 'toggleMelee' then
    Melee_Mode = (Melee_Mode == "Tauret") and "Shijo" or "Tauret"
    add_to_chat(122,'Melee Weapon: '..Melee_Mode)
  elseif cmd == 'toggleAcc' then
    Acc_Index = Acc_Index % #Acc_Array + 1
    add_to_chat(122,'Accuracy: '..Acc_Array[Acc_Index])
  elseif cmd == 'toggleDT' then
    DT_Mode_Index = DT_Mode_Index % #DT_Modes + 1
    add_to_chat(122,'Defense: '..DT_Modes[DT_Mode_Index])
  elseif cmd == 'toggleMovement' then
    Movement_Mode = not Movement_Mode
    add_to_chat(122,'Movement: '..(Movement_Mode and 'ON' or 'OFF'))
  end
  update_hud(); aftercast({})
end

-- ========= Sets (ONLY items you own & COR can wear) =========
function get_sets()
  update_hud()
  sets = {}

  -- ========= ENGAGED (TP) =========
  -- Uses Adhemar/Mummu/your accessories. Avoid THF-locked Pillager/Plunderer/Turms.
  sets.engaged = {
    ammo = Aurgelmir,
    head = "Adhemar Bonnet +1",     -- COR-usable
    -- body  = (none from your list that's COR-usable)
    hands= "Adhemar Wrist. +1",
    legs = "Mummu Kecks +1",
    feet = "Adhe. Gamashes +1",
    neck = neck_Warder,             -- only shared neck you have
    ear1 = ear_Telos,
    ear2 = ear_Suppa,
    ring1= ring_Epona,
    ring2= ring_Chirich,
    waist= belt_Sailfi,
    -- back  = (no COR back in stash; left empty)
  }
  sets.engaged.Acc = set_combine(sets.engaged, {
    head = "Mummu Bonnet +2",
    hands= "Mummu Wrists +2",
    legs = "Mummu Kecks +1",
    feet = "Mummu Gamash. +2",
    ring2= ring_Regal,
  })
  sets.engaged.AccMid = set_combine(sets.engaged.Acc, {
    ear2 = ear_Telos,
  })
  sets.engaged.AccHigh = set_combine(sets.engaged.AccMid, {
    waist = belt_Kentarch,
  })

  -- ========= IDLE / DT / EVA =========
  sets.idle = {
    ammo = Aurgelmir,
    head = "Adhemar Bonnet +1",
    hands= "Adhemar Wrist. +1",
    legs = "Mummu Kecks +1",
    feet = "Adhe. Gamashes +1",
    neck = neck_Warder,
    ear1 = ear_Suppa,
    ear2 = ear_Telos,
    ring1= ring_Def,
    ring2= ring_Moon,
    waist= belt_Flume,
  }
  sets.dt  = set_combine(sets.idle, { })
  sets.eva = set_combine(sets.idle, { waist=belt_Reiki })

  -- ========= Weapon Skills =========
  sets.ws = {}

  -- Savage Blade (works fine with Tauret/Shijo; you’ll swap to Naegling later)
  sets.ws["Savage Blade"] = {
    ammo = Aurgelmir,
    head = "Adhemar Bonnet +1",
    hands= "Adhemar Wrist. +1",
    legs = "Mummu Kecks +1",
    feet = "Adhe. Gamashes +1",
    neck = neck_Warder,         -- no Fotia in stash
    ear1 = ear_Ishvara,
    ear2 = ear_Moonshade,
    ring1= ring_Epamin,
    ring2= ring_Regal,
    waist= belt_Sailfi,         -- swap to Fotia later, not in stash now
  }

  -- Evisceration (crit WS)
  sets.ws["Evisceration"] = {
    ammo = Yetshila,
    head = "Mummu Bonnet +2",
    hands= "Mummu Wrists +2",
    legs = "Mummu Kecks +1",
    feet = "Mummu Gamash. +2",
    ear1 = ear_Odr,
    ear2 = ear_Moonshade,
    ring1= ring_Epona,
    ring2= ring_Epamin,
    waist= belt_Reiki,
    neck = neck_Warder,
  }

  -- Exenterator (DEX/AGI WS)
  sets.ws["Exenterator"] = {
    ammo = Aurgelmir,
    head = "Adhemar Bonnet +1",
    hands= "Adhemar Wrist. +1",
    legs = "Mummu Kecks +1",
    feet = "Adhe. Gamashes +1",
    ear1 = ear_Telos,
    ear2 = ear_Suppa,
    ring1= ring_Epona,
    ring2= ring_Chirich,
    waist= belt_Sailfi,
    neck = neck_Warder,
  }

  -- Dancing Edge – solid multi-hit fallback
  sets.ws["Dancing Edge"] = {
    ammo = Aurgelmir,
    head = "Adhemar Bonnet +1",
    hands= "Adhemar Wrist. +1",
    legs = "Mummu Kecks +1",
    feet = "Adhe. Gamashes +1",
    ear1 = ear_Telos,
    ear2 = ear_Moonshade,
    ring1= ring_Epona,
    ring2= ring_Chirich,
    waist= belt_Sailfi,
    neck = neck_Warder,
  }

  sets.ws.Default = set_combine(sets.engaged, {ear2 = ear_Moonshade})
end

-- ========= Equip logic =========
local function equip_melee_weapons()
  if Melee_Mode == "Shijo" then
    equip({main=Shijo_TP, sub=Gleti_Off})
  else
    equip({main=Tauret, sub=Gleti_Off})
  end
end

local function check_capacity_ring()
  local eq = windower.ffxi.get_items().equipment
  if eq and eq.ring1 and eq.ring1 == 28540 then
    add_to_chat(122,'Capacity Ring equipped.')
  end
end

local function check_debuffs()
  for _,d in ipairs({"Doom","Silence","Paralysis"}) do
    if buffactive[d] then add_to_chat(123,'Debuff: '..d..' — item it!') end
  end
end

-- ========= Cast phases =========
function precast(spell)
  if spell.type == 'WeaponSkill' then
    equip(sets.ws[spell.english] or sets.ws.Default)
    add_to_chat(122,'WS: '..spell.english)
  end
end

function midcast(spell) end

function aftercast(spell)
  if player.status == 'Engaged' then
    local acc = Acc_Array[Acc_Index]
    equip(sets.engaged[acc] or sets.engaged)
    equip_melee_weapons()
    equip({ammo=Aurgelmir})
  else
    local mode = DT_Modes[DT_Mode_Index]
    if mode == "DT" then equip(sets.dt)
    elseif mode == "EVA" then equip(sets.eva)
    else equip(sets.idle) end
    equip_melee_weapons()
  end

  if Movement_Mode then
    -- You used Pill. Poulaines +3 on THF; COR doesn't have them. Keep feet as-is.
  end

  check_debuffs()
  check_capacity_ring()
end

function status_change(new, old) aftercast({}) end

-- ========= Optional keybinds (type in chat once or use init.txt)
-- //gs c toggleMelee
-- //gs c toggleAcc
-- //gs c toggleDT
-- //gs c toggleMovement
