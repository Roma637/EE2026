`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 21:32:37
// Design Name: 
// Module Name: draw_chicken
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


module draw_chicken#(
    parameter TOP_LEFT_X = 0,
    parameter TOP_LEFT_Y = 0,
    parameter LENGTH = 12,
    parameter WIDTH = 12
)(
    input clk_25MHz,
    input [6:0] x, y,
    output reg [15:0] oled_data
    );
    
    always @(clk_25MHz) begin
        // Check if pixel is inside the box
        if ((x >= TOP_LEFT_X && x < TOP_LEFT_X + LENGTH) &&
            (y >= TOP_LEFT_Y && y < TOP_LEFT_Y + WIDTH) &&
            (x == TOP_LEFT_X || x == TOP_LEFT_X + LENGTH - 1 ||
             y == TOP_LEFT_Y || y == TOP_LEFT_Y + WIDTH - 1))
            oled_data = 16'hee37;  // peachish
        else
            oled_data = 16'h0000;  // Black background
    end
endmodule
