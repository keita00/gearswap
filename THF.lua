-- THF.lua with HUD, Accuracy Toggle, TH Toggle, Buff Warnings, Capacity Ring Alert, Day/Weather WS Checks

texts = require('texts')

th_hud = texts.new('TH: OFF', {
    pos = {x=1100, y=30},
    bg = {alpha=0},
    fg = {alpha=255},
    text = {size=12}
})

TH_mode = true
Acc_Index = 1
Acc_Array = {"Default", "Acc", "AccMid", "AccHigh"}

function update_hud()
    if not th_hud then return end

    local hud_text = ''

    if TH_mode then
        hud_text = hud_text .. 'TH: ON'
    else
        hud_text = hud_text .. 'TH: OFF'
    end

    hud_text = hud_text .. ' | ACC: ' .. (Acc_Array and Acc_Array[Acc_Index] or 'N/A')

    if player and player.sub_job then
        hud_text = hud_text .. ' | SJ: ' .. player.sub_job
    end

    local trust_list = {'Kupipi','Joachim','Ayame','Qultada','Amchuchu','AAEV'}
    local active_trusts = {}
    for _, name in ipairs(trust_list) do
        if pet and pet.name == name then
            table.insert(active_trusts, name)
        elseif windower.ffxi.get_mob_by_name(name) then
            table.insert(active_trusts, name)
        end
    end
if #active_trusts > 0 then
        hud_text = hud_text .. ' | Trusts: ' .. table.concat(active_trusts, ', ')
    end

    th_hud:text(hud_text)
    th_hud:show()
end

function self_command(command)
    if command == 'toggleAcc' then
        Acc_Index = Acc_Index + 1
        if Acc_Index > #Acc_Array then Acc_Index = 1 end
        add_to_chat(122, 'Accuracy mode: ' .. Acc_Array[Acc_Index])
        update_hud()
    end
    if command == 'toggleTH' then
        TH_mode = not TH_mode
        if TH_mode then
            add_to_chat(122, 'Treasure Hunter: ENABLED')
        else
            add_to_chat(123, 'Treasure Hunter: DISABLED')
        end
        update_hud()
    end
end

