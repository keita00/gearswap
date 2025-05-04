-- data/gear.lua

function init_gear()
    sets.precast = {}
    sets.ws = {}
    sets.tp = {}
    sets.tp_acc = {}
    sets.idle = {}
    sets.movement = {}
    sets.ranged = {}
    sets.TH = {}
    sets.buff = {}

    sets.precast.FC = {
        head="Herculean Helm", neck="Baetyl Pendant", ear1="Loquac. Earring", ear2="Etiolation Earring",
        body="Adhemar Jacket +1", hands="Leyline Gloves", ring1="Kishar Ring", ring2="Rahab Ring",
        back="Moonlight Cape", waist="Audumbla Sash", legs="Rawhide Trousers", feet="Malignance Boots"
    }

    sets.ws["Rudra's Storm"] = {
        ammo="Crepuscular Pebble",
        head="Skulker's Bonnet +3", neck="Assassin's Gorget +2", ear1="Odr Earring", ear2="Moonshade Earring",
        body="Skulker's Vest +3", hands="Skulker's Armlets +3", ring1="Epaminondas's Ring", ring2="Regal Ring",
        back="Toutatis's Cape", waist="Kentarch Belt +1", legs="Skulker's Culottes +3", feet="Skulker's Poulaines +3"
    }

    sets.ws["Savage Blade"] = {
        ammo="Crepuscular Pebble",
        head="Nyame Helm", neck="Rep. Plat. Medal", ear1="Ishvara Earring", ear2="Moonshade Earring",
        body="Nyame Mail", hands="Nyame Gauntlets", ring1="Epaminondas's Ring", ring2="Regal Ring",
        back="Toutatis's Cape", waist="Sailfi Belt +1", legs="Nyame Flanchard", feet="Nyame Sollerets"
    }

    sets.ws["Aeolian Edge"] = {
        ammo="Seething Bomblet +1",
        head="Nyame Helm", neck="Baetyl Pendant", ear1="Friomisi Earring", ear2="Crematio Earring",
        body="Nyame Mail", hands="Nyame Gauntlets", ring1="Epaminondas's Ring", ring2="Dingir Ring",
        back="Toutatis's Cape", waist="Orpheus's Sash", legs="Nyame Flanchard", feet="Nyame Sollerets"
    }

    sets.ws["Last Stand"] = sets.ws["Savage Blade"]

    sets.tp.Low = {
        ammo="Coiste Bodhar",
        head="Skulker's Bonnet +3", neck="Assassin's Gorget +2", ear1="Sherida Earring", ear2="Telos Earring",
        body="Skulker's Vest +3", hands="Skulker's Armlets +3", ring1="Gere Ring", ring2="Epona's Ring",
        back="Toutatis's Cape", waist="Reiki Yotai", legs="Skulker's Culottes +3", feet="Skulker's Poulaines +3"
    }

    sets.tp.Mid = set_combine(sets.tp.Low, {waist="Windbuffet Belt +1"})
    sets.tp.High = set_combine(sets.tp.Mid, {ear2="Skulker's Earring +2"})

    sets.tp_acc.Low = set_combine(sets.tp.Low, {
        head="Malignance Chapeau", hands="Malignance Gloves", legs="Malignance Tights", feet="Malignance Boots"
    })

    sets.tp_acc.Mid = set_combine(sets.tp_acc.Low, {ear2="Telos Earring"})
    sets.tp_acc.High = set_combine(sets.tp_acc.Mid, {ring2="Regal Ring"})

    sets.idle = {
        ammo="Staunch Tathlum +1",
        head="Nyame Helm", neck="Warder's Charm +1", ear1="Infused Earring", ear2="Etiolation Earring",
        body="Malignance Tabard", hands="Malignance Gloves", ring1="Stikini Ring +1", ring2="Defending Ring",
        back="Moonlight Cape", waist="Carrier's Sash", legs="Nyame Flanchard", feet="Nyame Sollerets"
    }

    sets.movement = {feet="Jute Boots +1"}

    sets.ranged.default = {
        ammo="Chrono Bullet",
        head="Malignance Chapeau", body="Meghanada Cuirie +2", hands="Malignance Gloves",
        legs="Malignance Tights", feet="Malignance Boots", neck="Iskur Gorget", ear1="Telos Earring", ear2="Crep. Earring",
        ring1="Dingir Ring", ring2="Regal Ring", waist="Yemaya Belt", back="Toutatis's Cape"
    }

    sets.ranged.acc = set_combine(sets.ranged.default, {
        head="Ikenga's Hat", body="Ikenga's Vest", ring1="Cacoethic Ring +1"
    })

    sets.TH = {
        head="Wh. Rarab Cap +1", hands="Plunderer's Armlets +3", waist="Chaac Belt", feet="Skulker's Poulaines +3"
    }

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
