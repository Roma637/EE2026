`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2025 23:02:26
// Design Name: 
// Module Name: task_password_match
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


module task_password_match(
    input basys_clk,
    input [7:0]sw,
    input enable, //start SIGNAL
    output reg [7:0]led, //leds used for password.
    output reg [3:0]an = 4'b0, 
    output reg [7:0]seg = 8'b0,
    output reg [1:0]isPlaying = 2'b0 //DONE SIGNAL. - 2'b00 playing, 2'b01 lost, 2'b10 won
    );

    //Password combination (default fallbacks)
    reg [7:0] first_combi = 7'b1000;
    reg [7:0] second_combi = 7'b1100;
    reg [7:0] third_combi = 7'b1110;
    reg [7:0] final_combi = 7'b1111;
    wire [2:0] number_1;
    wire [2:0] number_2;
    wire [2:0] number_3;
    wire [2:0] number_4;
    wire valid_sequence;

    //LFSR random generator for 4 numbers (frankly, this should never reset)
    rng rng0 (basys_clk, enable, number_1, number_2, number_3, number_4, valid_sequence);

    //Match the switch inputs
    reg [15:0] prev_sw = 16'b0;
    parameter WAIT = 4'b0001, START = 4'b0,
        ONECHECK = 4'b0010, INIITIALISE = 4'b0011,
        TWOCHECK = 4'b0100, THREEWAIT = 4'b0101,
        THREECHECK = 4'b0110, FOURWAIT = 4'b0111,
        FOURCHECK = 4'b1000, FINISH = 4'b1001,
        FAIL = 4'b1011;

    reg [3:0] state = WAIT;
    reg blink = 0;
    wire clk_2Hz;
    wire clk_3Hz;

    flexible_clock flexiclk(basys_clk, 25_000_000, clk_2Hz);
    flexible_clock flexiclk1(basys_clk, 12_500_000, clk_3Hz);
    

    always @(posedge clk_2Hz or posedge enable) begin //LED management
        if (!enable) begin
            led <= 8'b0;
        end 
        else begin
            blink <= ~blink;
            case (state)
                WAIT: begin
                    led <= ~led;
                end
                START: begin
                    led <= blink ? first_combi : 8'b0;  
                end
                ONECHECK: begin
                    led <= blink ? second_combi : 8'b0;  
                end
                TWOCHECK: begin
                    led <= blink ? third_combi : 8'b0;  
                end
                THREECHECK: begin
                    led <= blink ? final_combi : 8'b0;  
                end
                FINISH: begin
                    led <= 8'b11111111;
                end 
                FAIL: begin
                    led <= 8'b0;
                end
            endcase
        end
    end

    always @(posedge clk_3Hz or posedge enable) begin //States for password checking
        if (!enable) begin
            //Off segments when not in use
            an <= 4'b1111;
            seg <= 8'h80;
            isPlaying <= 2'b00; 
            state <= WAIT;
        end
        else begin
            case (state)
                WAIT: begin
                    an <= 4'b1111;
                    if (sw == 4'b0) begin
                        prev_sw <= sw;
                        state <= INIITIALISE;
                    end
                end

                INIITIALISE: begin
                    seg <= 8'h80; //display 8 on segmnet
                    //Reset the passwords here.
                    // if (valid_sequence) begin
                        first_combi <= 8'b1 << number_1;
                        second_combi <= (8'b1 << number_2) | (8'b1 << number_1) ;
                        third_combi <= (8'b1 << number_3) | (8'b1 << number_2) | (8'b1 << number_1);
                        final_combi <= (8'b1 << number_4) | (8'b1 << number_3) | (8'b1 << number_2) | (8'b1 << number_1); 
                        state <= START;
                    // end
                end

                START: begin
                    an <= 4'b1111;
                    if (prev_sw != sw) begin
                        prev_sw <= sw;
                        if (sw == first_combi) begin
                            state <= ONECHECK;
                        end else begin
                            state <= FAIL;
                        end
                    end
                end

                ONECHECK: begin
                    an <= 4'b1110;
                    if (prev_sw != sw) begin
                        prev_sw <= sw;
                        if (sw == second_combi) begin
                            state <= TWOCHECK;
                        end else begin
                            state <= FAIL;
                        end
                    end
                end

                TWOCHECK: begin
                    an <= 4'b1100;
                    if (prev_sw != sw) begin
                        prev_sw <= sw;
                        if (sw == third_combi) begin
                            state <= THREECHECK;
                        end else begin
                            state <= FAIL;
                        end
                    end
                end

                THREECHECK: begin
                    an <= 4'b1000;
                    if (prev_sw != sw) begin
                        prev_sw <= sw;
                        if (sw == final_combi) begin
                            state <= FINISH;
                            isPlaying <= 2'b10; //WON
                        end else begin
                            state <= FAIL;
                        end
                    end
                end

                FINISH: begin
                    an <= 4'b0000;
                    seg <= 8'h80;
                    isPlaying <= 2'b10; //WON
                end

                FAIL: begin
                    an <= 4'b0000;
                    seg <= 8'b11000111;
                    isPlaying <= 2'b01; 
                end
                default: begin
                    state <= WAIT; //Failsafe restart to normal
                end
            endcase
        end
    end

endmodule

