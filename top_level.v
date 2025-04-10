`timescale 1ns / 1ps

module top_level(
    input basys_clk,
    output [7:0] JXADC,
    input [15:0] sw,
    input btnC
    //output reg [11:0] menu_1,//cannnot assign as if a port is defined in the top_level module, Verilog assumes it's trying to map to a physical pin
    //output reg [11:0] menu_2,//cannnot assign as if a port is defined in the top_level module, Verilog assumes it's trying to map to a physical pin
    //output reg [11:0] menu_3,//cannnot assign as if a port is defined in the top_level module, Verilog assumes it's trying to map to a physical pin
);

    parameter basys3_clk_freq = 100_000_000;
    parameter frame_rate = 12;
    wire clk_frameRate;
    wire [31:0] clk_param;
    assign clk_param = (basys3_clk_freq / (frame_rate)) - 1;
    flexible_clock clk1(basys_clk, clk_param, clk_frameRate);
    
    wire [1:0] item_1;
    wire [1:0] item_2;
    wire [1:0] item_3;
    
    reg [11:0] menu_1;
    reg [11:0] menu_2;
    reg [11:0] menu_3;
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
    
    
    






    wire [15:0] oled_data;
    wire clk_6p25MHz;
    wire slow_clk;
    wire frame_begin;
    wire [12:0] pixel_index;
    wire sending_pixels;
    wire sample_pixel;
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
        end else if (btnC_sync && !btnC_last) begin
            // Capture counter at the moment of button press
            seed_reg <= counter;
        end
    end
    

    
    flexible_clock clk0(basys_clk, 7, clk_6p25MHz);

    
    Oled_Display oled_unit_A (.clk(clk_6p25MHz),
                              .reset(0),
                              .frame_begin(frame_begin),
                              .sending_pixels(sending_pixels),
                              .sample_pixel(sample_pixel),
                              .pixel_index(pixel_index),
                              .pixel_data(oled_data),
                              .cs(JXADC[0]),
                              .sdin(JXADC[1]), 
                              .sclk(JXADC[3]),
                              .d_cn(JXADC[4]),
                              .resn(JXADC[5]),
                               .vccen(JXADC[6]),
                              .pmoden(JXADC[7]));
                              
    wire [7:0] x;
    wire [6:0] y;
    
    coords coordinates(
        .x(x), 
        .y(y), 
        .pixel_index(pixel_index)
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
        .oled_data(oled_data)
    );
endmodule


module random_generator(
    input basys_clk,
    input reset,            // Active-high reset (e.g. btnC)
    input [31:0] seed,      // 32-bit seed input
    output reg [1:0] item_1,
    output reg [1:0] item_2,
    output reg [1:0] item_3
    
);
    // 32-bit LFSR register
    reg [31:0] lfsr;
    // Counter to determine which item to update (will count 0 to 3)
    reg [2:0] count;  
    // LFSR feedback (using taps at bits 31, 21, 1, and 0)
    wire feedback = lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0];
    
    always @(posedge basys_clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize the LFSR with the provided seed and clear the counter and outputs
            lfsr   <= seed;
            count  <= 0;
        end else if (count < 3'd4) begin
            // For the first four clock cycles after reset, update one item per cycle.
            case(count)
                3'd0: item_1 <= lfsr[1:0];
                3'd1: item_2 <= lfsr[1:0];
                3'd2: item_3 <= lfsr[1:0];
            endcase
            // Update the LFSR and increment the counter
            lfsr  <= {lfsr[30:0], feedback};
            count <= count + 1;
        end
        // When count reaches 4, the random outputs remain unchanged.
    end
endmodule