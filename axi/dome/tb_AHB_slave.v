module tb_AHB_slave;

reg hclk;
reg hreset;

reg hsel;
reg hwrite;
reg [1:0] htrans;
reg [31:0] haddr;
reg [31:0] hwdata;
wire [31:0] hrdata;
wire hready;
wire hready_in;
wire [1:0] hresp;

wire [31:0] dma_cfg_saddr;
wire [31:0] dma_cfg_daddr;
wire [13:0] dma_cfg_number;
wire dma_axi_start;
reg dma_axi_done;

assign hready_in = 1;

AHB_slave u_AHB_slave(
	.hclk(hclk),
	.hreset(hreset),
	//
	.hsel(hsel),
	.hready_in,
	.hwrite(hwrite),
	.htrans(htrans),
	.haddr(haddr),
	.hwdata(hwdata),
	.hrdata(hrdata),
	.hready(hready),
	.hresp(hresp),
	//
	.dma_cfg_saddr(dma_cfg_saddr),
	.dma_cfg_daddr(dma_cfg_daddr),
	.dma_cfg_number(dma_cfg_number),
	.dma_axi_start(dma_axi_start),
	.dma_axi_done(dma_axi_done)
);

always#1 hclk = ~hclk;
initial begin
	hclk = 0;
	hreset = 0;
	#10
	hreset = 1;
end

initial begin
	hsel = 0;
	hwrite = 0;
	htrans = 0;
	haddr = 0;
	hwdata = 0;
	dma_axi_done = 1;
end

initial begin
	@(posedge hreset)
	forever begin
		@(posedge dma_axi_start)
		@(posedge hclk)
		dma_axi_done = 0;
		#100
		@(posedge hclk)
		dma_axi_done = 1;
	end
end

initial begin
	@(posedge hreset)
	@(posedge hclk)
	//
	hsel = 1;
	hwrite = 1;
	haddr = 0;
	@(posedge hclk)
	hwdata = 9;
	//
	hsel = 1;
	hwrite = 1;
	haddr = 4;
	@(posedge hclk)
	hwdata = 16;
	//
	hsel = 1;
	hwrite = 1;
	haddr = 8;
	@(posedge hclk)
	hwdata = 100;
	// 
	hsel = 1;
	hwrite = 1;
	haddr = 12;
	@(posedge hclk)
	hwdata = 1;
	// 
	hsel = 0;
	
	#50;
	@(posedge hclk)
	
	//
	hsel = 1;
	hwrite = 1;
	haddr = 0;
	@(posedge hclk)
	hwdata = 9;
	//
	hsel = 1;
	hwrite = 1;
	haddr = 4;
	@(posedge hclk)
	hwdata = 16;
	//
	
	#100
	$finish();
	
end

endmodule
