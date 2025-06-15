# Monster AI System

The server supports optional dynamic difficulty scaling for monsters.
When `dynamicDifficultyEnabled` is set to `true` in `config.lua`,
monster health and damage scale with the number of players online
according to `difficultyScalingCurve`.

Example configuration:

```
dynamicDifficultyEnabled = true
difficultyScalingCurve = {
    { players = 1, multiplier = 1 },
    { players = 25, multiplier = 1.2 },
    { players = 50, multiplier = 1.5 }
}
```

The multiplier selected for the current online player count is applied
when a monster spawns, increasing its maximum health and the damage of
its attacks.

