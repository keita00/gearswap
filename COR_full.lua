-- Maedhros COR GearSwap - Full version (no wardrobe refs, Phantom Roll fix, RA/QD/Triple Shot precast)

include('Mirdain-Include')

----------------------------------------------------------------------------------------------------
-- Basic config
----------------------------------------------------------------------------------------------------
LockStylePallet = "12"
MacroBook = "17"
MacroSet  = "1"

Food = "Sublime Sushi"
AutoItem = true
Random_Lockstyle = false
Lockstyle_List = {1,2,6,12}

state.OffenseMode:options('TP','ACC','DT','PDL','CRIT','MEVA','SB')
state.OffenseMode:set('TP')
state.WeaponMode:options('Fomalhaut','Death Penalty','Savage Blade','Aeolian Edge','Evisceration')
state.WeaponMode:set('Death Penalty')
UI_Name = 'TP Mode'
state.JobMode:options('Standard','Melee','Ranged')
state.JobMode:set('Standard')

jobsetup(LockStylePallet,MacroBook,MacroSet)

Ammo_Warning_Limit = 99

-- Ammo table (used in sets below)
Ammo = {}
Ammo.Bullet = {
  RA      = "Chrono Bullet",   -- TP
  WS      = "Chrono Bullet",   -- Physical WS
  CRIT    = "Chrono Bullet",
  PDL     = "Chrono Bullet",
  SB      = "Chrono Bullet",
  MAB     = "Living Bullet",   -- Magical WS
  MACC    = "Chrono Bullet",
  QD      = "Hauksbok Bullet", -- Quick Draw
  MAG_WS  = "Living Bullet"
}

