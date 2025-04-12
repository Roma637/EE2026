`timescale 1ns / 1ps

module starting_screen(
    input basys_clk,
    input btnC,
    output [7:0] JB
);
    
    reg ctr_pb_pressed = 0;
    wire ctr_pb_signal;
    debounce ctr_pb_debounce(basys_clk, btnC, ctr_pb_signal);

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
                              
     

//     frame_data framedata (clk_frameRate, pixel_index, oled_data);
//    frame_data start_screen (clk_6p25MHz, pixel_index, oled_data);
    
    wire [15:0] win_screen ;
    wire [15:0] game_over ;
    
    single_port_ram #(
            .RAM_WIDTH(16),
            .RAM_DEPTH(8192),
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
            .INIT_FILE("win_screen.mem")  // Ensure the correct memory file is used
        ) win_screen_ram (
            .addra(pixel_index),  // Address bus
            .clka(basys_clk),           // Clock signal
            .ena(1'b1),           // Enable always on
            .regcea(1'b1),        // Output register enable always on
            .douta(win_screen)    // RAM output
        );
        
    single_port_ram #(
            .RAM_WIDTH(16),
            .RAM_DEPTH(8192),
            .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
            .INIT_FILE("game_over.mem")  // Ensure the correct memory file is used
        ) game_over_ram (
            .addra(pixel_index),  // Address bus
            .clka(basys_clk),           // Clock signal
            .ena(1'b1),           // Enable always on
            .regcea(1'b1),        // Output register enable always on
            .douta(game_over)    // RAM output
        );
        
    always @(posedge basys_clk) begin
    
        if (ctr_pb_signal) begin
            ctr_pb_pressed <= ~ctr_pb_pressed; // Mark as pressed
        end
    
//        if (ctr_pb_pressed) begin
////        if (btnC) begin
//            oled_data <= win_screen;
//        end else begin
//            oled_data <= game_over;
//        end
        
    end
    
    assign oled_data = ctr_pb_pressed ? win_screen : game_over;

    
endmodule