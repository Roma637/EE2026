`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2025 14:07:12
// Design Name: 
// Module Name: digits
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


module digits(
    input basys_clk,
    input start,
    input reset,
    output reg [3:0] tenth,
    output reg [3:0] sec,
    output reg [3:0] tensec,
    output reg [3:0] min
    );
    
    parameter REST = 2'b00;
    parameter START = 2'b01;
    parameter END = 2'b10;
    
    wire clk_10Hz;
    reg [1:0] state;
    flexible_clock mod0(basys_clk, 5_000_000, clk_10Hz); //10Hz clock for digit countdown starting in tenths
    
    always @(posedge clk_10Hz or posedge reset) begin
        if (reset) begin
            state <= REST;
        end
        
        else begin
            if (start) begin
                state <= START;
            end
        
            case (state)
                REST: begin //TODO: Change this to not 30s and whatever game timer we want
                    tenth <= 0;
                    sec <= 0;
                    tensec <= 3;
                    min <= 0;
                end
                START: begin
                    //Digit logic for counting down
                    
                    //Tenth logic (Rightmost)
                    if(tenth == 0) begin
                        tenth <= 9;
                    end
                    else begin
                        tenth <= tenth - 1;
                    end
                    
                    //Sec logic (2nd Rightmost)
                    if (tenth == 9) begin
                        if (sec == 0) begin
                            sec <= 9;
                        end
                        else begin
                            sec <= sec - 1;
                        end
                    end
                    
                    //Sec logic (3rd Rightmost)
                    if(sec == 0 && tenth == 0) begin
                        if(tensec == 0) begin
                            tensec <= 9;
                        end
                        else begin
                            tensec <= tensec - 1;
                        end
                    end

                    //Uncomment this line when we eventually figure out how to implement minute timer
//                    if(tensec == 0 && sec == 0 && tenth == 0) begin
//                          if(min == 0) begin
//                              min <= 0;
//                          end
//                          else begin
//                              min <= min - 1;    
//                          end
//                    end

                    //Timer reaches 0, stop.
                    if (tensec == 0 && sec == 0 && tenth == 0) begin 
                        tenth <= 0;
                        sec <= 0;
                        tensec <= 0;
                        min <= 0;
                        state <= END;
                    end
                end
                
                //End state.
                END: begin
                    tenth <= 0;
                    sec <= 0;
                    tensec <= 0;
                    min <= 0;
                    if (reset) begin
                        state <= REST;
                    end
                end
                
            endcase
        end
    end
    
endmodule
