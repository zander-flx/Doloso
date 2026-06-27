module doloso_ew (ew_car,ew_ped,timer_ew,clk,rst_n,en,ovr);
    input  wire clk;
    input  wire rst_n;
    input  wire en;
    input  wire ovr;
    output reg	[2:0]	ew_car;
    output reg	[1:0]	ew_ped;
    output [3:0] timer_ew;

	localparam [3:0]EW0 = 4'b0000;
	localparam [3:0]EW1 = 4'b0001;
	localparam [3:0]EW2 = 4'b0010;
	localparam [3:0]EW3 = 4'b0011;
	localparam [3:0]EW4 = 4'b0100;
	

    reg [3:0] pre_ew; //present East_West state
    reg [3:0] nxt_ew; //next East_West state
    reg [3:0] t;

    //input block
    always @(t or pre_ew or ovr) begin
		case(pre_ew)
			EW0:nxt_ew = (t == 2)? EW1:EW0;//Shifts to ES1 if t = 2 (7 ticks)
			EW1:nxt_ew = (t == 0)? EW2:EW1;//Shifts to ES2 if t = 0
			EW2:nxt_ew = (t == 0)? EW3:EW2;//Shifts to ES3 if t = 0 (7 ticks)
			EW3:nxt_ew = (t == 0)? EW0:EW3;//Shifts to ES0 if t = 0 (1 ticks)
			EW4:nxt_ew = ovr? EW4:EW0;//Shifts to ES4 if ovr = 1
			default: nxt_ew = EW0;
		endcase //end of case(pre_ew)
	    end //end of always @(t or pre_ns or ovr)

    //sequential block
    always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		pre_ew <= EW0;
		t <= 0;
	    end //end  of if(!rst_n)
		
	else if(ovr)  begin
		pre_ew <= EW4;
		t <= clk? 4'd10:4'd11;
	    end
	else if(en) begin
		pre_ew <= nxt_ew;
	
		//Check timer
		case(pre_ew)
			EW0: t <= (t == 4'd2)? (4'b0001):(t - 4'b0001);
			EW1: t <= (t == 4'd0)? (4'b0111):(t - 4'b0001);
			EW2: t <= (t == 4'd0)? (4'b0001):(t - 4'b0001);
 			EW3: t <= (t == 4'd0)? (4'b1010):(t - 4'b0001);
			default: t <= 4'b1010;
		endcase //end of case(pre_ew)
	    end //end of else if(en)
	end //end of always @(posedge clk or negedge rst_n)
    //output block
	always@(pre_ew) begin
		case(pre_ew)
				EW0: begin
					ew_car = 3'b001;
					ew_ped = 2'b10;
				end //end of EW0
				
				EW1: begin
					ew_car = 3'b001;
					ew_ped = 2'b01;
				end //end of EW1
				
				EW2: begin
					ew_car = 3'b100;
					ew_ped = 2'b01;
				end //end of EW2
				
 				EW3: begin
					ew_car = 3'b010;
					ew_ped = 2'b01;
				end //end of EW3
				
				EW4: begin
					ew_car = 3'b001;
					ew_ped = 2'b01;
				end //end of EW4
				
				default: begin 
					ew_car = 3'b001;
					ew_ped = 2'b10;
				end //end of default
			endcase //end of case(pre_ew)
		end //end of always@(pre_ns)
assign timer_ew = t;
endmodule
