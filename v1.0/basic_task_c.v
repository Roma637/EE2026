`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2025 13:49:25
// Design Name: 
// Module Name: basic_task_c
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


module basic_task_c(
    input basys_clk,
    input [12:0] pixel_index,
    output reg [15:0] oled_data
    );
    
    wire [6:0] x;
    wire [6:0] y;
    convertToCoords coords0 (pixel_index, x, y);
    
    wire clk_30Hz;
    flexible_clock clk0(basys_clk, 1_666_667, clk_30Hz);
    
    reg [6:0] bot_y = 11;
    reg [6:0] left_x = 84;
    
    reg [6:0] left_x2 = 84;
    
    reg [4:0] state = 5'b00001;
     
    always @(posedge clk_30Hz) begin
        if (state[0]) begin 
            if (x > left_x && x < 95 && y >= 0 && y < bot_y) begin
                oled_data <= 16'b11111_111111_00000; //yellow
            end else begin
                oled_data <= 16'd0;
            end
            if (bot_y < 63) begin
                bot_y <= bot_y + 1;
            end else begin
                state <= 5'b00011;
            end
        end else if (state[0] && state[1]) begin
            if ((x > left_x && x < 95 && y >= 0 && y < bot_y) ||
             (x < 95 && x > left_x2 && y < 63 && y > bot_y)) begin
                oled_data <= 16'b11111_111111_00000; // yellow
            end else begin
                oled_data <= 16'd0;
            end
            if (left_x2 > 47) begin
                left_x2 <= left_x2 - 1;
            end else begin
                state <= 5'b00111;
            end
        end
    end
endmodule
