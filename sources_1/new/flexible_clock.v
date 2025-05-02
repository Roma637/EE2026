`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 15:26:05
// Design Name: 
// Module Name: flexible_clock
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


module flexible_clock(
    input basys_clk,
    input [31:0] m,
    output reg clk_6p25MHz
    );
    reg [31:0] COUNT = 0;
        
    initial begin
        clk_6p25MHz = 0;
    end
    
    always @(posedge basys_clk) begin
        COUNT <= (COUNT == m) ? 0 : COUNT + 1; 
        clk_6p25MHz <= (COUNT == 0) ? ~clk_6p25MHz : clk_6p25MHz;
    end
endmodule
