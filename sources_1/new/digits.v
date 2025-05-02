`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2025 14:07:12
// Design Name: 
// Module Name: digits
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


module digits(
    input basys_clk,
    input reset,
    input [15:0] total_seconds,
    output reg [3:0] tenth,
    output reg [3:0] sec,
    output reg [3:0] tensec,
    output reg [3:0] min,
    output reg done
    );
    
    parameter REST = 2'b00;
    parameter START = 2'b01;
    parameter END = 2'b10;
    
    reg [1:0] state;
    
    wire [5:0] initial_min, initial_tensec, initial_sec, initial_tenth;
    
    convertTime converter (
        .total_seconds(total_seconds),
        .min(initial_min),
        .tensec(initial_tensec),
        .sec(initial_sec),
        .tenth(initial_tenth)      
        ); 
    
    always @(posedge basys_clk or posedge reset) begin
            if (reset) begin
                state <= REST;
            end else begin
            case (state)
                REST: begin
                    tenth <= initial_tenth;
                    sec <= initial_sec;
                    tensec <= initial_tensec;
                    min <= initial_min;
                    done <= 0;
                    if (!reset) begin
                        state <= START;
                    end
                end
    
                START: begin
                    if (min == 0 && tensec == 0 && sec == 0 && tenth == 0) begin
                        done <= 1;
                        state <= END;
                    end 
                    else begin
                        // Countdown logic
                        if (tenth > 0) begin
                            tenth <= tenth - 1;
                        end 
                        else begin
                            tenth <= 9;
    
                            if (sec > 0) begin
                                sec <= sec - 1;
                            end 
                            else begin
                                sec <= 9;
    
                                if (tensec > 0) begin
                                    tensec <= tensec - 1;
                                end 
                                else begin
                                    tensec <= 5;
                                    if (min > 0) begin
                                        min <= min - 1;
                                    end
                                end
                            end
                        end
                    end
                end
    
                END: begin
                    // Freeze at 0
                    tenth <= 0;
                    sec <= 0;
                    tensec <= 0;
                    min <= 0;
                    done <= 1;
                    if (reset)
                        state <= REST;
                end
            endcase
        end
    end

    
endmodule

module convertTime (
    input [15:0] total_seconds, // Input time in seconds
    output reg [5:0] min,       // Minutes (0-59)
    output reg [3:0] tensec,    // Tens of seconds (0-5)
    output reg [3:0] sec,       // Seconds (0-9)
    output reg [3:0] tenth      // Tenths of a second (default 0 on init)
);

always @(*) begin
    min    = total_seconds / 60;
    tensec = (total_seconds % 60) / 10;
    sec    = (total_seconds % 60) % 10;
    tenth  = 0; // default tenth of a second at init
end

endmodule


