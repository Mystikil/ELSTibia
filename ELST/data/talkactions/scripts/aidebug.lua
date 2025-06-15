function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local setting = param:lower()
    if setting == "on" then
        Game.setAIDebug(true)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "AI debugging enabled.")
    elseif setting == "off" then
        Game.setAIDebug(false)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "AI debugging disabled.")
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Usage: /aidebug on|off")
    end
    return false
end
