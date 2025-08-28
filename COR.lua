-- COR GearSwap file with Rostam fix for Phantom Roll

-- Load and initialize the include file.
include('Mirdain-Include')

--Set to ingame lockstyle and Macro Book/Set
LockStylePallet = "12"
MacroBook = "17"
MacroSet = "1"

Food = "Sublime Sushi"
AutoItem = true
Random_Lockstyle = false
Lockstyle_List = {1,2,6,12}

state.OffenseMode:options('TP','ACC','DT','PDL','CRIT','MEVA','SB')
state.OffenseMode:set('TP')
state.WeaponMode:options('Fomalhaut','Death Penalty', 'Savage Blade', 'Aeolian Edge', 'Evisceration')
state.WeaponMode:set('Death Penalty')
UI_Name = 'TP Mode'
state.JobMode:options('Standard','Melee','Ranged')
state.JobMode:set('Standard')

jobsetup(LockStylePallet,MacroBook,MacroSet)
Ammo_Warning_Limit = 99

function get_sets()
    sets.Weapons = {}
    sets.Weapons['Fomalhaut'] = {
        main={ name="Rostam", augments={'Path: A'}, bag="wardrobe4"},
        sub={ name="Rostam", augments={'Path: C'}, bag="wardrobe2"},
        range={ name="Fomalhaut", augments={'Path: A',}},
    }

    sets.PhantomRoll = {
        main={ name="Rostam", augments={'Path: C'}, bag="wardrobe2"},
        sub={ name="Nusku Shield", priority=2},
        range="Compensator",
        head={ name="Lanun Tricorne +1", augments={'Enhances \"Winning Streak\" effect',}},
        hands="Chasseur's Gants +3",
        neck="Regal Necklace",
        right_ring="Luzaf's Ring",
        back={ name="Camulus's Mantle", augments={'HP+60','HP+20','\"Snapshot\"+10',}},
    }
end

function precast_custom(spell)
    local equipSet = {}
    if (spell.type == 'CorsairRoll') or (spell.english == 'Double-Up') then
        equipSet = set_combine(equipSet, sets.PhantomRoll)
        return equipSet
    end
    return equipSet
end

function Job_Mode_Check(equipSet)
    if state.JobMode.value == 'Melee' then
        equipSet = set_combine(equipSet, sets.Weapons.Melee)
    elseif state.JobMode.value == 'Ranged' then
        equipSet = set_combine(equipSet, sets.Weapons.Ranged)
    end
    if DualWield == false then
        if TwoHand == false then
            equipSet = set_combine(equipSet, sets.Weapons.Shield)
        end
    end
    return equipSet
end
