-- data/functions.lua

function setup_states()
    state.WeaponMode = M{['description']='Weapon Mode', 'Melee', 'Ranged'}
    state.AutoRA = M(false, 'Auto RA')
    state.TreasureMode = M{['description']='Treasure Mode', 'None', 'Tag', 'Fulltime'}
    state.HasteMode = M{['description']='Haste Mode', 'Low', 'Mid', 'High'}
    state.AccMode = M{['description']='Accuracy Mode', 'Normal', 'Acc'}
    th_tagged = false
end

function determine_jp_tier()
    if job_points >= 1200 then
        jp_tier = 3
    elseif job_points >= 550 then
        jp_tier = 2
    else
        jp_tier = 1
    end
end

function determine_ws()
    local subjob = player.sub_job
    local main_weapon = player.equipment.main or ""
    if main_weapon:lower():find("vajra") or main_weapon:lower():find("mandau") or main_weapon:lower():find("tauret") then
        return "Rudra's Storm"
    elseif main_weapon:lower():find("tp") or main_weapon:lower():find("aphotic") then
        return "Savage Blade"
    elseif subjob == 'RNG' then
        return "Last Stand"
    else
        return "Aeolian Edge"
    end
end

function is_tag_ability(name)
    local tag_abilities = {
        ["Provoke"] = true,
        ["Animated Flourish"] = true,
        ["Aeolian Edge"] = true
    }
    return tag_abilities[name] or false
end

function is_subjob_ja(name)
    local subjob_abilities = {
        DNC = {"Step", "Feather Step", "Quickstep"},
        WAR = {"Berserk", "Warcry", "Aggressor"},
        NIN = {"Utsusemi: Ichi", "Utsusemi: Ni"},
        RNG = {"Scavenge", "Sharpshot"}
    }
    local list = subjob_abilities[player.sub_job] or {}
    for _, ability in ipairs(list) do
        if name:startswith(ability) then return true end
    end
    return false
end

function table.contains(tab, val)
    for _, v in ipairs(tab) do
        if v == val then return true end
    end
    return false
end
w
function check_trusts()
    trusts = windower.ffxi.get_party()
    trust_names = {}
    for i,v in pairs(trusts) do
        if v.mob then table.insert(trust_names, v.mob.name) end
    end

    kupipi_active     = table.contains(trust_names, "Kupipi")
    joachim_active    = table.contains(trust_names, "Joachim")
    koru_active       = table.contains(trust_names, "Koru-Moru")
    shantotto_active  = table.contains(trust_names, "Shantotto II")
    ulmia_active      = table.contains(trust_names, "Ulmia")
    arciela_active    = table.contains(trust_names, "Arciela II")
    selhteus_active   = table.contains(trust_names, "Selh'teus")
    amchuchu_active   = table.contains(trust_names, "Amchuchu")
    aadev_active      = table.contains(trust_names, "AAEV")
    quiltada_active   = table.contains(trust_names, "Qu'ltada")
end

function equip_tp_set()
    local haste = state.HasteMode.value
    local acc = state.AccMode.value
    local set = (acc == 'Acc') and sets.tp_acc[haste] or sets.tp[haste]

    if state.TreasureMode.value == 'Fulltime' then
        set = set_combine(set, sets.TH)
    end
    if aadev_active or amchuchu_active then
        set = set_combine(set, sets.trust_tank)
    end
    if ulmia_active or joachim_active or koru_active then
        set = set_combine(set, sets.trust_support)
    end
    if world.area:contains("Sheol") or buffactive["Reive Mark"] then
        set = set_combine(set, sets.odyssey_boss)
    end

    equip(set)
end

function equip_idle_set()
    local set = sets.idle
    if aadev_active or amchuchu_active then
        set = set_combine(set, sets.trust_tank)
    end
    if ulmia_active or joachim_active or koru_active then
        set = set_combine(set, sets.trust_support)
    end
    equip(set)
end

function handle_buff_change(name, gain)
    if gain then
        if name == 'Doom' then
            windower.add_to_chat(123, '>> DOOMED! Use Holy Water! <<')
            equip(sets.buff.Doom)
            disable('ring1','waist')
        elseif name == 'Paralysis' then
            windower.add_to_chat(123, '>> PARALYZED! <<')
        elseif name == 'Silence' then
            windower.add_to_chat(123, '>> SILENCED! Echo Drops! <<')
            equip(sets.buff.Silence)
        end
    elseif name == 'Doom' then
        enable('ring1','waist')
        handle_aftercast()
    end
end
function has_tp_bonus_weapon()
    local items = windower.ffxi.get_items()
    local tp_bonus_weapons = {
        "Gleti's Knife", "Daybreak", "Sacro Sword", "Naegling", "Crepuscular Knife"
    }
    for _, entry in ipairs(tp_bonus_weapons) do
        for _, bag in ipairs({'inventory','wardrobe','wardrobe2','wardrobe3','wardrobe4'}) do
            for _, item in pairs(items[bag] or {}) do
                if type(item) == 'table' and item.id then
                    local res_item = res.items[item.id]
                    if res_item and res_item.name == entry then return true end
                end
            end
        end
    end
    return false
end

function handle_precast(spell)
    notify_action(spell)
    if spell.action_type == 'Magic' then
        equip(sets.precast.FC)
    elseif spell.type == 'WeaponSkill' then
        local ws = spell.english
        local ws_set = sets.ws[ws] or sets.ws[current_ws]
        if ws_set then
            equip(ws_set)
            if not has_tp_bonus_weapon() then
                if ws == "Savage Blade" then
                    equip({waist = "Sailfi Belt +1"})
                elseif ws == "Aeolian Edge" then
                    equip({waist = "Orpheus's Sash"})
                elseif ws == "Exenterator" or ws == "Evisceration" then
                    equip({waist = "Fotia Belt"})
                end
            end
        end
    elseif spell.type == 'JobAbility' then
        if is_tag_ability(spell.name) and state.TreasureMode.value ~= 'None' then
            equip(sets.TH)
            th_tagged = true
        elseif is_subjob_ja(spell.name) then
            equip(sets.tp.Mid)
        end
    end
