`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2025 00:47:33
// Design Name: 
// Module Name: ingredient_management
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


module ingredient_management(
    input clk,
    input [15:0] sw,
    input btnC,
    input btnD,
    input btnU,
    output [3:0] an,
    output [7:0] seg,
    output [15:0] led
    //    output [7:0] JB
    );
    
    reg [11:0] inventory = 12'b0;
    assign led[11:0] = inventory ; //debug purposes
    
    reg [11:0] crate_chicken = 12'b100_000_000_000; //sw7
    reg [11:0] crate_tomato = 12'b000_100_000_000; //sw6
    reg [11:0] crate_rice = 12'b000_000_100_000; //sw5
    reg [11:0] crate_onion = 12'b000_000_000_100; //sw4
    
    reg [11:0] station_stove_1 = 12'b0; //sw3
    reg [11:0] station_stove_2 = 12'b0; //sw2
    reg [11:0] station_chop = 12'b0; //sw1
    reg [11:0] station_serve = 12'b0; //sw0
    
    // pick up
    wire ctr_pb_signal;
    debounce ctr_pb_debounce(clk, btnC, ctr_pb_signal);
    
    // put down
    wire down_pb_signal;
    debounce down_pb_debounce(clk, btnD, down_pb_signal);
    
    // clear
    wire up_pb_signal;
    debounce up_pb_debounce(clk, btnU, up_pb_signal);
    
    always @ (posedge clk) begin
    
//        if (down_pb_signal) begin
//            inventory <= 12'b0;
//        end else if (ctr_pb_signal & inventory == 12'b0) begin
//            inventory <= sw[11:0];
//        end

        // up = drop what's in inventory
        if (up_pb_signal) begin 
            inventory <= 12'b0;
        end
        
        // center = pick up
        // sw7-sw4 for crates
        if (ctr_pb_signal & inventory == 12'b0 & sw==8'b1000_0000) begin 
            inventory <= 12'b100_000_000_000;
        end
        if (ctr_pb_signal & inventory == 12'b0 & sw==8'b0100_0000) begin 
            inventory <= 12'b000_100_000_000;
        end
        if (ctr_pb_signal & inventory == 12'b0 & sw==8'b0010_0000) begin 
            inventory <= 12'b000_000_100_000;
        end
        if (ctr_pb_signal & inventory == 12'b0 & sw==8'b0001_0000) begin 
            inventory <= 12'b000_000_000_100;
        end
        
        // sw3-sw0 for stations
        if (ctr_pb_signal & inventory == 12'b0 & sw==8'b0000_1000) begin 
            inventory <= station_stove_1;
            station_stove_1 <= 0;
        end
        if (ctr_pb_signal & inventory == 12'b0 & sw==8'b0000_0100) begin 
            inventory <= station_stove_2;
            station_stove_2 <= 0;
        end
        if (ctr_pb_signal & inventory == 12'b0 & sw==8'b0000_0010) begin 
            inventory <= station_chop;
            station_chop <= 0;
        end
        if (ctr_pb_signal & inventory == 12'b0 & sw==8'b0000_0001) begin 
            inventory <= station_serve;
            station_serve <= 0;
        end
        
        // down = put down
        // can only put down at stations
        if (down_pb_signal & station_stove_1==12'b0 & sw==8'b0000_1000) begin 
            station_stove_1 <= inventory;
            inventory <= 0;
        end
        if (down_pb_signal & station_stove_2==12'b0 & sw==8'b0000_0100) begin 
            station_stove_2 <= inventory;
            inventory <= 0;
        end
        if (down_pb_signal & station_chop==12'b0 & sw==8'b0000_0010) begin 
            station_chop <= inventory;
            inventory <= 0;
        end
        if (down_pb_signal & station_serve==12'b0 & sw==8'b0000_0001) begin 
            station_serve <= inventory;
            inventory <= 0;
        end

    end

endmodule
