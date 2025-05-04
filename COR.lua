-- COR.lua (Main GearSwap entry)
include('organizer-lib')
include('Mote-Include.lua')
res = require('resources')
texts = require('texts')

-- Modular includes
include('data/gear_cor.lua')
include('data/functions.lua')
include('data/hud.lua')

function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
end

function job_setup()
    setup_states()
    determine_jp_tier()
    check_trusts()
    load_cor_gear()
    check_ammo()
    check_ranged_weapon()
    tp_ready_notified = false
    auto_ra_delay = 1.1
    last_ra_time = 0
end

function user_setup()
    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
end

function init_gear_sets()
    init_gear()
end

function precast(spell)
    handle_precast(spell)
end

function midcast(spell)
end

function aftercast(spell)
    handle_aftercast(spell)
end

function status_change(new, old)
    handle_status_change(new, old)
end

function self_command(cmd)
    handle_self_command(cmd)
end

function buff_change(name, gain)
    handle_buff_change(name, gain)
end

windower.register_event('prerender', function()
    handle_prerender()
end)

-- Full COR rolls list
local roll_info = {
    ["Corsair's Roll"] = {lucky=5, unlucky=9},
    ["Chaos Roll"] = {lucky=4, unlucky=8},
    ["Hunter's Roll"] = {lucky=4, unlucky=8},
    ["Samurai Roll"] = {lucky=2, unlucky=6},
    ["Rogue's Roll"] = {lucky=5, unlucky=9},
    ["Allies' Roll"] = {lucky=3, unlucky=10},
    ["Tactician's Roll"] = {lucky=5, unlucky=8},
    ["Magus's Roll"] = {lucky=4, unlucky=8},
    ["Healer's Roll"] = {lucky=4, unlucky=8},
    ["Craftman's Roll"] = {lucky=5, unlucky=9},
    ["Drachen's Roll"] = {lucky=4, unlucky=8},
    ["Warlock's Roll"] = {lucky=4, unlucky=8},
    ["Storm's Roll"] = {lucky=5, unlucky=9},
    ["Fellow's Roll"] = {lucky=5, unlucky=9}
}

-- Handle COR rolls: Add all roll names and track results
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

-- Timer logic for all COR rolls
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
