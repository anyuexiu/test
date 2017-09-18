module AHB_reg(
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
	//
	error,
	//
	dma_axi_start,
	dma_axi_done,
	dma_cfg_saddr,
	dma_cfg_daddr,
	dma_cfg_number,
	dma_init
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
//
output error;
//
output dma_axi_start;
input dma_axi_done;
output [31:0] dma_cfg_saddr;
output [31:0] dma_cfg_daddr;
output [13:0] dma_cfg_number;
output dma_init;

reg hsel_r;
reg hwrite_r;
reg [1:0] htrans_r;
reg [31:0] hwaddr_r;
reg [31:0] hraddr_r;
always@(posedge hclk) begin
	if(!hreset) begin
		hsel_r <= 1'd0;
		hwrite_r <= 1'd0;
		htrans_r <= 2'd0;
		hwaddr_r <= 31'd0;
		hraddr_r <= 31'd0;
	end
	else begin
		if(hready_in && hsel) begin
			hsel_r <= hsel;
			hwrite_r <= hwrite;
			htrans_r <= htrans;
			if(hwrite) begin
				hwaddr_r <= haddr;
				hraddr_r <= hraddr_r;
			end
			else begin
				hwaddr_r <= hwaddr_r;
				hraddr_r <= haddr;
			end
		end
		else begin
			hsel_r <= hsel_r;
			hwrite_r <= hwrite_r;
			htrans_r <= htrans_r;
			hwaddr_r <= hwaddr_r;
			hraddr_r <= hraddr_r;
		end
	end
end

wire wen = hready_in && hsel_r && hwrite_r && dma_axi_done;

reg [31:0] dma_cfg_saddr;
always@(posedge hclk) begin
	if(!hreset) begin
		dma_cfg_saddr <= 32'd0;
	end
	else begin
		if(wen && hwaddr_r == 32'h0000_0000) begin
			dma_cfg_saddr <= hwdata;
		end
		else begin
			dma_cfg_saddr <= dma_cfg_saddr;
		end
	end
end

reg [31:0] dma_cfg_daddr;
always@(posedge hclk) begin
	if(!hreset) begin
		dma_cfg_daddr <= 32'd0;
	end
	else begin
		if(wen && hwaddr_r == 32'h0000_0004) begin
			dma_cfg_daddr <= hwdata;
		end
		else begin
			dma_cfg_daddr <= dma_cfg_daddr;
		end
	end
end

reg [13:0] dma_cfg_number;
always@(posedge hclk ) begin
	if(!hreset) begin
		dma_cfg_number <= 14'd0;
	end
	else begin
		if(wen && hwaddr_r == 32'h0000_0008) begin
			dma_cfg_number <= hwdata[13:0];
		end
		else begin
			dma_cfg_number <= dma_cfg_number;
		end
	end
end

reg dma_axi_start;
always@(posedge hclk) begin
	if(!hreset) begin
		dma_axi_start <= 1'd0;
	end
	else begin
		if(wen && hwaddr_r == 32'h0000_000c) begin
			dma_axi_start <= hwdata[0];
		end
		else if(dma_axi_done) begin
			dma_axi_start <= 1'd0;
		end
		else begin
			dma_axi_start <= dma_axi_start;
		end
	end
end

reg [31:0] hrdata;
always@(*) begin
	case(hraddr_r) 
	32'h0000_0000:hrdata = dma_cfg_saddr;
	32'h0000_0004:hrdata = dma_cfg_daddr;
	32'h0000_0008:hrdata = dma_cfg_number;
	32'h0000_000c:hrdata = dma_axi_start;
	default:hrdata = 32'd0;
	endcase
end

reg error;
always@(*) begin
	if(hready_in && hsel) begin
		if(~dma_axi_done && haddr <= 32'h0000_000c && hwrite) begin
			error = 1'd1;
		end
		else if(haddr > 32'h0000_0010) begin
			error = 1'd1;
		end
		else begin
			error = 1'd0;
		end
	end
	else begin
		error = 1'b0;
	end
end

endmodule
