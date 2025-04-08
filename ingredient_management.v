`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2025 14:50:06
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
    input basys_clk,
    input [15:0] sw,
    input btnC,
    input isInOnion,
    input isInRice,
    input isInTomato,
    input isInChicken,
    input isInChopper,
    input isInBoiler,
    input isInServer,
    output [15:0] led
    //    output [7:0] JB
    );
    
    reg [11:0] inventory = 12'b0;
    assign led[11:0] = inventory ; //debug purposes
    
    parameter [11:0] CHICKEN = 12'b100_000_000_000; //sw7
    parameter [11:0] TOMATO = 12'b000_100_000_000; //sw6
    parameter [11:0] RICE = 12'b000_000_100_000; //sw5
    parameter [11:0] ONION = 12'b000_000_000_100; //sw4
    
    parameter [11:0] RAW_MASK = 12'b100_100_100_100;
    
    reg [11:0] station_boil = 12'b0; //sw3
    reg [11:0] station_stove_2 = 12'b0; //sw2
    reg [11:0] station_chop = 12'b0; //sw1
    reg [11:0] station_serve = 12'b0; //sw0
    
    wire clk_5Hz;
    flexible_clock clk0 (basys_clk, 10_000_000, clk_5Hz);
    // pick up
    wire ctr_pb_signal;
    singlePulse ctr_pb_debounce(clk_5Hz, btnC, ctr_pb_signal);
    
//    // put down
//    wire down_pb_signal;
//    singlePulse down_pb_debounce(clk_5Hz, btnD, down_pb_signal);
    
//    // clear
//    wire up_pb_signal;
//    singlePulse up_pb_debounce(clk_5Hz, btnU, up_pb_signal);
    wire [11:0] boiled_inventory;
    boiler boiler0 (.ingredient(station_boil), .boiled_ingredient(boiled_inventory));
    
    always @ (posedge basys_clk) begin
        // sw[15] -- pick up
        // sw[14] -- put down
        // sw[13] -- discard
        // up = drop what's in inventory
        if (sw[13]) begin 
            inventory <= 12'b0;
        end
        
        // sw[15] = pick up
        // sw7-sw4 for crates
        // picks up ingredient and put in inventory
        // replace each of this switches with the inOnion module
        if (sw[15] & inventory == 12'b0 & isInChicken) begin 
            inventory <= CHICKEN;
        end
        if (sw[15] & inventory == 12'b0 & isInTomato) begin 
            inventory <= TOMATO;
        end
        if (sw[15] & inventory == 12'b0 & isInRice) begin 
            inventory <= RICE;
        end
        if (sw[15] & inventory == 12'b0 & isInOnion) begin 
            inventory <= ONION;
        end
        
        // sw3-sw0 for stations
        // pick up ingredient in station
        if (sw[15] & inventory == 12'b0 & isInBoiler) begin 
            inventory <= boiled_inventory;
            station_boil = 0;
        end
        if (sw[15] & inventory == 12'b0 & sw==8'b0000_0100) begin 
            inventory <= station_stove_2;
            station_stove_2 <= 0;
        end
        if (sw[15] & inventory == 12'b0 & isInChopper) begin 
            inventory <= station_chop;
            station_chop <= 0;
        end
        if (sw[15] & inventory == 12'b0 & isInServer) begin 
            inventory <= station_serve;
            station_serve <= 0;
        end
        
        // sw[14] = put down
        // can only put down at stations
        if (sw[14] & station_boil==12'b0 & isInBoiler) begin 
            station_boil <= inventory;
            inventory <= 0;
        end
        if (sw[14] & station_stove_2==12'b0 & sw==8'b0000_0100) begin 
            station_stove_2 <= inventory;
            inventory <= 0;
        end
        if (sw[14] & station_chop==12'b0 & isInChopper) begin 
            station_chop <= inventory;
            inventory <= 0;
        end
        if (sw[14] & station_serve==12'b0 & isInServer) begin 
            station_serve <= inventory;
            inventory <= 0;
        end

    end

endmodule

// checks for raw ingredients and boils ALL of them
// However, since we cannot merge ingredients yet, it will
// only boil one
module boiler(
    input [11:0] ingredient,
    output reg [11:0] boiled_ingredient
);
    always @(*) begin
        boiled_ingredient = ingredient;
        // Boil Chicken (bit 11 = raw, bit 9 = boiled)
        if (ingredient[11]) begin
            boiled_ingredient[11] <= 0;  // clear raw
            boiled_ingredient[9] <= 1;   // set boiled
        end
        // Boil Tomato (bit 8 = raw, bit 6 = boiled)
        if (ingredient[8]) begin
            boiled_ingredient[8] <= 0;
            boiled_ingredient[6] <= 1;
        end
        // Boil Rice (bit 5 = raw, bit 3 = boiled)
        if (ingredient[5]) begin
            boiled_ingredient[5] <= 0;
            boiled_ingredient[3] <= 1;
        end
        // Boil Onion (bit 2 = raw, bit 0 = boiled)
        if (ingredient[2]) begin
            boiled_ingredient[2] <= 0;
            boiled_ingredient[0] <= 1;
        end
    end

endmodule
