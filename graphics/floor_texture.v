`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 12:34:36
// Design Name: 
// Module Name: floor_texture
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


module floor_texture(
    input clk,
input [6:0] x,
input [6:0] y,
output reg [15:0] oled_data
    );
    
    always @(posedge clk) begin
        if (y%6 < 4) begin
            oled_data <= 16'b10011_010000_00000;
        end
        else begin
            oled_data <= 16'b01011_001010_00000;
        end
    end
    
endmodule
