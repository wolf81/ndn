# ndn

*ndn* is a miniature library for using D&D-style dice rolls in a game.

The library can be used as such:

```lua
-- import library from project directory
local ndn = require "path.to.ndn"

-- create d&d-style dice
local dice = ndn("2d6-3")
print(dice) --> 2d6-3

-- roll
local v = dice()
print(v) --> 8
```

# API

Call *ndn* with a D&D-style dice string to generate new dice, e.g.

```lua
local d1 = ndn("1d6")
local d2 = ndn("-2d4+3")
```

In order to print the string used to generate the dice, just print the dice:

```lua
print(d1) --> 1d6
print(d2) --> -2d4+3
```

In order to perform a random roll, use one of the following approaches:

```lua
print(d1()) --> 4
print(d2.roll()) --> -2
```

It's also possible to retrieve the lowest and highest values that can be 
generated with the dice as such:

```lua
print(d1.range()) --> 1, 6
print(d2.range()) --> -5, 1
```

A LÖVE program is included that generates random dice and does many rolls, 
printing out the results in the console. Press "g" to generate new random dice.

The program displays results as such:

```
dice: 3d6

range: (3 ... 18)

v	%
3	0.52
4	1.45
5	2.58
6	4.83
7	7.01
8	8.84
9	11.87
10	12.39
11	13.01
12	11.74
13	9.54
14	6.76
15	4.62
16	2.75
17	1.6
18	0.49

average: 10.5173
```