function get_sets()
    update_hud()
    sets = {}

    Shijo_WS = { name="Shijo", augments={'Path: C'} }
    Shijo_TP = { name="Shijo", augments={'Path: D'} }
    Tauret = "Tauret"

    Toutatis_WSD = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%'} }
    Toutatis_STP = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Store TP+10','Damage taken-5%'} }
    Toutatis_Crit = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Critical hit rate +10%','Phys. dmg. taken-10%'} }
    Toutatis_AGI  = { name="Toutatis's Cape", augments={'AGI+20','Evasion+25','Store TP+10','Eva.+20/Magic Eva.+20'} }
    Toutatis_INT  = { name="Toutatis's Cape", augments={'INT+30','Mag. Acc+20 /Mag. Dmg.+20','Weapon skill damage +10%','Phys. dmg. taken-10%'} }

    sets.engaged = {
        head="Adhemar Bonnet +1", body="Pillager's Vest +3", hands="Adhemar Wrist. +1",
        legs="Pill. Culottes +3", feet="Adhe. Gamashes +1", neck="Asn. Gorget +2",
        ear1="Cessance Earring", ear2="Suppanomimi", ring1="Epona's Ring", ring2="Chirich Ring +1",
        waist="Reiki Yotai", back=Toutatis_STP
    }
    sets.engaged.Acc = set_combine(sets.engaged, {
        head="Mummu Bonnet +2", hands="Mummu Wrists +2", legs="Mummu Kecks +1", feet="Mummu Gamash. +2", ring2="Regal Ring"
    })
    sets.engaged.AccMid = set_combine(sets.engaged.Acc, {
        neck="Asn. Gorget +2", ear2="Telos Earring"
    })
    sets.engaged.AccHigh = set_combine(sets.engaged.AccMid, {
        ring1="Chirich Ring +1", waist="Kentarch Belt +1"
    })
	-- Subjob-specific accuracy overrides
	sets.engaged.DNC = set_combine(sets.engaged, {
		hands="Adhemar Wrist. +1", waist="Reiki Yotai"
	})
	sets.engaged.DNC.Acc = set_combine(sets.engaged.Acc, {
		hands="Mummu Wrists +2"
	})
	sets.engaged.DNC.AccMid = set_combine(sets.engaged.AccMid, {
		waist="Reiki Yotai"
	})
	sets.engaged.WAR = set_combine(sets.engaged, {
		ear1="Sherida Earring", waist="Sailfi Belt +1"
	})
	sets.engaged.DRG = set_combine(sets.engaged, {
		legs="Pill. Culottes +3"
	})
    sets.idle = {
        head="Turms Cap +1", body="Tu. Harness +1", hands="Turms Mittens +1",
        legs="Turms Subligar +1", feet="Turms Leggings +1", neck="Asn. Gorget +2",
        ring1="Defending Ring", ring2="Moonlight Ring", ear1="Suppanomimi",
        waist="Reiki Yotai", back=Toutatis_STP
    }
    sets.JA = {
        ["Sneak Attack"] = { hands="Plun. Armlets +3" },
        ["Trick Attack"] = { hands="Plun. Armlets +3" },
        ["Feint"] = { legs="Plun. Culottes +3" },
        ["Bully"] = {}, ["Mug"] = {}, ["Accomplice"] = {}, ["Collaborator"] = {}
    }
    sets.TH = {
        head="Wh. Rarab Cap +1",
        hands="Plun. Armlets +3",
        waist="Chaac Belt",
        feet="Skulker's Poulaines +3"
    }
    sets.ws = {
        ["Aeolian Edge"] = {
            head="Mummu Bonnet +2", body="Pillager's Vest +3", hands="Pill. Armlets +1",
            legs="Pill. Culottes +3", feet="Plun. Pulaines +1", neck="Asn. Gorget +2",
            ear1="Odr Earring", ear2="Moonshade Earring", ring1="Epona's Ring", ring2="Epaminondas's Ring",
            waist="Orpheus's Sash", back=Toutatis_INT
        },
        ["Evisceration"] = {
            head="Mummu Bonnet +2", hands="Mummu Wrists +2", legs="Mummu Kecks +1",
            body="Pillager's Vest +3", feet="Plun. Pulaines +1", neck="Asn. Gorget +2",
            ear1="Odr Earring", ear2="Moonshade Earring", ring1="Epona's Ring", ring2="Epaminondas's Ring",
            waist="Reiki Yotai", back=Toutatis_Crit
        },
        ["Exenterator"] = {
            head="Adhemar Bonnet +1", body="Pillager's Vest +3", hands="Adhemar Wrist. +1",
            legs="Pill. Culottes +3", feet="Adhe. Gamashes +1", neck="Asn. Gorget +2",
            ear1="Cessance Earring", ear2="Suppanomimi", ring1="Epona's Ring", ring2="Chirich Ring +1",
            waist="Reiki Yotai", back=Toutatis_AGI
        },
        ["Savage Blade"] = {
        head="Pill. Bonnet +3",
        body="Pillager's Vest +3",
        hands="Plun. Armlets +3",
        legs="Pill. Culottes +3",
        feet="Plun. Pulaines +1",
        neck="Asn. Gorget +2",
        ear1="Ishvara Earring", ear2="Moonshade Earring",
        ring1="Epaminondas's Ring", ring2="Regal Ring",
        waist="Sailfi Belt +1",
        back=Toutatis_WSD
        },
		["Mandalic Stab"] = {
			head="Pill. Bonnet +3",
			body="Pillager's Vest +3",
			hands="Plun. Armlets +3",
			legs="Pill. Culottes +3",
			feet="Plun. Pulaines +1",
			neck="Asn. Gorget +2",
			ear1="Odr Earring", ear2="Moonshade Earring",
			ring1="Regal Ring", ring2="Epaminondas's Ring",
			waist="Reiki Yotai",
			back=Toutatis_WSD
		},
		["Dancing Edge"] = {
			head="Adhemar Bonnet +1",
			body="Pillager's Vest +3",
			hands="Adhemar Wrist. +1",
			legs="Pill. Culottes +3",
			feet="Adhe. Gamashes +1",
			neck="Asn. Gorget +2",
			ear1="Cessance Earring", ear2="Moonshade Earring",
			ring1="Epona's Ring", ring2="Chirich Ring +1",
			waist="Reiki Yotai",
			back=Toutatis_STP
		},
		["Mercy Stroke"] = {
			head="Pill. Bonnet +3",
			body="Pillager's Vest +3",
			hands="Plun. Armlets +3",
			legs="Pill. Culottes +3",
			feet="Plun. Pulaines +1",
			neck="Asn. Gorget +2",
			ear1="Ishvara Earring", ear2="Moonshade Earring",
			ring1="Regal Ring", ring2="Epaminondas's Ring",
			waist="Sailfi Belt +1",
			back=Toutatis_WSD
		},
        -- Default fallback WS set
        ["Default"] = {
        head="Adhemar Bonnet +1",
        body="Pillager's Vest +3",
        hands="Adhemar Wrist. +1",
        legs="Pill. Culottes +3",
        feet="Adhe. Gamashes +1",
        neck="Asn. Gorget +2",
        ear1="Odr Earring", ear2="Moonshade Earring",
        ring1="Epona's Ring", ring2="Chirich Ring +1",
        waist="Reiki Yotai",
        back=Toutatis_STP
        }
    }
	-- Savage Blade Subjob Variants
	sets.ws["Savage Blade"].WAR = set_combine(sets.ws["Savage Blade"], {
		waist="Sailfi Belt +1", ear1="Sherida Earring"
	})
	sets.ws["Savage Blade"].DNC = set_combine(sets.ws["Savage Blade"], {
		hands="Adhemar Wrist. +1"
	})
	sets.ws["Savage Blade"].DRG = set_combine(sets.ws["Savage Blade"], {
		legs="Pill. Culottes +3", ring2="Chirich Ring +1"
	})
	-- Evisceration Subjob Variants
	sets.ws["Evisceration"].DNC = set_combine(sets.ws["Evisceration"], {
		hands="Mummu Wrists +2", waist="Reiki Yotai"
	})
	sets.ws["Evisceration"].WAR = set_combine(sets.ws["Evisceration"], {
		ear1="Sherida Earring", waist="Sailfi Belt +1"
	})

	-- Aeolian Edge Subjob Variant
	sets.ws["Aeolian Edge"].DNC = set_combine(sets.ws["Aeolian Edge"], {
		ring2="Regal Ring"
	})
