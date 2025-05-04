function setup_states()
    state.WeaponMode = M{['description']='Weapon Mode', 'Melee', 'Ranged'}
    state.AutoRA = M(false, 'Auto RA')
    state.TreasureMode = M{['description']='Treasure Mode', 'None', 'Tag', 'Fulltime'}
    state.HasteMode = M{['description']='Haste Mode', 'Low', 'Mid', 'High'}
    state.AccMode = M{['description']='Accuracy Mode', 'Normal', 'Acc'}
    state.CORMode = M{['description']='COR Mode', 'Ranged', 'Melee'}
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
    if player.main_job == 'COR' then
        equip_cor_tp_set()
    else
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

function equip_cor_tp_set()
    local mode = state.CORMode.value
    if mode == 'Ranged' then
        equip(sets.tp.ranged.default)
    else
        equip(sets.tp.melee.default)
    end
end

function handle_cor_roll(spell)
    if spell.type == 'CorsairRoll' then
        equip(sets.rolls)
        local duration = 300
        local roll_name = spell.english
        send_command('timers delete \"' .. roll_name .. '\"')
        send_command('timers create \"' .. roll_name .. '\" ' .. duration .. ' down abilities/00255.png')
        windower.add_to_chat(200, '>> Roll: ' .. roll_name .. ' (' .. duration .. 's) <<')
    end
end

function handle_cor_qdraw(spell)
    if spell.english:contains('Quick Draw') then
        equip(sets.qd.default)
    end
end

function handle_precast(spell)
    notify_action(spell)
    if player.main_job == 'COR' then
        handle_cor_roll(spell)
        handle_cor_qdraw(spell)
    end
    -- THF logic continues here...
    -- [omitted for brevity – assume this merges with THF logic from earlier]
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

function handle_status_change(new, old)
    if new == 'Engaged' then
        equip_tp_set()
    elseif new == 'Idle' then
        equip_idle_set()
    end
end

function handle_buff_change(name, gain)
    if not gain and name:endswith("Roll") then
        send_command('timers delete \"' .. name .. '\"')
    end
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
    elseif cmd == 'cycle CORMode' or cmd == 'cor' then
        state.CORMode:cycle()
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

-- Roll result feedback
local roll_info = {
    ["Corsair's Roll"] = {lucky=5, unlucky=9},
    ["Chaos Roll"] = {lucky=4, unlucky=8},
    ["Hunter's Roll"] = {lucky=4, unlucky=8},
    ["Samurai Roll"] = {lucky=2, unlucky=6},
    ["Rogue's Roll"] = {lucky=5, unlucky=9},
    ["Allies' Roll"] = {lucky=3, unlucky=10},
    ["Tactician's Roll"] = {lucky=5, unlucky=8},
}

windower.register_event('action', function(act)
    if act.category == 6 and act.actor_id == windower.ffxi.get_player().id then
        local roll_id = act.param
        local roll_name = res.job_abilities[roll_id] and res.job_abilities[roll_id].name
        if roll_info[roll_name] then
            local val = act.targets[1].actions[1].param % 12 + 1
            local info = roll_info[roll_name]
            if val == info.lucky then
                windower.add_to_chat(32, ('>> Lucky Roll! [%s] = %d <<'):format(roll_name, val))
            elseif val == info.unlucky then
                windower.add_to_chat(123, ('>> Unlucky Roll. [%s] = %d <<'):format(roll_name, val))
            else
                windower.add_to_chat(200, ('>> %s = %d <<'):format(roll_name, val))
            end
        end
    end
end)

-- Auto ammo/weapon check after zone or gear change
windower.register_event('equip_change', function(slot)
    if slot == 2 or slot == 3 or slot == 4 then
        coroutine.schedule(function()
            coroutine.sleep(1)
            check_ammo()
            check_ranged_weapon()
            windower.add_to_chat(200, '>> Weapon change detected — gear recheck complete.')
        end)
    end
end)

windower.register_event('zone change', function()
    coroutine.schedule(function()
        coroutine.sleep(5)
        check_ammo()
        check_ranged_weapon()
        for roll in pairs(roll_info) do
            send_command('timers delete \"' .. roll .. '\"')
        end
        windower.add_to_chat(200, '>> Zone change — gear recheck complete.')
    end)
end)

-- Load COR gear if applicable
function load_cor_gear()
    if player.main_job == 'COR' then
        include('data/gear_cor.lua')
        init_gear()
        windower.add_to_chat(200, '>> COR gear initialized.')
    end
end

load_cor_gear()
