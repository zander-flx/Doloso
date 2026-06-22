/*====================================
		FSM TIMER DEMO
======================================
DESCRIPTION:
	FSM WITH INTERNAL TIMER BASED ON 
	STATE DIAGRAM. TIMER COUNTS CLOCK 
	CYCLES SPENT IN EACH STATE.
	
DESIGN ENGINEER:
	FELIXANDER B. DOLOSO

DATE:
	MAY 11, 2026


------------------------------------*/
module doloso(ns_car, ns_ped, ew_car, ew_ped, timer_ns, timer_ew, state_ns, state_ew, clk, ovr, en, rst_n);
	//ports
	input 				rst_n;
	input					en;
	input					clk;
	input					ovr;
	output reg	[2:0]	ns_car;
	output reg	[1:0]	ns_ped;
	output reg	[2:0]	ew_car;
	output reg	[1:0]	ew_ped;
	output reg	[3:0]	state_ns;
	output reg	[3:0]	state_ew;
	output 		[3:0]	timer_ns;
	output 		[3:0]	timer_ew;
	
	//state
	localparam [3:0]NS0 = 4'b0000;
	localparam [3:0]NS1 = 4'b0001;
	localparam [3:0]NS2 = 4'b0010;
	localparam [3:0]NS3 = 4'b0011;
	localparam [3:0]NS4 = 4'b0100;
	localparam [3:0]EW0 = 4'b0000;
	localparam [3:0]EW1 = 4'b0001;
	localparam [3:0]EW2 = 4'b0010;
	localparam [3:0]EW3 = 4'b0011;
	localparam [3:0]EW4 = 4'b0100;
	reg [3:0]pre_ns; //present North_South state
	reg [3:0]pre_ew; //present East_West state
	reg [3:0]nxt_ns; //next North_South state
	reg [3:0]nxt_ew; //next East_West state
	reg [3:0]t_ns;
	reg [3:0]t_ew;

	//input block
	always @(t_ns or t_ew or pre_ns or pre_ew or ovr) begin
		case(pre_ns)
			NS0:nxt_ns = (t_ns == 0)? NS1:NS0;//Shifts to NW1 if t_ns = 0 (7 ticks)
			NS1:nxt_ns = (t_ns == 0)? NS2:NS1;//Shifts to NW2 if t_ns = 0 (1 ticks)
			NS2:nxt_ns = (t_ns == 2)? NS3:NS2;//Shifts to NW3 if t_ns = 2 (7 ticks)
			NS3:nxt_ns = (t_ns == 0)? NS0:NS3;//Shifts to NW0 if t_ns = 0	
			NS4:nxt_ns = ovr? NS4:NS0;//Shifts to NW4 if ovr = 1
			default: nxt_ns = NS0;
		endcase //end of case(pre_ns)
		
		case(pre_ew)
			EW0:nxt_ew = (t_ew == 2)? EW1:EW0;//Shifts to ES1 if t_ew = 2 (7 ticks)
			EW1:nxt_ew = (t_ew == 0)? EW2:EW1;//Shifts to ES2 if t_ew = 0
			EW2:nxt_ew = (t_ew == 0)? EW3:EW2;//Shifts to ES3 if t_ew = 0 (7 ticks)
			EW3:nxt_ew = (t_ew == 0)? EW0:EW3;//Shifts to ES0 if t_ew = 0 (1 ticks)
			EW4:nxt_ew = ovr? EW4:EW0;//Shifts to ES4 if ovr = 1
			default: nxt_ew = EW0;
		endcase //end of case(pre_ew)
	end //end of always @(t_ns or t_ew or pre_ns or pre_ew or ovr)
	
	//sequential block
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			pre_ns <= NS0;
			pre_ew <= EW0;
			t_ns <= 0;
			t_ew <= 0;
		end //end  of if(!rst_n)
		
		else if(ovr)  begin
			pre_ns <= NS4;
			pre_ew <= EW4;
			t_ns <= 4'b1010; //bcd_7seg will translate 10 to "-"
			t_ew <= 4'b1010; //made it 10 to align with bcd_7seg modified version
		end //end of else if(ovr)
		
		else if(en) begin
			pre_ns <= nxt_ns;
			pre_ew <= nxt_ew;
	
			//Check timer
			case(pre_ns)
				NS0: t_ns <= (t_ns = 4'd0)? (4'b0001):(t_ns - 4'b0001);
				NS1: t_ns <= (t_ns = 4'd0)? (4'b1010):(t_ns - 4'b0001);
				NS2: t_ns <= (t_ns = 4'd2)? (4'b0001):(t_ns - 4'b0001);
 				NS3: t_ns <= (t_ns = 4'd0)? (4'b0111):(t_ns - 4'b0001);
				default: begin 
					t_ns <= 4'b0111;
				end //end of default
			endcase //end of case(state)
				
			case(pre_ew)
				EW0: t_ew <= (t_ew = 4'd2)? (4'b0001):(t_ew - 4'b0001);
				EW1: t_ew <= (t_ew = 4'd0)? (4'b0111):(t_ew - 4'b0001);
				EW2: t_ew <= (t_ew = 4'd0)? (4'b0001):(t_ew - 4'b0001);
 				EW3: t_ew <= (t_ew = 4'd0)? (4'b1010):(t_ew - 4'b0001);
				default: begin 
					t_ew <= 4'b1010;
				end //end of default
			endcase //end of case(state)
		end //end of else if(en) 
	end //end of always@(posedge clk, negedge rst_n)
	
	
	//output block
	always@(pre_ns or pre_ew)begin
		case(pre_ns)
				NS0: begin
					ns_car = 3'b100;
					ns_ped = 2'b01;
					state_ns = NS0;
				end //end of NW0
				
				NS1: begin
					ns_car = 3'b010;
					ns_ped = 2'b01;
					state_ns = NS1;
				end //end of NW0
				
				NS2: begin
					ns_car = 3'b001;
					ns_ped = 2'b10;
					state_ns = NS2;
				end //end of NW0
				
 				NS3: begin
					ns_car = 3'b001;
					ns_ped = 2'b01;
					state_ns = NS3;
				end //end of NW0
				
				NS4: begin
					ns_car = 3'b001;
					ns_ped = 2'b01;
					state_ns = NS4;
				end //end of NW0
				
				default: begin 
					ns_car = 3'b100;
					ns_ped = 2'b01;
					state_ns = NS0;
				end //end of default
			endcase //end of case(pre_ns)
			
			case(pre_ew)
				EW0: begin
					ew_car = 3'b001;
					ew_ped = 2'b10;
					state_ew = EW0;
				end //end of NW0
				
				EW1: begin
					ew_car = 3'b001;
					ew_ped = 2'b01;
					state_ew = EW0;
				end //end of NW0
				
				EW2: begin
					ew_car = 3'b100;
					ew_ped = 2'b01;
					state_ew = EW0;
				end //end of NW0
				
 				EW3: begin
					ew_car = 3'b010;
					ew_ped = 2'b01;
					state_ew = EW0;
				end //end of NW0
				
				EW4: begin
					ew_car = 3'b001;
					ew_ped = 2'b10;
					state_ew = EW0;
				end //end of NW0
				
				default: begin 
					ew_car = 3'b001;
					ew_ped = 2'b10;
					state_ew = EW0;
				end //end of default
			endcase //end of case(pre_ns)
	 end //end of always@(pre)
	
	assign timer_ns = t_ns;
	assign timer_ew = t_ew;
endmodule