local KillTitles = CreatureEvent("KillTitles")

local KILL_THRESHOLD = 100

function KillTitles.onKill(player, target)
        local monster = target:getMonster()
        if not monster or monster:getMaster() then
                return true
        end

        local raceId = monster:getType():getBestiaryInfo().raceId
        if raceId == 0 then
                return true
        end

        local count = player:addKillTitleCount(raceId)
        if count == KILL_THRESHOLD then
                local name = monster:getName():lower()
                if not name:find('s$') then
                        name = name .. 's'
                end
                local title = string.format('Slayer of %d %s', KILL_THRESHOLD, name)
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Title unlocked: ' .. title)
        end
        return true
end

KillTitles:register()
