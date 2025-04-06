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
    input clk_25MHz,
    input [6:0] x, y,
    input [6:0] character_y_top, character_y_bot, character_x_left, character_x_right,
    output led,
    output [15:0] oled_data
    );
    wire [15:0] oled_onion, oled_chop, oled_rice, oled_boil, oled_tomato, oled_chicken;
    
    parameter LENGTH = 12;
    parameter WIDTH = 12;
    
    parameter ONION_TOP_LEFT_X = 3;
    parameter ONION_TOP_LEFT_Y = 3;
    
    oneStation #(.TOP_LEFT_X(ONION_TOP_LEFT_X), .TOP_LEFT_Y(ONION_TOP_LEFT_Y), .LENGTH(LENGTH), .WIDTH(WIDTH)) 
    onion_drawer_inst (.clk_25MHz(clk_25MHz), .x(x), .y(y), .oled_data(oled_onion));
    
    assign oled_data = oled_onion;
    
    inOnionStation #(
        .LENGTH(LENGTH),
        .WIDTH(WIDTH),
        .ONION_TOP_LEFT_X(ONION_TOP_LEFT_X),
        .ONION_TOP_LEFT_Y(ONION_TOP_LEFT_Y)
        ) checker0 (
        .character_y_top(character_y_top), 
        .character_y_bot(character_y_bot), 
        .character_x_left(character_x_left), 
        .character_x_right(character_x_right),
        .inStation(led));
//    oneStation #(.TOP_LEFT_X(32), .TOP_LEFT_Y(3), .LENGTH(LENGTH), .WIDTH(WIDTH)) 
//    chop_drawer_inst (.clk_25MHz(clk_25MHz), .x(x), .y(y), .oled_data(oled_chop));
        
//    oneStation #(.TOP_LEFT_X(81), .TOP_LEFT_Y(3), .LENGTH(LENGTH), .WIDTH(WIDTH)) 
//    rice_drawer_inst (.clk_25MHz(clk_25MHz), .x(x), .y(y), .oled_data(oled_rice));
    
//    oneStation #(.TOP_LEFT_X(81), .TOP_LEFT_Y(16), .LENGTH(LENGTH), .WIDTH(WIDTH)) 
//    boil_drawer_inst (.clk_25MHz(clk_25MHz), .x(x), .y(y), .oled_data(oled_boil));
    
//    oneStation #(.TOP_LEFT_X(3), .TOP_LEFT_Y(49), .LENGTH(LENGTH), .WIDTH(WIDTH)) 
//    tomato_drawer_inst (.clk_25MHz(clk_25MHz), .x(x), .y(y), .oled_data(oled_tomato));
    
//    oneStation #(.TOP_LEFT_X(32), .TOP_LEFT_Y(49), .LENGTH(LENGTH), .WIDTH(WIDTH)) 
//    chicken_drawer_inst (.clk_25MHz(clk_25MHz), .x(x), .y(y), .oled_data(oled_chicken));
    
//    assign oled_data =  oled_onion | oled_chop | oled_rice | oled_boil | oled_tomato | oled_chicken;
    
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

module inOnionStation #(
    parameter LENGTH = 12,
    parameter WIDTH = 12,
    parameter ONION_TOP_LEFT_X = 3,
    parameter ONION_TOP_LEFT_Y = 3
)(
    input [6:0] character_y_top, character_y_bot, character_x_left, character_x_right,
    output reg inStation
    );
    reg [6:0] onion_left_x = ONION_TOP_LEFT_X;
    reg [6:0] onion_right_x = ONION_TOP_LEFT_X + LENGTH - 1;
    reg [6:0] onion_top_y = ONION_TOP_LEFT_Y;
    reg [6:0] onion_bot_y = ONION_TOP_LEFT_Y + WIDTH - 1;
    always @ (*) begin
        if (character_x_left >= onion_left_x && character_x_right <= onion_right_x
        && character_y_top >= onion_top_y && character_y_bot <= onion_bot_y) begin
            inStation = 1;
        end else begin
            inStation = 0;
        end
    end
endmodule