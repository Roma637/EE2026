`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 15:12:52
// Design Name: 
// Module Name: debounce
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


`timescale 1ns / 1ps

module debounce(
    input basys_clk,
    input btn,
    output reg signal = 0
);

    reg state = 0;
    reg btn_prev = 0;
    reg slow_clk_prev = 0;
    wire slow_clk;
    
//    flexible_clock fcd (basys_clk, 10_000_000, slow_clk
    flexible_clock clock1 (basys_clk, 50_000_000, slow_clk);
    always @(posedge basys_clk) begin
        btn_prev <= btn;
        slow_clk_prev <= slow_clk;
        
        case (state)
            0: begin
                if (btn && !btn_prev) begin//button rising edge
                    signal <= 1;
                    state <= 1;//trigger debounce lock-off period
                end else begin
                    signal <= 0;
                end
            end
            1: begin//wait to release the debounce
                if (slow_clk && !slow_clk_prev && !btn) begin
                    state <= 0;//ready for next button press
                    signal <= 0;
                end else begin
                    signal <= 0;
                end
            end
            
            default: begin
                state <= 0;
                signal <= 0;
            end
        endcase
    end
endmodule
