-- gear_cor.lua

function init_gear()
    sets.precast = {}
    sets.ws = {}
    sets.tp = {}
    sets.tp.ranged = {}
    sets.tp.melee = {}
    sets.rolls = {}
    sets.qd = {}
    sets.idle = {}
    sets.movement = {}
    sets.buff = {}

    sets.precast.FC = {
        head="Carmine Mask +1", neck="Baetyl Pendant", ear1="Loquac. Earring", ear2="Etiolation Earring",
        body="Adhemar Jacket +1", hands="Leyline Gloves", ring1="Kishar Ring", ring2="Rahab Ring",
        back="Camulus's Mantle", waist="Witful Belt", legs="Rawhide Trousers", feet="Carmine Greaves +1"
    }

    sets.ws["Last Stand"] = {
        ammo="Chrono Bullet",
        head="Ikenga's Hat", neck="Fotia Gorget", ear1="Ishvara Earring", ear2="Moonshade Earring",
        body="Ikenga's Vest", hands="Ikenga's Gloves", ring1="Epaminondas's Ring", ring2="Regal Ring",
        back="Camulus's Mantle", waist="Fotia Belt", legs="Ikenga's Trousers", feet="Lanun Bottes +3"
    }

    sets.ws["Savage Blade"] = {
        ammo="Aurgelmir Orb +1",
        head="Nyame Helm", neck="Rep. Plat. Medal", ear1="Ishvara Earring", ear2="Moonshade Earring",
        body="Nyame Mail", hands="Nyame Gauntlets", ring1="Epaminondas's Ring", ring2="Regal Ring",
        back="Camulus's Mantle", waist="Sailfi Belt +1", legs="Nyame Flanchard", feet="Lanun Bottes +3"
    }

    sets.ws["Leaden Salute"] = {
        ammo="Living Bullet",
        head="Pixie Hairpin +1", neck="Baetyl Pendant", ear1="Friomisi Earring", ear2="Moonshade Earring",
        body="Lanun Frac +3", hands="Carmine Fin. Ga. +1", ring1="Archon Ring", ring2="Dingir Ring",
        back="Camulus's Mantle", waist="Orpheus's Sash", legs="Nyame Flanchard", feet="Lanun Bottes +3"
    }

    sets.ws["Wildfire"] = {
        ammo="Living Bullet",
        head="Nyame Helm", neck="Baetyl Pendant", ear1="Friomisi Earring", ear2="Moonshade Earring",
        body="Nyame Mail", hands="Nyame Gauntlets", ring1="Epaminondas's Ring", ring2="Dingir Ring",
        back="Camulus's Mantle", waist="Orpheus's Sash", legs="Nyame Flanchard", feet="Lanun Bottes +3"
    }

    sets.tp.ranged.default = {
        ammo="Chrono Bullet",
        head="Malignance Chapeau", neck="Iskur Gorget", ear1="Telos Earring", ear2="Crep. Earring",
        body="Malignance Tabard", hands="Malignance Gloves", ring1="Dingir Ring", ring2="Cacoethic Ring +1",
        back="Camulus's Mantle", waist="Yemaya Belt", legs="Malignance Tights", feet="Malignance Boots"
    }

    sets.tp.melee.default = {
        ammo="Aurgelmir Orb +1",
        head="Adhemar Bonnet +1", neck="Anu Torque", ear1="Sherida Earring", ear2="Telos Earring",
        body="Malignance Tabard", hands="Adhemar Wrist. +1", ring1="Gere Ring", ring2="Epona's Ring",
        back="Camulus's Mantle", waist="Reiki Yotai", legs="Samnuha Tights", feet="Malignance Boots"
    }

    sets.rolls = {
        head="Lanun Tricorne +3", hands="Chasseur's Gants +3", back="Camulus's Mantle"
    }

    sets.qd.default = {
        ammo="Living Bullet",
        head="Nyame Helm", neck="Baetyl Pendant", ear1="Friomisi Earring", ear2="Crematio Earring",
        body="Lanun Frac +3", hands="Carmine Fin. Ga. +1", ring1="Dingir Ring", ring2="Regal Ring",
        back="Camulus's Mantle", waist="Orpheus's Sash", legs="Nyame Flanchard", feet="Lanun Bottes +3"
    }

    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Nyame Helm", neck="Loricate Torque +1", ear1="Eabani Earring", ear2="Etiolation Earring",
        body="Malignance Tabard", hands="Malignance Gloves", ring1="Defending Ring", ring2="Stikini Ring +1",
        back="Moonlight Cape", waist="Carrier's Sash", legs="Nyame Flanchard", feet="Nyame Sollerets"
    }

    sets.movement = {feet="Hermes' Sandals"}

    sets.buff.Doom = {
        ring1="Purity Ring", ring2="Saida Ring +1", waist="Gishdubar Sash"
    }
end
