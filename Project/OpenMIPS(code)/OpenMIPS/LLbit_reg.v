//////////////////////////////////////////////////////////////////////
// Module:  LLbit_reg
// File:    LLbit_reg.v
// Author:  Lei Silei
// E-mail:  leishangwen@163.com
// Description: 保存LLbit，用在SC、LL指令中
// Revision: 1.0
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module LLbit_reg(

	input	wire										clk,
	input wire										rst,
	
	input wire                    flush,
	//写端口
	input wire										LLbit_i,
	input wire                    we,
	
	//读端口1
	output reg                    LLbit_o
	
);


	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
					LLbit_o <= 1'b0;
		end else if((flush == 1'b1)) begin
					LLbit_o <= 1'b0;
		end else if((we == `WriteEnable)) begin
					LLbit_o <= LLbit_i;
		end
	end

endmodule