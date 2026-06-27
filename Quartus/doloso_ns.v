module doloso_ns (ns_car,ns_ped,timer_ns,clk,rst_n,en,ovr);
    input  wire clk;
    input  wire rst_n;
    input  wire en;
    input  wire ovr;
    output reg	[2:0]	ns_car;
    output reg	[1:0]	ns_ped;
    output [3:0] timer_ns;

	localparam [3:0]NS0 = 4'b0000;
	localparam [3:0]NS1 = 4'b0001;
	localparam [3:0]NS2 = 4'b0010;
	localparam [3:0]NS3 = 4'b0011;
	localparam [3:0]NS4 = 4'b0100;
	

    reg [3:0] pre_ns; //present East_West state
    reg [3:0] nxt_ns; //next East_West state
    reg [3:0] t;

    //input block
    always @(t or pre_ns or ovr) begin
		case(pre_ns)
			NS0:nxt_ns = (t == 2)? NS1:NS0;//Shifts to ES1 if t = 2 (7 ticks)
			NS1:nxt_ns = (t == 0)? NS2:NS1;//Shifts to ES2 if t = 0
			NS2:nxt_ns = (t == 0)? NS3:NS2;//Shifts to ES3 if t = 0 (7 ticks)
			NS3:nxt_ns = (t == 0)? NS0:NS3;//Shifts to ES0 if t = 0 (1 ticks)
			NS4:nxt_ns = ovr? NS4:NS0;//Shifts to ES4 if ovr = 1
			default: nxt_ns = NS0;
		endcase //end of case(pre_ew)
	    end //end of always @(t or pre_ns or ovr)

    //sequential block
    always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		pre_ns <= NS0;
		t <= 0;
	    end //end  of if(!rst_n)
		
	else if(ovr)  begin
		pre_ns <= NS4;
		t <= clk? 4'd10:4'd11;
	    end
	else if(en) begin
		pre_ns <= nxt_ns;
	
		//Check timer
		case(pre_ns)
			NS0: t <= (t == 4'd0)? (4'b0001):(t - 4'b0001);
			NS1: t <= (t == 4'd0)? (4'b0111):(t - 4'b0001);
			NS2: t <= (t == 4'd2)? (4'b0001):(t - 4'b0001);
 			NS3: t <= (t == 4'd0)? (4'b1010):(t - 4'b0001);
			default: t <= 4'b0111;
		endcase //end of case(pre_ew)
	    end //end of else if(en)
	end //end of always @(posedge clk or negedge rst_n)
    //output block
	always@(pre_ns) begin
		case(pre_ns)
				NS0: begin
					ns_car = 3'b100;
					ns_ped = 2'b01;
				end //end of EW0
				
				NS1: begin
					ns_car = 3'b010;
					ns_ped = 2'b01;
				end //end of EW1
				
				NS2: begin
					ns_car = 3'b001;
					ns_ped = 2'b10;
				end //end of EW2
				
 				NS3: begin
					ns_car = 3'b001;
					ns_ped = 2'b01;
				end //end of EW3
				
				NS4: begin
					ns_car = 3'b001;
					ns_ped = 2'b01;
				end //end of EW4
				
				default: begin 
					ns_car = 3'b100;
					ns_ped = 2'b01;
				end //end of default
			endcase //end of case(pre_ew)
		end //end of always@(pre_ns)
	assign timer_ns = t;
endmodule