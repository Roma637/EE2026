# Cooked! - FPGA Cooking Game

## Introduction

Welcome to Cooked! This is a single-player cooking game inspired by Overcooked, implemented directly onto a Basys 3 FPGA board. Race against the clock to assemble complex dishes by gathering, preparing, and serving ingredients. Can you handle the heat and become a master chef in this hardware-based culinary challenge?

## How it Works

The entire game logic runs on the Basys 3 FPGA. Players navigate a four-quadrant kitchen using the board's buttons. Ingredients are grabbed from designated zones, processed using interactive mini-games at chopping and boiling stations (controlled via switches and monitored on the 7-segment display), and finally served to fulfill dynamic orders shown on an OLED screen.

## Features

* **Pure Hardware Thrills:** Experience unique gameplay running directly on the Basys 3 FPGA!
* **Master the Ingredients:** Juggle multiple ingredients like onions, rice, chicken, and tomatoes to craft delicious meals.
* **Exciting, Randomized Dishes:** Each game presents a new challenge with 3 pseudo-randomly selected dish orders out of several possibilities, demanding adaptability and quick thinking for maximum replayability!
* **Engaging Mini-Games:** Test your reflexes with challenging chopping and boiling mini-games using the FPGA's switches and LEDs. Precision is key!
* **Intelligent Zone Detection:** The game precisely senses when your character is fully within a cooking or ingredient zone using dedicated hitboxes, ensuring accurate interaction.
* **High-Stakes Cooking:** Careful! Leaving a cooking station mid-task means you fail the mini-game and lose that precious ingredient – manage your time and actions wisely!
* **Multi-Display Interface:** Keep track of the action with dedicated OLED screens for map/position and orders/inventory, plus the 7-segment display for the crucial timer, mini-game tasks, and your final glorious score.
* **Beat the Clock Scoring:** Your performance is rated based on the number of completed orders multiplied by the precious seconds remaining on the timer. Speed and efficiency lead to victory!

## How to Play

1.  **Hardware:** You need a Basys 3 FPGA board.
2.  **Setup:** Grab the zip file from the releases section, and flash it onto your Basys 3 board.
3.  **Start Game:** Press the center button (btnC) on the start screen to begin the 5-minute countdown!
4.  **Gameplay:**
    * Use `btnU`, `btnD`, `btnL`, `btnR` to navigate the kitchen.
    * Use switches `sw[3:0]` to open the corresponding doors between zones (remember, only one can be open at once!).
    * Dash to an ingredient zone and press `btnC` to grab a raw item. Check your inventory on the left OLED.
    * Race the ingredient to the correct station (chopping/boiling).
    * Follow the mini-game prompts on the 7-segment display, using switches (`sw[13:10]` for chopping, `sw[15:8]` for boiling) to succeed. *Don't bail mid-task, or the ingredient is lost!*
    * Grab the prepared ingredient once the station animation completes.
    * Combine the correct ingredients (check the order list on the left OLED) at the serving station to complete orders!
5.  **Objective:** Serve as many orders as possible before time expires! Aim for that high score!

## Demo Video
[![Cooked! Demo](https://img.youtube.com/vi/O5UnHBDp72E/0.jpg)](https://www.youtube.com/watch?v=O5UnHBDp72E)
