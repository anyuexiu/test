module AHB_slave(
	hclk,
	hreset,
	//
	hsel,
	hready_in,
	hwrite,
	htrans,
	haddr,
	hwdata,
	hrdata,
	hready,
	hresp,
	//
	dma_cfg_saddr,
	dma_cfg_daddr,
	dma_cfg_number,
	dma_axi_start,
	dma_axi_done
);

input hclk;
input hreset;
//
input hsel;
input hready_in;
input hwrite;
input [1:0] htrans;
input [31:0] haddr;
input [31:0] hwdata;
output [31:0] hrdata;
output [1:0] hresp;
output hready;
//
wire error;
//
output dma_axi_start;
input dma_axi_done;
output [31:0] dma_cfg_saddr;
output [31:0] dma_cfg_daddr;
output [13:0] dma_cfg_number;

AHB_reg u_AHB_reg(
	.hclk(hclk),
	.hreset(hreset),
	//
	.hsel(hsel),
	.hready_in(hready_in),
	.hwrite(hwrite),
	.htrans(htrans),
	.haddr(haddr),
	.hwdata(hwdata),
	.hrdata(hrdata),
	//
	.error(error),
	//
	.dma_axi_start(dma_axi_start),
	.dma_axi_done(dma_axi_done),
	.dma_cfg_saddr(dma_cfg_saddr),
	.dma_cfg_daddr(dma_cfg_daddr),
	.dma_cfg_number(dma_cfg_number),
	.dma_init()
);

AHB_resp u_AHB_resp(
	.hclk(hclk),
	.hreset(hreset),
	//
	.error_en(error),
	.hresp(hresp),
	.hready(hready)
);

endmodule
