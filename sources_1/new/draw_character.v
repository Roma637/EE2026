`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 10:54:24
// Design Name: 
// Module Name: draw_character
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


module draw_character(
    input basys_clk,
    input [6:0] x,
    input [6:0] y,
    input [6:0] character_x,
    input [6:0] character_y,
    input btnU,
    input btnD,
    input btnL,
    input btnR,
    output reg [15:0] oled_data
    );
    
    reg [15:0] char_up [0:14][0:14];
    reg [15:0] char_down [0:14][0:14];
    reg [15:0] char_left [0:14][0:14];
    reg [15:0] char_right [0:14][0:14];
    
    reg [1:0] dir ;
    
    initial begin
    
    dir = 2'b0;
    
    // char_up[y][x], somehow the y and x is inverted
    // however, the eyes cannot be completely black as they will take the value of the background
    // so we have to set it to a value that is closest to black but not 0
    // the eyes are indicated by comments
    char_up[0][0] = 16'b00000_000000_00000;
    char_up[0][1] = 16'b11111_111111_11111;
    char_up[0][2] = 16'b11111_111111_11111;
    char_up[0][3] = 16'b11111_111111_11111;
    char_up[0][4] = 16'b11111_111111_11111;
    char_up[0][5] = 16'b11111_111111_11111;
    char_up[0][6] = 16'b11111_111111_11111;
    char_up[0][7] = 16'b00000_000000_00000;
    char_up[1][0] = 16'b11111_111111_11111;
    char_up[1][1] = 16'b11111_111111_11111;
    char_up[1][2] = 16'b10100_101001_10100;
    char_up[1][3] = 16'b11111_111111_11111;
    char_up[1][4] = 16'b11111_111111_11111;
    char_up[1][5] = 16'b11111_111111_11111;
    char_up[1][6] = 16'b11111_111111_11111;
    char_up[1][7] = 16'b11111_111111_11111;
    char_up[2][0] = 16'b10100_101001_10100;
    char_up[2][1] = 16'b11111_111111_11111;
    char_up[2][2] = 16'b10100_101001_10100;
    char_up[2][3] = 16'b11111_111111_11111;
    char_up[2][4] = 16'b10100_101001_10100;
    char_up[2][5] = 16'b11111_111111_11111;
    char_up[2][6] = 16'b10100_101001_10100;
    char_up[2][7] = 16'b11111_111111_11111;
    char_up[3][0] = 16'b00000_000000_00000;
    char_up[3][1] = 16'b11111_111111_11111;
    char_up[3][2] = 16'b10100_101001_10100;
    char_up[3][3] = 16'b11111_111111_11111;
    char_up[3][4] = 16'b10100_101001_10100;
    char_up[3][5] = 16'b11111_111111_11111;
    char_up[3][6] = 16'b10100_101001_10100;
    char_up[3][7] = 16'b00000_000000_00000;
    char_up[4][0] = 16'b00000_000000_00000;
    char_up[4][1] = 16'b11111_111111_11111;
    char_up[4][2] = 16'b10100_101001_10100;
    char_up[4][3] = 16'b11111_111111_11111;
    char_up[4][4] = 16'b10100_101001_10100;
    char_up[4][5] = 16'b11111_111111_11111;
    char_up[4][6] = 16'b10100_101001_10100;
    char_up[4][7] = 16'b00000_000000_00000;
    char_up[5][0] = 16'b00000_000000_00000;
    char_up[5][1] = 16'b11111_111111_11111;
    char_up[5][2] = 16'b10100_101001_10100;
    char_up[5][3] = 16'b11111_111111_11111;
    char_up[5][4] = 16'b10100_101001_10100;
    char_up[5][5] = 16'b11111_111111_11111;
    char_up[5][6] = 16'b10100_101001_10100;
    char_up[5][7] = 16'b00000_000000_00000;
    char_up[6][0] = 16'b00000_000000_00000;
    char_up[6][1] = 16'b11110_101110_00111;
    char_up[6][2] = 16'b11110_101110_00111;
    char_up[6][3] = 16'b11110_101110_00111;
    char_up[6][4] = 16'b11110_101110_00111;
    char_up[6][5] = 16'b11110_101110_00111;
    char_up[6][6] = 16'b11110_101110_00111;
    char_up[6][7] = 16'b00000_000000_00000;
    char_up[7][0] = 16'b00000_000000_00000;
    char_up[7][1] = 16'b11111_111111_11111;
    char_up[7][2] = 16'b11111_111111_11111;
    char_up[7][3] = 16'b11111_111111_11111;
    char_up[7][4] = 16'b11111_111111_11111;
    char_up[7][5] = 16'b11111_111111_11111;
    char_up[7][6] = 16'b11111_111111_11111;
    char_up[7][7] = 16'b00000_000000_00000;
    char_up[8][0] = 16'b00000_000000_00000;
    char_up[8][1] = 16'b11111_111111_11111;
    char_up[8][2] = 16'b11111_111111_11111;
    char_up[8][3] = 16'b11111_111111_11111;
    char_up[8][4] = 16'b11111_111111_11111;
    char_up[8][5] = 16'b11111_111111_11111;
    char_up[8][6] = 16'b11111_111111_11111;
    char_up[8][7] = 16'b00000_000000_00000;
    char_up[9][0] = 16'b00000_000000_00000;
    char_up[9][1] = 16'b11110_101110_00111;
    char_up[9][2] = 16'b00000_000000_00000;
    char_up[9][3] = 16'b00000_000000_00000;
    char_up[9][4] = 16'b00000_000000_00000;
    char_up[9][5] = 16'b00000_000000_00000;
    char_up[9][6] = 16'b11110_101110_00111;
    char_up[9][7] = 16'b00000_000000_00000;

    char_down[0][0] = 16'b00000_000000_00000;
    char_down[0][1] = 16'b11111_111111_11111;
    char_down[0][2] = 16'b11111_111111_11111;
    char_down[0][3] = 16'b11111_111111_11111;
    char_down[0][4] = 16'b11111_111111_11111;
    char_down[0][5] = 16'b11111_111111_11111;
    char_down[0][6] = 16'b11111_111111_11111;
    char_down[0][7] = 16'b00000_000000_00000;
    char_down[1][0] = 16'b11111_111111_11111;
    char_down[1][1] = 16'b11111_111111_11111;
    char_down[1][2] = 16'b11111_111111_11111;
    char_down[1][3] = 16'b11111_111111_11111;
    char_down[1][4] = 16'b11111_111111_11111;
    char_down[1][5] = 16'b10100_101001_10100;
    char_down[1][6] = 16'b11111_111111_11111;
    char_down[1][7] = 16'b11111_111111_11111;
    char_down[2][0] = 16'b11111_111111_11111;
    char_down[2][1] = 16'b10100_101001_10100;
    char_down[2][2] = 16'b11111_111111_11111;
    char_down[2][3] = 16'b10100_101001_10100;
    char_down[2][4] = 16'b11111_111111_11111;
    char_down[2][5] = 16'b10100_101001_10100;
    char_down[2][6] = 16'b11111_111111_11111;
    char_down[2][7] = 16'b11111_111111_11111;
    char_down[3][0] = 16'b00000_000000_00000;
    char_down[3][1] = 16'b10100_101001_10100;
    char_down[3][2] = 16'b11111_111111_11111;
    char_down[3][3] = 16'b10100_101001_10100;
    char_down[3][4] = 16'b11111_111111_11111;
    char_down[3][5] = 16'b10100_101001_10100;
    char_down[3][6] = 16'b11111_111111_11111;
    char_down[3][7] = 16'b00000_000000_00000;
    char_down[4][0] = 16'b00000_000000_00000;
    char_down[4][1] = 16'b11110_101110_00111;
    char_down[4][2] = 16'b11110_101110_00111;
    char_down[4][3] = 16'b11110_101110_00111;
    char_down[4][4] = 16'b11110_101110_00111;
    char_down[4][5] = 16'b11110_101110_00111;
    char_down[4][6] = 16'b11110_101110_00111;
    char_down[4][7] = 16'b00000_000000_00000;
    char_down[5][0] = 16'b00000_000000_00000;
    char_down[5][1] = 16'b11110_101110_00111;
    char_down[5][2] = 16'b00000_000001_00000; // here
    char_down[5][3] = 16'b11110_101110_00111;
    char_down[5][4] = 16'b11110_101110_00111;
    char_down[5][5] = 16'b00000_000001_00000; // here
    char_down[5][6] = 16'b11110_101110_00111;
    char_down[5][7] = 16'b00000_000000_00000;
    char_down[6][0] = 16'b00000_000000_00000;
    char_down[6][1] = 16'b11110_101110_00111;
    char_down[6][2] = 16'b11110_101110_00111;
    char_down[6][3] = 16'b11110_101110_00111;
    char_down[6][4] = 16'b11110_101110_00111;
    char_down[6][5] = 16'b11110_101110_00111;
    char_down[6][6] = 16'b11110_101110_00111;
    char_down[6][7] = 16'b00000_000000_00000;
    char_down[7][0] = 16'b00000_000000_00000;
    char_down[7][1] = 16'b11111_111111_11111;
    char_down[7][2] = 16'b11111_111111_11111;
    char_down[7][3] = 16'b01111_011110_01111;
    char_down[7][4] = 16'b01111_011110_01111;
    char_down[7][5] = 16'b11111_111111_11111;
    char_down[7][6] = 16'b11111_111111_11111;
    char_down[7][7] = 16'b00000_000000_00000;
    char_down[8][0] = 16'b00000_000000_00000;
    char_down[8][1] = 16'b11111_111111_11111;
    char_down[8][2] = 16'b11111_111111_11111;
    char_down[8][3] = 16'b10010_100101_10010;
    char_down[8][4] = 16'b10010_100101_10010;
    char_down[8][5] = 16'b11111_111111_11111;
    char_down[8][6] = 16'b11111_111111_11111;
    char_down[8][7] = 16'b00000_000000_00000;
    char_down[9][0] = 16'b00000_000000_00000;
    char_down[9][1] = 16'b11110_101110_00111;
    char_down[9][2] = 16'b00000_000000_00000;
    char_down[9][3] = 16'b00000_000000_00000;
    char_down[9][4] = 16'b00000_000000_00000;
    char_down[9][5] = 16'b00000_000000_00000;
    char_down[9][6] = 16'b11110_101110_00111;
    char_down[9][7] = 16'b00000_000000_00000;
    
    
    char_left[0][0] = 16'b00000_000000_00000;
    char_left[0][1] = 16'b11111_111111_11111;
    char_left[0][2] = 16'b11111_111111_11111;
    char_left[0][3] = 16'b11111_111111_11111;
    char_left[0][4] = 16'b11111_111111_11111;
    char_left[0][5] = 16'b11111_111111_11111;
    char_left[0][6] = 16'b11111_111111_11111;
    char_left[0][7] = 16'b00000_000000_00000;
    char_left[1][0] = 16'b11111_111111_11111;
    char_left[1][1] = 16'b11111_111111_11111;
    char_left[1][2] = 16'b11111_111111_11111;
    char_left[1][3] = 16'b11111_111111_11111;
    char_left[1][4] = 16'b11111_111111_11111;
    char_left[1][5] = 16'b10100_101001_10100;
    char_left[1][6] = 16'b11111_111111_11111;
    char_left[1][7] = 16'b11111_111111_11111;
    char_left[2][0] = 16'b11111_111111_11111;
    char_left[2][1] = 16'b10100_101001_10100;
    char_left[2][2] = 16'b11111_111111_11111;
    char_left[2][3] = 16'b10100_101001_10100;
    char_left[2][4] = 16'b11111_111111_11111;
    char_left[2][5] = 16'b10100_101001_10100;
    char_left[2][6] = 16'b11111_111111_11111;
    char_left[2][7] = 16'b10100_101001_10100;
    char_left[3][0] = 16'b00000_000000_00000;
    char_left[3][1] = 16'b10100_101001_10100;
    char_left[3][2] = 16'b11111_111111_11111;
    char_left[3][3] = 16'b10100_101001_10100;
    char_left[3][4] = 16'b11111_111111_11111;
    char_left[3][5] = 16'b10100_101001_10100;
    char_left[3][6] = 16'b11111_111111_11111;
    char_left[3][7] = 16'b00000_000000_00000;
    char_left[4][0] = 16'b00000_000000_00000;
    char_left[4][1] = 16'b11110_101110_00111;
    char_left[4][2] = 16'b11110_101110_00111;
    char_left[4][3] = 16'b11110_101110_00111;
    char_left[4][4] = 16'b11110_101110_00111;
    char_left[4][5] = 16'b11110_101110_00111;
    char_left[4][6] = 16'b11111_111111_11111;
    char_left[4][7] = 16'b00000_000000_00000;
    char_left[5][0] = 16'b00000_000000_00000;
    char_left[5][1] = 16'b00000_000001_00000; // here
    char_left[5][2] = 16'b11110_101110_00111;
    char_left[5][3] = 16'b00000_000001_00000; // here
    char_left[5][4] = 16'b11110_101110_00111;
    char_left[5][5] = 16'b11110_101110_00111;
    char_left[5][6] = 16'b11110_101110_00111;
    char_left[5][7] = 16'b00000_000000_00000;
    char_left[6][0] = 16'b00000_000000_00000;
    char_left[6][1] = 16'b11110_101110_00111;
    char_left[6][2] = 16'b11110_101110_00111;
    char_left[6][3] = 16'b11110_101110_00111;
    char_left[6][4] = 16'b11110_101110_00111;
    char_left[6][5] = 16'b11110_101110_00111;
    char_left[6][6] = 16'b11110_101110_00111;
    char_left[6][7] = 16'b00000_000000_00000;
    char_left[7][0] = 16'b00000_000000_00000;
    char_left[7][1] = 16'b11111_111111_11111;
    char_left[7][2] = 16'b11111_111111_11111;
    char_left[7][3] = 16'b01111_011110_01111;
    char_left[7][4] = 16'b11111_111111_11111;
    char_left[7][5] = 16'b11111_111111_11111;
    char_left[7][6] = 16'b11111_111111_11111;
    char_left[7][7] = 16'b00000_000000_00000;
    char_left[8][0] = 16'b00000_000000_00000;
    char_left[8][1] = 16'b11111_111111_11111;
    char_left[8][2] = 16'b11111_111111_11111;
    char_left[8][3] = 16'b10010_100101_10010;
    char_left[8][4] = 16'b11111_111111_11111;
    char_left[8][5] = 16'b11111_111111_11111;
    char_left[8][6] = 16'b11111_111111_11111;
    char_left[8][7] = 16'b00000_000000_00000;
    char_left[9][0] = 16'b00000_000000_00000;
    char_left[9][1] = 16'b00000_000000_00000;
    char_left[9][2] = 16'b11110_101110_00111;
    char_left[9][3] = 16'b00000_000000_00000;
    char_left[9][4] = 16'b00000_000000_00000;
    char_left[9][5] = 16'b00000_000000_00000;
    char_left[9][6] = 16'b11110_101110_00111;
    char_left[9][7] = 16'b00000_000000_00000;
    
    
    char_right[0][0] = 16'b00000_000000_00000;
    char_right[0][1] = 16'b11111_111111_11111;
    char_right[0][2] = 16'b11111_111111_11111;
    char_right[0][3] = 16'b11111_111111_11111;
    char_right[0][4] = 16'b11111_111111_11111;
    char_right[0][5] = 16'b11111_111111_11111;
    char_right[0][6] = 16'b11111_111111_11111;
    char_right[0][7] = 16'b00000_000000_00000;
    char_right[1][0] = 16'b11111_111111_11111;
    char_right[1][1] = 16'b11111_111111_11111;
    char_right[1][2] = 16'b10100_101001_10100;
    char_right[1][3] = 16'b11111_111111_11111;
    char_right[1][4] = 16'b11111_111111_11111;
    char_right[1][5] = 16'b11111_111111_11111;
    char_right[1][6] = 16'b11111_111111_11111;
    char_right[1][7] = 16'b11111_111111_11111;
    char_right[2][0] = 16'b10100_101001_10100;
    char_right[2][1] = 16'b11111_111111_11111;
    char_right[2][2] = 16'b10100_101001_10100;
    char_right[2][3] = 16'b11111_111111_11111;
    char_right[2][4] = 16'b10100_101001_10100;
    char_right[2][5] = 16'b11111_111111_11111;
    char_right[2][6] = 16'b10100_101001_10100;
    char_right[2][7] = 16'b11111_111111_11111;
    char_right[3][0] = 16'b00000_000000_00000;
    char_right[3][1] = 16'b11111_111111_11111;
    char_right[3][2] = 16'b10100_101001_10100;
    char_right[3][3] = 16'b11111_111111_11111;
    char_right[3][4] = 16'b10100_101001_10100;
    char_right[3][5] = 16'b11111_111111_11111;
    char_right[3][6] = 16'b10100_101001_10100;
    char_right[3][7] = 16'b00000_000000_00000;
    char_right[4][0] = 16'b00000_000000_00000;
    char_right[4][1] = 16'b11111_111111_11111;
    char_right[4][2] = 16'b11110_101110_00111;
    char_right[4][3] = 16'b11110_101110_00111;
    char_right[4][4] = 16'b11110_101110_00111;
    char_right[4][5] = 16'b11110_101110_00111;
    char_right[4][6] = 16'b11110_101110_00111;
    char_right[4][7] = 16'b00000_000000_00000;
    char_right[5][0] = 16'b00000_000000_00000;
    char_right[5][1] = 16'b11110_101110_00111;
    char_right[5][2] = 16'b11110_101110_00111;
    char_right[5][3] = 16'b11110_101110_00111;
    char_right[5][4] = 16'b00000_000001_00000; // here
    char_right[5][5] = 16'b11110_101110_00111;
    char_right[5][6] = 16'b00000_000001_00000; // here
    char_right[5][7] = 16'b00000_000000_00000;
    char_right[6][0] = 16'b00000_000000_00000;
    char_right[6][1] = 16'b11110_101110_00111;
    char_right[6][2] = 16'b11110_101110_00111;
    char_right[6][3] = 16'b11110_101110_00111;
    char_right[6][4] = 16'b11110_101110_00111;
    char_right[6][5] = 16'b11110_101110_00111;
    char_right[6][6] = 16'b11110_101110_00111;
    char_right[6][7] = 16'b00000_000000_00000;
    char_right[7][0] = 16'b00000_000000_00000;
    char_right[7][1] = 16'b11111_111111_11111;
    char_right[7][2] = 16'b11111_111111_11111;
    char_right[7][3] = 16'b11111_111111_11111;
    char_right[7][4] = 16'b01111_011110_01111;
    char_right[7][5] = 16'b11111_111111_11111;
    char_right[7][6] = 16'b11111_111111_11111;
    char_right[7][7] = 16'b00000_000000_00000;
    char_right[8][0] = 16'b00000_000000_00000;
    char_right[8][1] = 16'b11111_111111_11111;
    char_right[8][2] = 16'b11111_111111_11111;
    char_right[8][3] = 16'b11111_111111_11111;
    char_right[8][4] = 16'b10010_100101_10010;
    char_right[8][5] = 16'b11111_111111_11111;
    char_right[8][6] = 16'b11111_111111_11111;
    char_right[8][7] = 16'b00000_000000_00000;
    char_right[9][0] = 16'b00000_000000_00000;
    char_right[9][1] = 16'b11110_101110_00111;
    char_right[9][2] = 16'b00000_000000_00000;
    char_right[9][3] = 16'b00000_000000_00000;
    char_right[9][4] = 16'b00000_000000_00000;
    char_right[9][5] = 16'b11110_101110_00111;
    char_right[9][6] = 16'b00000_000000_00000;
    char_right[9][7] = 16'b00000_000000_00000;

    end
    
    always @(posedge basys_clk) begin
    
        if (btnU) begin
            dir <= 2'b0;
        end
        else if (btnD) begin
            dir <= 2'b01;
        end
        else if (btnL) begin
            dir <= 2'b10;
        end        
        else if (btnR) begin
            dir <= 2'b11;
        end
        
//        if (x >= character_x && x < 8 + character_x && y >= character_y && y < 10 + character_y) begin
//            case (dir)
//                2'b00: oled_data <= char_up[y - character_y][x - character_x];
//                2'b01: oled_data <= char_down[y - character_y][x - character_x];
//                2'b10: oled_data <= char_left[y - character_y][x - character_x];
//                2'b11: oled_data <= char_right[y - character_y][x - character_x];
//            endcase
//        end
//        else begin
//            oled_data <= 16'b0;
//        end
        
    end
    
    reg [6:0] sprite_x, sprite_y;
    always @(*) begin
        sprite_x = x - character_x;
        sprite_y = y - character_y;
        // character_x and character_y may be negative
        // this allows the rendering of the rest of the character that is still in the frame
        // regs cannot be negative since it will overflow
        if (sprite_x < 8 && sprite_y < 10) begin  // Implicitly checks sprite_x, sprite_y >= 0
            case (dir)
                2'b00: oled_data = char_up[sprite_y][sprite_x];
                2'b01: oled_data = char_down[sprite_y][sprite_x];
                2'b10: oled_data = char_left[sprite_y][sprite_x];
                2'b11: oled_data = char_right[sprite_y][sprite_x];
            endcase
        end else begin
            oled_data = 16'b0;
        end
    end

    
endmodule
