`timescale 1ns / 1ps

module top_level(
    input basys_clk,
    output [7:0] JB
);

    parameter basys3_clk_freq = 100_000_000;
    parameter frame_rate = 12;
    wire clk_frameRate;
    wire [31:0] clk_param;
    assign clk_param = (basys3_clk_freq / (frame_rate)) - 1;
    flexible_clock clk1(basys_clk, clk_param, clk_frameRate);

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
                              
    wire [7:0] x;
    wire [6:0] y;
    
    coords coordinates(
        .x(x), 
        .y(y), 
        .pixel_index(pixel_index)
    );
    
    draw_map map(
        .clk(basys_clk),
        .x(x), 
        .y(y), 
        .oled_data(oled_data)
    );
                              
endmodule