module AXI_raddr(
	aclk,
	areset,
	// 
	araddr,
	arlen,
	arvalid,
	arready,
	//
	dma_axi_start,
	dma_axi_raddr_free,
	dma_cfg_saddr,
	dma_cfg_number,
	dma_cfg_sexceed_4k
);

input aclk;
input areset;
//
output [31:0] araddr;
output [3:0] arlen;
output arvalid;
input arready;
//
input dma_axi_start;
output dma_axi_raddr_free;
input [31:0] dma_cfg_saddr;
input [13:0] dma_cfg_number;
input dma_cfg_sexceed_4k;

localparam AXI_raddr_idle = 1'd0;
localparam AXI_raddr_busy = 1'd1;

reg [31:0] araddr;
wire [3:0] arlen;
reg arvalid;
reg dma_axi_raddr_free;

reg [4:0] len;
reg [13:0] axi_raddr_number;

wire [4:0] next_len = (axi_raddr_number > 5'd16)?5'd16:axi_raddr_number;
wire [3:0] align_len = 5'b1_0000 - dma_cfg_saddr[3:0];
assign arlen = len - 1'd1;

reg state;
always@(posedge aclk) begin
	if(!areset) begin
		state <= AXI_raddr_idle;
		araddr <= 32'd0;
		len <= 4'd1;
		arvalid <= 1'd0;
		dma_axi_raddr_free <= 1'd1;
		axi_raddr_number <= 14'd0;
	end
	else begin
		case(state)
		AXI_raddr_idle:begin
			if(dma_axi_start) begin
				state <= AXI_raddr_busy;
				araddr <= dma_cfg_saddr;
				arvalid <= 1'd1;
				dma_axi_raddr_free <= 1'd0;
				if(dma_cfg_sexceed_4k) begin
					len <= align_len;
					axi_raddr_number <= dma_cfg_number - align_len;
				end
				else begin
					if(dma_cfg_number > 5'd16) begin
						len <= 5'd16;
						axi_raddr_number <= dma_cfg_number - 5'd16;
					end
					else begin
						len <= dma_cfg_number;
						axi_raddr_number <= 14'd0;
					end
				end
			end
			else begin
				state <= AXI_raddr_idle;
				araddr <= araddr;
				arvalid <= 1'd0;
				dma_axi_raddr_free <= 1'd1;
				len <= len;
				axi_raddr_number <= 14'd0;
			end
		end
		AXI_raddr_busy:begin
			if(arready) begin
				if(axi_raddr_number == 14'd0) begin
					state <= AXI_raddr_idle;
					araddr <= araddr;
					arvalid <= 1'd0;
					dma_axi_raddr_free <= 1'd1;
					len <= len;
					axi_raddr_number <= 14'd0;
				end
				else begin
					state <= AXI_raddr_busy;
					araddr <= araddr + len;
					arvalid <= 1'd1;
					dma_axi_raddr_free <= 1'd0;
					len <= next_len;
					axi_raddr_number <= axi_raddr_number - next_len;
				end
			end
			else begin
				state <= AXI_raddr_busy;
				araddr <= araddr;
				arvalid <= 1'd1;
				dma_axi_raddr_free <= 1'd0;
				len <= len;
				axi_raddr_number <= axi_raddr_number;
			end
		end
		endcase
	end
end

endmodule
