`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME: Poh Yu Wen
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (input basys_clk,
                    input btnC,
                    input btnD,
                    input btnU,
                    input btnL,
                    input btnR,
                    input [15:0] sw, 
                    output [7:0] JB, 
                    output [7:0] JXADC,
                    output [7:0] seg, 
                    output [3:0] an, 
                    output [15:0] led
                    );

wire [15:0] oled_data;
wire clk_6p25MHz;
wire frame_begin;
wire [12:0] pixel_index;
wire sending_pixels;
wire sample_pixel;
flexible_clock clk0(basys_clk, 7, clk_6p25MHz);
Oled_Display oled_unit_A (.clk(clk_6p25MHz),
                          .reset(0),
                          .frame_begin(frame_begin),
                          .sending_pixels(sending_pixels),
                          .sample_pixel(sample_pixel),
                          .pixel_index(pixel_index),
                          .pixel_data(oled_data),
                          .cs(JB[0]),
                          .sdin(JB[1]), 
                          .sclk(JB[3]),
                          .d_cn(JB[4]),
                          .resn(JB[5]),
                          .vccen(JB[6]),
                          .pmoden(JB[7]));
                          
//    wire [1:0] item_1;
//  wire [1:0] item_2;
//  wire [1:0] item_3;
                          
wire [15:0] oled_data1;
//wire clk_6p25MHz1;
wire frame_begin1;
wire [12:0] pixel_index1;
wire sending_pixels1;
wire sample_pixel1;
//flexible_clock clk2(basys_clk, 7, clk_6p25MHz);
//reg [31:0] seed_reg = 32'hFACEB10C;

Oled_Display oled_unit_B (.clk(clk_6p25MHz),
                        .reset(0),
                        .frame_begin(frame_begin1),
                        .sending_pixels(sending_pixels1),
                        .sample_pixel(sample_pixel1),
                        .pixel_index(pixel_index1),
                        .pixel_data(oled_data1),
                        .cs(JXADC[0]),
                        .sdin(JXADC[1]), 
                        .sclk(JXADC[3]),
                        .d_cn(JXADC[4]),
                        .resn(JXADC[5]),
                         .vccen(JXADC[6]),
                        .pmoden(JXADC[7]));
                          
wire [11:0] inventory;

wire [15:0] oled_map, oled_starting_screen;
map map0 (
    .basys_clk(basys_clk),
    .pixel_index(pixel_index),
    .sw(sw),
    .btnC(btnC),
    .btnU(btnU),
    .btnD(btnD),
    .btnL(btnL),
    .btnR(btnR),
    .seg(seg),
    .an(an),
    .led(led),
    .oled_data(oled_map),
    .inventory(inventory)
);

starting_screen(
    basys_clk,
    pixel_index,
    oled_starting_screen
);
//    wire [7:0] x;
//    wire [6:0] y;
    
//    coords coordinates(
//    .x(x), 
//    .y(y), 
//    .pixel_index(pixel_index)
//);

//random_generator menu_gen(
//    basys_clk,
//    btnC,
//    seed_reg,
//    item_1,
//    item_2,
//    item_3
//);

//draw_menu menu(
//    .clk(basys_clk),
//    .x(x), 
//    .y(y),
//    .item_1_id(item_1),
//    .item_2_id(item_2),
//    .item_3_id(item_3),
//    .sw(sw),
//    .oled_data(oled_data1)
//);

left_oled left_display(
    .basys_clk(basys_clk),
    .oled_data1(oled_data1),
    .pixel_index1(pixel_index1),
    .sw(sw),
    .btnC(btnC),
    .inventory(inventory)
);

wire clk_10Hz;
flexible_clock clk1 (basys_clk, 5_000_000, clk_10Hz);

wire btnC_pressed;
// to debounce and hold the state, can expand later to include end screen state
debounce_and_hold db0 (clk_10Hz, btnC, btnC_pressed);
assign oled_data = btnC_pressed ? oled_map : oled_starting_screen;


// draw character test ====================================================

//wire [6:0] x;
//wire [6:0] y;
//convertToCoords coords0 (pixel_index, x, y);

//reg [6:0] left_x = 0; 
//reg [6:0] top_y = 4;

//wire clk_45Hz;
//flexible_clock clk2(basys_clk, 1_111_111, clk_45Hz);

//always @ (posedge clk_45Hz) begin
//    if (btnU && top_y > 0) begin
//        top_y <= top_y - 1; 
//    end
//    if (btnD && top_y < 95) begin   
//        top_y <= top_y + 1;
//    end
//    if (btnL && left_x > 0) begin   
//        left_x <= left_x - 1;
//    end
//    if (btnR && left_x < 63) begin   
//        left_x <= left_x + 1;
//    end
//end

//draw_character character_drawer_inst (
//    .basys_clk(basys_clk),
//    .x(x),
//    .y(y),
//    .btnU(btnU),
//    .btnD(btnD),
//    .btnL(btnL),
//    .btnR(btnR),
//    .character_x(left_x),
//    .character_y(top_y),
//    .oled_data(oled_data)
//);

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
module debounce_and_hold(
    input clk_10Hz,
    input pb,
    output reg state = 0
    );
    always @ (posedge clk_10Hz) begin
        if (pb) begin
            state = 1;
        end
    end
endmodule