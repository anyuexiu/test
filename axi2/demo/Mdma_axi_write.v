module Mdma_axi_write(
	aclk,
	areset,
	//
	valid,
	head_addr,
	burst_len,
	free,
	//
	fifo_ren,
	fifo_rdata,
	//
	awaddr,
	awlen,
	awvalid,
	awready,
	//
	wdata,
	wvalid,
	wready,
	wlast,
	//
	bvalid,
	bready,
);

input aclk;
input areset;
//
input valid;
input [31:0] head_addr;
input [4:0] burst_len;
output free;
//
output fifo_ren;
input [63:0] fifo_rdata;
//
output [31:0] awaddr;
output [3:0] awlen;
output awvalid;
input awready;
//
output [63:0] wdata;
output wvalid;
input wready;
output wlast;
//
input bvalid;
output bready;

assign wdata = fifo_rdata;
assign bready = 1'b1;

// ============================== awaddr;
reg [31:0] awaddr;
always@(posedge aclk) begin
	if(!areset) begin
		awaddr <= 32'd0;
	end
	else if(valid) begin
		awaddr <= head_addr;
	end
	else begin
		awaddr <= awaddr;
	end
end

// ============================== awlen
reg [3:0] awlen;
always@(posedge aclk) begin
	if(!areset) begin
		awlen <= 4'd0;
	end
	else if(valid) begin
		awlen <= burst_len - 1'b1;
	end
	else begin
		awlen <= awlen;
	end
end

// ============================== awvalid
reg awvalid;
always@(posedge aclk) begin
	if(!areset) begin
		awvalid <= 1'b0;
	end
	else if(valid) begin
		awvalid <= 1'b1;
	end
	else if(awvalid && awready) begin
		awvalid <= 1'b0;
	end
	else begin
		awvalid <= awvalid;
	end
end

// ============================== wvalid
reg wvalid;
always@(posedge aclk) begin
	if(!areset) begin
		wvalid <= 1'b0;
	end
	else if(valid) begin
		wvalid <= 1'b1;
	end
	else if(wvalid && wready && remain_count == 5'd1) begin
		wvalid <= 1'b0;
	end
	else begin
		wvalid <= wvalid;
	end
end

// ============================= fifo_ren
assign fifo_ren = valid || (wvalid && wready && remain_count!=5'd1);
// ============================= remain_count
reg [4:0] remain_count;
always@(posedge aclk)begin
	if(!areset) begin
		remain_count <= 5'd0;
	end
	else if(valid) begin
		remain_count <= burst_len;
	end
	else if(wvalid && wready) begin
		remain_count <= remain_count - 1'd1;
	end
	else begin
		remain_count <= remain_count;
	end
end
// ============================= wlast
assign wlast = remain_count == 5'd1;

// ============================= free
reg free;
always@(posedge aclk) begin
	if(!areset) begin
		free <= 1'b1;
	end
	else if(valid) begin
		free <= 1'b0;
	end
	else if(wvalid && wready && wlast) begin
		free <= 1'b1;
	end
	else begin
		free <= free;
	end
end

endmodule