----------------------------------------------------------------------------------------------------
-- Sets
----------------------------------------------------------------------------------------------------
function get_sets()

  -- Weapon sets
  sets.Weapons = {}
  sets.Weapons['Savage Blade'] = { main="Naegling", sub="Gleti's Knife", range="Anarchy" }
  sets.Weapons['Evisceration'] = { main="Tauret",   sub="Gleti's Knife", range="Anarchy +2" }
  sets.Weapons['Fomalhaut']    = { main="Rostam",   sub="Rostam",        range="Fomalhaut" }
  sets.Weapons['Death Penalty']= { main="Rostam",   sub="Tauret",        range="Death Penalty" }
  sets.Weapons['Aeolian Edge'] = { main="Rostam",   sub="Tauret",        range="Anarchy +2", ammo=Ammo.Bullet.MAG_WS }

  sets.Weapons.Melee  = { sub="Gleti's Knife" }
  sets.Weapons.Ranged = { sub="Kustawi +1"    }
  sets.Weapons.Shield = { sub="Nusku Shield"  }
  sets.Weapons.Sleep  = { range="Earp"        }

  -- Idle
  sets.Idle = {
    ammo = Ammo.Bullet.RA,
    head="Nyame Helm", body="Nyame Mail", hands="Nyame Gauntlets",
    legs="Nyame Flanchard", feet="Nyame Sollerets",
    neck="Loricate Torque +1", waist="Carrier's Sash",
    left_ear="Sanare Earring", right_ear="Odnowa Earring +1",
    left_ring="Gelatinous Ring +1", right_ring="Shadow Ring",
    back="Camulus's Mantle"
  }
  sets.Idle.TP     = set_combine(sets.Idle,{})
  sets.Idle.ACC    = set_combine(sets.Idle,{})
  sets.Idle.DT     = set_combine(sets.Idle,{})
  sets.Idle.SB     = set_combine(sets.Idle,{})
  sets.Idle.PDL    = set_combine(sets.Idle,{})
  sets.Idle.CRIT   = set_combine(sets.Idle,{})
  sets.Idle.MEVA   = set_combine(sets.Idle,{})
  sets.Idle.Resting= set_combine(sets.Idle,{})

  sets.Movement = {
    legs="Carmine Cuisses +1",
    right_ring="Defending Ring",
  }

  sets.Cursna_Received = {
    neck="Nicander's Necklace",
    left_ring={ name="Eshmun's Ring", priority=2},
    right_ring={ name="Eshmun's Ring", priority=1},
    waist="Gishdubar Sash",
  }

  sets.Subtle_Blow = {
    neck="Bathy Choker +1",
    right_ring="Chirich Ring +1",
  }

  -- Dual Wield layer
  sets.DualWield = { waist="Reiki Yotai" }

  -- TP / Offense modes
  sets.OffenseMode = {
    ammo=Ammo.Bullet.RA,
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Adhemar Wristbands +1",
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet="Ikenga's Clogs",
    neck="Iskur Gorget",
    waist="Sailfi Belt +1",
    left_ear="Telos Earring",
    right_ear="Crep. Earring",
    left_ring="Epona's Ring",
    right_ring="Petrov Ring",
    back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-2%',}},
  }
  sets.OffenseMode.TP   = set_combine(sets.OffenseMode,{})
  sets.OffenseMode.DT   = set_combine(sets.OffenseMode,{ legs="Chas. Culottes +3", right_ear="Odnowa Earring +1" })
  sets.OffenseMode.PDL  = set_combine(sets.OffenseMode,{ legs="Malignance Tights" })
  sets.OffenseMode.CRIT = set_combine(sets.OffenseMode,{})
  sets.OffenseMode.ACC  = set_combine(sets.OffenseMode,{})
  sets.OffenseMode.SB   = set_combine(sets.OffenseMode.DT,{})
  sets.OffenseMode.MEVA = set_combine(sets.OffenseMode.DT,{
    head="Malignance Chapeau", body="Malignance Tabard", hands="Malignance Gloves",
    legs="Chas. Culottes +3", feet="Malignance Boots",
    neck="Warder's Charm +1", waist="Carrier's Sash",
    left_ear="Telos Earring", right_ear="Odnowa Earring +1",
    left_ring="Lehko's Ring", right_ring="Defending Ring",
  })

  -- Snapshot / RA Precast
  sets.Precast = {}
  sets.Precast.RA = {
    ammo=Ammo.Bullet.RA,
    head="Chass. Tricorne +3",   -- 0/14
    body="Oshosi Vest +1",       -- 14/0
    hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}}, -- 8/11
    legs={ name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}}, -- 10/13
    feet="Meg. Jam. +2",         -- 10/0
    left_ear={ name="Tuisto Earring", priority=2},
    right_ear={ name="Etiolation Earring", priority=1},
    left_ring="Dingir Ring",
    right_ring="Crepuscular Ring", -- 3/0
    neck={ name="Comm. Charm +2", augments={'Path: A',}}, -- 4/0
    waist="Yemaya Belt",         -- 0/5
    back={ name="Camulus's Mantle", augments={'HP+60','HP+20','"Snapshot"+10',}}, -- 10/0
  } -- ~59/43

  sets.Precast.RA.Flurry = set_combine(sets.Precast.RA, {
    body="Laksa. Frac +3", -- +20 Rapid
  })

  sets.Precast.RA.Flurry_II = set_combine(sets.Precast.RA.Flurry, {
    feet={ name="Pursuer's Gaiters", augments={'Rng.Acc.+10','"Rapid Shot"+10','"Recycle"+15',}}, -- +10 Rapid
  })

  -- Fast Cast (used e.g. for Quick Draw precast)
  sets.Precast.FastCast = {
    head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}}, -- 14
    body={ name="Taeon Tabard", augments={'"Fast Cast"+5','HP+44',}}, -- 9
    hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}}, -- 7
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+7','"Fast Cast"+6',}}, -- 6
    feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}}, -- 8
    neck="Voltsurge Torque", -- 4
    waist="Plat. Mog. Belt",
    left_ear="Loquac. Earring", -- 2
    right_ear="Etiolation Earring", -- 1
    left_ring="Lebeche Ring",
    right_ring="Kishar Ring", -- 4
    back={ name="Camulus's Mantle", augments={'HP+60','HP+20','"Fast Cast"+10',}}, -- 10
  } -- ~65 FC

  -- Midcast RA
  sets.Midcast = set_combine(sets.Idle,{})
  sets.Midcast.RA = {
    ammo=Ammo.Bullet.RA,
    head="Ikenga's Hat", body="Ikenga's Vest", hands="Ikenga's Gloves",
    legs="Chas. Culottes +3", feet="Ikenga's Clogs",
    neck="Iskur Gorget", waist="Yemaya Belt",
    left_ear="Telos Earring", right_ear="Crep. Earring",
    left_ring="Ilabrat Ring", right_ring="Crepuscular Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10','Phys. dmg. taken-10%',}},
  }
  sets.Midcast.RA.ACC  = set_combine(sets.Midcast.RA,{})
  sets.Midcast.RA.PDL  = set_combine(sets.Midcast.RA,{ left_ring="Sroda Ring" })
  sets.Midcast.RA.CRIT = set_combine(sets.Midcast.RA,{
    head={ name="Ikenga's Hat", augments={'Path: A',}},
    feet="Osh. Leggings +1",
    legs="Ikenga's Trousers",
    waist="K. Kachina Belt +1",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    right_ear="Chas. Earring +1",
    back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','Crit.hit rate+10','Damage taken-5%',}},
  })
  sets.Midcast.RA.TripleShot = set_combine(sets.Midcast.RA,{
    head="Oshosi Mask +1",
    body="Chasseur's Frac +3",
    hands="Lanun Gants +3",
    legs="Osh. Trousers +1",
    feet="Osh. Leggings +1",
  })

  sets.Midcast.Utsusemi = set_combine(sets.Idle,{})

  -- Quick Draw
  sets.QuickDraw = {}
  sets.QuickDraw.ACC = {
    ammo=Ammo.Bullet.QD,
    head="Malignance Chapeau", body="Malignance Tabard", hands="Malignance Gloves",
    legs="Malignance Tights", feet="Malignance Boots",
    neck={ name="Comm. Charm +2", augments={'Path: A',}},
    waist="Eschan Stone",
    left_ear="Hermetic Earring", right_ear="Crep. Earring",
    left_ring="Kishar Ring", right_ring="Crepuscular Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10','Phys. dmg. taken-10%',}},
  }
  sets.QuickDraw.DMG = {
    ammo=Ammo.Bullet.QD,
    head="Nyame Helm", body={ name="Lanun Frac +1", augments={'Enhances "Loaded Deck" effect',}},
    hands="Nyame Gauntlets", legs="Nyame Flanchard", feet="Chass. Bottes +3",
    neck={ name="Comm. Charm +2", augments={'Path: A',}}, waist="Orpheus's Sash",
    left_ear="Friomisi Earring", right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Dingir Ring", right_ring="Ilabrat Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%','Damage taken-5%',}},
  }
  sets.QuickDraw.STP = {
    ammo=Ammo.Bullet.QD,
    head="Malignance Chapeau", body="Malignance Tabard", hands="Malignance Gloves",
    legs="Chas. Culottes +3", feet="Malignance Boots",
    neck="Iskur Gorget", waist="Yemaya Belt",
    left_ear="Telos Earring", right_ear="Crep. Earring",
    left_ring="Crepuscular Ring", right_ring="Ilabrat Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10','Phys. dmg. taken-10%',}},
  }
  sets.QuickDraw["Fire Shot"]   = set_combine(sets.QuickDraw.DMG,{})
  sets.QuickDraw["Ice Shot"]    = set_combine(sets.QuickDraw.DMG,{})
  sets.QuickDraw["Wind Shot"]   = set_combine(sets.QuickDraw.DMG,{})
  sets.QuickDraw["Earth Shot"]  = set_combine(sets.QuickDraw.DMG,{})
  sets.QuickDraw["Thunder Shot"]= set_combine(sets.QuickDraw.DMG,{})
  sets.QuickDraw["Water Shot"]  = set_combine(sets.QuickDraw.DMG,{})
  sets.QuickDraw["Light Shot"]  = set_combine(sets.QuickDraw.DMG,{})
  sets.QuickDraw["Dark Shot"]   = set_combine(sets.QuickDraw.DMG,{ head="Pixie Hairpin +1", right_ring="Archon Ring" })

  -- Job Abilities
  sets.JA = {}
  sets.JA["Wild Card"]    = { feet={ name="Lanun Bottes +1", augments={'Enhances "Wild Card" effect',}}, }
  sets.JA["Phantom Roll"] = {}
  sets.JA["Random Deal"]  = { body={ name="Lanun Frac +1", augments={'Enhances "Loaded Deck" effect',}}, }
  sets.JA["Snake Eye"]    = { legs={ name="Lanun Trews +3", augments={'Enhances "Snake Eye" effect',}}, }
  sets.JA["Fold"]         = {}  -- Use hands in special case below
  sets.JA["Triple Shot"]  = {}  -- Midshot handled by sets.Midcast.RA.TripleShot
  sets.JA["Cutting Cards"]= {}
  sets.JA["Crooked Cards"]= {}
  sets.JA["Double-Up"]    = { right_ring="Luzaf's Ring" } -- 16y range

  sets.Waltz = set_combine(sets.OffenseMode.DT,{
    ammo="Yamarang",
    hands="Slither Gloves +1",
    legs="Dashing Subligar",
  })

  sets.Fold = { hands={ name="Lanun Gants +3", augments={'Enhances "Fold" effect',}}, }

  -- Phantom Roll (forces Rostam Path C)
  sets.PhantomRoll = {
    main="Rostam",
    sub="Nusku Shield",
    range="Compensator",
    head={ name="Lanun Tricorne +1", augments={'Enhances "Winning Streak" effect',}},
    hands="Chasseur's Gants +3",
    neck="Regal Necklace",
    right_ring="Luzaf's Ring",
    back={ name="Camulus's Mantle", augments={'HP+60','HP+20','"Snapshot"+10',}},
  }
  sets.PhantomRoll["Fighter's Roll"]  = sets.PhantomRoll
  sets.PhantomRoll["Monk's Roll"]     = sets.PhantomRoll
  sets.PhantomRoll["Healer's Roll"]   = sets.PhantomRoll
  sets.PhantomRoll["Wizard's Roll"]   = sets.PhantomRoll
  sets.PhantomRoll["Warlock's Roll"]  = sets.PhantomRoll
  sets.PhantomRoll["Rogue's Roll"]    = sets.PhantomRoll
  sets.PhantomRoll["Gallant's Roll"]  = sets.PhantomRoll
  sets.PhantomRoll["Chaos Roll"]      = sets.PhantomRoll
  sets.PhantomRoll["Beast Roll"]      = sets.PhantomRoll
  sets.PhantomRoll["Choral Roll"]     = sets.PhantomRoll
  sets.PhantomRoll["Hunter's Roll"]   = sets.PhantomRoll
  sets.PhantomRoll["Samurai Roll"]    = sets.PhantomRoll
  sets.PhantomRoll["Ninja Roll"]      = sets.PhantomRoll
  sets.PhantomRoll["Drachen Roll"]    = sets.PhantomRoll
  sets.PhantomRoll["Evoker's Roll"]   = sets.PhantomRoll
  sets.PhantomRoll["Magus's Roll"]    = sets.PhantomRoll
  sets.PhantomRoll["Corsair's Roll"]  = sets.PhantomRoll
  sets.PhantomRoll["Puppet Roll"]     = sets.PhantomRoll
  sets.PhantomRoll["Dancer's Roll"]   = sets.PhantomRoll
  sets.PhantomRoll["Scholar's Roll"]  = sets.PhantomRoll
  sets.PhantomRoll["Bolter's Roll"]   = sets.PhantomRoll
  sets.PhantomRoll["Caster's Roll"]   = set_combine(sets.PhantomRoll,{ legs="Chas. Culottes +3" })
  sets.PhantomRoll["Tactician's Roll"]= set_combine(sets.PhantomRoll,{ body="Chasseur's Frac +3" })
  sets.PhantomRoll["Allies' Roll"]    = set_combine(sets.PhantomRoll,{ hands="Chasseur's Gants +3" })
  sets.PhantomRoll["Miser's Roll"]    = sets.PhantomRoll
  sets.PhantomRoll["Companion's Roll"]= sets.PhantomRoll
  sets.PhantomRoll["Avenger's Roll"]  = sets.PhantomRoll
  sets.PhantomRoll["Naturalist's Roll"]=sets.PhantomRoll
  sets.PhantomRoll["Courser's Roll"]  = set_combine(sets.PhantomRoll,{ feet="Chass. Bottes +3" })
  sets.PhantomRoll["Blitzer's Roll"]  = set_combine(sets.PhantomRoll,{ head="Chass. Tricorne +3" })

  -- WS base
  sets.WS = {
    ammo=Ammo.Bullet.WS,
    head="Nyame Helm", body="Nyame Mail", hands="Chasseur's Gants +3",
    legs="Nyame Flanchard", feet="Nyame Sollerets",
    neck={ name="Comm. Charm +2", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring="Regal Ring", right_ring="Epaminondas's Ring",
    back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}},
  }
  sets.WS.CRIT = set_combine(sets.WS,{})
  sets.WS.ACC  = set_combine(sets.WS,{})
  sets.WS.PDL  = set_combine(sets.WS,{ left_ring="Sroda Ring" })
  sets.WS.SB   = sets.Subtle_Blow
  sets.WS.MAB  = set_combine(sets.WS,{
    ammo=Ammo.Bullet.MAB,
    feet={ name="Lanun Bottes +1", augments={'Enhances "Wild Card" effect',}},
    waist="Eschan Stone",
    left_ear="Friomisi Earring",
    right_ear="Crematio Earring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%','Damage taken-5%',}},
  })
  sets.WS.MEVA = set_combine(sets.WS,{ neck="Warder's Charm +1", waist="Carrier's Sash" })

  -- Ranged WS base
  sets.WS.RA = {
    head="Nyame Helm", body="Nyame Mail", hands="Nyame Gauntlets",
    legs="Nyame Flanchard", feet="Lanun Bottes +1",
    neck="Fotia Gorget", waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Friomisi Earring",
    left_ring="Regal Ring", right_ring="Epaminondas's Ring",
    back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Damage taken-5%',}},
  }
  sets.WS.RA.ACC  = set_combine(sets.WS.RA,{})
  sets.WS.RA.PDL  = set_combine(sets.WS.RA,{ left_ring="Sroda Ring", head="Ikenga's Hat", legs="Ikenga's Trousers", feet="Ikenga's Clogs" })
  sets.WS.RA.CRIT = set_combine(sets.WS.RA,{})

  sets.WS['Aeolian Edge']  = set_combine(sets.WS.MAB,{ right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}}, })
  sets.WS['Savage Blade']  = set_combine(sets.WS,{ left_ring="Sroda Ring" })
  sets.WS['Leaden Salute'] = set_combine(sets.WS.MAB,{
    head="Pixie Hairpin +1",
    right_ring="Archon Ring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    waist="Svelt. Gouriz +1",
  })

  sets.WS['Hot Shot']   = set_combine(sets.WS, sets.WS.RA, {})
  sets.WS['Split Shot'] = set_combine(sets.WS, sets.WS.RA, {})
  sets.WS['Sniper Shot']= set_combine(sets.WS, sets.WS.RA, {})
  sets.WS['Numbing Shot']=set_combine(sets.WS, sets.WS.RA, {})
  sets.WS['Slug Shot']  = set_combine(sets.WS, sets.WS.RA, {})
  sets.WS['Last Stand'] = set_combine(sets.WS, sets.WS.RA, {})
  sets.WS['Wildfire']   = set_combine(sets.WS.MAB, {})
