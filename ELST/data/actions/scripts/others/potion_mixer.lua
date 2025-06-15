local buffCondition = Condition(CONDITION_ATTRIBUTES)
buffCondition:setParameter(CONDITION_PARAM_TICKS, 5 * 60 * 1000)
buffCondition:setParameter(CONDITION_PARAM_SKILL_MELEE, 3)
buffCondition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)

local debuffCondition = Condition(CONDITION_POISON)
debuffCondition:setParameter(CONDITION_PARAM_DELAYED, true)
debuffCondition:setParameter(CONDITION_PARAM_MINVALUE, -50)
debuffCondition:setParameter(CONDITION_PARAM_MAXVALUE, -120)
debuffCondition:setParameter(CONDITION_PARAM_STARTVALUE, -5)
debuffCondition:setParameter(CONDITION_PARAM_TICKINTERVAL, 4000)
debuffCondition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not item:isContainer() then
        return false
    end

    if not table.contains(PotionMixConfig.cauldrons, item:getId()) then
        return false
    end

    local items = item:getItems()
    if #items == 0 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "The cauldron is empty.")
        return true
    end

    local result = PotionSystem.evaluate(items, player)

    for i = 1, #items do
        items[i]:remove()
    end

    local pos = item:getPosition()
    if result.type == 'buff' then
        buffCondition:setParameter(CONDITION_PARAM_SKILL_MELEE, result.value)
        player:addCondition(buffCondition)
        pos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel empowered by the brew.")
    elseif result.type == 'debuff' then
        debuffCondition:setParameter(CONDITION_PARAM_MINVALUE, -20 * result.value)
        debuffCondition:setParameter(CONDITION_PARAM_MAXVALUE, -40 * result.value)
        player:addCondition(debuffCondition)
        pos:sendMagicEffect(CONST_ME_POFF)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Ugh! The mixture tastes awful.")
    elseif result.type == 'mutation' then
        player:setMonsterOutfit("rat", 60 * 1000)
        pos:sendMagicEffect(CONST_ME_HOLYAREA)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Strange energies change your body!")
    elseif result.type == 'craft' then
        Game.createItem(result.item, 1, pos)
        pos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The ingredients merge into something new.")
    else
        Game.createItem(PotionMixConfig.zoneEffectItem, 1, pos)
        pos:sendMagicEffect(CONST_ME_MAGIC_RED)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The mixture explodes!")
    end
    return true
end
