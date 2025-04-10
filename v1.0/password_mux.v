`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2025 00:04:18
// Design Name: 
// Module Name: password_mux
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


module password_mux(
    input basys_clk,
    input [15:0] sw,
    input [3:0] pb,
    input [12:0] pixel_index,
    output reg [15:0] led,
    output reg [15:0] oled_data
    );
    
    wire [15:0] groupID_oled;
    groupID id0 (basys_clk, pixel_index, groupID_oled);
    
    wire clk_2Hz;
    wire clk_4Hz;
    wire clk_6Hz;
    wire clk_25MHz;
    flexible_clock clk0 (basys_clk, 25_000_000, clk_2Hz);
    flexible_clock clk1 (basys_clk, 12_500_000, clk_4Hz);
    flexible_clock clk2 (basys_clk, 8_333_333, clk_6Hz);
    flexible_clock clk3 (basys_clk, 1, clk_25MHz);
    
    reg [15:0] basic_task_a = 16'b11111_000000_00000; // red
    reg [15:0] basic_task_b = 16'b00000_111111_00000; // green
    reg [15:0] basic_task_c = 16'b00000_000000_11111; // blue
    wire [15:0] basic_task_d; // green + blue
    
    reg [15:0] prev_sw;
    reg reset_module = 0;
    // FILL IN YOUR MODULE HERE
    // FILL IN YOUR MODULE HERE
    // FILL IN YOUR MODULE HERE
    basic_task_d task0 (.basys_clk(basys_clk), .reset_module(reset_module), .pixel_index(pixel_index), .pb(pb), .oled_data(basic_task_d));
    
    always @ (posedge clk_25MHz) begin
        case (sw)
        16'b0001001110001111: begin // student a
            reset_module <= 0;
            led = clk_4Hz ? sw : {sw[15:12], 12'b0};
            oled_data <= basic_task_a; 
        end
        16'b0010000100011111: begin // student b
            reset_module <= 0;
            led = clk_2Hz ? sw : {sw[15:12], 12'b0};
            oled_data <= basic_task_b; 
        end
        16'b0100000011100111: begin // student c
            reset_module <= 0;
            led = clk_2Hz ? sw : {sw[15:12], 12'b0};
            oled_data <= basic_task_c; 
        end
        16'b1000000010100111: begin // student d
            reset_module <= 0;
            led = clk_6Hz ? sw : {sw[15:12], 12'b0};
            oled_data <= basic_task_d; 
        end
        default: begin
            led = sw;
            oled_data <= groupID_oled;
            reset_module <= 1;
        end
        endcase
    end
    
endmodule
