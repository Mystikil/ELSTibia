#include "otpch.h"

#include "monsteraicontroller.h"
#include "monster.h"
#include "game.h"
#include "tile.h"
#include "item.h"

extern Game g_game;

void MonsterAIController::processInteractions(Monster* monster)
{
        const auto& interactions = monster->getMonsterType()->info.interactions;
        for (MonsterInteractionType type : interactions) {
                switch (type) {
                        case MonsterInteractionType::OPEN_DOOR: {
                                // open door in front of the monster if present
                                Position pos = monster->getPosition();
                                Position ahead = pos.getNextPosition(monster->getDirection());
                                Tile* tile = g_game.map.getTile(ahead);
                                if (!tile) {
                                        continue;
                                }
                                Item* doorItem = tile->getItemByType(ITEM_TYPE_DOOR);
                                if (!doorItem) {
                                        continue;
                                }
                                g_game.transformItem(doorItem, doorItem->getID() + 1);
                                break;
                        }
                }
        }
}
