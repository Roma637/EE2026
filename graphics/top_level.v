`timescale 1ns / 1ps

module top_level(
    input basys_clk,
    input [4:0] pb,
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
        
    wire up_pb_signal;
    debounce up_pb_debounce(
        .clk(basys_clk), 
        .btn(pb[1]), 
        .signal(up_pb_signal)
    );
    
    wire down_pb_signal;
    debounce down_pb_debounce(
        .clk(basys_clk), 
        .btn(pb[4]), 
        .signal(down_pb_signal)
    );
    
    wire left_pb_signal;
    debounce left_pb_debounce(
        .clk(basys_clk), 
        .btn(pb[2]), 
        .signal(left_pb_signal)
    );
    
    wire right_pb_signal;
    debounce right_pb_debounce(
        .clk(basys_clk), 
        .btn(pb[3]), 
        .signal(right_pb_signal)
    );
    
//    drawCharacter char(
//        basys_clk,
//        x,
//        y,
//        0,
//        0,
//        up_pb_signal,
//        down_pb_signal,
//        left_pb_signal,
//        right_pb_signal,
//        oled_data
//    );    
    
//    draw_map map(
//        .clk(basys_clk),
//        .x(x), 
//        .y(y), 
//        .oled_data(oled_data)
//    );
    
//    wire stove_ready ;
//    wire stove_done ;
    reg [11:0] stove_inventory = 12'b0;
    
//    always @(posedge basys_clk) begin
//        if (ctr_pb_signal) begin
//            stove_ready <= 1;
//        end
//        else begin
//            stove_ready <= 0;
//        end
//    end

    wire [15:0] stove_oled;
    wire [15:0] chop_oled;
    
     drawStove stove (
        basys_clk,
        up_pb_signal,
        left_pb_signal,
        stove_inventory,
        x,
        y,
        stove_oled
    );

     drawChop chop (
        basys_clk,
        down_pb_signal,
        left_pb_signal,
        stove_inventory,
        x,
        y,
        chop_oled
    );
    
    assign oled_data = stove_oled | chop_oled ;
    
                              
endmodule