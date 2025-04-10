`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 15:37:20
// Design Name: 
// Module Name: display_scoring
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


module display_scoring(
    input basys_clk,
    input [2:0] orders_done, //One hot encoded, 1 in each bit if done
    input [15:0] time_left, //Shouldn't exceed 16 bits - time unlikely to be so long
    output reg [7:0] seg,
    output reg [3:0] an
    );

    parameter ZERO = 8'b11000000;
    parameter ONE = 8'b11111001;
    parameter TWO = 8'b10100100;
    parameter THREE = 8'b10110000;
    parameter FOUR = 8'b10011001;
    parameter FIVE = 8'b10010010;
    parameter SIX = 8'b10000010;
    parameter SEVEN = 8'b11111000;
    parameter EIGHT = 8'b10000000;
    parameter NINE = 8'b10010000;

    reg [2:0] total_orders = 0;
    reg [15:0] total_score = 15'b0;
    reg [1:0] digit_select = 0;

    reg [3:0] thousands = 0;
    reg [3:0] hundreds = 0;
    reg [3:0] tens = 0;
    reg [3:0] ones = 0;

    wire clk_1kHz;
    wire clk_2kHz;    
    
    flexible_clock clk2 (basys_clk, 50_000, clk_1kHz);
    flexible_clock clk1 (basys_clk, 100_000, clk_2kHz);

    always @(*) begin        
        total_orders <= orders_done[0] + orders_done[1] + orders_done[2]; //Get total orders
        total_score <= (total_orders * 1000) + time_left; //Get total score
        thousands <= (total_score / 1000) % 10;
        hundreds <= (total_score / 100) % 10;
        tens <= (total_score / 10) % 10;
        ones <= time_left % 10;
    end

    always @(posedge clk_2kHz) begin
        digit_select <= digit_select + 1;
    end 

    always @(posedge basys_clk) begin
        case(digit_select) 
            2'b00 : begin
                an = 4'b1110;   // Turn on ones digit
                case(ones)
                    4'b0000 : seg = ZERO;
                    4'b0001 : seg = ONE;
                    4'b0010 : seg = TWO;
                    4'b0011 : seg = THREE;
                    4'b0100 : seg = FOUR;
                    4'b0101 : seg = FIVE;
                    4'b0110 : seg = SIX;
                    4'b0111 : seg = SEVEN;
                    4'b1000 : seg = EIGHT;
                    4'b1001 : seg = NINE;
                endcase
            end
            2'b01 : begin       
                an = 4'b1101;   // Turn on tens digit
                case(tens)
                    4'b0000 : seg = ZERO;
                    4'b0001 : seg = ONE;
                    4'b0010 : seg = TWO;
                    4'b0011 : seg = THREE;
                    4'b0100 : seg = FOUR;
                    4'b0101 : seg = FIVE;
                    4'b0110 : seg = SIX;
                    4'b0111 : seg = SEVEN;
                    4'b1000 : seg = EIGHT;
                    4'b1001 : seg = NINE;
                endcase
            end
            2'b10 : begin       
                an = 4'b1011;   // Turn on hundreds digit
                case(hundreds)
                    4'b0000 : seg = ZERO;
                    4'b0001 : seg = ONE;
                    4'b0010 : seg = TWO;
                    4'b0011 : seg = THREE;
                    4'b0100 : seg = FOUR;
                    4'b0101 : seg = FIVE;
                    4'b0110 : seg = SIX;
                    4'b0111 : seg = SEVEN;
                    4'b1000 : seg = EIGHT;
                    4'b1001 : seg = NINE;
                endcase
            end
            2'b11 : begin       
                an = 4'b0111;   // Turn on thousands digit
                case(thousands)
                    4'b0000 : seg = ZERO;
                    4'b0001 : seg = ONE;
                    4'b0010 : seg = TWO;
                    4'b0011 : seg = THREE;
                    4'b0100 : seg = FOUR;
                    4'b0101 : seg = FIVE;
                    4'b0110 : seg = SIX;
                    4'b0111 : seg = SEVEN;
                    4'b1000 : seg = EIGHT;
                    4'b1001 : seg = NINE;
                endcase
            end
        endcase
    end

endmodule
