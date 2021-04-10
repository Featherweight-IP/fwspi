
/****************************************************************************
 * fwspi_initiator_tb.sv
 ****************************************************************************/

`ifdef NEED_TIMESCALE
`timescale 1ns/1ns
`endif

`include "wishbone_macros.svh"
  
/**
 * Module: fwspi_initiator_tb
 * 
 * TODO: Add module documentation
 */
module fwspi_initiator_tb(input clock);
	
`ifdef HAVE_HDL_CLOCKGEN
	reg clock_r = 0;
	
	initial begin
		forever begin
`ifdef NEED_TIMESCALE
			#10;
`else
			#10ns;
`endif
			clock_r <= ~clock_r;
		end
	end
	
	assign clock = clock_r;
`endif
	
`ifdef IVERILOG
`include "iverilog_control.svh"
`endif
	
	reg reset = 0;
	reg[7:0] reset_cnt = 0;
	
	always @(posedge clock) begin
		case (reset_cnt)
			1: begin
				reset <= 1;
				reset_cnt <= reset_cnt + 1;
			end
			20: reset <= 0;
			default: reset_cnt <= reset_cnt + 1;
		endcase
	end

	`WB_WIRES(i2dut_, 4, 32);
	
	wire inta, sck, mosi, miso;
	
	wb_initiator_bfm #(
		.ADDR_WIDTH  (4 ), 
		.DATA_WIDTH  (32)
		) u_reg_bfm (
		.clock       (clock      ), 
		.reset       (reset      ), 
		`WB_CONNECT( , i2dut_)
		);
	
	fwspi_initiator u_dut (
		.clock     (clock    ), 
		.reset     (reset    ), 
		`WB_CONNECT(rt_, i2dut_),
		.inta(inta),
		.sck(sck),
		.mosi(mosi),
		.miso(miso)
	);

	gpio_bfm #(
		.N_PINS    (1   ), 
		.N_BANKS   (1  )
		) u_irq_bfm (
		.clock     (clock    ), 
		.reset     (reset    ), 
		.pin_i     (inta     ));
	
	spi_target_bfm u_spi_bfm (
		.reset      (reset     ), 
		.sck        (sck       ), 
		.sdi        (mosi      ), 
		.sdo        (miso      ), 
		.csn        (1'b0      ));

endmodule


