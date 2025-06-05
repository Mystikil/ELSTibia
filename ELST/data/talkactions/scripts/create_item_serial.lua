function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    local split = param:split(",")
    if #split < 2 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Usage: " .. words .. " itemId,serial")
        return false
    end

    local itemId = tonumber(split[1]) or 0
    local serial = string.trim(split[2])
    if itemId == 0 or serial == "" then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Invalid parameters.")
        return false
    end

    local item = Game.createItem(itemId, 1)
    if not item then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Invalid item id.")
        return false
    end

    item:setCustomAttribute("serial", serial)
    player:addItemEx(item)
    return false
end
