`timescale 1ns / 1ps

`include".\OpenMIPS\defines.v"

module openmips_min_sopc(
    input wire clk_in,
    input wire rst_n,
    input wire flash_continue,

    // UART
	input wire     uart_in,
	output wire    uart_out,
	
	// GPIO
	input wire[15:0]       gpio_i,
	output wire[31:0]      gpio_o, //31:16-led, 15:8-o_seg, 7:0-o_sel
	
	// Flash
    output  cs_n,
    input   sdi,
    output  sdo,
    output  wp_n,
    output  hld_n,
    
    // DDR2 
    inout [15:0]            ddr2_dq,
	inout [1:0]             ddr2_dqs_n,
	inout [1:0]             ddr2_dqs_p,
	output [12:0]           ddr2_addr,
	output [2:0]            ddr2_ba,
	output                  ddr2_ras_n,
	output                  ddr2_cas_n,
	output                  ddr2_we_n,
	output [0:0]            ddr2_ck_p,
	output [0:0]            ddr2_ck_n,
	output [0:0]            ddr2_cke,
	output [0:0]            ddr2_cs_n,
	output [1:0]            ddr2_dm,
	output [0:0]            ddr2_odt
    );

    wire[31:0]  m0_data_i,m0_data_o,m0_addr_i;
    wire[3:0]   m0_sel_i;
    wire        m0_we_i,m0_cyc_i,m0_stb_i,m0_ack_o;

    wire[31:0]  m1_data_i,m1_data_o,m1_addr_i;
    wire[3:0]   m1_sel_i;
    wire        m1_we_i,m1_cyc_i,m1_stb_i,m1_ack_o;

    wire[31:0]  s0_data_i,s0_data_o,s0_addr_o;
    wire[3:0]   s0_sel_o;
    wire        s0_we_o,s0_cyc_o,s0_stb_o,s0_ack_i;

    wire[31:0]  s1_data_i,s1_data_o,s1_addr_o;
    wire[3:0]   s1_sel_o;
    wire        s1_we_o,s1_cyc_o,s1_stb_o,s1_ack_i;

    wire[31:0]  s2_data_i,s2_data_o,s2_addr_o;
    wire[3:0]   s2_sel_o;
    wire        s2_we_o,s2_cyc_o,s2_stb_o,s2_ack_i;

    wire[31:0]  s3_data_i,s3_data_o,s3_addr_o;
    wire[3:0]   s3_sel_o;
    wire        s3_we_o,s3_cyc_o,s3_stb_o,s3_ack_i;

//############################################
    wire clk;
    wire rst;
    assign rst = ~rst_n;
    assign clk = clk_in;
    
