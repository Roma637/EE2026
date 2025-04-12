`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 12:51:09
// Design Name: 
// Module Name: seven_seg_timer
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


module seven_seg_timer(
    input basys_clk,
    input reset,
    input all_orders_done,
    output reg [7:0] seg,
    output reg [3:0] an,
    output reg [15:0] seconds_left,
    output done
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
    
    // number of seconds that the clock will start counting down from
    parameter TOTAL_SECONDS = 150;
   
    reg [1:0] digit_select; //Select which anode to light up.
    reg urgent = 0;
    reg [25:0] COUNT = 0;    
        
    wire [3:0] tenth;
    wire [3:0] sec;
    wire [3:0] tensec;
    wire [3:0] min;

    reg digit_clk;
    wire clk_10Hz;
    wire clk_500Hz;
    wire clk_1kHz;
    wire clk_2kHz;    
    
    flexible_clock mod0(basys_clk, 5_000_000, clk_10Hz); //10Hz clock for digit countdown starting in tenths
    flexible_clock mod1(basys_clk, 100_000, clk_500Hz);
    flexible_clock clk2 (basys_clk, 50_000, clk_1kHz);
    flexible_clock clk1 (basys_clk, 25_000, clk_2kHz);
        
    initial begin
        seconds_left <= TOTAL_SECONDS;
    end
    
    always @(posedge clk_1kHz) begin //THIS NEEDS TO BE CLOCKED, OR IT WONT WORK
        if (all_orders_done == 1'b1) begin
            seconds_left <= seconds_left;
            digit_clk <= clk_500Hz;
        end
        else begin
            seconds_left <= sec + (tensec * 10) + (min * 60);
            digit_clk <= clk_10Hz;
        end
    end

    digits timer_display (
        .digits_clk(digit_clk),
        .reset(reset),
        .total_seconds(TOTAL_SECONDS),
        .tenth(tenth),
        .sec(sec),
        .tensec(tensec),
        .min(min),
        .done(done)
    );
    
    
    always @(posedge clk_2kHz) begin
        //Toggle this every 1ms (update every 1ms the display)
        //it is impossible to make this flash in urgent time so WGT
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
                seg[7] = 1; // turn off dp
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
                seg[7] = 0; // turn on dp
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
                seg[7] = 1;
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
                seg[7] = 0;
            end
        endcase
    end
    
endmodule
