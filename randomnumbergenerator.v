`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 17:11:12
// Design Name: 
// Module Name: randomnumbergenerator
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


module randomnumbergenerator (
    input basys_clk,
    input reset,
    output reg [2:0] first_shift = 3'b000,
    output reg [2:0] second_shift = 3'b000,
    output reg [2:0] third_shift = 3'b000,
    output reg [2:0] final_shift = 3'b000,
    output reg valid_sequence = 0
    
);
    //LFSR to randomise the 4 3-bit shifts.
    reg [2:0] random_out = 3'b001;
    always @(posedge basys_clk or posedge reset) begin //Fast enough clock to overcome 1kHz in task.
        if (!reset) begin
            random_out <= 3'b001; 
        end
        else begin
            valid_sequence <= 0;
            random_out <= {random_out[1:0], (random_out[2] ^ random_out[1])};
            //Shift for first, second, third, fourth.
            if (random_out != 0 && random_out != first_shift 
                && random_out != second_shift && random_out != third_shift) begin                final_shift <= third_shift;
                final_shift <= third_shift;
                third_shift <= second_shift;
                second_shift <= first_shift;
                first_shift <= random_out;
                valid_sequence <= 1;
            end
            else begin
                //Duplicate input, change the random_out again.
                valid_sequence <= 0;
                random_out <= {random_out[1:0], ~(random_out[2] ^ random_out[1])};
            end
        end
    end




endmodule
