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

# What is the mimimum viable product?
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

