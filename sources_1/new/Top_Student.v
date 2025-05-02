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
                    output [15:0] led);

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

wire [15:0] left_oled;
//wire clk_6p25MHz1;
wire frame_begin1;
wire [12:0] pixel_index1;
wire sending_pixels1;
wire sample_pixel1;
Oled_Display oled_unit_B (.clk(clk_6p25MHz),
                          .reset(0),
                          .frame_begin(frame_begin1),
                          .sending_pixels(sending_pixels1),
                          .sample_pixel(sample_pixel1),
                          .pixel_index(pixel_index1),
                          .pixel_data(left_oled),
                          .cs(JXADC[0]),
                          .sdin(JXADC[1]), 
                          .sclk(JXADC[3]),
                          .d_cn(JXADC[4]),
                          .resn(JXADC[5]),
                           .vccen(JXADC[6]),
                          .pmoden(JXADC[7]));

wire clk_10Hz;
flexible_clock clk1 (basys_clk, 5_000_000, clk_10Hz);

wire start_game;
// to debounce and hold the state, can expand later to include end screen state
debounce_and_hold db0 (clk_10Hz, btnC, start_game);

wire [15:0] oled_map, oled_starting_screen;
wire [7:0] seg_timer;
wire [3:0] an_timer;
wire [11:0] inventory;
wire [11:0] order_1, order_2, order_3;
wire [2:0] orders_done;
wire [15:0] led_map;
wire [15:0] time_left;
map map0 (
    .basys_clk(basys_clk),
    .pixel_index(pixel_index),
    .sw(sw),
    .btnC(btnC),
    .btnU(btnU),
    .btnD(btnD),
    .btnL(btnL),
    .btnR(btnR),
    .start_game(start_game),
    .order_1(order_1),
    .order_2(order_2),
    .order_3(order_3),
    .seg(seg_timer),
    .an(an_timer),
    .led(led_map),
    .oled_data(oled_map),
    .inventory(inventory),
    .orders_done(orders_done),
    .time_left(time_left)
);

starting_screen(
    basys_clk,
    pixel_index,
    oled_starting_screen
);

wire [15:0] oled_menu;
left_oled left_display(
    .basys_clk(basys_clk),
    .oled_data1(oled_menu),
    .pixel_index1(pixel_index1),
    .sw(sw),
    .btnC(start_game),
    .inventory(inventory),
    .order_1(order_1),
    .order_2(order_2),
    .order_3(order_3),
    .orders_done(orders_done)
);

wire [7:0] seg_score;
wire [3:0] an_score;
wire game_end;
assign game_end = (orders_done == 3'b111 || time_left == 1);
display_scoring(
    basys_clk,
    orders_done, //One hot encoded, 1 in each bit if done
    time_left, //Shouldn't exceed 16 bits - time unlikely to be so long
    seg_score,
    an_score
);

wire [15:0] oled_end_screen;
ending_screen screen0 (
    .basys_clk(basys_clk),
    .pixel_index(pixel_index),
    .oled_data(oled_end_screen)
    );
    
wire [15:0] oled_background;
draw_background background0(
    .clk(basys_clk),
    .pixel_index(pixel_index),
    .oled_data(oled_background)
        );

assign oled_data = game_end ? oled_end_screen :
                   (start_game ? (oled_map ? oled_map : oled_background) : oled_starting_screen);
assign left_oled = game_end ? 16'b0 :
                   (start_game ? oled_menu : 16'b0);
assign seg = game_end ? seg_score :
                   (start_game ? seg_timer : 8'b1111_1111);
assign an = game_end ? an_score :
                   (start_game ? an_timer : 4'b1111);
assign led = game_end ? 16'b0 :
                   (start_game ? led_map : 16'b0);

endmodule

module random_generator(
    input basys_clk,      // Clock input
    input [31:0] seed,     // 32-bit seed value; should be 0 until initialized externally
    output [1:0]  item_1,   // First 2-bit output: lfsr[1:0]
    output [1:0]  item_2,   // Second 2-bit output: lfsr[3:2]
    output [1:0]  item_3    // Third 2-bit output: lfsr[5:4]
);

    reg [31:0] lfsr;
    reg loaded = 1'b0;

    always @(posedge basys_clk) begin

        if (!loaded && (seed != 32'hFACEB10C)) begin
            lfsr   <= seed;
            loaded <= 1'b1;
        end 
        else begin
            // Once loaded, hold the value forever.
            lfsr <= lfsr;
        end
    end

    // Produce three 2-bit outputs by slicing the stored value.
    assign item_1 = lfsr[1:0];
    assign item_2 = lfsr[3:2];
    assign item_3 = lfsr[5:4];

endmodule

module debounce_and_hold(
    input clk_10Hz,
    input pb,
    output reg state = 0
    );
    always @ (posedge clk_10Hz) begin
        if (pb) begin
            state <= 1;
        end
    end
endmodule