end

function precast(spell)
    if sets.JA[spell.english] then
        equip(sets.JA[spell.english])

        -- Add TH gear for relevant abilities
        if TH_mode and (spell.english == "Provoke" or spell.english == "Mug" or spell.english == "Feint") then
            equip(sets.TH)
            add_to_chat(122, 'Treasure Hunter gear equipped.')
        end

    elseif spell.type == 'WeaponSkill' then
        -- Weapon logic by WS
        if spell.english == "Aeolian Edge" then
            equip({main=Shijo_WS, sub="Gleti's Knife"})
        elseif spell.english == "Evisceration" then
            equip({main=Tauret, sub="Gleti's Knife"})
        elseif spell.english == "Exenterator" then
            equip({main=Shijo_WS, sub="Gleti's Knife"})
        elseif spell.english == "Savage Blade" then
            equip({main=Shijo_WS, sub="Gleti's Knife"})
        elseif spell.english == "Mandalic Stab" then
            equip({main=Tauret, sub="Gleti's Knife"})
        elseif spell.english == "Dancing Edge" then
            equip({main=Tauret, sub="Gleti's Knife"})
        elseif spell.english == "Mercy Stroke" then
            equip({main=Tauret, sub="Gleti's Knife"})
        else
            equip({main=Shijo_WS, sub="Gleti's Knife"}) -- fallback
        end

        -- Equip subjob-specific variant of WS set (if it exists)
        local base_set = sets.ws[spell.english] or sets.ws["Default"]
        local subjob_set = base_set[player.sub_job]
        if subjob_set then
            equip(subjob_set)
        else
            equip(base_set)
        end

        check_day_weather_bonus(spell)
        add_to_chat(122, 'WS Set equipped: ' .. spell.english)

    elseif spell.action_type == 'Ranged Attack' then
        -- (Optional future ranged logic here)
        add_to_chat(122, 'Ranged Attack — no specific set.')
    end
end

function midcast(spell)
    if TH_mode and (spell.action_type == 'Ranged Attack' or spell.english == 'Mug' or spell.english == 'Provoke') then
        equip(sets.TH)
    end
end

function aftercast(spell)
    if player.status == 'Engaged' then
        equip(sets.engaged[Acc_Array[Acc_Index]] or sets.engaged)
        equip({main=Shijo_TP, sub="Gleti's Knife"})
    else
        equip(sets.idle)
        check_debuffs()
        check_capacity_ring()
    end
end

function status_change(new, old)
    if new == 'Engaged' then
        equip(sets.engaged[Acc_Array[Acc_Index]] or sets.engaged)
        equip({main=Shijo_TP, sub="Gleti's Knife"})
    elseif new == 'Idle' then
        equip(sets.idle)
        check_debuffs()
        check_capacity_ring()
    end
end
function check_day_weather_bonus(spell)
    local spell_element = res.spells:with('en', spell.english).element
    local weather = world.weather_element
    local day = world.day_element
    if spell_element and (spell_element == weather or spell_element == day) then
        add_to_chat(8, '[Bonus] ' .. spell_element .. ' matches weather or day!')
    end
end

function check_capacity_ring()
    local ring = windower.ffxi.get_items().equipment.ring1
    if ring and ring == 28540 then
        add_to_chat(122, 'Capacity Ring equipped.')
    end
end

function check_debuffs()
    for _, debuff in ipairs({"Doom", "Silence", "Paralysis"}) do
        if buffactive[debuff] then
            add_to_chat(123, 'Debuff active: ' .. debuff .. ' — use a remedy item!')
        end
    end
end
