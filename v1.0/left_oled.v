`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 10:56:47
// Design Name: 
// Module Name: left_oled
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

module left_oled(
    input basys_clk,
    input [15:0] sw,
    output [15:0] oled_data1,
    input [12:0] pixel_index1,
    input btnC,
    input [11:0] inventory
    //output reg [11:0] menu_1,//cannnot assign as if a port is defined in the top_level module, Verilog assumes it's trying to map to a physical pin
    //output reg [11:0] menu_2,//cannnot assign as if a port is defined in the top_level module, Verilog assumes it's trying to map to a physical pin
    //output reg [11:0] menu_3,//cannnot assign as if a port is defined in the top_level module, Verilog assumes it's trying to map to a physical pin
);

//    parameter basys3_clk_freq = 100_000_000;
//    parameter frame_rate = 12;
//    wire clk_frameRate;
//    wire [31:0] clk_param;
//    assign clk_param = (basys3_clk_freq / (frame_rate)) - 1;
//    flexible_clock clk1(basys_clk, clk_param, clk_frameRate);
    
    wire [1:0] item_1;
    wire [1:0] item_2;
    wire [1:0] item_3;
    
    reg [11:0] menu_1;
    reg [11:0] menu_2;
    reg [11:0] menu_3;
    reg  random_initialised = 1'b0;
    //UPDATE WITH THE PROPER 12-BIT DISH IDs
    always @(*) begin
            case (item_1)
                2'b00: menu_1 = 12'b000_000_000_000;
                2'b01: menu_1 = 12'b000_000_000_001;
                2'b10: menu_1 = 12'b000_000_000_010;
                2'b11: menu_1 = 12'b000_000_000_011;
            endcase
    
            case (item_2)
                2'b00: menu_2 = 12'b000_000_000_000;
                2'b01: menu_2 = 12'b000_000_001_111;
                2'b10: menu_2 = 12'b000_000_010_000;
                2'b11: menu_2 = 12'b000_000_011_111;
            endcase
    
            case (item_3)
                2'b00: menu_3 = 12'b000_000_000_000;
                2'b01: menu_3 = 12'b111_000_000_000;
                2'b10: menu_3 = 12'b001_111_000_000;
                2'b11: menu_3 = 12'b111_111_111_111;
            endcase
        end
    
    


//    wire [15:0] oled_data1;
//    wire clk_6p25MHz;
//    wire slow_clk;
//    wire frame_begin;
//    wire [12:0] pixel_index;
//    wire sending_pixels;
//    wire sample_pixel;
    reg [31:0] seed_reg = 32'hFACEB10C;  // initial seed
    
    reg [31:0] counter = 0;
    
    // Synchronize the btnC signal to basys_clk (avoid metastability).
    reg btnC_sync = 0;
    reg btnC_last = 0;
    
    always @(posedge basys_clk) begin
        btnC_sync <= btnC;
        btnC_last <= btnC_sync;
    end

    always @(posedge basys_clk) begin
        if (!btnC_sync) begin                              
            counter <= counter + 1;
        end else if (btnC_sync && !btnC_last && (seed_reg == 32'hFACEB10C)) begin
            // Capture counter at the moment of button press
            seed_reg <= counter;
            random_initialised = 1;
        end
    end
    

    
//    flexible_clock clk0(basys_clk, 7, clk_6p25MHz);

                              
    wire [7:0] x;
    wire [6:0] y;
    
    convertToCoords coordinates(
        .pixel_index(pixel_index1),
        .x(x), 
        .y(y)
    );
    
    random_generator menu_gen(
        basys_clk,
        btnC,
        seed_reg,
        item_1,
        item_2,
        item_3
    );
    
    draw_menu menu(
        .clk(basys_clk),
        .x(x), 
        .y(y),
        .item_1_id(item_1),
        .item_2_id(item_2),
        .item_3_id(item_3),
        .sw(sw),
        .oled_data(oled_data1),
        .inventory(inventory)
    );
    
endmodule
