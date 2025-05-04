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
