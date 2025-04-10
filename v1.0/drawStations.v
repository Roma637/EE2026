`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2025 16:18:08
// Design Name: 
// Module Name: drawStations
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


module drawStations(
    input basys_clk,
    input [6:0] x, y,
    input [6:0] character_y_top, character_y_bot, character_x_left, character_x_right,
    output isInOnion,
    output isInRice,
    output isInTomato,
    output isInChicken,
    output isInChopper,
    output isInBoiler,
    output isInServer,
    output [15:0] oled_data
    );
    wire [15:0] oled_onion, oled_chop, oled_rice,
    oled_boil, oled_tomato, oled_chicken, oled_server,
    oled_ingredients;
    
    parameter LENGTH = 15;
    parameter WIDTH = 15;
    
    parameter ONION_TOP_LEFT_X = 2;
    parameter ONION_TOP_LEFT_Y = 2;
    
    parameter TOMATO_TOP_LEFT_X = 2;
    parameter TOMATO_TOP_LEFT_Y = 47;
    
    parameter CHICKEN_TOP_LEFT_X = 30;
    parameter CHICKEN_TOP_LEFT_Y = 47;
    
    parameter RICE_TOP_LEFT_X = 51;
    parameter RICE_TOP_LEFT_Y = 2;
    
    parameter CHOPPER_TOP_LEFT_X = 30;
    parameter CHOPPER_TOP_LEFT_Y = 2;
    
    parameter BOILER_TOP_LEFT_X = 79;
    parameter BOILER_TOP_LEFT_Y = 2;
    
    parameter SERVER_TOP_LEFT_X = 70;
    parameter SERVER_TOP_LEFT_Y = 47;
    
    draw_ingredients #(
        .ONION_TOP_LEFT_X(ONION_TOP_LEFT_X),
        .ONION_TOP_LEFT_Y(ONION_TOP_LEFT_Y),
        .TOMATO_TOP_LEFT_X(TOMATO_TOP_LEFT_X),
        .TOMATO_TOP_LEFT_Y(TOMATO_TOP_LEFT_Y),
        .CHICKEN_TOP_LEFT_X(CHICKEN_TOP_LEFT_X),
        .CHICKEN_TOP_LEFT_Y(CHICKEN_TOP_LEFT_Y),
        .RICE_TOP_LEFT_X(RICE_TOP_LEFT_X),
        .RICE_TOP_LEFT_Y(RICE_TOP_LEFT_Y)
    ) ingredient_drawer_inst (
        .clk_25MHz(basys_clk),
        .x(x),
        .y(y),
        .oled_data(oled_ingredients)
    );
    // stove_ready / chop_ready is to start the animation
    reg reset = 0;
    draw_boiler #(
        .BOILER_TOP_LEFT_X(BOILER_TOP_LEFT_X),
        .BOILER_TOP_LEFT_Y(BOILER_TOP_LEFT_Y)
    ) draw_boiler0 (
        .clk(basys_clk),
        .stove_ready(1),
        .reset(reset),
        .x(x),
        .y(y),
        .oled_data(oled_boil)
        );
        
    draw_chopper #(
        .CHOPPER_TOP_LEFT_X(CHOPPER_TOP_LEFT_X),
        .CHOPPER_TOP_LEFT_Y(CHOPPER_TOP_LEFT_Y)
    ) draw_chopper0 (
        .clk(basys_clk),
        .chop_ready(1),
        .reset(reset),
        .x(x),
        .y(y),
        .oled_data(oled_chop)
    );
    
    draw_server #(.TOP_LEFT_X(SERVER_TOP_LEFT_X), .TOP_LEFT_Y(SERVER_TOP_LEFT_Y), .LENGTH(LENGTH), .WIDTH(WIDTH)) 
    server_drawer_inst (.clk_25MHz(basys_clk), .x(x), .y(y), .oled_data(oled_server));
    
    assign oled_data =  oled_chop | oled_boil | oled_server | oled_ingredients;    
        
    checkInStation #(
        .LENGTH(LENGTH),
        .WIDTH(WIDTH),
        .TOP_LEFT_X(ONION_TOP_LEFT_X),
        .TOP_LEFT_Y(ONION_TOP_LEFT_Y)
    ) checkInOnion (
        .character_y_top(character_y_top), 
        .character_y_bot(character_y_bot), 
        .character_x_left(character_x_left), 
        .character_x_right(character_x_right),
        .isInStation(isInOnion)
    );
    
    checkInStation #(
        .LENGTH(LENGTH),
        .WIDTH(WIDTH),
        .TOP_LEFT_X(TOMATO_TOP_LEFT_X),
        .TOP_LEFT_Y(TOMATO_TOP_LEFT_Y)
    ) checkInTomato (
        .character_y_top(character_y_top), 
        .character_y_bot(character_y_bot), 
        .character_x_left(character_x_left), 
        .character_x_right(character_x_right),
        .isInStation(isInTomato)
    );
    
    checkInStation #(
        .LENGTH(LENGTH),
        .WIDTH(WIDTH),
        .TOP_LEFT_X(CHICKEN_TOP_LEFT_X),
        .TOP_LEFT_Y(CHICKEN_TOP_LEFT_Y)
    ) checkInChicken (
        .character_y_top(character_y_top), 
        .character_y_bot(character_y_bot), 
        .character_x_left(character_x_left), 
        .character_x_right(character_x_right),
        .isInStation(isInChicken)
    );
    
    checkInStation #(
        .LENGTH(LENGTH),
        .WIDTH(WIDTH),
        .TOP_LEFT_X(RICE_TOP_LEFT_X),
        .TOP_LEFT_Y(RICE_TOP_LEFT_Y)
    ) checkInRice (
        .character_y_top(character_y_top), 
        .character_y_bot(character_y_bot), 
        .character_x_left(character_x_left), 
        .character_x_right(character_x_right),
        .isInStation(isInRice)
    );
    
    checkInStation #(
        .LENGTH(LENGTH),
        .WIDTH(WIDTH),
        .TOP_LEFT_X(CHOPPER_TOP_LEFT_X),
        .TOP_LEFT_Y(CHOPPER_TOP_LEFT_Y)
    ) checkInChopper (
        .character_y_top(character_y_top), 
        .character_y_bot(character_y_bot), 
        .character_x_left(character_x_left), 
        .character_x_right(character_x_right),
        .isInStation(isInChopper)
    );
    
    checkInStation #(
        .LENGTH(LENGTH),
        .WIDTH(WIDTH),
        .TOP_LEFT_X(BOILER_TOP_LEFT_X),
        .TOP_LEFT_Y(BOILER_TOP_LEFT_Y)
    ) checkInBoiler (
        .character_y_top(character_y_top), 
        .character_y_bot(character_y_bot), 
        .character_x_left(character_x_left), 
        .character_x_right(character_x_right),
        .isInStation(isInBoiler)
    );
    
    checkInStation #(
        .LENGTH(LENGTH),
        .WIDTH(WIDTH),
        .TOP_LEFT_X(SERVER_TOP_LEFT_X),
        .TOP_LEFT_Y(SERVER_TOP_LEFT_Y)
    ) checkInServer (
        .character_y_top(character_y_top), 
        .character_y_bot(character_y_bot), 
        .character_x_left(character_x_left), 
        .character_x_right(character_x_right),
        .isInStation(isInServer)
    );


endmodule

module hasOnion(
    input clk,
    input btnPulse,
    output reg holding
);
    always @ (posedge clk) begin
        if (btnPulse) begin
            holding <= ~holding;
        end
    end
endmodule

// module checks if character is in the station range
// returns inStation which is 1 if in, or 0 when outside
module checkInStation #(
    parameter LENGTH = 0,
    parameter WIDTH = 0,
    parameter TOP_LEFT_X = 0,
    parameter TOP_LEFT_Y = 0
)(
    input [6:0] character_y_top, character_y_bot, character_x_left, character_x_right,
    output reg isInStation
    );
    reg [6:0] station_left_x = TOP_LEFT_X;
    reg [6:0] station_right_x = TOP_LEFT_X + LENGTH - 1;
    reg [6:0] station_top_y = TOP_LEFT_Y;
    reg [6:0] station_bot_y = TOP_LEFT_Y + WIDTH - 1;
    
    // calculate smaller boundary for logic detection
    // to make it easier to be considered in the zone
    // x = 6, y = 5 so 6 by 5 detection zone
    wire [6:0] detect_y_top = character_y_top + 4;
    wire [6:0] detect_y_bot = character_y_bot - 1;
    wire [6:0] detect_x_left = character_x_left;
    wire [6:0] detect_x_right = character_x_right;
    
    always @ (*) begin
        if (detect_x_left >= station_left_x && detect_x_right <= station_right_x
        && detect_y_top >= station_top_y && detect_y_bot <= station_bot_y) begin
            isInStation = 1;
        end else begin
            isInStation = 0;
        end
    end
endmodule