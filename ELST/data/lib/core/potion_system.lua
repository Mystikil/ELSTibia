PotionMixConfig = dofile('data/potion_system_config.lua')

PotionSystem = {}

local function defaultFormula(stats)
    if stats.buff > stats.debuff and stats.buff >= stats.mutation then
        return {type = 'buff', value = stats.buff}
    elseif stats.debuff > stats.buff and stats.debuff >= stats.mutation then
        return {type = 'debuff', value = stats.debuff}
    elseif stats.mutation > 0 then
        return {type = 'mutation', value = stats.mutation}
    else
        return {type = 'zone'}
    end
end

function PotionSystem.evaluate(items, player)
    local stats = {buff = 0, debuff = 0, mutation = 0}
    local craft
    for i = 1, #items do
        local cfg = PotionMixConfig.ingredients[items[i]:getId()]
        if cfg then
            stats.buff = stats.buff + (cfg.buff or 0)
            stats.debuff = stats.debuff + (cfg.debuff or 0)
            stats.mutation = stats.mutation + (cfg.mutation or 0)
            craft = craft or cfg.craft
        end
    end

    if craft then
        return {type = 'craft', item = craft}
    end

    if PotionMixConfig.formula then
        return PotionMixConfig.formula(stats, player)
    end

    return defaultFormula(stats)
end
