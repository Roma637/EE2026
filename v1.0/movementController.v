`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2025 12:06:32
// Design Name: 
// Module Name: movementController
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


module movementController #(
    parameter CHARACTER_WIDTH = 0,
    parameter LEFT_GAP_LEFT = 0,
    parameter LEFT_GAP_RIGHT = 0,
    parameter RIGHT_GAP_LEFT = 0,
    parameter RIGHT_GAP_RIGHT = 0,
    parameter TOP_GAP_TOP = 0,
    parameter TOP_GAP_BOT = 0,
    parameter BOT_GAP_TOP = 0,
    parameter BOT_GAP_BOT = 0,
    parameter VERTICAL_LINE_LEFT = 0,
    parameter VERTICAL_LINE_RIGHT = 0,
    parameter HORIZONTAL_LINE_TOP = 0,
    parameter HORIZONTAL_LINE_BOT = 0
)(
    input basys_clk,
    input btnU,
    input btnD,
    input btnL,
    input btnR,
    output reg [6:0] character_center_x = 4,
    output reg [6:0] character_center_y = 5,
    // this defines the collision boundaries for the character
    output reg [6:0] character_y_top, character_y_bot, character_x_left, character_x_right
);    
    reg [3:0] state = 0;
    wire clk_25MHz;
    flexible_clock clk1(basys_clk, 1, clk_25MHz);
    wire clk_60Hz;
    flexible_clock clk2(basys_clk, 833333, clk_60Hz);
    
    reg is_in_left_gap, is_in_right_gap, is_in_top_gap, is_in_bot_gap;
    
    always @(posedge clk_60Hz) begin
        // Compute character boundaries
        // calculated based on character center at x = 4, y = 5 for the character sprite
        // rectangular body 6 by 10
        character_y_top = character_center_y - 5;
        character_y_bot = character_center_y + 4;
        character_x_left = character_center_x - 3;
        character_x_right = character_center_x + 2;

        // Check if character is inside a gap
        is_in_left_gap = (character_x_left > LEFT_GAP_LEFT && character_x_right < LEFT_GAP_RIGHT) &&
                         (character_y_top < HORIZONTAL_LINE_BOT && character_y_bot > HORIZONTAL_LINE_TOP);
        is_in_right_gap = (character_x_left > RIGHT_GAP_LEFT && character_x_right < RIGHT_GAP_RIGHT) &&
                          (character_y_top < HORIZONTAL_LINE_BOT && character_y_bot > HORIZONTAL_LINE_TOP);
        is_in_top_gap = (character_y_top > TOP_GAP_TOP && character_y_bot < TOP_GAP_BOT) &&
                        (character_x_left < VERTICAL_LINE_RIGHT && character_x_right > VERTICAL_LINE_LEFT);
        is_in_bot_gap = (character_y_top > BOT_GAP_TOP && character_y_bot < BOT_GAP_BOT) &&
                        (character_x_left < VERTICAL_LINE_RIGHT && character_x_right > VERTICAL_LINE_LEFT);

        
            if (btnU) begin // Move Up
                if (character_y_top > 0) begin
                    if ((character_x_left > LEFT_GAP_LEFT && character_x_right < LEFT_GAP_RIGHT) ||
                        (character_x_left > RIGHT_GAP_LEFT && character_x_right < RIGHT_GAP_RIGHT)) begin
                        character_center_y = character_center_y - 1;
                    end 
                    else if (character_y_top < HORIZONTAL_LINE_TOP) begin
                        if (is_in_top_gap && character_y_top > TOP_GAP_TOP + 1)
                            character_center_y = character_center_y - 1;
                        else if (!is_in_top_gap)
                            character_center_y = character_center_y - 1;
                    end
                    else if (character_y_top > HORIZONTAL_LINE_BOT) begin
                        if (is_in_bot_gap && character_y_top > BOT_GAP_TOP + 1)
                            character_center_y = character_center_y - 1;
                        else if (!is_in_bot_gap)
                            character_center_y = character_center_y - 1;
                    end
                end
            end
            if (btnL) begin // Move Left
                if (character_x_left > 0) begin
                    if ((character_y_top > TOP_GAP_TOP && character_y_bot < TOP_GAP_BOT) ||
                        (character_y_top > BOT_GAP_TOP && character_y_bot < BOT_GAP_BOT)) begin
                        character_center_x = character_center_x - 1;
                    end 
                    else if (character_x_left < VERTICAL_LINE_LEFT) begin
                        if (is_in_left_gap && character_x_left > LEFT_GAP_LEFT + 1)
                            character_center_x = character_center_x - 1;
                        else if (!is_in_left_gap)
                            character_center_x = character_center_x - 1;
                    end 
                    else if (character_x_left > VERTICAL_LINE_RIGHT) begin
                        if (is_in_right_gap && character_x_left > RIGHT_GAP_LEFT + 1)
                            character_center_x = character_center_x - 1;
                        else if (!is_in_right_gap)
                            character_center_x = character_center_x - 1;
                    end
                end 
            end
            if (btnR) begin // Move Right
                if (character_x_right < 95) begin
                    if ((character_y_top > TOP_GAP_TOP && character_y_bot < TOP_GAP_BOT) ||
                        (character_y_top > BOT_GAP_TOP && character_y_bot < BOT_GAP_BOT)) begin
                        character_center_x = character_center_x + 1;
                    end 
                    else if (character_x_right < VERTICAL_LINE_LEFT) begin
                        if (is_in_left_gap && character_x_right < LEFT_GAP_RIGHT - 1)
                            character_center_x = character_center_x + 1;
                        else if (!is_in_left_gap)
                            character_center_x = character_center_x + 1;
                    end 
                    else if (character_x_right > VERTICAL_LINE_RIGHT) begin
                        if (is_in_right_gap && character_x_right < RIGHT_GAP_RIGHT - 1)
                            character_center_x = character_center_x + 1;
                        else if (!is_in_right_gap)
                            character_center_x = character_center_x + 1;
                    end
                end 
            end
            if (btnD) begin // Move Down
                if (character_y_bot < 63) begin
                    if ((character_x_left > LEFT_GAP_LEFT && character_x_right < LEFT_GAP_RIGHT) ||
                        (character_x_left > RIGHT_GAP_LEFT && character_x_right < RIGHT_GAP_RIGHT)) begin
                        character_center_y = character_center_y + 1;
                    end 
                    else if (character_y_bot < HORIZONTAL_LINE_TOP) begin
                        if (is_in_top_gap && character_y_bot < TOP_GAP_BOT - 1)
                            character_center_y = character_center_y + 1;
                        else if (!is_in_top_gap)
                            character_center_y = character_center_y + 1;
                    end 
                    else if (character_y_bot > HORIZONTAL_LINE_BOT) begin
                        if (is_in_bot_gap && character_y_bot < BOT_GAP_BOT - 1)
                            character_center_y = character_center_y + 1;
                        else if (!is_in_bot_gap)
                            character_center_y = character_center_y + 1;
                    end
                end 
            end
    end
    // debouncing 
//    always @(posedge clk_25MHz) begin
//        case (pb)
//        4'b1000: state <= 4'b1000;
//        4'b0100: state <= 4'b0100;
//        4'b0010: state <= 4'b0010;
//        4'b0001: state <= 4'b0001;
//        endcase
//    end
endmodule
