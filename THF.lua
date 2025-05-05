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

    sets.precast = {}
    sets.precast.FC = {
        hands="Adhemar Wrist. +1",
        ear1="Loquac. Earring",
        ring1="Kishar Ring"
    }

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
        }
    }
end

function precast(spell)
    if sets.JA[spell.english] then
        equip(sets.JA[spell.english])
        if TH_mode and (spell.english == "Provoke" or spell.english == "Mug" or spell.english == "Feint") then
            equip(sets.TH)
        end
    elseif spell.action_type == 'Magic' then
        equip(sets.precast.FC)
    elseif spell.type == 'WeaponSkill' then
        if sets.ws[spell.english] then
            if spell.english == "Aeolian Edge" then
                equip({main=Shijo_WS, sub="Gleti's Knife"})
            elseif spell.english == "Evisceration" then
                equip({main=Tauret, sub="Gleti's Knife"})
            elseif spell.english == "Exenterator" then
                equip({main=Shijo_WS, sub="Gleti's Knife"})
            else
                equip({main=Shijo_WS, sub="Gleti's Knife"})
            end
            equip(sets.ws[spell.english])
            check_day_weather_bonus(spell)
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
