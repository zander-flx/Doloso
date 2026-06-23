/*============================================
	         CLOCK DIVIDER
==============================================
Description:
 This module take high requency input clock (clk_in)
 and divides it down to a lower frequency to produce 
 3Hz clock output.

Design Engineer:
 Felixander B. Doloso
 Seth Andrei V. Gedalanga

Date:
 Feb. 18, 2026
-----------------------------------------------
*/
module  clk_div(clk_out,clk_led,clk_in);
 //ports
 input 		clk_in;
 output reg clk_out = 1'b0;
 output reg clk_led = 1'b0;
 
 //clock @50MHz
 parameter integer PERIOD_OUT		= 1;								//1 second
 parameter integer FREQ_IN			= 50_000_000;					//50Mhz by default
 parameter integer TICKS 			= (FREQ_IN*PERIOD_OUT)/2; 	// no. of ticks per 1.5s (Formula: Ticks = (input frequency * second/s) / 2)
 integer tick_cnt = 0;
 
 always@(posedge clk_in) begin
    if(tick_cnt == TICKS-1) begin 
       clk_out <= ~clk_out;
       clk_led <= ~clk_led;
       tick_cnt <= 27'b0;
    end
    
    else tick_cnt <= tick_cnt + 27'b1;
 
 end


endmodule