`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 22:23:25
// Design Name: 
// Module Name: basic_task_d
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


module basic_task_d(
    input basys_clk,
    input reset_module,
    input [12:0] pixel_index,
    input [3:0] pb,
    output reg [15:0] oled_data
    );
    // pb 3 - up
    // pb 2 - left
    // pb 1 - right
    // pb 0 - down
    
    wire clk_25MHz;
    wire clk_30Hz;
    flexible_clock clk1(basys_clk, 1, clk_25MHz);
    flexible_clock clk2(basys_clk, 1_666_667, clk_30Hz);
    
    wire [6:0] x;
    wire [6:0] y;
    convertToCoords coords0 (pixel_index, x, y);
    
    // right and bot edge of green square
    reg [6:0] right_x = 9;
    reg [6:0] bot_y = 63;
    reg [6:0] green_square_size = 10;
    reg [6:0] red_square_size = 30;
    reg [3:0] state = 0; //state of pb pressed
    
    // movement
    always @(posedge clk_30Hz) begin
        if (reset_module) begin
            right_x <= 9;
            bot_y <= 63;
        end else begin
            case (state)
            4'b1000: begin //up
                if ((right_x <= 95 - red_square_size && bot_y - green_square_size + 1 > 0) 
                || (right_x >= 95 - red_square_size + 1 && bot_y - green_square_size + 1 > red_square_size)) begin //below red square
                    bot_y <= bot_y - 1;
                end
            end
            4'b0100: begin //left
                if (right_x - green_square_size + 1 > 0) begin
                    right_x <= right_x - 1;
                end
            end
            4'b0010: begin //right
                if ((bot_y - green_square_size + 1 < red_square_size && right_x < 95 - red_square_size) //left of red square
                || (bot_y - green_square_size + 1 >= red_square_size && right_x < 95)) begin
                    right_x <= right_x + 1;
                end
            end
            4'b0001: begin //down
                if (bot_y < 63) begin
                    bot_y <= bot_y + 1;
                end
            end
            default: begin
            end
            endcase
        end
    end
    
    // debouncing 
    always @(posedge clk_25MHz) begin
        if (reset_module) begin
            state <= 0;
        end else begin
            case (pb)
            4'b1000: state <= 4'b1000;
            4'b0100: state <= 4'b0100;
            4'b0010: state <= 4'b0010;
            4'b0001: state <= 4'b0001;
            endcase
        end
    end
    
    // drawing of green square
    always @(posedge clk_25MHz) begin      
        if (x >= right_x - green_square_size + 1 && x <= right_x && 
            y <= bot_y && y >= bot_y - green_square_size + 1) begin
            oled_data <= 16'b00000_111111_00000;  // Green
        end else if (x >= 95 - red_square_size + 1 && x <= 95 && y >= 0 && y <= red_square_size - 1) begin
            oled_data <= 16'b11111_000000_00000;  // Red
        end else begin
            oled_data <= 16'b00000_000000_00000;  // Black
        end
    end
endmodule
