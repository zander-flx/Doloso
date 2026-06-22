// top level design for Timer Demo
module top_doloso(ns_car,ns_ped,ew_car,ew_ped,state_ns,state_ew,leds_timer_ns,leds_timer_ew,clk_led,clk_in,ovr,en,rst_n);
 // ports
 input 			rst_n;
 input			en;
 input			ovr;
 input 			clk_in;
 output 	[2:0]	ns_car;
 output 	[1:0]	ns_ped;
 output 	[2:0]	ew_car;
 output 	[1:0]	ew_ped;
 output 	[3:0]	state_ns;
 output 	[3:0]	state_ew;
 output       	clk_led;
 output	[0:6]	leds_timer_ns;
 output	[0:6]	leds_timer_ew;
 
 wire		[3:0]	timer_ns; 
 wire		[3:0]	timer_ew; 
 wire				clk_w;

 // clock divider instance
 clk_div clk_div_inst(
	.clk_out  (clk_w),
	.clk_led  (clk_led),
	.clk_in   (clk_in)
 );
 
 // doloso instance
 doloso doloso_inst(
	.ns_car	(ns_car), 
	.ns_ped	(ns_ped), 
	.ew_car	(ew_car), 
	.ew_ped	(ew_ped), 
	.timer_ns(timer_ns), 
	.timer_ew(timer_ew), 
	.state_ns(state_ns), 
	.state_ew(state_ew), 
	.clk		(clk_w), 
	.ovr		(ovr), 
	.en		(en), 
	.rst_n	(rst_n)
);

 //bcd_7seg state instance
 bcd_7seg bcd_7seg_timer_ns_inst(
	.leds(leds_timer_ns), 
	.bcd(timer_ns)
 );
 
  //bcd_7seg timer instance
bcd_7seg bcd_7seg_timer_ew_inst(
 .leds(leds_timer_ew), 
 .bcd(timer_ew)
 );
 endmodule 