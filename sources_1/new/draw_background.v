`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 14:35:12
// Design Name: 
// Module Name: draw_background
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


module draw_background(
input clk,
input [12:0] pixel_index,
output reg [15:0] oled_data
    );
    wire [6:0] x;
    wire [6:0] y;
    convertToCoords coords0 (pixel_index, x, y);
    always @(posedge clk) begin
        if (y%6 < 4) begin
            oled_data <= 16'b01001_001000_00000;
        end
        else begin
            oled_data <= 16'b00101_000101_00000;
        end
    end    
endmodule
