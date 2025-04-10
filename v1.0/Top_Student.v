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

//wire [15:0] oled_map, oled_starting_screen;
//map map0 (
//    .basys_clk(basys_clk),
//    .pixel_index(pixel_index),
//    .sw(sw),
//    .btnC(btnC),
//    .btnU(btnU),
//    .btnD(btnD),
//    .btnL(btnL),
//    .btnR(btnR),
//    .seg(seg),
//    .an(an),
//    .led(led),
//    .oled_data(oled_map)
//);

//starting_screen(
//    basys_clk,
//    pixel_index,
//    oled_starting_screen
//);

//wire clk_10Hz;
//flexible_clock clk1 (basys_clk, 5_000_000, clk_10Hz);

//wire btnC_pressed;
//// to debounce and hold the state, can expand later to include end screen state
//debounce_and_hold db0 (clk_10Hz, btnC, btnC_pressed);
//assign oled_data = btnC_pressed ? oled_map : oled_starting_screen;


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