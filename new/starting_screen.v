`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 15:19:22
// Design Name: 
// Module Name: starting_screen
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

module starting_screen(
    input clk,
    input [12:0] pixel_index,
    output reg [15:0] oled_data
);
    
    wire [15:0] start_screen ;
    single_port_ram #(
            .RAM_WIDTH(16),
            .RAM_DEPTH(8192),
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
            .INIT_FILE("start_screen.mem")  // Ensure the correct memory file is used
        ) image_memory (
            .addra(pixel_index),  // Address bus
            .clka(clk),           // Clock signal
            .ena(1'b1),           // Enable always on
            .regcea(1'b1),        // Output register enable always on
            .douta(start_screen)    // RAM output
        );
        
    always @(posedge clk) begin
        oled_data = start_screen;
    end
    
endmodule
