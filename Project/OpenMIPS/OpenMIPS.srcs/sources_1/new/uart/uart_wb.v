// UART core WISHBONE interface 
//
// Author: Jacob Gorban   (jacob.gorban@flextronicssemi.com)
// Company: Flextronics Semiconductor
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "uart_defines.v"
 
module uart_wb (clk, wb_rst_i, 
	wb_we_i, wb_stb_i, wb_cyc_i, wb_ack_o, wb_adr_i,
	wb_adr_int, wb_dat_i, wb_dat_o, wb_dat8_i, wb_dat8_o, wb_dat32_o, wb_sel_i,
	we_o, re_o // Write and read enable output for the core
);

input 		  clk;

// WISHBONE interface	
input 		  wb_rst_i;
input 		  wb_we_i;
input 		  wb_stb_i;
input 		  wb_cyc_i;
input [3:0]   wb_sel_i;
input [`UART_ADDR_WIDTH-1:0] 	wb_adr_i; //WISHBONE address line

`ifdef DATA_BUS_WIDTH_8
input [7:0]  wb_dat_i; //input WISHBONE bus 
output [7:0] wb_dat_o;
reg [7:0] 	 wb_dat_o;
wire [7:0] 	 wb_dat_i;
reg [7:0] 	 wb_dat_is;
`else // for 32 data bus mode
input [31:0]  wb_dat_i; //input WISHBONE bus 
output [31:0] wb_dat_o;
reg [31:0] 	  wb_dat_o;
wire [31:0]   wb_dat_i;
reg [31:0] 	  wb_dat_is;
`endif // !`ifdef DATA_BUS_WIDTH_8

output [`UART_ADDR_WIDTH-1:0]	wb_adr_int; // internal signal for address bus
input [7:0]   wb_dat8_o; // internal 8 bit output to be put into wb_dat_o
output [7:0]  wb_dat8_i;
input [31:0]  wb_dat32_o; // 32 bit data output (for debug interface)
output 		  wb_ack_o;
output 		  we_o;
output 		  re_o;

wire 			  we_o;
reg 			  wb_ack_o;
reg [7:0] 	  wb_dat8_i;
wire [7:0] 	  wb_dat8_o;
wire [`UART_ADDR_WIDTH-1:0]	wb_adr_int; // internal signal for address bus
reg [`UART_ADDR_WIDTH-1:0]	wb_adr_is;
reg 								wb_we_is;
reg 								wb_cyc_is;
reg 								wb_stb_is;
reg [3:0] 						wb_sel_is;
wire [3:0]   wb_sel_i;
reg 			 wre ;// timing control signal for write or read enable

// wb_ack_o FSM
reg [1:0] 	 wbstate;
always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) begin
		wb_ack_o <= #1 1'b0;
		wbstate <= #1 0;
		wre <= #1 1'b1;
	end else
		case (wbstate)
			0: begin
				if (wb_stb_is & wb_cyc_is) begin
					wre <= #1 0;
					wbstate <= #1 1;
					wb_ack_o <= #1 1;
				end else begin
					wre <= #1 1;
					wb_ack_o <= #1 0;
				end
			end
			1: begin
			   wb_ack_o <= #1 0;
				wbstate <= #1 2;
				wre <= #1 0;
			end
			2,3: begin
				wb_ack_o <= #1 0;
				wbstate <= #1 0;
				wre <= #1 0;
			end
		endcase

assign we_o =  wb_we_is & wb_stb_is & wb_cyc_is & wre ; //WE for registers	
assign re_o = ~wb_we_is & wb_stb_is & wb_cyc_is & wre ; //RE for registers	

// Sample input signals
always  @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i) begin
		wb_adr_is <= #1 0;
		wb_we_is <= #1 0;
		wb_cyc_is <= #1 0;
		wb_stb_is <= #1 0;
		wb_dat_is <= #1 0;
		wb_sel_is <= #1 0;
	end else begin
		wb_adr_is <= #1 wb_adr_i;
		wb_we_is <= #1 wb_we_i;
		wb_cyc_is <= #1 wb_cyc_i;
		wb_stb_is <= #1 wb_stb_i;
		wb_dat_is <= #1 wb_dat_i;
		wb_sel_is <= #1 wb_sel_i;
	end

`ifdef DATA_BUS_WIDTH_8 // 8-bit data bus
always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i)
		wb_dat_o <= #1 0;
	else
		wb_dat_o <= #1 wb_dat8_o;

always @(wb_dat_is)
	wb_dat8_i = wb_dat_is;

assign wb_adr_int = wb_adr_is;

`else // 32-bit bus
// put output to the correct byte in 32 bits using select line
always @(posedge clk or posedge wb_rst_i)
	if (wb_rst_i)
		wb_dat_o <= #1 0;
	else if (re_o)
		case (wb_sel_is)
			4'b0001: wb_dat_o <= #1 {24'b0, wb_dat8_o};
			4'b0010: wb_dat_o <= #1 {16'b0, wb_dat8_o, 8'b0};
			4'b0100: wb_dat_o <= #1 {8'b0, wb_dat8_o, 16'b0};
			4'b1000: wb_dat_o <= #1 {wb_dat8_o, 24'b0};
			4'b1111: wb_dat_o <= #1 wb_dat32_o; // debug interface output
 			default: wb_dat_o <= #1 0;
		endcase // case(wb_sel_i)

reg [1:0] wb_adr_int_lsb;

always @(wb_sel_is or wb_dat_is)
begin
	case (wb_sel_is)
		4'b0001 : wb_dat8_i = wb_dat_is[7:0];
		4'b0010 : wb_dat8_i = wb_dat_is[15:8];
		4'b0100 : wb_dat8_i = wb_dat_is[23:16];
		4'b1000 : wb_dat8_i = wb_dat_is[31:24];
		default : wb_dat8_i = wb_dat_is[7:0];
	endcase // case(wb_sel_i)

  `ifdef LITLE_ENDIAN
	case (wb_sel_is)
		4'b0001 : wb_adr_int_lsb = 2'h0;
		4'b0010 : wb_adr_int_lsb = 2'h1;
		4'b0100 : wb_adr_int_lsb = 2'h2;
		4'b1000 : wb_adr_int_lsb = 2'h3;
		default : wb_adr_int_lsb = 2'h0;
	endcase // case(wb_sel_i)
  `else
	case (wb_sel_is)
		4'b0001 : wb_adr_int_lsb = 2'h3;
		4'b0010 : wb_adr_int_lsb = 2'h2;
		4'b0100 : wb_adr_int_lsb = 2'h1;
		4'b1000 : wb_adr_int_lsb = 2'h0;
		default : wb_adr_int_lsb = 2'h0;
	endcase // case(wb_sel_i)
  `endif
end

assign wb_adr_int = {wb_adr_is[`UART_ADDR_WIDTH-1:2], wb_adr_int_lsb};

`endif // !`ifdef DATA_BUS_WIDTH_8

endmodule