end

----------------------------------------------------------------------------------------------------
-- Helpers
----------------------------------------------------------------------------------------------------
local function get_flurry_tier()
  -- Simple check: if both present, prefer II
  if buffactive['Flurry II'] then return 2 end
  if buffactive['Flurry'] then return 1 end
  -- Some setups apply "Flurry" only; adapt to your include if names differ
  return 0
end

----------------------------------------------------------------------------------------------------
-- Hooks
----------------------------------------------------------------------------------------------------
function pretarget_custom(spell,action)
end

function precast_custom(spell)
  local equipSet = {}

  -- Force Rostam C set for all rolls & Double-Up
  if (spell.type == 'CorsairRoll') or (spell.english == 'Double-Up') then
    equipSet = set_combine(equipSet, sets.PhantomRoll)
    return equipSet
  end

  -- Ranged Attack snapshot with Flurry handling
  if spell.action_type == 'Ranged Attack' then
    local tier = get_flurry_tier()
    if tier == 2 then
      equipSet = set_combine(equipSet, sets.Precast.RA.Flurry_II)
    elseif tier == 1 then
      equipSet = set_combine(equipSet, sets.Precast.RA.Flurry)
    else
      equipSet = set_combine(equipSet, sets.Precast.RA)
    end
    return equipSet
  end

  -- Quick Draw: use Fast Cast on precast (damage/acc on midcast)
  if spell.type == 'CorsairShot' then
    equipSet = set_combine(equipSet, sets.Precast.FastCast)
    return equipSet
  end

  -- JA specifics
  if spell.english == 'Fold' and buffactive['Bust'] == 2 then
    equipSet = set_combine(equipSet, sets.Fold)
    return equipSet
  end
  if sets.JA[spell.english] then
    equipSet = set_combine(equipSet, sets.JA[spell.english])
    return equipSet
  end

  return Job_Mode_Check(equipSet)
