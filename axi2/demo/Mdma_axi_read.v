module Mdma_axi_read(
	aclk,
	areset,
	//
	valid,
	head_addr,
	burst_len,
	free,
	//
	fifo_wen,
	fifo_wdata,
	//
	araddr,
	arlen,
	arvalid,
	arready,
	//
	rdata,
	rvalid,
	rready,
	rlast
);

input aclk;
input areset;
//
input valid;
input [31:0] head_addr;
input [4:0] burst_len;
output free;
//
output fifo_wen;
output [63:0] fifo_wdata;
//
output [31:0] araddr;
output [3:0] arlen;
output arvalid;
input arready;
//
input [63:0] rdata;
input rvalid;
output rready;
input rlast;

assign rready = 1'b1;

// ========================= araddr
reg [31:0] araddr;
always@(posedge aclk) begin
	if(!areset) begin
		araddr <= 32'd0;
	end
	else if(valid) begin
		araddr <= head_addr;
	end
	else begin
		araddr <= araddr;
	end
end

// ========================= arlen
reg [3:0] arlen;
always@(posedge aclk) begin
	if(!areset) begin
		arlen <= 4'd0;
	end
	else if(valid) begin
		arlen <= burst_len - 1'b1;
	end
	else begin
		arlen <= arlen;
	end
end	

// ========================= arvalid
reg arvalid;
always@(posedge aclk) begin
	if(!areset) begin
		arvalid <= 1'b0;
	end
	else if(valid) begin
		arvalid <= 1'b1;
	end
	else if(arvalid && arready) begin
		arvalid <= 1'b0;
	end
	else begin
		arvalid <= arvalid;
	end
end

// ========================== free
reg free;
always@(posedge aclk) begin
	if(!areset) begin
		free <= 1'b1;
	end
	else if(valid) begin
		free <= 1'b0;
	end
	else if(rvalid && rready && rlast) begin
		free <= 1'b1;
	end
	else begin
		free <= free;
	end
end

assign fifo_wdata = rdata;
assign fifo_wen = rvalid;

endmodule
