// seed_generator.v - Updates the Seed Based on the Current Time
module seed_generator (
    input clk,
    input rst,
    input update,         // One-cycle pulse from center button press
    output reg [31:0] seed
);
    // Free-running time counter to capture elapsed time (in clock cycles)
    reg [31:0] time_counter;
    
    // Increment time counter on every clock cycle
    always @(posedge clk or posedge rst) begin
        if (rst)
            time_counter <= 32'b0;
        else
            time_counter <= time_counter + 1;
    end
    
    // On update pulse, capture the current time as the new seed
    always @(posedge clk or posedge rst) begin
        if (rst)
            seed <= 32'hA5A5A5A5;  // Initial seed value on reset
        else if (update)
            seed <= time_counter;
    end
endmodule
