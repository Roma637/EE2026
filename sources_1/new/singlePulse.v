`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2025 16:23:44
// Design Name: 
// Module Name: singlePulse
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


module singlePulse(
    input clk,
    input btnC,
    output pulse
    );
    
    reg q0 = 0;
    reg q1 = 0;
    always @ (posedge clk) begin
        q0 <= btnC;
        q1 <= q0;
    end
    assign pulse = q0 & ~q1;
endmodule   
