# Monster AI System

This document describes the basics of the monster behaviour system.

## Debugging

Use `/aidebug on` to enable detailed logging of monster AI decisions.
Use `/aidebug off` to disable the logs.

When enabled, the server prints information about each monster on every think cycle.
Lua scripts can check `Game.isAIDebugEnabled()` and print additional data such as active behaviour tree nodes if desired.
