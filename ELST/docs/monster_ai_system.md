# Monster AI System

This document describes the extended monster AI configuration. The new system allows monsters to load external behavior trees and exposes additional attributes in their XML definition. A few sample monsters are provided to demonstrate usage.

## New XML tags

### `<ai>`
Defines the AI profile for a monster. The `profile` attribute points to a JSON file describing the behavior tree and optional settings.

```xml
<ai profile="data/ai/cyber_dragon.json" />
```

### `<skills>`
Specifies custom skill levels used by the AI. Each `<skill>` entry has `name` and `value` attributes.

```xml
<skills>
    <skill name="accuracy" value="110" />
    <skill name="evasion" value="40" />
</skills>
```

### `<perception>`
Controls how far a monster can detect opponents and when it should lose them.

```xml
<perception range="7" chaseRange="10" forgetRange="12" />
```

### `<threatRules>`
Allows configuration of aggro mechanics. Each rule modifies how threat is calculated.

```xml
<threatRules>
    <rule type="damage" weight="1.0" />
    <rule type="heal" weight="0.5" />
</threatRules>
```

## Skill definitions

Skills referenced in `<attacks>` or the behavior tree correspond to numerical values in the XML. For example, the Cyber Dragon uses high melee skill:

```xml
<attack name="melee" interval="2000" skill="110" attack="150" />
```

Custom skills declared in `<skills>` are accessible in the behavior tree using their name.

## Perception parameters

The `<perception>` block defines how the AI senses the environment. `range` is the basic vision distance. `chaseRange` specifies how far the monster will pursue a target, and `forgetRange` is the distance at which it stops chasing.

## Threat rules

Threat rules adjust the priority given to targets. The default implementation increases threat when a monster is damaged, but additional rules can consider healing, buffing or scripted events. Higher `weight` values make a rule contribute more to the threat score.

## External AI profiles

Behavior trees are stored in JSON files under `data/ai/`. Each profile describes states and transitions used by the monster. The `profile` attribute of `<ai>` links to one of these files.

### Example profile snippet

```json
{
    "root": "Selector",
    "nodes": {
        "Selector": ["AttackNearest", "Wander"],
        "AttackNearest": {"type": "Chase", "range": 7},
        "Wander": {"type": "RandomMove", "delay": 1000}
    }
}
```

## Example monster usage

The Cyber Dragon demonstrates the AI tags combined with traditional settings. File: `data/monster/monsters/cyber_dragon.xml`:

```xml
<monster name="Cyber Dragon" nameDescription="a cyber dragon" race="energy" experience="12000" speed="320" raceId="990">
    <ai profile="data/ai/cyber_dragon.json" />
    <perception range="8" chaseRange="12" forgetRange="15" />
    <skills>
        <skill name="accuracy" value="110" />
    </skills>
    <attacks>
        <attack name="melee" interval="2000" skill="110" attack="150" />
        <!-- other attacks omitted -->
    </attacks>
</monster>
```

Another example script `data/monster/lua/#example.lua` shows how events can hook into the AI:

```lua
mType.onThink = function(monster, interval)
    print("I'm thinking")
end
```

## Behaviour tree reference

The behavior tree JSON uses simple nodes such as `Selector`, `Sequence`, `Chase`, and `RandomMove`. More complex profiles can be created to fit different monster roles. Reusing profiles lets multiple monsters share the same logic with different stats.

---

With these new tags and profiles you can build advanced monster behaviors without modifying server code. Place behavior tree files in `data/ai/` and reference them from the monster XML to activate the system.
