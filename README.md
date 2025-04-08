# Table of contents
- [How to run the game](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#how-to-run-the-game)
- [Resource briefing](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#resource-briefing)
    - [Proposal abstract](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#proposal-briefing)
    - [Tools I'm using for this project](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#tools-im-using-for-this-project)
        - [Project management](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#project-management)
        - [Game design](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#game-design)
        - [IDE choice](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#ide-choice)
        - [Misc.](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#misc)
- [What is the mimimum viable product?](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#what-is-the-minimum-viable-product)
    - [General requirements](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#general-requirements)
    - [Game specific requirements](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#game-specific-requirements)
- [Alpha release briefing](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#alpha-release-briefing)
    - [Purpose](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#purpose)
    - [Measure of success](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#measure-of-success)
    - [Game concepts](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#game-concepts)
    - [The engine](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#the-engine)
        - [What is given to you](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#what-is-given-to-you)
        - [Includes](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#includes)
    - [Key data structures and algorithms](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#key-data-structures-and-algorithms)
        - [Key data structures](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#key-data-structures)
        - [Key algorithms](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#key-algorithms)
    - [Problems](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#problems)
    - [Expansion and customization](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#expansion-and-customization)
- [Beta release briefing](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#beta-release-briefing)
    - [Requirements met/not met](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#requirements-metnot-met)
        - [Requirements met](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#requirements-met)
        - [Requirements not met](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#requirements-not-met)
    - [Methods](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#methods)
    - [Project management](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#project-management-1)
    - [What I learned](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#what-i-learned)
    - [Problems and solutions](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#problems-and-solutions)
    - [What next?](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#what-next)

# How to run the game:
- To open the file, first figure out your OS in the naming scheme. Then download only that file to your machine from GitHub, and open it on your machine. 
    - For MacOS, download and open game.app, then go to Contents, then MacOS and launch the game file.
    - For linux, download and open linux then run the game file, however you choose to do so.
    - For Windows, download and open windows and run game.exe.

# Resource briefing

## Proposal Briefing
I want to do a video game for this project, because I wish to go into game development after college. The games name will be Puzzles? Now with Death!. The genres of the game will be mostly puzzle, with a little bit of beat ’em up/fighting. The reasoning behind this is because the game will be about completing weapons first and foremost. The secondary objective is to have the player fight a ”boss” with those weapons. This allows the player to not only experience a vast array of unique puzzles, but different play styles with the various weapons as well.

## Tools I'm using for this project

### Project management
- The tools I’m using for project management is TODO’s in the code, placed at the top of one of the main files I’m always visiting. For version control, I’m using both Git command line and GitHub, these allow me to be versatile and update the game from any machine that I’ve cloned the game to. 

### Game desgin
- To design my game, I’m using paper and drawing each sprite ahead of time, planning out what I want them to look like before making them in PICO-8.
    - I chose PICO-8 because of the simplicity, and also other people have recommended it to me, the language itself is quite similar to Python as well, so it made learning the language fast and really easy. 
    - There are no tools for documenting PICO-8’s specific version of Lua, so I will be doing it myself, unfortunately. For presenting my project, I’m using the bin export PICO-8 provides with the program in order to provide a game that you don’t have to download any other software in order to play. 

### IDE choice
- For writing software, I’m using Visual Studio Code with the _pico8-ls_ extension to be able to read the code with colors more effectively. For testing software, since I can’t write unit tests, I have to rely on playing the game in order to test how the code is doing, and this can also rely on other people testing the code in order to let me know how it’s working, and what is broken/bugging out. 
    - The reason I chose Visual Studio Code is because the built-in code editor for PICO-8 is not that good, and it’s really restrictive on the width and height for the visible code you can se, also I just like coding in VS Code more, since it’s more popular in the industry.

### Misc.
- I’ve also used Youtube quite a bit in order to understand the Lua language better. 

# What is the minimum viable product?
The mimimum viable product is a .bin file with four files that let the user play it on different systems (Rasberry PI, Windows, Mac, Linux)

## General requirements:
Well, I think the most obvious answer to this, is that the player should be able to launch the game. In order to stick to specifics about the game, I’ll list the general requirements first, but I won’t describe them in detail like I will for the requirements about the game itself. The general requirements will be as follows:
- The game should be able to launch and run.
- The game should be able to close properly.
- The game should be not crash during play.
- The game should maintain a consistent amount of frames per second (also referred to as FPS).
- The game should not fall below 15 FPS in normal play.
- The game should be accessible to anyone on any platform.
- The game should be able to run on any system.

## Game specific requirements
The mimimum viable product for this project, is a game in which, there is a character that you can play and move around the screen. I'll now list some specific requirements that are unique to my project.

### Menu actions
-  The player should be able to access a pause menu while playing, this is they can access the save and load features from before. 
    - On top of that, the player should be able to quit the game whilst in the pause menu, and it should stop, this is for ease-ability, so the player doesn’t have to go to the main menu every single time to close the game. 

#### Saving and loading
- First, the player should be able to both save and load their game, this is so you don’t have to play the game in one sitting and the player can take breaks from the game whenever. 
- After that, the player should load into a main menu for the game, this is so they can continue their play through from anywhere. 
    - When the player hits "play" from the main screen it will attempt to load the most recent save file the player was on.
    - The select screen will display all the levels the player has played on correctly, as long as the player has saved manually recently.

### Map and camera
- Next, the player should be able to move around the map in any direction they please, this is so they can play the game. Next, a camera should follow the player whenever they move, this is so the player can see all of the map!
    - The camera should not go past the beginning or the end of the map.
    - The player should not be able to escape the map boundaries

### Attacking
- Next, the player should be able to attack via a button press, this is so they can fight the boss at the end of each level. 
    - The player should not be able to move while holding down an attack
        - On top of this, the player should do more damage the longer they hold the attack button
    - The player should be able to swap between two different weapons and use them interchangeably

I think that these requirements actually encompass the game better, I also think they fit what I want to go for better
than the general requirements.


# Alpha release briefing

## Purpose
The purpose of my project is to gain valuable insight into how the game design process works and at the same time learn a new programming language. An employer looking at this project will see the game, fully realized, and they will also be able to see how I approached handling the different difficulties of creating a game [basically] from scratch.

## Measure of success
3,227 lines of code (as of v.1.3.0) and 65 different functions across 3 different files, with 38 of them being in _.movement.p8_ (as of v.1.3.0)

## Game concepts
- FPS is one of the most important things in video games, the higher the FPS, the smoother the gameplay, this game only runs at _30 fps flat_, although it can be changed to 60, I am keeping it at 30 for the final release.
- The game uses a coordinate system, but you don’t need to understand it to play the game, if you were making a game in PICO-8 though, you would need to know that x = 0 and y = 0 starts at the top left and goes to x = 1024 and y = 512
- So the way Lua works, everything is a global variable unless you declare it _local_ inside of a functions’ scope. The main global variable the game always has is the _player_ variable, referenced by using _player.x_, _player.y_, _player.sp_, etc.

## The engine

### What is given to you
PICO-8 gives you literally nothing to start with, you are given the engine itself, and the ability to type bash like commands (help, load, save, cd, etc) which allow you save and load the different files you create. The only files I have are _——.p8_ files which contain all the data that the files need, however you can use _#include ——.p8_ or _#include ——.lua_ to import different files that contain functions that you want to use, this is the strategy I use when making the levels, instead of creating the functions over and over again, or including from the level files, I created the _.movement.p8_ and _.movement2.p8_ files, which contain all the level code that I want to use. The dot naming scheme in PICO-8 is to signify that you don’t want to include that file in the _splore_ function that’s included in the PICO-8 engine once you buy it.

### Includes
As explained in the above section, PICO-8 doesn't use the traditional import statements as many other langauges do, but it uses the _#include_ statement for importing differnet files into your file that your working on. Here is a picture of my _#includes_ (and other code) from _.level3.p8_.

![includes example](https://github.com/professionaldiot/puzzles_now_with_death/blob/main/images/includes.png?raw=true)

## Key data structures and algorithms

### Key data structures
The main data structure of PICO-8's Lua is tables, they can act like lists or, how most people use them, dictionaries with a little extra functionality. 

![tables example](https://github.com/professionaldiot/puzzles_now_with_death/blob/main/images/tables.png?raw=true)

(Referencing the above image here) So take the x value of player, your question might be, how do I reference this in PICO-8's system? There are three different way's to do this, the most popular seeming to be the dot structure to referencing, as seen in the below image.

![player dot structure example](https://github.com/Professionaldiot/Puzzles_Now_With_Death/blob/main/images/player_example.png?raw=true)

There are other ways to do this, but I've removed them all from my code, so I'll just put them in _italics_ here. The second most popular way to reference these values is what I call the dictionary reference, since it's referenced similarly to Python's dictionaries, the way to reference in this fashion is (using player.x here again) _player['x']_ or _player["x"]_ (either way works, but i used the single quote more). And finally the least popular way to reference them is by index, so lets take _player.dead_ in the above table, you could reference it like _player[1]_ (PICO-8s' Lua starts at 1, not 0), but this is not a good coding practice, as if you put something else before it, now the code where you referenced it is broken, and has to be changed, so the other two, referencing by the name, is much more popular.

I said at the beginning that tables can work like lists too, and in this case, I've done this a lot, take for example, the list of tables that contains button information for _.level2.p8_ (the image below).

![level 2 buttons](https://github.com/professionaldiot/puzzles_now_with_death/blob/main/images/lvl2_buttons.png?raw=true)

This is what the initilization for those buttons looks like. As you can see, the data structure is a table of tables that contain the information I need, but I'll refer to this type of data structure as a list of tables for simplicity. The way you reference these is a combination of the ways above, instead of saying _lvl2_buttons[{...}].x_ we can say _lvl2_buttons[1].x_, which is much more useful in this case, and that's in fact how I use it in code when referencing these, and it also makes it possible to use for loops with integers as the variable possible. Speaking of that, PICO-8 has the unique syntax _for btn in all(btnlst) do ..._ which (assuming _btnlst_ is a list of buttons like the example before), takes each value of that table and lets me do stuff like _for btn in all(btnlst) do __if btn.pressed then foo() end__ end_ which allows the simplicity of code even more. The other way of using tables is as a literal list of data (or as in the example below, a list of integers, just look at the not crossed out part of the function call)

![function call with a list of ints](https://github.com/professionaldiot/puzzles_now_with_death/blob/main/images/combo_list.png?raw=true)

These are simply referenced with an integer value, as it's the easiest way to do it.

### Key algorithms
The only algorithms you have in PICO-8 are the ones you make yourself, I'll show the images of the bot algorithm I made, but in order to simplify it, all you need to know is that the bot moves towards the player and once it's close enough it attacks the player, and if it hits the player, it removes health from the player. If the player is above the bot, the bot jumps to move towards the player.

![update_bot() function](https://github.com/professionaldiot/puzzles_now_with_death/blob/main/images/update_bot.png?raw=true)
![move_to_goal() function](https://github.com/professionaldiot/puzzles_now_with_death/blob/main/images/move_to_goal.png?raw=true)
![check_px() function](https://github.com/professionaldiot/puzzles_now_with_death/blob/main/images/check_px.png?raw=true)

## Problems
I have encoutered many problems developing this code, such as the bot attempting to jump towards the player, just to go away from it immediately and repeat that process, or the Off By One Error that happened when creating the weapons on _.level1.p8_, for which, I simply increased the limit of how many times the code ran by one, but it took me a while to figure out that was happneing. Over all, in game development, the bugs you make while making the game kind of create the experience of finding what's causing those problems and fixing them. Sometimes they're small, like the weapon example, but sometimes they're big, like bot bug I started this off with, whatever bug appears though, will be fixed usually within the version, unless it isn't impacting gameplay super heavily.

## Expansion and customization
After the game is compiled, the player can't change anything about the game, so custimaztion is quite low, but for expansion, I could always add more levels. Just recently (as of like v1.2.3 or v.1.2.4) I made the functions for the puzzles able to be used on any level instead of level specific, so if someone wanted to, they could redesign my levels if they knew what they were doing.

# Beta release briefing

## Requirements met/not met
Most of the requirements I set out for myself, I hit, there were only a few left that I wasn't able to do by the time of April 4th, 2025, but to be fair to myself in the past, I did not know that the last three days would be reserved for writing a retrospective, so when I planned all the stuff I wanted to do, I created those tasks with that idea in mind.

### Requirements met
With that in mind, the requirements I did meet from my proposal are as follows:
- Design and implement new character designs
- Redesigning level 1 and 2
    - On top of this, level 1 became a tutorial level to introduce the player to the mechanics of the level
- Added the boss room file
    - Added the bot to that file, and ensured that it was working, also got the bot to fall and jump, but not climb
- Added in attacking with two different weapons
    - The catch is that when you pick up a new weapon, you gain the stats of it, instead of it being displayed on screen
    - Added a weapon pickup system
- Designed more puzzles mechanics
    - Portals
    - Platform
    - Bridge & parkour
    - A combo lock system which requires the player to input the correct sequence of buttons in order to unlock a door
    - A door system, which can be unlocked by either a combo lock, or a singular button
    - A damaging circle system, which damages the player when inside of it
- Some sound effects were implemented for specific actions the player takes

### Requirements not met
Even with all of those I did meet from the proposal, there are only a few that I did not get around to
- Making it possible for the bot to climb ladders
    - Not needed in the boss room, since there are no ladders
- Getting the layouts of levels to save correctly for each individual level
    - Not needed, and too complicated to implement in the timeframe I had
- Music and sounds
    - I didn't get as many music and sound effects as I wanted to into the levels
    - If I had more time, this is what I would be working on in the final stretch of the project

## Methods
 
![showoff of level2](https://github.com/professionaldiot/puzzles_now_with_death/blob/main/images/level2.gif?raw=true)

As seen in the gif above, level 2 is organized in a way that is simple, but still complicated in a way that isn't easy to finish if you haven't found the solution already. The organization, as described in the [Alpha release briefing](https://github.com/Professionaldiot/Puzzles_Now_With_Death?tab=readme-ov-file#alpha-release-briefing), is quite simple, I put all the important functions into two main files, .movement.p8 and .movement2.p8 

![organization of filews](https://github.com/professionaldiot/puzzles_now_with_death/blob/main/images/organization.png?raw=true)

Also in the Alpha release briefing, was this image:

![tables example](https://github.com/professionaldiot/puzzles_now_with_death/blob/main/images/tables.png?raw=true)

This image shows one of the most useful data structures in PICO-8's Lua, tables, which, as a reminder, can act as unindexed dictionaries, or indexed lists. When naming variables (the difference between global and local variables is covered in the Alpha release briefing), I chose to name global variables in a way that would describe them well enough if someone were to be looking from the outside, it could still make sense to them as well. Meanwhile, for local variables/function variables I named them in a way that made sense for the function, so if a function needed a list of tables for the buttons for a level, I would describe it as *function btn_update(btn_list)*, this shows clearly that the function needs to take in a list of btns, which in this case, is a list of tables.

![documentation example](https://github.com/professionaldiot/puzzles_now_with_death/blob/main/images/documentation.png?raw=true)

This image shows the way I had been documenting the functions that I created, even functions without variables got this treatement, this was to number one, make it easier for me to remember what each function did at a quick glance, and number two, tell others that view the code what each function does at a glance, this is so if someone were to want to modify, let's say level 2 for example, they could if they knew what they were doing, and the documentation only makes it easier. I created this documentation style for my own programming in Lua, it was so I didn't go insane while making this project. Most of the tools I'm using are either PICO-8 itself, or through the code that I see in Visual Studio Code.

## Project management
I did not use any specific tools for project management, but to track progress, I did this in the way of version control, when this project started, before it was on github, it was on v0.5.0, and as of this momement it is currently at v1.6.3, each increase in vx.1-9.x  denotes a change that fundamentally changes how the game was running, or how the game is working, each release of a v0-1.1-9.0 is a release that adds new functions, and I usually released the .bin for these releases too, although I have released for the other versions, anything that is a version of v0-1.1-9.1-9 is working towards the previous type of versioning (v0-1.1-9.0), slowly adding new functions that interact or change how the game functions, but are not fully implemented yet. The big v1.0.0.0 release, was a major release, this was when I finished the bot, and was happy enough with it that I could move on from it. If you are a programmer, you might realize this is semantic versioning, which just comes naturally to me.

## What I learned
Through this project, I learned that the game dev process is quite harsh for just one person to be doing, and that if done by one person you need quite a bit of time to develop a game that is enjoyable by the playerbase. I still enjoyed this process, and it taught me a lot of valuable insight about the process while letting me explore a new programming langauge.

## Problems and solutions
The biggest rock in the road, to say, was bugs, and there were so many when making the enemy's 'ai', like the bug causing him (I call the bot a him) to "windmill" around one spot when the player climbed up a ledge. The solution for this was to just make the bot move towards the player while in the air, which stopped this behavior for the most part, but it can still happen when the player is above the bot and there is a ground piece between them. 

## What next?
If I had more time, I would've added more sounds and music into the levels, and maybe added more unique puzzle ideas. 