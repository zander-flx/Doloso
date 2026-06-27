/*======================================================
 BINARY-CODED-DECIMAL TO 7-SEGMENT COMMON-ANODE DISPLAY
========================================================
Description:
 This module takes 4-bit decimal value and translate
 it in a 7-segment common-anode display.

Design Engineer:
 Felixander B. Doloso
 Seth Andrei V. Gedalanga

Date:
 Feb. 18, 2026
*/
module bcd_7seg(leds, bcd);
    input[3:0] bcd; // data input in mux
    output reg[0:6] leds; /*	to reorder led from led[0]-led[6] 
										being A-F respectively
								  */

    always @(bcd) begin
        case(bcd)
            4'd0: leds = 7'b1111110;
            4'd1: leds = 7'b0110000;
            4'd2: leds = 7'b1101101;
            4'd3: leds = 7'b1111001; 
            4'd4: leds = 7'b0110011;
            4'd5: leds = 7'b1011011;
            4'd6: leds = 7'b0011111;
            4'd7: leds = 7'b1110000; 
            4'd8: leds = 7'b1111111;
            4'd9: leds = 7'b1110011;
	    4'd10: leds = 7'b0000001;//edit for override
            4'd11: leds = 7'b0000000;
            default: leds = 7'b0000001;
        endcase
    end
endmodule
