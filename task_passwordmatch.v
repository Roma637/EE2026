`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 14:06:17
// Design Name: 
// Module Name: task_passwordmatch
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


module task_passwordmatch(
    input basys_clk,
    input [15:0]sw,
    input btnC, //RESET SIGNAL, change to whatever reset signal.
    output reg [15:0]led, //Comment out if not used.
    output reg [3:0]an,
    output reg [7:0]seg
    //output done //DONE SIGNAL, uncomment when used.
    );

    //Password combination
    reg [15:0] first_combi = 16'h1000;
    reg [15:0] second_combi = 16'h3000;
    reg [15:0] third_combi = 16'h7000;
    reg [15:0] final_combi = 16'hF000;
    
    // randomnumbergenerator(basys_clk, btnC,number);


    //Match the switch inputs
    reg [15:0] prev_sw = 16'b0;
    parameter WAIT = 4'b0001, START = 4'b0, ONEWAIT = 4'b0001,
        ONECHECK = 4'b0010, TWOWAIT = 4'b0011,
        TWOCHECK = 4'b0100, THREEWAIT = 4'b0101,
        THREECHECK = 4'b0110, FOURWAIT = 4'b0111,
        FOURCHECK = 4'b1000, FINISH = 4'b1001,
        FAIL = 4'b1011;

    reg [3:0] state = START;
    reg blink = 0;
    wire clk_1Hz;
    wire clk_1kHz;

    flexible_clock flexiclk(basys_clk, 50_000_000, clk_1Hz);
    flexible_clock flexiclk1(basys_clk, 50_000, clk_1kHz);
    

    always @(posedge clk_1Hz) begin //LED management
        blink <= ~blink;
        case (state)
            WAIT: begin
                led <= ~led;
            end
            START: begin
                led <= blink ? first_combi : 16'h0000;  
            end
            ONECHECK: begin
                led <= blink ? second_combi : 16'h0000;  
            end
            TWOCHECK: begin
                led <= blink ? third_combi : 16'h0000;  
            end
            THREECHECK: begin
                led <= blink ? final_combi : 16'h0000;  
            end
            FINISH: begin
                led <= 16'hFFFF;
            end 
            FAIL: begin
                led <= 16'b0;
            end
        
        endcase
    end

    always @(posedge clk_1kHz or posedge btnC) begin //States for password checking
        if (btnC) begin
            state <= WAIT;
            // done <= 1'b0;
        end
        else begin
            case (state)
                WAIT: begin
                    an <= 4'b1111;
                    if (sw == 16'b0) begin
                        prev_sw <= sw;
                        state <= START;
                    end
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
//                            done <= 1'b1;
                        end else begin
                            state <= FAIL;
                        end
                    end
                end

                FINISH: begin
                    an <= 4'b0000;
                    seg <= 7'b1110111;
                    // done <= 1'b1;
                end

                FAIL: begin
                    an <= 4'b1010;
                    seg <= 7'b0;
                end
                default: begin
                    state <= WAIT; //Failsafe restart to normal
                end
            endcase
        end
    end

endmodule
