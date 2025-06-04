# Kill Titles Progression

Players now earn special titles by slaying large numbers of the same creature.
For every monster, killing **100** individuals grants the title `Slayer of 100 <monster>s`.

This system is handled by `data/scripts/creaturescripts/player/kill_titles.lua`
which tracks kills per creature race and announces a title once the threshold is
reached. Titles are stored using the new `killTitlesBase` player storage key and
are independent from the normal level system.
