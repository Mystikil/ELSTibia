#include "otpch.h"

#include "monster_ai.h"
#include "monster.h"
#include "game.h"
#include "configmanager.h"

#include <fstream>

extern Game g_game;

MonsterAIController::MonsterAIController(Monster* owner) : owner(owner) {}

bool MonsterAIController::loadProfile(const std::string& file)
{
    std::ifstream in(file);
    if (!in.is_open()) {
        return false;
    }

    std::string data((std::istreambuf_iterator<char>(in)), std::istreambuf_iterator<char>());
    try {
        behaviorTree = boost::json::parse(data);
    } catch (const std::exception&) {
        return false;
    }
    return true;
}

void MonsterAIController::onThink(uint32_t interval)
{
    Monster* monster = owner;

    monster->Creature::onThink(interval);

    if (monster->mType->info.thinkEvent != -1) {
        if (!tfs::lua::reserveScriptEnv()) {
            std::cout << "[Error - Monster::onThink] Call stack overflow" << std::endl;
            return;
        }

        LuaScriptInterface* scriptInterface = monster->mType->info.scriptInterface;
        ScriptEnvironment* env = tfs::lua::getScriptEnv();
        env->setScriptId(monster->mType->info.thinkEvent, scriptInterface);

        lua_State* L = scriptInterface->getLuaState();
        scriptInterface->pushFunction(monster->mType->info.thinkEvent);

        tfs::lua::pushUserdata(L, monster);
        tfs::lua::setMetatable(L, -1, "Monster");

        lua_pushnumber(L, interval);

        if (scriptInterface->callFunction(2)) {
            return;
        }
    }

    if (!monster->isInSpawnRange(monster->position)) {
        if (getBoolean(ConfigManager::MONSTER_OVERSPAWN)) {
            if (monster->spawn) {
                monster->spawn->removeMonster(monster);
                monster->spawn->startSpawnCheck();
                monster->spawn = nullptr;
            }
        } else {
            g_game.addMagicEffect(monster->getPosition(), CONST_ME_POFF);
            if (getBoolean(ConfigManager::REMOVE_ON_DESPAWN)) {
                g_game.removeCreature(monster, false);
            } else {
                g_game.internalTeleport(monster, monster->masterPos);
                monster->setIdle(true);
            }
        }
    } else {
        monster->updateIdleStatus();

        if (!monster->isIdle) {
            monster->addEventWalk();

            if (monster->isSummon()) {
                if (!monster->attackedCreature) {
                    if (monster->getMaster() && monster->getMaster()->getAttackedCreature()) {
                        monster->selectTarget(monster->getMaster()->getAttackedCreature());
                    } else if (monster->getMaster() != monster->followCreature) {
                        monster->setFollowCreature(monster->getMaster());
                    }
                } else if (monster->attackedCreature == monster) {
                    monster->removeFollowCreature();
                } else if (monster->followCreature != monster->attackedCreature) {
                    monster->setFollowCreature(monster->attackedCreature);
                }
            } else if (!monster->targetList.empty()) {
                if (!monster->followCreature || !monster->hasFollowPath) {
                    monster->searchTarget();
                } else if (monster->isFleeing()) {
                    if (monster->attackedCreature && !monster->canUseAttack(monster->getPosition(), monster->attackedCreature)) {
                        monster->searchTarget(TARGETSEARCH_ATTACKRANGE);
                    }
                }
            }

            monster->onThinkTarget(interval);
            monster->onThinkYell(interval);
            monster->onThinkDefense(interval);
        }
    }
