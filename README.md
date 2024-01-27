# thain-thain

Abandoned attempt to create a space shooter with maths.

![thain-thain-cover](https://github.com/sacredSatan/thain-thain/assets/16580690/d0573757-992a-45c7-91d0-83deb4176fc0)

## What did go wrong?

I comitted to the "hand-drawn" art style too early. The iteration wasn't quick as the method was stupid (I was exporting stuff from excalidraw after drawing it there).

I should've just stuck to boxes interacting with boxes, implement the gameplay completely first before spending time on art. 

I got stuck with enemy 3's design and never made it past that. It was supposed to be a kamikaze enemy, homing towards you to collide and deal damage.


## Initial Game Loop

1. Player has a spaceship floating in space, able to fire Addition and Deletion bullets
2. Player has an equation attached to the spaceship with one operand highlighted
3. Enemies enter from all directions and attack the player with Addition and Deletion bullets
4. Every *n* seconds the active operand switches
5. Powerups pass through like bullets that a player can acquire
6. That's it, maybe to begin with just a time limit mode

## Media

### Gameplay

https://github.com/sacredSatan/thain-thain/assets/16580690/daa24072-949e-49d1-9a23-8883dd63463a


https://github.com/sacredSatan/thain-thain/assets/16580690/6b4ebdf1-fc95-470f-b618-916b95b445aa


### Player ship

![player-ship](https://github.com/sacredSatan/thain-thain/assets/16580690/6b7c5015-2811-4791-9d59-42a8baff0a5c)

### Gun and Bullets

![guns-bullets](https://github.com/sacredSatan/thain-thain/assets/16580690/a5f8c207-2fc9-40b0-9ae5-72af041e171f)

### Enemies

![enemy-designs](https://github.com/sacredSatan/thain-thain/assets/16580690/ba1b45a0-18e9-4925-9074-d837924d744c)

### Rogh notes dump

```
Space shooter but with maths

Initially 2 types of bullets, one increases value, one decreases it

Enemies have a math equation on top of them and a value highlighted in it, to eliminate them you need the equation to go to 0

example: enemy has 100 * 5, then if 5 is highlighted, you want to shoot them with the bullet that decreases value so eventually it becomes 100 * 0 = 0 and the enemy dies

Same for player's health, you also have a bunch of equations and you can choose to get hit by some bullets from enemies because you know it'll help your equation.

more bullet types and power ups for the future that switch the formula signs, or swap the operands around.

Can do shit like if the enemy's equation evaluates to infinity then we start making copies of that enemy until the player does something, stuff like that

Lots of opportunities to figure shit out.

bullet types/power ups
auto bullet - picks the most imp target and picks the best way to kill it and becomes that kind of bullet
```
