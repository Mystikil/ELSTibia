#ifndef FS_MONSTER_AI_H
#define FS_MONSTER_AI_H

#include <string>
#include <boost/json.hpp>

class Monster;

class MonsterAIController
{
public:
    explicit MonsterAIController(Monster* owner);

    bool loadProfile(const std::string& file);

    void onThink(uint32_t interval);

private:
    Monster* owner;
    boost::json::value behaviorTree;
};

#endif // FS_MONSTER_AI_H
