/*================================================================
            INTERSECTION TRAFFIC LIGHT CONTROLLER
==================================================================
Description:
  This module simulates a fully featured intersection traffic 
  light system for North-South and East-West lanes. It includes 
  synchronized pedestrian clearance intervals, dual 7-segment 
  countdown timers, an emergency override switch, and a system
  enable/pause function.

Design Engineer:
  Doloso, Felixander B.
  Gedalanga, Seth Andrei V.

Date:
  12 June 2026
================================================================*/
module top_doloso (ns_car_leds,ew_car_leds,ns_ped_leds,ew_ped_leds,ns_seg_display,ew_seg_display,clk_in,rst_n_ew,rst_n_ns,en_ns,en_ew,ovr_ew,ovr_ns,clk_led);
    // initial input wires
    input clk_in;
    input rst_n_ew;
    input rst_n_ns;
    input en_ns;
    input en_ew;
    input ovr_ew;
    input ovr_ns;
    
    output clk_led;
    output [2:0] ns_car_leds;
    output [2:0] ew_car_leds;
    output [1:0] ns_ped_leds;
    output [1:0] ew_ped_leds;
    output [0:6] ns_seg_display;
    output [0:6] ew_seg_display;
    
    // internal wires
    wire clk_w;
    wire [3:0] timer_ns_wire;
    wire [3:0] timer_ew_wire;

    // clock divider
    clk_div inst_clk_div (
        .clk_in  (clk_in),
        .clk_out (clk_w),
        .clk_led (clk_led)
    );

    // n-s controller
    doloso_ns inst_ns (
        .clk      (clk_w),
        .rst_n    (rst_n_ns),
        .en       (en_ns),
        .ovr      (ovr_ns),
        .ns_car   (ns_car_leds),
        .ns_ped   (ns_ped_leds),
        .timer_ns (timer_ns_wire)
    );

    // e-w controller
    doloso_ew inst_ew (
        .clk      (clk_w),
        .rst_n    (rst_n_ew),
        .en       (en_ew),
        .ovr      (ovr_ew),
        .ew_car   (ew_car_leds),
        .ew_ped   (ew_ped_leds),
        .timer_ew (timer_ew_wire)
    );

    // n-s 7-segments
    bcd_7seg inst_ns_seg (
        .leds (ns_seg_display),
        .bcd  (timer_ns_wire)
    );

    // e-w 7-segments
    bcd_7seg inst_ew_seg (
        .leds (ew_seg_display),
        .bcd  (timer_ew_wire)
    );

endmodule