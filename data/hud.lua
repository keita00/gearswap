-- data/hud.lua

function init_hud()
    hud = texts.new({
        pos = {x = 1000, y = 50},
        text = {font = 'Arial', size = 12},
        flags = {draggable = true, bold = true},
        bg = {alpha = 200, red = 0, green = 0, blue = 0},
        padding = 5
    })
end

init_hud()

function update_hud()
    local trust_line = ''
    local trusts = {}
    if kupipi_active then table.insert(trusts, 'Kupipi') end
    if joachim_active then table.insert(trusts, 'Joachim') end
    if koru_active then table.insert(trusts, 'Koru') end
    if ulmia_active then table.insert(trusts, 'Ulmia') end
    if arciela_active then table.insert(trusts, 'Arciela') end
    if shantotto_active then table.insert(trusts, 'Shantotto') end
    if selhteus_active then table.insert(trusts, "Selh'teus") end
    if amchuchu_active then table.insert(trusts, 'Amchuchu') end
    if aadev_active then table.insert(trusts, 'AAEV') end
    if quiltada_active then table.insert(trusts, "Qu'ltada") end
    if #trusts > 0 then
        trust_line = 'Trusts: ' .. table.concat(trusts, ', ')
    end

    local job_line = ''
    if player.main_job == 'COR' then
        job_line = 'COR Mode: ' .. state.CORMode.value
    else
        job_line = string.format(
            'Weapon: %s | AutoRA: %s | TH: %s | Haste: %s | Acc: %s',
            state.WeaponMode.value,
            tostring(state.AutoRA.value),
            state.TreasureMode.value,
            state.HasteMode.value,
            state.AccMode.value
        )
    end

    hud:text(string.format('%s\nJP Tier: %d\n%s', job_line, jp_tier or 0, trust_line))
    hud:show()
end
