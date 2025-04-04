
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 14:23:11
// Design Name: 
// Module Name: flexible_clock
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


//module flexible_clock(
//    input CLOCK,
//    input [31:0]m,
//    output reg SLOW_CLOCK = 0
//    );
    
//    // SAMPLE EVERY m
    
//    reg[31:0] COUNT = 32'b0 ;
    
//    always @ (posedge CLOCK) begin
//        COUNT <= ( COUNT == m ) ? 0 : COUNT + 1;
//        if ( COUNT == 0 ) begin
//            SLOW_CLOCK <= ~SLOW_CLOCK ;
//        end
//    end

//endmodule

module flexible_clock(
    input CLOCK,
    input [31:0] n,
    output reg SLOW_CLOCK = 0
    );
    
    reg[31:0] COUNT = 32'b0 ;
    
     always @ (posedge CLOCK ) begin
            if (COUNT >= n) begin
                COUNT <= 0;
                SLOW_CLOCK <= ~SLOW_CLOCK;
            end else begin
                COUNT <= COUNT + 1;
            end
    end
endmodule