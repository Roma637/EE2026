`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 23:24:28
// Design Name: 
// Module Name: seven_seg_groupID
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


module seven_seg_groupID(
    input basys_clk,
    output reg [7:0] seg,
    output reg [3:0] an
    );
    wire clk_500Hz;
    reg [3:0] state = 4'b1000;
    flexible_clock clk0 (basys_clk, 100_000, clk_500Hz);
    
    always @ (posedge clk_500Hz) begin
        if (state[3]) begin
            seg <= 8'b10010010;
            an <= 4'b0111;
            state <= 4'b0100;
        end else if (state[2]) begin
            seg <= 8'b00110000; //dp on
            an <= 4'b1011;
            state <= 4'b0010;
        end else if (state[1]) begin
            seg <= 8'b11111001; 
            an <= 4'b1101;
            state <= 4'b0001;
        end else if (state[0]) begin
            seg <= 8'b10100100; 
            an <= 4'b1110;
            state <= 4'b1000;
        end
    end
endmodule
