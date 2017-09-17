module AXI_raddr_tb;

reg aclk;
reg areset;

wire [31:0] araddr;
wire [3:0] arlen;
wire arvalid;
reg arready;

reg dma_axi_start;
wire dma_axi_raddr_free;
reg [31:0] dma_cfg_saddr;
reg [13:0] dma_cfg_number;
reg dma_cfg_sexceed_4k;

AXI_raddr u_AXI_raddr(
	.aclk(aclk),
	.areset(areset),
	// 
	.araddr(araddr),
	.arlen(arlen),
	.arvalid(arvalid),
	.arready(arready),
	//
	.dma_axi_start(dma_axi_start),
	.dma_axi_raddr_free(dma_axi_raddr_free),
	.dma_cfg_saddr(dma_cfg_saddr),
	.dma_cfg_number(dma_cfg_number),
	.dma_cfg_sexceed_4k(dma_cfg_sexceed_4k)
);

always #1 aclk = ~aclk;
initial begin
	aclk = 0;
	areset = 0;
	#10
	areset = 1;
end

initial begin
	arready = 1;
	dma_axi_start = 0;
	dma_cfg_saddr = 0;
	dma_cfg_number = 50;
	dma_cfg_sexceed_4k = 0;
	
	@(posedge areset);
	#10
	
	@(posedge aclk) 
	dma_axi_start = 1;
	@(posedge aclk)
	dma_axi_start = 0;
	@(negedge arvalid)
	#10
	
	dma_cfg_saddr = 32'h0x0000_0ff5;
	dma_cfg_number = 50;
	dma_cfg_sexceed_4k = 1;
	
	@(posedge aclk) 
	dma_axi_start = 1;
	@(posedge aclk)
	dma_axi_start = 0;
	@(negedge arvalid)
	#10
	
	
	$finish();
end

endmodule
