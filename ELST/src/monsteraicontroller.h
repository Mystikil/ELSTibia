#ifndef FS_MONSTER_AICONTROLLER_H
#define FS_MONSTER_AICONTROLLER_H

#include "monsters.h"

class Monster;

class MonsterAIController
{
public:
        static void processInteractions(Monster* monster);
};

#endif // FS_MONSTER_AICONTROLLER_H
