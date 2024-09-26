# Coffer Tracker

Coffer Tracker is an addon that tracks how many [Restored Coffer Keys](https://www.wowhead.com/item=224172/restored-coffer-key) you have looted. You can only receive 4 keys per week, per character, from opening loot boxes. You may otherwise purchase them from a vendor, so long as you have enough Delve reputation and [Undercoins](https://www.wowhead.com/currency=2803/undercoin).

The addon will display an info box on your screen, which you can click-drag to move around. Hovering over the info box, will display a tooltip with helpful command information.

![image](https://github.com/user-attachments/assets/c5725b0f-73cc-4d50-baad-07e9046609c5)

## Options

Counts are automatically updated everytime you loot a key.

* `/coffer`: Toggle visbility of the info box.
* `/coffer <num>`: Manually set the number of keys you have looted on your current character. Example: `/coffer 4`
* `/coffer reset`: Reset the count for all characters. (You should do this once, on every weekly reset).

## Important Note

If you purchase a coffer key from [Sir Finley Mrrgglton](https://www.wowhead.com/npc=208070/sir-finley-mrrgglton), the counter should increment.

I currently make no effort to exclusively identify keys you loot from opening chests. You may find the current behavior helpful, in that it will show you all the keys you've looted. Or, if you prefer, you can manually set the number of keys you've looted (using `/count <num>`) if you'd prefer this count to only reflect the chests you know you've opened for the week.