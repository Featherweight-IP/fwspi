/****************************************************************************
 * fwspi_initiator.v
 ****************************************************************************/
 
`include "wishbone_macros.svh"
  
/**
 * Module: fwspi_initiator
 * 
 * TODO: Add module documentation
 */
module fwspi_initiator(
		input			clock,
		input			reset,
		`WB_TARGET_PORT(rt_, 4, 32),
		output			inta,
	
		// Handshake signals to support DMA
		output			tx_ready,
		output			rx_ready,
		
		output			sck,
		output			mosi,
		input			miso
		);

	assign rt_dat_r[31:8] = {24{1'b0}};
	fwspi_initiator_core u_core (
		.clk_i   (clock			), 
		.rst_i   (~reset		), 
		.cyc_i   (rt_cyc		), 
		.stb_i   (rt_stb		), 
		.adr_i   (rt_adr[3:2]	), 
		.we_i    (rt_we  		), 
		.dat_i   (rt_dat_w[7:0]	), 
		.dat_o   (rt_dat_r[7:0]	), 
		.ack_o   (rt_ack		), 
		.inta_o  (inta			),
		.tx_ready(tx_ready      ),
		.rx_ready(rx_ready      ),
		.sck_o   (sck			), 
		.mosi_o  (mosi			), 
		.miso_i  (miso			));

endmodule


