`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2025 15:28:30
// Design Name: 
// Module Name: bitMapGenerator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bitMapGenerator;
    // Define the map size (96x64 as per your request)
    parameter MAP_WIDTH = 96;
    parameter MAP_HEIGHT = 64;
    
    // 2D array to store the map (1 = wall, 0 = free space)
    reg [0:0] map[MAP_WIDTH-1:0][MAP_HEIGHT-1:0];
    integer x, y;
    // Initial block to generate the map based on conditions for x and y
    initial begin
    // Generate the map based on x < 95 and y < 63 condition
    
    for (x = 0; x < MAP_WIDTH; x = x + 1) begin
        for (y = 0; y < MAP_HEIGHT; y = y + 1) begin
            // Set map value to 1 if x < 95 and y < 63, else 0
            if (x < 95 && y < 63) begin
                map[x][y] = 1;  // Wall
            end else begin
                map[x][y] = 0;  // Free space
            end
        end
    end
    
    // Display the map for verification (can be used in simulation)
    $display("Generated Map:");
    for (y = 0; y < MAP_HEIGHT; y = y + 1) begin
        $write("Row %0d: ", y);
        for (x = 0; x < MAP_WIDTH; x = x + 1) begin
            $write("%0d ", map[x][y]);
        end
        $display;
    end
end

endmodule
