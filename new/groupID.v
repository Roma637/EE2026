`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 22:36:17
// Design Name: 
// Module Name: groupID
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


module groupID(
    input clk,
    input [12:0] pixel_index,
    output reg [15:0] oled_data
    );
    
    wire [6:0] x;
    wire [6:0] y;
    convertToCoords coords0 (pixel_index, x, y);
    
    // Digit positioning
    localparam NUM_WIDTH = 18;  // Approximate width of a digit
    localparam NUM_HEIGHT = 50; // Approximate height of a digit
    localparam THICKNESS = 4;   // Uniform line thickness
    localparam CENTER_X = 29;   // Centering numbers within 96 pixels
    localparam CENTER_Y = 7;   // Centering vertically within 64 pixels

    always @(posedge clk) begin
        // Number "1" structure
        if ((x >= CENTER_X && x <= CENTER_X + THICKNESS) && // Vertical line
            (y >= CENTER_Y && y <= CENTER_Y + NUM_HEIGHT)) begin
            oled_data = 16'b11111_111111_11111;  // White color
        end
        // Number "2" structure
        else if (
            // Top horizontal line
            (x >= CENTER_X + NUM_WIDTH && x <= CENTER_X + NUM_WIDTH + NUM_WIDTH - THICKNESS &&
             y >= CENTER_Y && y <= CENTER_Y + THICKNESS) ||
            // Top right vertical line
            (x >= CENTER_X + NUM_WIDTH + NUM_WIDTH - THICKNESS && x <= CENTER_X + NUM_WIDTH + NUM_WIDTH &&
             y >= CENTER_Y && y <= CENTER_Y + NUM_HEIGHT / 2) ||
            // Middle horizontal line
            (x >= CENTER_X + NUM_WIDTH && x <= CENTER_X + NUM_WIDTH + NUM_WIDTH &&
             y >= CENTER_Y + NUM_HEIGHT / 2 && y <= CENTER_Y + NUM_HEIGHT / 2 + THICKNESS) ||
            // Bottom left vertical line
            (x >= CENTER_X + NUM_WIDTH && x <= CENTER_X + NUM_WIDTH + THICKNESS &&
             y >= CENTER_Y + NUM_HEIGHT / 2 && y <= CENTER_Y + NUM_HEIGHT) ||
            // Bottom horizontal line
            (x >= CENTER_X + NUM_WIDTH && x <= CENTER_X + NUM_WIDTH + NUM_WIDTH &&
             y >= CENTER_Y + NUM_HEIGHT - THICKNESS && y <= CENTER_Y + NUM_HEIGHT)) begin
            oled_data = 16'b11111_111111_11111;  // White color
        end
        else begin
            oled_data = 16'b00000_000000_00000;  // Black background
        end
    end
endmodule
