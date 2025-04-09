module frame_data(
    input clk,  // Should match OLED display clock
    input [12:0] pixel_index,
    output reg [15:0] oled_data
);

    // RAM output wire
    wire [15:0] ram_output;

    // RAM instance with proper port mapping
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
        .douta(ram_output)    // RAM output
    );

    // Assign the pixel value directly from RAM
    always @(*) begin
        oled_data = ram_output;
//        oled_data = 16'b11111_000000_11111;
    end

endmodule
