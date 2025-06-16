-- THF.lua with HUD, Accuracy Toggle, TH Toggle, Buff Warnings, Capacity Ring Alert, Day/Weather WS Checks

texts = require('texts')
function get_current_main()
    local equipment = windower.ffxi.get_items().equipment
    local inventory = windower.ffxi.get_items()
    local main_bag = equipment.main_bag
    local main_index = equipment.main
    local item = inventory[main_bag] and inventory[main_bag][main_index]
    if item and item.id ~= 0 then
        return res.items[item.id].name
    end
    return ""
end

th_hud = texts.new('TH: OFF', {
    pos = {x=1100, y=30},
    bg = {alpha=0},
    fg = {alpha=255},
    text = {size=12}
})

TH_mode = true
Acc_Index = 1
Acc_Array = {"Default", "Acc", "AccMid", "AccHigh"}
Shijo_WS = { name="Shijo", augments={'Path: C'} }
Shijo_TP = { name="Shijo", augments={'Path: D'} }
Tauret = "Tauret"
tauret_ws = S{"Evisceration", "Mandalic Stab", "Dancing Edge"}
shijo_ws  = S{"Savage Blade", "Exenterator", "Aeolian Edge", "Rudra's Storm"}
	
function update_hud()
    if not th_hud then return end

    local weapon_text = 'Weapon: ' .. (Weapon_Mode or 'Unknown')
    local acc_text = 'ACC: ' .. (Acc_Array and Acc_Array[Acc_Index] or 'N/A')
    local dt_text = 'DT Mode: ' .. (DT_Modes and DT_Modes[DT_Mode_Index] or 'N/A')
    local th_text = TH_mode and 'TH: ON' or 'TH: OFF'

    local hud_text = weapon_text .. ' | ' .. acc_text .. ' | ' .. dt_text .. ' | ' .. th_text

    hud_text = hud_text .. ' | ACC: ' .. (Acc_Array and Acc_Array[Acc_Index] or 'N/A')

    if th_hud then
        th_hud:text(hud_text)
        th_hud:show()
    end
	

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


Weapon_Mode = "Shijo" -- default


function self_command(command)
	if command == 'toggleWeapon' then
		if Weapon_Mode == "Tauret" then
			Weapon_Mode = "Shijo"
			equip({main=Shijo_TP, sub="Gleti's Knife"})
		elseif Weapon_Mode == "Shijo" then
			Weapon_Mode = "Mandau"
			equip({main="Mandau", sub="Gleti's Knife"})
		else
			Weapon_Mode = "Tauret"
			equip({main=Tauret, sub="Gleti's Knife"})
		end
		add_to_chat(122, 'Weapon Mode: ' .. Weapon_Mode)
		update_hud()
	end
    if command == 'toggleDT' then
        DT_Mode_Index = DT_Mode_Index % #DT_Modes + 1
        add_to_chat(122, 'Defense Mode: ' .. DT_Modes[DT_Mode_Index])
        update_hud()
	end
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


Weapon_Mode = "Shijo" -- default


DT_Modes = {"Normal", "DT", "EVA"}
DT_Mode_Index = 1
function get_sets()
    update_hud()
    sets = {}
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
    
    sets.eva = {
        main=Shijo_TP,
        sub="Gleti's Knife",
        head="Turms Cap +1",
        body="Pillager's Vest +3",
        hands="Turms Mittens +1",
        legs="Turms Subligar +1",
        feet="Turms Leggings +1",
        neck="Warder's Charm +1",
        ring1="Defending Ring",
        ring2="Moonlight Ring",
        ear1="Suppanomimi",
        waist="Flume Belt +1",
        back=Toutatis_AGI
    }

sets.dt = {
        main=Shijo_TP,
        sub="Gleti's Knife",
        head="Turms Cap +1",
        body="Tu. Harness +1",
        hands="Turms Mittens +1",
        legs="Turms Subligar +1",
        feet="Turms Leggings +1",
        neck="Warder's Charm +1",
        ring1="Defending Ring",
        ring2="Moonlight Ring",
        ear1="Suppanomimi",
        waist="Carrier's Sash",
        back=Toutatis_STP
    }


