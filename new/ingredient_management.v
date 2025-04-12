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
    input boil_done, // to check if the boiling animation is complete
    input chop_done,
    output reg start_boil = 0, // to start the animation
    output reg start_chop = 0,
    output reg reset_boil = 0, // to set back to IDLE state
    output reg reset_chop = 0,
    output [15:0] led,
    output reg [11:0] inventory
    );
    wire [11:0] after_serving;
//    reg [11:0] inventory = 12'b0;
    assign led[11:0] = inventory ; //debug purposes
    
    parameter [11:0] CHICKEN = 12'b100_000_000_000;
    parameter [11:0] TOMATO = 12'b000_100_000_000;
    parameter [11:0] RICE = 12'b000_000_100_000;
    parameter [11:0] ONION = 12'b000_000_000_100;
    
    reg [11:0] station_boil = 12'b0; 
    reg [11:0] station_chop = 12'b0;
    reg [11:0] station_serve = 12'b0;
    
    wire clk_10Hz;
    flexible_clock clk0 (basys_clk, 5_000_000, clk_10Hz);
    
    // for testing 
    wire clk_0p5Hz;
    flexible_clock clk1 (basys_clk, 100_000_000, clk_0p5Hz);
    
    wire btnC_pulse;
    // represents the state, 1 to pick up, 0 to put down
    reg pickUp = 0;
    singlePulse ctr_pb_debounce(clk_10Hz, btnC, btnC_pulse);
    
    wire [11:0] boiled_ingredient;
    boiler boiler0 (.ingredient(station_boil), .boiled_ingredient(boiled_ingredient));
    
    wire [11:0] chopped_ingredient;
    chopper chopper0 (.ingredient(station_chop), .chopped_ingredient(chopped_ingredient));
    
    
    wire [1:0] orders_done;
    wire served;
    assign led[15:14] = orders_done;
    wire [11:0] order1 = 12'b100_100_000_000;
    wire [11:0] order2 = 12'b000_000_100_100;
    wire [11:0] order3 = 12'b100_000_001_001;
    server server0 (clk_10Hz, 0, order1, order2, order3, station_serve, after_serving, orders_done, served);
    
    always @(*) begin
        pickUp = (inventory == 0) ? 1 : 0;
    end
    
    always @ (posedge clk_10Hz) begin
        // sw[15] -- pick up
        // sw[14] -- put down
        // sw[13] -- discard
        // up = drop what's in inventory
        if (sw[13]) begin 
            inventory <= 12'b0;
        end
        if (served) begin
            station_serve <= after_serving;
        end
        if (pickUp && btnC_pulse) begin
            // pick up ingredients
            if (inventory == 12'b0 & isInChicken) begin 
                inventory <= CHICKEN;
            end
            else if (inventory == 12'b0 & isInTomato) begin 
                inventory <= TOMATO;
            end
            else if (inventory == 12'b0 & isInRice) begin 
                inventory <= RICE;
            end
            else if (inventory == 12'b0 & isInOnion) begin 
                inventory <= ONION;
            end
            // pick up from stations
            // check if in boiler and boiling is done before you can pick up
            // 
            else if (inventory == 12'b0 & isInBoiler & boil_done) begin 
                //picking up
                inventory <= boiled_ingredient;
                station_boil <= 0;
                // boiler should be in IDLE state if no ingredient
                reset_boil <= 1;
                // should not be animating after picking up
                start_boil <= 0;
            end
            else if (inventory == 12'b0 & isInChopper & chop_done) begin 
                inventory <= chopped_ingredient;
                station_chop <= 0;
                // chopper should be in IDLE state if no ingredient
                reset_chop <= 1;
                // should not be animating after picking up
                start_chop <= 0;
            end
            else if (inventory == 12'b0 & isInServer) begin 
                inventory <= station_serve;
                station_serve <= 0;
            end
        end
        else begin
            // put in stations
            if (btnC_pulse & station_boil==12'b0 & isInBoiler) begin 
                station_boil <= inventory;
                inventory <= 0;
                // for now start animation immediately upon putting in boil
                start_boil <= 1;
                // stop reset when boiling starts
                reset_boil <= 0;
            end
            else if (btnC_pulse & station_chop==12'b0 & isInChopper) begin 
                station_chop <= inventory;
                inventory <= 0;
                // for now start animation immediately upon putting in chop
                start_chop <= 1;
                // stop reset when chopping starts
                reset_chop <= 0;
            end
            else if (btnC_pulse & isInServer) begin 
                station_serve <= inventory | station_serve;
                inventory <= 0;
            end
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

// chops all raw ingredients at once
module chopper(
    input [11:0] ingredient,
    output reg [11:0] chopped_ingredient
);
    always @(*) begin
        chopped_ingredient = ingredient;
        if (ingredient[11]) begin
            chopped_ingredient[11] <= 0;  
            chopped_ingredient[10] <= 1;   
        end
        if (ingredient[8]) begin
            chopped_ingredient[8] <= 0;
            chopped_ingredient[7] <= 1;
        end
        if (ingredient[5]) begin
            chopped_ingredient[5] <= 0;
            chopped_ingredient[4] <= 1;
        end
        if (ingredient[2]) begin
            chopped_ingredient[2] <= 0;
            chopped_ingredient[1] <= 1;
        end
    end

endmodule

module server(
    input clk,
    input reset,
    input [11:0] order1, order2, order3,
    input [11:0] before_serving,
    output reg [11:0] after_serving = 0,
    output reg [1:0] orders_done = 0,  // counts how many orders have been completed
    output reg served = 0
);
    // marks if the orders have been done before
    reg done1 = 0;
    reg done2 = 0;
    reg done3 = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            after_serving <= 12'b0;
            orders_done <= 2'd0;
            done1 <= 0;
            done2 <= 0;
            done3 <= 0;
            served <= 0;
        end
        else begin
            served <= 0; // default to 0
    
            if (((before_serving & order1) == order1) && !done1) begin
                after_serving <= before_serving & ~order1;
                done1 <= 1;
                orders_done <= orders_done + 1;
                served <= 1; // pulse high for 1 clock
            end
            else if (((before_serving & order2) == order2) && !done2) begin
                after_serving <= before_serving & ~order2;
                done2 <= 1;
                orders_done <= orders_done + 1;
                served <= 1;
            end
            else if (((before_serving & order3) == order3) && !done3) begin
                after_serving <= before_serving & ~order3;
                done3 <= 1;
                orders_done <= orders_done + 1;
                served <= 1;
            end 
            else begin
                after_serving <= before_serving;
                // served remains 0
            end
        end
    end


endmodule
