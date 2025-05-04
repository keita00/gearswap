-- Update HUD to show roll timers and COR Mode
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
        -- Display roll timers in HUD
        for roll_name, _ in pairs(roll_info) do
            local timer = windower.ffxi.get_timer(roll_name)
            if timer then
                job_line = job_line .. ' | ' .. roll_name .. ': ' .. timer .. 's'
            end
        end
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