//############################################
    wire [5:0] int;
    wire timer_int,gpio_int,uart_int;
    assign int = {3'b000,gpio_int,uart_int,timer_int};
    
    openmips openmips0(
        .clk(clk),      .rst(rst),

        .iwishbone_data_i(m1_data_o),.iwishbone_ack_i(m1_ack_o),
        .iwishbone_addr_o(m1_addr_i),.iwishbone_data_o(m1_data_i),
        .iwishbone_we_o(m1_we_i),.iwishbone_sel_o(m1_sel_i),
        .iwishbone_stb_o(m1_stb_i),.iwishbone_cyc_o(m1_cyc_i),

        .int_i(int),

        .dwishbone_data_i(m0_data_o),.dwishbone_ack_i(m0_ack_o),
        .dwishbone_addr_o(m0_addr_i),.dwishbone_data_o(m0_data_i),
        .dwishbone_we_o(m0_we_i),.dwishbone_sel_o(m0_sel_i),
        .dwishbone_stb_o(m0_stb_i),.dwishbone_cyc_o(m0_cyc_i),

        .timer_int_o(timer_int)
    );
    
//############################################    
    uart_top uart_top0(
        .wb_clk_i(clk),.wb_rst_i(rst),
        .wb_adr_i(s1_addr_o[4:0]),.wb_dat_i(s1_data_o),
        .wb_dat_o(s1_data_i),.wb_we_i(s1_we_o),
        .wb_stb_i(s1_stb_o),.wb_cyc_i(s1_cyc_o),
        .wb_ack_o(s1_ack_i),.wb_sel_i(s1_sel_o),

        .int_o(uart_int),

        .stx_pad_o(uart_out),.srx_pad_i(uart_in),
        .cts_pad_i(1'b0),.dsr_pad_i(1'b0),
        .ri_pad_i(1'b0),.dcd_pad_i(1'b0),
        .rts_pad_o(),.dtr_pad_o()
    );
  
//############################################
//    wire[31:0] gpio_o;
    wire sdram_init_done;
    wire [31:0] gpio_i_temp;
    assign gpio_i_temp={15'h0,sdram_init_done,gpio_i};

    gpio_top gpio_top0(
        .wb_clk_i(clk),.wb_rst_i(rst),
        .wb_cyc_i(s2_cyc_o),.wb_adr_i(s2_addr_o[7:0]),
        .wb_dat_i(s2_data_o),.wb_sel_i(s2_sel_o),
        .wb_we_i(s2_we_o),.wb_stb_i(s2_stb_o),
        .wb_dat_o(s2_data_i),.wb_ack_o(s2_ack_i),
        .wb_err_o(),

        .wb_inta_o(gpio_int),
        .ext_pad_i(gpio_i_temp),
        .ext_pad_o(gpio_o),
        .ext_padoe_o()
    );
    
//############################################    
	flash_rom flash_rom(
        .wb_clk_i(clk_in), //100MHz
        .wb_rst_i(rst),
        .wb_adr_i({s3_addr_o[23:2],2'b00}),
        .wb_dat_o(s3_data_i),
        .wb_dat_i(s3_data_o),
        .wb_sel_i(s3_sel_o),
        .wb_we_i(s3_we_o),
        .wb_stb_i(s3_stb_o), 
        .wb_cyc_i(s3_cyc_o), 
        .wb_ack_o(s3_ack_i),
        
        .flash_continue(flash_continue),
        .cs_n(cs_n),
        .sdi(sdi),
        .sdo(sdo),
        .wp_n(wp_n),
        .hld_n(hld_n)
    );
  
//############################################    
    DDR2 DDR2(
        .wb_rst_i(1'b0),
        .wb_clk_i(clk_in),
                
        .wb_stb_i(s0_stb_o),
        .wb_ack_o(s0_ack_i),
        .wb_adr_i({s0_addr_o[26:2],2'b00}),
        .wb_we_i(s0_we_o),
        .wb_dat_i(s0_data_o),
        .wb_sel_i(s0_sel_o),
        .wb_dat_o(s0_data_i),
        .wb_cyc_i(s0_cyc_o),
        
        .init_calib_complete(sdram_init_done),

		.ddr2_ck_p(ddr2_ck_p),
		.ddr2_ck_n(ddr2_ck_n),
		.ddr2_cke(ddr2_cke),
		.ddr2_cs_n(ddr2_cs_n),
		.ddr2_ras_n(ddr2_ras_n),
		.ddr2_cas_n(ddr2_cas_n),
		.ddr2_we_n(ddr2_we_n),
		.ddr2_dm(ddr2_dm),
		.ddr2_ba(ddr2_ba),
		.ddr2_addr(ddr2_addr),
		.ddr2_dq(ddr2_dq),
		.ddr2_dqs_p(ddr2_dqs_p),
		.ddr2_dqs_n(ddr2_dqs_n),
		.ddr2_odt(ddr2_odt)
    );

//############################################    
    wb_conmax_top wb_conmax_top0(
        .clk_i(clk),.rst_i(rst),
        
        .m0_data_i(m0_data_i),.m0_data_o(m0_data_o),
        .m0_addr_i(m0_addr_i),.m0_sel_i(m0_sel_i),
        .m0_we_i(m0_we_i),.m0_cyc_i(m0_cyc_i),
        .m0_stb_i(m0_stb_i),.m0_ack_o(m0_ack_o),
        
        .m1_data_i(m1_data_i),.m1_data_o(m1_data_o),
        .m1_addr_i(m1_addr_i),.m1_sel_i(m1_sel_i),
        .m1_we_i(m1_we_i),.m1_cyc_i(m1_cyc_i),
        .m1_stb_i(m1_stb_i),.m1_ack_o(m1_ack_o),
        
        .m2_data_i(`ZeroWord),.m2_data_o(),
        .m2_addr_i(`ZeroWord),.m2_sel_i(4'b0000),
        .m2_we_i(1'b0),.m2_cyc_i(1'b0),
        .m2_stb_i(1'b0),.m2_ack_o(),
        .m2_err_o(),.m2_rty_o(),
        
        .m3_data_i(`ZeroWord),.m3_data_o(),
        .m3_addr_i(`ZeroWord),.m3_sel_i(4'b0000),
        .m3_we_i(1'b0),.m3_cyc_i(1'b0),
        .m3_stb_i(1'b0),.m3_ack_o(),
        .m3_err_o(),.m3_rty_o(),
        
        .m4_data_i(`ZeroWord),.m4_data_o(),
        .m4_addr_i(`ZeroWord),.m4_sel_i(4'b0000),
        .m4_we_i(1'b0),.m4_cyc_i(1'b0),
        .m4_stb_i(1'b0),.m4_ack_o(),
        .m4_err_o(),.m4_rty_o(),
        
        .m5_data_i(`ZeroWord),.m5_data_o(),
        .m5_addr_i(`ZeroWord),.m5_sel_i(4'b0000),
        .m5_we_i(1'b0),.m5_cyc_i(1'b0),
        .m5_stb_i(1'b0),.m5_ack_o(),
        .m5_err_o(),.m5_rty_o(),
        
        .m6_data_i(`ZeroWord),.m6_data_o(),
        .m6_addr_i(`ZeroWord),.m6_sel_i(4'b0000),
        .m6_we_i(1'b0),.m6_cyc_i(1'b0),
        .m6_stb_i(1'b0),.m6_ack_o(),
        .m6_err_o(),.m6_rty_o(),
        
        .m7_data_i(`ZeroWord),.m7_data_o(),
        .m7_addr_i(`ZeroWord),.m7_sel_i(4'b0000),
        .m7_we_i(1'b0),.m7_cyc_i(1'b0),
        .m7_stb_i(1'b0),.m7_ack_o(),
        .m7_err_o(),.m7_rty_o(),
        
        .s0_data_i(s0_data_i),.s0_data_o(s0_data_o),
        .s0_addr_o(s0_addr_o),.s0_sel_o(s0_sel_o),
        .s0_we_o(s0_we_o),.s0_cyc_o(s0_cyc_o),
        .s0_stb_o(s0_stb_o),.s0_ack_i(s0_ack_i),
        .s0_err_i(1'b0),.s0_rty_i(1'b0),
        
        .s1_data_i(s1_data_i),.s1_data_o(s1_data_o),
        .s1_addr_o(s1_addr_o),.s1_sel_o(s1_sel_o),
        .s1_we_o(s1_we_o),.s1_cyc_o(s1_cyc_o),
        .s1_stb_o(s1_stb_o),.s1_ack_i(s1_ack_i),
        .s1_err_i(1'b0),.s1_rty_i(1'b0),
        
        .s2_data_i(s2_data_i),.s2_data_o(s2_data_o),
        .s2_addr_o(s2_addr_o),.s2_sel_o(s2_sel_o),
        .s2_we_o(s2_we_o),.s2_cyc_o(s2_cyc_o),
        .s2_stb_o(s2_stb_o),.s2_ack_i(s2_ack_i),
        .s2_err_i(1'b0),.s2_rty_i(1'b0),
        
        .s3_data_i(s3_data_i),.s3_data_o(s3_data_o),
        .s3_addr_o(s3_addr_o),.s3_sel_o(s3_sel_o),
        .s3_we_o(s3_we_o),.s3_cyc_o(s3_cyc_o),
        .s3_stb_o(s3_stb_o),.s3_ack_i(s3_ack_i),
        .s3_err_i(1'b0),.s3_rty_i(1'b0),
        
        .s4_data_i(),.s4_data_o(),
        .s4_addr_o(),.s4_sel_o(),
        .s4_we_o(),.s4_cyc_o(),
        .s4_stb_o(),.s4_ack_i(1'b0),
        .s4_err_i(1'b0),.s4_rty_i(1'b0),
        
        .s5_data_i(),.s5_data_o(),
        .s5_addr_o(),.s5_sel_o(),
        .s5_we_o(),.s5_cyc_o(),
        .s5_stb_o(),.s5_ack_i(1'b0),
        .s5_err_i(1'b0),.s5_rty_i(1'b0),
        
        .s6_data_i(),.s6_data_o(),
        .s6_addr_o(),.s6_sel_o(),
        .s6_we_o(),.s6_cyc_o(),
        .s6_stb_o(),.s6_ack_i(1'b0),
        .s6_err_i(1'b0),.s6_rty_i(1'b0),
        
        .s7_data_i(),.s7_data_o(),
        .s7_addr_o(),.s7_sel_o(),
        .s7_we_o(),.s7_cyc_o(),
        .s7_stb_o(),.s7_ack_i(1'b0),
        .s7_err_i(1'b0),.s7_rty_i(1'b0),
        
        .s8_data_i(),.s8_data_o(),
        .s8_addr_o(),.s8_sel_o(),
        .s8_we_o(),.s8_cyc_o(),
        .s8_stb_o(),.s8_ack_i(1'b0),
        .s8_err_i(1'b0),.s8_rty_i(1'b0),
        
        .s9_data_i(),.s9_data_o(),
        .s9_addr_o(),.s9_sel_o(),
        .s9_we_o(),.s9_cyc_o(),
        .s9_stb_o(),.s9_ack_i(1'b0),
        .s9_err_i(1'b0),.s9_rty_i(1'b0),
        
        .s10_data_i(),.s10_data_o(),
        .s10_addr_o(),.s10_sel_o(),
        .s10_we_o(),.s10_cyc_o(),
        .s10_stb_o(),.s10_ack_i(1'b0),
        .s10_err_i(1'b0),.s10_rty_i(1'b0),
        
        .s11_data_i(),.s11_data_o(),
        .s11_addr_o(),.s11_sel_o(),
        .s11_we_o(),.s11_cyc_o(),
        .s11_stb_o(),.s11_ack_i(1'b0),
        .s11_err_i(1'b0),.s11_rty_i(1'b0),
        
        .s12_data_i(),.s12_data_o(),
        .s12_addr_o(),.s12_sel_o(),
        .s12_we_o(),.s12_cyc_o(),
        .s12_stb_o(),.s12_ack_i(1'b0),
        .s12_err_i(1'b0),.s12_rty_i(1'b0),
        
        .s13_data_i(),.s13_data_o(),
        .s13_addr_o(),.s13_sel_o(),
        .s13_we_o(),.s13_cyc_o(),
        .s13_stb_o(),.s13_ack_i(1'b0),
        .s13_err_i(1'b0),.s13_rty_i(1'b0),
        
        .s14_data_i(),.s14_data_o(),
        .s14_addr_o(),.s14_sel_o(),
        .s14_we_o(),.s14_cyc_o(),
        .s14_stb_o(),.s14_ack_i(1'b0),
        .s14_err_i(1'b0),.s14_rty_i(1'b0),
        
        .s15_data_i(),.s15_data_o(),
        .s15_addr_o(),.s15_sel_o(),
        .s15_we_o(),.s15_cyc_o(),
        .s15_stb_o(),.s15_ack_i(1'b0),
        .s15_err_i(1'b0),.s15_rty_i(1'b0)
    );

endmodule