end

function has_ammo(name)
    local items = windower.ffxi.get_items()
    for _, bag in ipairs({'inventory','wardrobe','wardrobe2','wardrobe3','wardrobe4'}) do
        for _, item in pairs(items[bag] or {}) do
            if type(item) == 'table' and item.id then
                local res_item = res.items[item.id]
                if res_item and res_item.name == name then return true end
            end
        end
    end
    return false
end

function check_ammo()
    if not player.equipment.ammo or player.equipment.ammo == 'empty' then
        if has_ammo("Chrono Bullet") then
            send_command('input /equip ammo "Chrono Bullet"')
            windower.add_to_chat(200, '>> Auto-equipped Chrono Bullet. <<')
        elseif has_ammo("Bronze Bullet") then
            send_command('input /equip ammo "Bronze Bullet"')
            windower.add_to_chat(200, '>> Using fallback: Bronze Bullet. <<')
        else
            windower.add_to_chat(123, '>> WARNING: No valid ammo found! <<')
        end
    end
end

function has_ranged_weapon(name)
    local items = windower.ffxi.get_items()
    for _, bag in ipairs({'inventory','wardrobe','wardrobe2','wardrobe3','wardrobe4'}) do
        for _, item in pairs(items[bag] or {}) do
            if type(item) == 'table' and item.id then
                local res_item = res.items[item.id]
                if res_item and res_item.name == name then return true end
            end
        end
    end
    return false
end

function check_ranged_weapon()
    local current_range = player.equipment.range or ""
    if current_range == "empty" or current_range == nil then
        if has_ranged_weapon("Fomalhaut") then
            send_command('input /equip range "Fomalhaut"')
            windower.add_to_chat(200, '>> Equipped Fomalhaut. <<')
        elseif has_ranged_weapon("Anarchy +2") then
            send_command('input /equip range "Anarchy +2"')
            windower.add_to_chat(200, '>> Equipped Anarchy +2. <<')
        else
            windower.add_to_chat(123, '>> No valid ranged weapon equipped or found. <<')
        end
    end
end
function notify_action(spell)
    if spell.type == 'WeaponSkill' then
        windower.add_to_chat(207, ('>> WS Used: %s on [%s] <<'):format(spell.english, spell.target.name))
    elseif spell.type == 'JobAbility' and is_tag_ability(spell.name) and state.TreasureMode.value ~= 'None' then
        windower.add_to_chat(207, ('>> TH Gear Applied: %s <<'):format(spell.name))
    end
end

function notify_tp_ready()
    if player.tp >= 1000 and not tp_ready_notified then
        windower.add_to_chat(200, '>> TP ≥ 1000 - Ready to WS! <<')
        tp_ready_notified = true
    elseif player.tp < 1000 then
        tp_ready_notified = false
    end
end

function handle_aftercast(spell)
    if th_tagged and state.TreasureMode.value == 'Tag' then
        th_tagged = false
        if player.status == 'Engaged' then equip_tp_set() else equip_idle_set() end
    elseif player.status == 'Engaged' then
        equip_tp_set()
    else
        equip_idle_set()
    end
end

function handle_status_change(new, old)
    if new == 'Engaged' then
        equip_tp_set()
    elseif new == 'Idle' then
        equip_idle_set()
    end
end

function handle_self_command(cmd)
    if cmd == 'cycle WeaponMode' then
        state.WeaponMode:cycle()
    elseif cmd == 'toggle AutoRA' then
        state.AutoRA:toggle()
    elseif cmd == 'cycle TreasureMode' then
        state.TreasureMode:cycle()
    elseif cmd == 'cycle HasteMode' then
        state.HasteMode:cycle()
    elseif cmd == 'cycle AccMode' then
        state.AccMode:cycle()
    end
    update_hud()
end

function handle_prerender()
    notify_tp_ready()
    if state.AutoRA.value and state.WeaponMode.value == 'Ranged' and player.status == 'Engaged' then
        check_ammo()
        local now = os.clock()
        if now - last_ra_time > auto_ra_delay and player.tp >= 1000 then
            equip(sets.ranged.acc)
            send_command('/ra <t>')
            last_ra_time = now
        end
    elseif state.AutoRA.value and state.WeaponMode.value == 'Melee' and player.tp >= 1000 then
        send_command('/ws \"' .. current_ws .. '\" <t>')
        last_ra_time = os.clock()
    end
end

-- Auto recheck after equip change (Main/Sub/Range)
windower.register_event('equip_change', function(slot, from, to)
    if slot == 2 or slot == 3 or slot == 4 then
        coroutine.schedule(function()
            coroutine.sleep(1)
            check_ammo()
            check_ranged_weapon()
            windower.add_to_chat(200, '>> Weapon change detected — gear recheck complete.')
        end)
    end
end)

-- Auto recheck after zoning
windower.register_event('zone change', function()
    coroutine.schedule(function()
        coroutine.sleep(5)
        check_ammo()
        check_ranged_weapon()
        windower.add_to_chat(200, '>> Zone change — gear recheck complete.')
    end)
end)

-- Additional:
load COR gear function load_cor_gear()
    if player.main_job == 'COR' then
        include('data/gear_cor.lua')
        init_gear() windower.add_to_chat(200, '>> COR gear initialized.')
    end
end

-- Call this during job setup load_cor_gear()
