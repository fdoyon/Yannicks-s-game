## Welcome to Yannick's Game!

My nephew wanted to learn programming and loves videogames, so I, a dutyful uncle, set forth to teach him the basics of programming with a fun twist.

### Want to play the game?
Here is [the latest version](https://palad1.github.io/Yannicks-s-game/docs/v1) (requires HTML5)
The objective of the game? Get Sonic to cover as much ground as possible within 60 seconds. You can't run on steep hills, and grab those 100 rings, for S U P E R speed!

### Controls

* *W* : Walk
* *R* : Run
* *J* : Jump


## Requirements
If you want to hack-away at this game and modify it, you will need the following: 

* [Love2d](https://love2d.org)
* A text editor (we used [Zerobrane Studio](https://studio.zerobrane.com))
* A bit of patience and lots of passion

## Lessons and Chapters

Each day we would spend a couple of hours in front of the computer and learn Lua together, as well as the Love2d api. Each day we built on what we had the previous day. I did most of the math (wrong) and the coding was done 4-handed. We stayed clear of the LUA warts (OOP) and tried to keep design patterns at bay (but we will have to cleanup after session 8, that's a given).

* [Lesson 0: hello love](/0-start) - intro to the language
* [Lesson 1: what is a sprite?](/1-sprite) - load an image and display it (please don't sue us)
* [Lesson 2: how do I sprite my bob?](/2-animations) - create animations off a spritesheet
* [Lesson 3: over the hills...](/3-level) - random generation of a 'level'
* [Lesson 4: ... and far away](/4-scrolling) - add scrolling, and generate an infinite level
* [Lesson 5: gotta go fast!](/5-moving) - walk/run/idle modes
* [Lesson 6: shadow of the beast](/6-background) - parralax effect
* [Lesson 7: time flies like an arrow](/7-timer) - game-over condition
* [Lesson 8: bling](/8-rings) - add rings, superspeed mode, poor man's gradient

## Methodology

We started with an hour of so of lua example, what's a number, what's a string, how do I add stuff, print, create variables, test conditions, loop, and moved to lua very quickly.

I expressly glossed over anything that was not required to get the game running. Yest most things are globals, yes there are no classes and ther are no naming conventions, but all that was done to keep things familiar for a 11 year old.

Our next project will be a Reactive Entity-Component rewrite of this game in rust ;)

## Last words:
We really had lots of fun doing this, the math was hard for both of us and what I can't share here is the pile of drawings we used to work-out the math, animations and 'design' of the objects. 

## Special Thanks

* [Math Is Fun](https://www.mathsisfun.com/sine-cosine-tangent.html) - great resource for some material that was not covered in my nephew's class.
* [Spriters Resource](https://www.spriters-resource.com) for the lovely spritesheets
* [SpaceRip](http://www.spacerip.com) for the Jupiter Background
* [Frontier Studio](http://elitedangerous.com) for the awesome unused wallpapers