sets.idle = {
    main=Shijo_TP,
    sub="Gleti's Knife",
        head="Turms Cap +1", body="Tu. Harness +1", hands="Turms Mittens +1",
        legs="Turms Subligar +1", feet="Turms Leggings +1", neck="Asn. Gorget +2",
        ring1="Defending Ring", ring2="Moonlight Ring", ear1="Suppanomimi",
        waist="Reiki Yotai", back=Toutatis_STP
    }
	sets.WSDHands = { hands="Pill. Armlets +3" }
    sets.JA = {
        ["Sneak Attack"] = { hands="Pill. Armlets +3" },
        ["Trick Attack"] = { hands="Pill. Armlets +3" },
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
            head="Mummu Bonnet +2", body="Pillager's Vest +3", hands="Pill. Armlets +3",
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
            waist="Sailfi Belt +1", back=Toutatis_AGI
        },
        ["Savage Blade"] = {
        head="Pill. Bonnet +3",
        body="Pillager's Vest +3",
        hands="Pill. Armlets +3",
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
			hands="Pill. Armlets +3",
			legs="Pill. Culottes +3",
			feet="Plun. Pulaines +1",
			neck="Asn. Gorget +2",
			ear1="Odr Earring", ear2="Moonshade Earring",
			ring1="Regal Ring", ring2="Epaminondas's Ring",
			waist="Sailfi Belt +1",
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
			waist="Sailfi Belt +1",
			back=Toutatis_STP
		},
		["Mercy Stroke"] = {
			head="Pill. Bonnet +3",
			body="Pillager's Vest +3",
			hands="Pill. Armlets +3",
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
		waist="Sailfi Belt +1",
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

        if TH_mode and (spell.english == "Provoke" or spell.english == "Mug" or spell.english == "Feint") then
            equip(sets.TH)
            add_to_chat(122, 'Treasure Hunter gear equipped.')
        end

    elseif spell.type == 'WeaponSkill' then
        local current_main = get_current_main():lower()

        if tauret_ws:contains(spell.english) then
            if Weapon_Mode == "Tauret" and current_main ~= "tauret" then
                cancel_spell()
                add_to_chat(123, spell.english .. ' canceled: Equip Tauret manually first.')
                return
            end
            equip({main=Tauret, sub="Gleti's Knife"})
        elseif shijo_ws:contains(spell.english) then
            if Weapon_Mode == "Shijo" and current_main ~= "shijo" then
                cancel_spell()
                add_to_chat(123, spell.english .. ' canceled: Equip Shijo manually first.')
                return
            end
            equip({main=Shijo_WS, sub="Gleti's Knife"})
        else
            if Weapon_Mode == "Shijo" and current_main ~= "shijo" then
                cancel_spell()
                add_to_chat(123, spell.english .. ' canceled: Default WS fallback requires Shijo.')
                return
            end
            equip({main=Shijo_WS, sub="Gleti's Knife"})
        end

        if spell.english == "Exenterator" then
            if Acc_Array[Acc_Index] == "Acc" or Acc_Array[Acc_Index] == "AccMid" or Acc_Array[Acc_Index] == "AccHigh" then
                equip({waist="Reiki Yotai"})
            else
                equip({waist="Sailfi Belt +1"})
            end
        end

        local ws_set = sets.ws[spell.english] or sets.ws["Default"]
        if ws_set[player.sub_job] then
            equip(ws_set[player.sub_job])
        else
            equip(ws_set)
        end

        add_to_chat(122, 'WS Set equipped: ' .. spell.english)
        if buffactive["Sneak Attack"] or buffactive["Trick Attack"] then
            equip(sets.WSDHands)
            add_to_chat(122, 'WSD hands equipped for SA/TA.')
        end
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

        if Weapon_Mode == "Shijo" then
            equip({main=Shijo_TP, sub="Gleti's Knife"})
        elseif Weapon_Mode == "Tauret" then
            equip({main=Tauret, sub="Gleti's Knife"})
        elseif Weapon_Mode == "Mandau" then
            equip({main="Mandau", sub="Gleti's Knife"})
        end

    else
        if DT_Modes[DT_Mode_Index] == "DT" then
            equip(sets.dt)
        elseif DT_Modes[DT_Mode_Index] == "EVA" then
            equip(sets.eva)
        else
            equip(sets.idle)
        end

        -- Keep sub weapon consistent in idle
        equip({sub="Gleti's Knife"})

        -- Apply defensive main hand if relevant
        if Weapon_Mode == "Mandau" then
            equip({main="Mandau"})
        elseif Weapon_Mode == "Tauret" then
            equip({main=Tauret})
        elseif Weapon_Mode == "Shijo" then
            equip({main=Shijo_TP})
        end

        check_debuffs()
        check_capacity_ring()
    end
end


function status_change(new, old)
    if new == 'Engaged' then
        equip(sets.engaged[Acc_Array[Acc_Index]] or sets.engaged)
        equip({main=Shijo_TP, sub="Gleti's Knife"})
    elseif new == 'Idle' then
        if DT_Modes[DT_Mode_Index] == "DT" then
        equip(sets.dt)
    elseif DT_Modes[DT_Mode_Index] == "EVA" then
        equip(sets.eva)
    else
        equip(sets.idle)
    end
equip({sub="Gleti\'s Knife"})
        check_debuffs()
        check_capacity_ring()
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