end

function midcast_custom(spell)
  local equipSet = {}

  -- Midshot
  if spell.action_type == 'Ranged Attack' then
    if buffactive['Triple Shot'] then
      equipSet = set_combine(equipSet, sets.Midcast.RA.TripleShot)
    else
      equipSet = set_combine(equipSet, sets.Midcast.RA)
    end
    return Job_Mode_Check(equipSet)
  end

  -- Quick Draw (elemental shots)
  if spell.type == 'CorsairShot' then
    local qd = sets.QuickDraw[spell.english] or sets.QuickDraw.DMG
    equipSet = set_combine(equipSet, qd)
    return Job_Mode_Check(equipSet)
  end

  -- Fold safety in midcast (rare race condition)
  if spell.english == 'Fold' and buffactive['Bust'] == 2 then
    equipSet = set_combine(equipSet, sets.Fold)
  end

  return Job_Mode_Check(equipSet)
end

function aftercast_custom(spell)
  return Job_Mode_Check({})
end

function buff_change_custom(name,gain)
  return Job_Mode_Check({})
end

function choose_set_custom()
  return Job_Mode_Check({})
end

function status_change_custom(new,old)
  return Job_Mode_Check({})
end

----------------------------------------------------------------------------------------------------
-- Utility
----------------------------------------------------------------------------------------------------
function Job_Mode_Check(equipSet)
  if state.JobMode.value == 'Melee' then
    equipSet = set_combine(equipSet, sets.Weapons.Melee)
  elseif state.JobMode.value == 'Ranged' then
    equipSet = set_combine(equipSet, sets.Weapons.Ranged)
  end
  if DualWield == false and TwoHand == false then
    equipSet = set_combine(equipSet, sets.Weapons.Shield)
  end
  return equipSet
end

function check_buff_JA()
  local buff = 'None'
  local ja_recasts = windower.ffxi.get_ability_recasts()
  if player.sub_job == 'WAR' then
    if not buffactive['Berserk']   and ja_recasts[1] == 0 then buff = "Berserk"
    elseif not buffactive['Aggressor'] and ja_recasts[4] == 0 then buff = "Aggressor"
    elseif not buffactive['Warcry']    and ja_recasts[2] == 0 then buff = "Warcry" end
  end
  return buff
end

function check_buff_SP()
  return 'None'
end

function pet_change_custom(pet,gain) return {} end
function pet_aftercast_custom(spell) return {} end
function pet_midcast_custom(spell)  return {} end
