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
    input reset,
    input start,
    output reg [7:0] seg,
    output reg [3:0] an
    );
    
    parameter ZERO = 7'b1000000;
    parameter ONE = 7'b1111001;
    parameter TWO = 7'b0100100;
    parameter THREE = 7'b0110000;
    parameter FOUR = 7'b0011001;
    parameter FIVE = 7'b0010010;
    parameter SIX = 7'b0000010;
    parameter SEVEN = 7'b1111000;
    parameter EIGHT = 7'b0000000;
    parameter NINE = 7'b0010000;
       
    reg [1:0] digit_select; //Select which anode to light up.
    
    wire [3:0] tenth;
    wire [3:0] sec;
    wire [3:0] tensec;
    wire [3:0] min;

    wire clk_2kHz;    

    flexible_clock clk1 (basys_clk, 100_000, clk_2kHz);
    digits digit(basys_clk, start, reset, tenth, sec, tensec, min);
    
    always @(posedge clk_2kHz) begin
        //Toggle this every 1ms (update every 1ms the display)
        //TODO: Is it possible to make this flash nearer to the end?
        digit_select <= digit_select + 1; 
    end 
    
    // Timer logic
    always @(posedge basys_clk) begin
        case(digit_select) 
            2'b00 : begin
                an = 4'b1110;   // Turn on tenth digit
                case(tenth)
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
                an = 4'b1101;   // Turn on sec digit
                case(sec)
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
                an = 4'b1011;   // Turn on tensec digit
                case(tensec)
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
                an = 4'b0111;   // Turn on min digit
                case(min)
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