-- data/gear.lua

function init_gear() sets.precast = {} sets.ws = {} sets.tp = {} sets.tp_acc = {} sets.idle = {} sets.movement = {} sets.ranged = {} sets.TH = {} sets.buff = {}

-- Fast Cast
sets.precast.FC = {
    head="Herculean Helm", neck="Baetyl Pendant", ear1="Loquac. Earring", ear2="Etiolation Earring",
    body="Adhemar Jacket +1", hands="Leyline Gloves", ring1="Kishar Ring", ring2="Rahab Ring",
    back="Moonlight Cape", waist="Audumbla Sash", legs="Rawhide Trousers", feet="Malignance Boots"
}

-- WS: Rudra's Storm (DEX/AGI mod, high FTP, critical)
sets.ws["Rudra's Storm"] = {
    ammo="Aurgelmir Orb +1",
    head="Skulker's Bonnet +3", neck="Assassin's Gorget +2", ear1="Odr Earring", ear2="Moonshade Earring",
    body="Skulker's Vest +3", hands="Skulker's Armlets +3", ring1="Epaminondas's Ring", ring2="Regal Ring",
    back="Toutatis's Cape", waist="Sailfi Belt +1", legs="Skulker's Culottes +3", feet="Skulker's Poulaines +3"
}

-- WS: Savage Blade (STR/Attack heavy)
sets.ws["Savage Blade"] = {
    ammo="Aurgelmir Orb +1",
    head="Nyame Helm", neck="Rep. Plat. Medal", ear1="Ishvara Earring", ear2="Moonshade Earring",
    body="Nyame Mail", hands="Nyame Gauntlets", ring1="Epaminondas's Ring", ring2="Regal Ring",
    back="Toutatis's Cape", waist="Sailfi Belt +1", legs="Nyame Flanchard", feet="Nyame Sollerets"
}

-- WS: Aeolian Edge (INT/AOE/MAB)
sets.ws["Aeolian Edge"] = {
    ammo="Pemphredo Tathlum",
    head="Nyame Helm", neck="Sibyl Scarf", ear1="Friomisi Earring", ear2="Crematio Earring",
    body="Nyame Mail", hands="Nyame Gauntlets", ring1="Epaminondas's Ring", ring2="Dingir Ring",
    back="Argocham. Mantle", waist="Orpheus's Sash", legs="Nyame Flanchard", feet="Nyame Sollerets"
}

sets.ws["Last Stand"] = sets.ws["Savage Blade"]

-- TP sets (assume capped DW with /DNC and full Haste)
sets.tp.Low = {
    ammo="Coiste Bodhar",
    head="Skulker's Bonnet +3", neck="Assassin's Gorget +2", ear1="Sherida Earring", ear2="Skulker's Earring +2",
    body="Skulker's Vest +3", hands="Skulker's Armlets +3", ring1="Gere Ring", ring2="Epona's Ring",
    back="Toutatis's Cape", waist="Reiki Yotai", legs="Skulker's Culottes +3", feet="Skulker's Poulaines +3"
}

sets.tp.Mid = set_combine(sets.tp.Low, {
    head="Malignance Chapeau", body="Malignance Tabard", hands="Malignance Gloves"
})

sets.tp.High = set_combine(sets.tp.Mid, {
    legs="Malignance Tights", feet="Malignance Boots"
})

-- TP Accuracy Sets
sets.tp_acc.Low = set_combine(sets.tp.High, {
    neck="Combatant's Torque", ring2="Chirich Ring +1"
})

sets.tp_acc.Mid = set_combine(sets.tp_acc.Low, {ear2="Telos Earring"})
sets.tp_acc.High = set_combine(sets.tp_acc.Mid, {ring1="Regal Ring"})

-- Idle
sets.idle = {
    ammo="Staunch Tathlum +1",
    head="Nyame Helm", neck="Warder's Charm +1", ear1="Eabani Earring", ear2="Infused Earring",
    body="Malignance Tabard", hands="Malignance Gloves", ring1="Stikini Ring +1", ring2="Defending Ring",
    back="Moonlight Cape", waist="Carrier's Sash", legs="Nyame Flanchard", feet="Nyame Sollerets"
}

sets.movement = {feet="Jute Boots +1"}

-- Ranged
sets.ranged.default = {
    ammo="Chrono Bullet",
    head="Ikenga's Hat", neck="Iskur Gorget", ear1="Telos Earring", ear2="Crep. Earring",
    body="Ikenga's Vest", hands="Ikenga's Gloves", ring1="Dingir Ring", ring2="Regal Ring",
    back="Toutatis's Cape", waist="Yemaya Belt", legs="Ikenga's Trousers", feet="Ikenga's Clogs"
}

sets.ranged.acc = set_combine(sets.ranged.default, {
    ring1="Cacoethic Ring +1", head="Meghanada Visor +2"
})

-- Treasure Hunter
sets.TH = {
    head="Wh. Rarab Cap +1", hands="Plunderer's Armlets +3", waist="Chaac Belt", feet="Skulker's Poulaines +3"
}

-- Buff Conditions
sets.buff.Doom = {
    ring1="Purity Ring", ring2="Saida Ring +1", waist="Gishdubar Sash"
}

sets.buff.Silence = {
    ear1="Sanare Earring"
}

sets.trust_tank = {
    body="Malignance Tabard", ring2="Defending Ring"
}

sets.trust_support = {
    back="Mecisto. Mantle", neck="Sanctity Necklace"
}

sets.odyssey_boss = {
    neck="Warder's Charm +1", ring1="Purity Ring", body="Malignance Tabard"
}

end
