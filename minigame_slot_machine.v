module slot_machine_one_anode(
    input basys_clk,
    input reset,
    input sw,
    input [2:0] correct_state,
    input [2:0] initial_state,
//    input an,
    output reg [7:0] seg,
    output led
    );
    
    parameter T = 8'b1000_0111;
    parameter C = 8'b1100_0110;
    parameter P = 8'b1000_1100;
    parameter L = 8'b1100_0111;
    
    parameter N = 8'b1010_1011;
    parameter O = 8'b1100_0000;
    parameter H = 8'b1000_1001;
    parameter E = 8'b1000_0110;
    
    reg [2:0] state ;
    
    initial begin
        state = initial_state ;
    end
    
    assign led = (state==correct_state);
    
    wire slow_clock;
    reg prev_slow_clock = 0;
    wire frame_tick;
    
    flexible_clock frame_timer (
        .CLOCK(basys_clk),
        .n(25_000_000),
        .SLOW_CLOCK(slow_clock)
    );
    
    // Rising edge detection
    assign frame_tick = (slow_clock == 1 && prev_slow_clock == 0);
    
    always @(posedge basys_clk or posedge reset) begin
        if (reset) begin
            state <= initial_state;
        end else begin
            prev_slow_clock <= slow_clock;
            
            if (sw==0) begin
//                case (state)
//                    2'b00: if (frame_tick) state <= 2'b01;
//                    2'b01: if (frame_tick) state <= 2'b10;
//                    2'b10: if (frame_tick) state <= 2'b11;
//                    2'b11: if (frame_tick) state <= 2'b00;
//                endcase
                if (frame_tick) state <= state + 1;
            end
        end
    end
    
    always @(*) begin
        case (state) 
            // letter A
//            2'b00: seg <= 8'b1000_1000;
//            // letter b
//            2'b01: seg <= 8'b1000_0011;
//            // letter c
//            2'b10: seg <= 8'b1100_0110;
//            // letter d
//            2'b11: seg <= 8'b1001_0001;
            
            3'd0: seg <= T;
            3'd1: seg <= C;
            3'd2: seg <= P;
            3'd3: seg <= L;
            3'd4: seg <= N;
            3'd5: seg <= O;
            3'd6: seg <= H;
            3'd7: seg <= E;
            
        endcase
    end
    
endmodule

module minigame_slot_machine(
        input basys_clk,
        input reset,
        input [3:0] sw,
        output [3:0] an,
        output reg [7:0] seg,
        output [15:0] led
);

    reg [2:0] correct_3 = 3'd1;
    reg [2:0] correct_2 = 3'd6;
    reg [2:0] correct_1 = 3'd5;
    reg [2:0] correct_0 = 3'd2;
    
    reg [2:0] initial_0 = 3'd5;
    reg [2:0] initial_1 = 3'd1;
    reg [2:0] initial_2 = 3'd6;
    reg [2:0] initial_3 = 3'd3;
    
    wire [7:0] seg_an0;
    wire [7:0] seg_an1;
    wire [7:0] seg_an2;
    wire [7:0] seg_an3;
    
    slot_machine_one_anode an0 (
         basys_clk,
         reset,
         sw[0],
         correct_0,
         initial_0,
         seg_an0,
         led[0]
        );    
        
    slot_machine_one_anode an1 (
         basys_clk,
         reset,
         sw[1],
         correct_1,
         initial_1,
         seg_an1,
         led[1]
        );    
        
    slot_machine_one_anode an2 (
         basys_clk,
         reset,
         sw[2],
         correct_2,
         initial_2,
         seg_an2,
         led[2]
        );    
        
    slot_machine_one_anode an3 (
         basys_clk,
         reset,
         sw[3],
         correct_3,
         initial_3,
         seg_an3,
         led[3]
        );
    
//    assign an = 4'b0000;

    reg [3:0] an_state = 4'b1110;
    assign an = an_state;
    
    wire clk_500Hz;
    flexible_clock anode_clk (basys_clk, 100_000, clk_500Hz);
    
    always @(posedge clk_500Hz) begin
        case (an_state) 
            4'b1110: begin
                an_state <= 4'b1101;
                seg <= seg_an1;
            end
            4'b1101: begin
                an_state <= 4'b1011;
                seg <= seg_an2;
            end
            4'b1011: begin
                an_state <= 4'b0111;
                seg <= seg_an3;
            end
            4'b0111: begin
                an_state <= 4'b1110;
                seg <= seg_an0;
            end
            default: begin
                an_state <= 4'b1110;
                seg <= seg_an0;
            end
        endcase
    end

endmodule
