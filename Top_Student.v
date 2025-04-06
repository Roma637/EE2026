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
                    input [3:0] pb, 
                    input btnC,
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
//seven_seg_groupID id1 (basys_clk, seg, an);
//password_mux mux0 (basys_clk, sw, pb, pixel_index, led, oled_data);
map map0 (basys_clk, pixel_index, pb, led[0], oled_data);
//wire pulse;
//wire clk_10hz;

//flexible_clock clk1 (basys_clk, 5_000_000, clk_10hz);
//singlePulse pulse0(clk_10hz, btnC, pulse);
//hasOnion onion0(clk_10hz, pulse, led[0]);

endmodule