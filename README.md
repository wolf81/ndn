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
3d4+8 (11 ... 20)

#   %
11  2
12  4.33
13  9.46
14  15.45
15  18.88
16  18.56
17  15.67
18  9.16
19  4.89
20  1.6

average: 15.4958
```