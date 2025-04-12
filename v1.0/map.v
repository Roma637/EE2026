`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 15:49:00
// Design Name: 
// Module Name: map
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module map(
    input basys_clk,
    input [12:0] pixel_index,
    input [15:0] sw,
    input btnU,
    input btnD,
    input btnL,
    input btnR,
    input btnC,
    input start_game, // like the reset for this module
    output [7:0] seg, 
    output [3:0] an,
    output [15:0] led,
    output [15:0] oled_data,
    output [11:0] inventory
    );
    
    wire [6:0] x;
    wire [6:0] y;
    convertToCoords coords0 (pixel_index, x, y);
    
    // CHARACTER PARAMETERS ==============================================================
    parameter CHARACTER_WIDTH = 6;
    wire [6:0] character_center_x, character_center_y;
    wire [6:0] character_y_top, character_y_bot, character_x_left, character_x_right;
      
    // MAP PARAMETERS ====================================================================
    // centers of the respective gaps, 2 gaps per horizontal / vertical line
    // horizontal marks x value, vertical marks y value
    parameter H_LEFT_GAP_CENTER = 23; 
    parameter H_RIGHT_GAP_CENTER = 72;
    parameter V_TOP_GAP_CENTER = 15;
    parameter V_BOT_GAP_CENTER = 48;
    
    // gap size is +1 of this due to the center of the gap
    // for simple implementation of gap
    // original gap_size = 12
    parameter GAP_SIZE = 18;
    parameter LINE_WIDTH = 2;

    localparam MAP_CENTER_X = 48;
    localparam MAP_CENTER_Y = 32;
    
    // HORIZONTAL_LINE_TOP is top boundary of horiztonal line, exclusive etc
    // ie drawing should exclude drawing this pixel
    parameter HORIZONTAL_LINE_TOP = MAP_CENTER_Y - LINE_WIDTH/2 - 1;
    parameter HORIZONTAL_LINE_BOT = MAP_CENTER_Y + LINE_WIDTH/2 + 1;
    parameter VERTICAL_LINE_LEFT = MAP_CENTER_X - LINE_WIDTH/2 - 1;
    parameter VERTICAL_LINE_RIGHT = MAP_CENTER_X + LINE_WIDTH/2 + 1;
    
    // marks the top and bottom points of top and bottom gaps (y value), inclusive
    parameter TOP_GAP_TOP = V_TOP_GAP_CENTER - GAP_SIZE/2;
    parameter TOP_GAP_BOT = V_TOP_GAP_CENTER + GAP_SIZE/2;
    parameter BOT_GAP_TOP = V_BOT_GAP_CENTER - GAP_SIZE/2;
    parameter BOT_GAP_BOT = V_BOT_GAP_CENTER + GAP_SIZE/2;
    
    // marks the left and right points of left and right gaps (x value), inclusive
    parameter LEFT_GAP_LEFT = H_LEFT_GAP_CENTER - GAP_SIZE/2;
    parameter LEFT_GAP_RIGHT = H_LEFT_GAP_CENTER + GAP_SIZE/2;
    parameter RIGHT_GAP_LEFT = H_RIGHT_GAP_CENTER - GAP_SIZE/2;
    parameter RIGHT_GAP_RIGHT = H_RIGHT_GAP_CENTER + GAP_SIZE/2;
    
    
    wire [15:0] oled_map, oled_character, oled_stations;
    
    movementController #(
        .CHARACTER_WIDTH(CHARACTER_WIDTH),
        .LEFT_GAP_LEFT(LEFT_GAP_LEFT),
        .LEFT_GAP_RIGHT(LEFT_GAP_RIGHT),
        .RIGHT_GAP_LEFT(RIGHT_GAP_LEFT),
        .RIGHT_GAP_RIGHT(RIGHT_GAP_RIGHT),
        .TOP_GAP_TOP(TOP_GAP_TOP),
        .TOP_GAP_BOT(TOP_GAP_BOT),
        .BOT_GAP_TOP(BOT_GAP_TOP),
        .BOT_GAP_BOT(BOT_GAP_BOT),
        .VERTICAL_LINE_LEFT(VERTICAL_LINE_LEFT),
        .VERTICAL_LINE_RIGHT(VERTICAL_LINE_RIGHT),
        .HORIZONTAL_LINE_TOP(HORIZONTAL_LINE_TOP),
        .HORIZONTAL_LINE_BOT(HORIZONTAL_LINE_BOT)
    ) movement_inst (
        .basys_clk(basys_clk),
        .btnU(btnU),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .character_center_x(character_center_x),
        .character_center_y(character_center_y),
        .character_y_top(character_y_top),
        .character_y_bot(character_y_bot),
        .character_x_left(character_x_left),
        .character_x_right(character_x_right)
    );
    
    // recalculate the top y and left x bounds from the collision center for drawing
    draw_character character_drawer_inst (
        .basys_clk(basys_clk),
        .x(x),
        .y(y),
        .character_x(character_center_x - 4),
        .character_y(character_center_y - 5),
        .btnU(btnU),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .oled_data(oled_character)
    );
    
    drawMap #(
        .HORIZONTAL_LINE_TOP(HORIZONTAL_LINE_TOP),
        .HORIZONTAL_LINE_BOT(HORIZONTAL_LINE_BOT),
        .LEFT_GAP_LEFT(LEFT_GAP_LEFT),
        .LEFT_GAP_RIGHT(LEFT_GAP_RIGHT),
        .RIGHT_GAP_LEFT(RIGHT_GAP_LEFT),
        .RIGHT_GAP_RIGHT(RIGHT_GAP_RIGHT),
        .VERTICAL_LINE_LEFT(VERTICAL_LINE_LEFT),
        .VERTICAL_LINE_RIGHT(VERTICAL_LINE_RIGHT),
        .TOP_GAP_TOP(TOP_GAP_TOP),
        .TOP_GAP_BOT(TOP_GAP_BOT),
        .BOT_GAP_TOP(BOT_GAP_TOP),
        .BOT_GAP_BOT(BOT_GAP_BOT)            
    ) map_drawer_inst (
        .basys_clk(basys_clk),
        .x(x),
        .y(y),
        .oled_data(oled_map)
    );
    
    wire clk_25MHz;
    flexible_clock clk1(basys_clk, 1, clk_25MHz);
    
    
    // wires to check if the character is in the respective zone
    wire isInOnion, isInChopper, isInTomato, isInChicken, isInRice, isInBoiler, isInServer;
    
    // wires for animation of chopping and boiling
    wire boil_done, chop_done, start_boil, start_chop, reset_boil, reset_chop;
    wire [11:0] server_inventory;
    drawStations station_drawer_inst (
        .basys_clk(basys_clk),
        .x(x),
        .y(y),
        .character_x_left(character_x_left), 
        .character_x_right(character_x_right), 
        .character_y_top(character_y_top), 
        .character_y_bot(character_y_bot),
        .server_inventory(server_inventory),
        .isInOnion(isInOnion),
        .isInTomato(isInTomato),
        .isInChicken(isInChicken),
        .isInRice(isInRice),
        .isInChopper(isInChopper),
        .isInBoiler(isInBoiler),
        .isInServer(isInServer),
        .boil_done(boil_done), // to check if the boiling animation is complete
        .chop_done(chop_done),
        .start_boil(start_boil), // to start the animation
        .start_chop(start_chop),
        .reset_boil(reset_boil), // to set back to IDLE state
        .reset_chop(reset_chop),
        .oled_data(oled_stations)
    );
    
    wire [7:0] seg_tasks;
    wire [3:0] an_tasks;
    wire reset_task_password_match;
    wire reset_task_slot_machine;
    ingredient_management ingredient_management (
        .basys_clk(basys_clk),
        .sw(sw),
        .btnC(btnC),
        .isInOnion(isInOnion),
        .isInTomato(isInTomato),
        .isInChicken(isInChicken),
        .isInRice(isInRice),
        .isInChopper(isInChopper),
        .isInBoiler(isInBoiler),
        .isInServer(isInServer),
        .boil_done(boil_done), // to check if the boiling animation is complete
        .chop_done(chop_done),
        .start_boil(start_boil), // to start the animation
        .start_chop(start_chop),
        .reset_boil(reset_boil), // to set back to IDLE state
        .reset_chop(reset_chop),
        .station_serve(server_inventory),
        .reset_task_password_match(reset_task_password_match),
        .reset_task_slot_machine(reset_task_slot_machine),
        .seg(seg_tasks),
        .an(an_tasks),
        .led(led),
        .inventory(inventory)
    );
    
    wire done;
    // if game not started, we keep resetting
    wire [7:0] seg_timer;
    wire [3:0] an_timer;
    seven_seg_timer timer0 (basys_clk, !start_game, seg_timer, an_timer, done);
    
    // if there are tasks going on, then switch to the seg and an for tasks
    assign seg = (reset_task_password_match && reset_task_slot_machine) ? seg_timer : seg_tasks;
    assign an = (reset_task_password_match && reset_task_slot_machine) ? an_timer : an_tasks;
    
    wire [15:0] map;
    assign map = oled_character ? oled_character : oled_map;
    assign oled_data = map ? map :
    oled_stations ? oled_stations :
    16'b0; 
endmodule
