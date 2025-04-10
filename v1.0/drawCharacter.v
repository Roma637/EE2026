`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2025 15:41:31
// Design Name: 
// Module Name: drawCharacter
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


module drawCharacter(
    input basys_clk,
    input [12:0] pixel_index,
    input [6:0] character_x_left, character_x_right, character_y_top, character_y_bot,
    output reg [15:0] oled_data
    );
    
    wire clk_25MHz;
    flexible_clock clk1(basys_clk, 1, clk_25MHz);
        
    wire [6:0] x;
    wire [6:0] y;
    convertToCoords coords0 (pixel_index, x, y);
    
    reg is_in_character_x_range, is_in_character_y_range;
    always @ (posedge clk_25MHz) begin
        is_in_character_x_range = (x <= character_x_right && x >= character_x_left);
        is_in_character_y_range = (y <= character_y_bot && y >= character_y_top);
        if (is_in_character_x_range && is_in_character_y_range) begin
            oled_data <= 16'b00000_111111_00000; // Green
        end else begin
            oled_data <= 16'b00000_000000_00000; // Black
        end
    end
    
endmodule
