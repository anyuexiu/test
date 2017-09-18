module AHB_resp(
	hclk,
	hreset,
	//
	error_en,
	hresp,
	hready
);

input hclk;
input hreset;
//
input error_en;
output [1:0] hresp;
output hready;

localparam OKAY = 2'b00;
localparam ERROR = 2'b01;
localparam RETRY = 2'b10;
localparam SPLIT = 2'b11;

localparam AHB_resp_okay = 2'b00;
localparam AHB_resp_error1 = 2'b01;
localparam AHB_resp_error2 = 2'b10;

reg [1:0] state;
always@(posedge hclk) begin
	if(!hreset) begin
		state <= AHB_resp_okay;
	end
	else begin
		case(state)
		AHB_resp_okay:begin
			if(error_en) begin
				state <= AHB_resp_error1;
			end
			else begin
				state <= state;
			end
		end
		AHB_resp_error1:begin
			state <= AHB_resp_error2;
		end
		AHB_resp_error2:begin
			state <= AHB_resp_okay;
		end
		default:begin
			state <= AHB_resp_okay;
		end
		endcase
	end
end

assign hready = (state == AHB_resp_error1) ? 1'b0:1'b1;
assign hresp = (state == AHB_resp_okay)?OKAY:ERROR;

endmodule
