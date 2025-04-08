`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 18:07:31
// Design Name: 
// Module Name: convertToCoords
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


module coords(
    input [12:0] pixel_index,
    output [7:0] x,
    output [6:0] y
    );
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
endmodule