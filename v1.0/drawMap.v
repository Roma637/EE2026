`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2025 11:27:49
// Design Name: 
// Module Name: drawMap
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

module drawMap #(
    parameter HORIZONTAL_LINE_TOP = 0,
    parameter HORIZONTAL_LINE_BOT = 0,
    parameter LEFT_GAP_LEFT = 0,
    parameter LEFT_GAP_RIGHT = 0,
    parameter RIGHT_GAP_LEFT = 0,
    parameter RIGHT_GAP_RIGHT = 0,
    parameter VERTICAL_LINE_LEFT = 0,
    parameter VERTICAL_LINE_RIGHT = 0,
    parameter TOP_GAP_TOP = 0,
    parameter TOP_GAP_BOT = 0,
    parameter BOT_GAP_TOP = 0,
    parameter BOT_GAP_BOT = 0
)(
    input basys_clk,
    input [6:0] x, y,
    output reg [15:0] oled_data
);
    wire clk_25MHz;
    flexible_clock clk1(basys_clk, 1, clk_25MHz);

    reg horizontal_line_width, horizontal_left_part, horizontal_center_part, horizontal_right_part;
    reg vertical_line_width, vertical_top_part, vertical_center_part, vertical_bottom_part;

    always @(posedge clk_25MHz) begin
        // Horizontal line conditions
        horizontal_line_width = ((y > HORIZONTAL_LINE_TOP) && (y < HORIZONTAL_LINE_BOT));

        // Horizontal gap conditions
        horizontal_left_part = (x <= LEFT_GAP_LEFT);
        horizontal_center_part = (x <= RIGHT_GAP_LEFT && x >= LEFT_GAP_RIGHT);
        horizontal_right_part = (x >= RIGHT_GAP_RIGHT);

        // Vertical line conditions
        vertical_line_width = ((x > VERTICAL_LINE_LEFT) && (x < VERTICAL_LINE_RIGHT));

        // Vertical gap conditions
        vertical_top_part = (y <= TOP_GAP_TOP);
        vertical_center_part = (y <= BOT_GAP_TOP && y >= TOP_GAP_BOT);
        vertical_bottom_part = (y >= BOT_GAP_BOT);

         if ((horizontal_line_width && (horizontal_left_part || horizontal_center_part || horizontal_right_part)) || 
            (vertical_line_width && (vertical_top_part || vertical_center_part || vertical_bottom_part))) begin
            oled_data <= 16'b11111_111111_00000; // Yellow
        end else begin            
            oled_data <= 16'b00000_000000_00000; // Black
        end
    end

endmodule
