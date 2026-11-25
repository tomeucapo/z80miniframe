// MSX I/O port decoder for the Z80AIO expansion CPLD (ATF1502AS).
//
// The decoder only generates active-low MSX selects. On the motherboard,
// combine each output with the corresponding active-low native CE:
//
//   VDP_CE_FINAL_N = VDP_CE_NATIVE_N & msx_vdp_ce_n
//   PSG_CE_FINAL_N = PSG_CE_NATIVE_N & msx_psg_ce_n
//   PPI_CE_FINAL_N = PPI_CE_NATIVE_N & msx_ppi_ce_n
//
// I/O decoding uses A[7:0], as MSX devices decode the low port byte.
// A[8:15] are intentionally ignored. /IORQ is active low.
module msx_io_decode (
    input  wire [7:0] a,
    input  wire       iorq_n,

    output wire       msx_vdp_ce_n,
    output wire       msx_psg_ce_n,
    output wire       msx_ppi_ce_n
);

    wire vdp_port = (a[7:1] == 7'b1001100); // 98h data, 99h control/status
    wire psg_port = (a[7:1] == 7'b1010000); // A0h register, A1h data
    wire ppi_port = (a[7:2] == 6'b101010);  // A8h through ABh

    // Select is asserted when /IORQ is low and the address matches.
    assign msx_vdp_ce_n = iorq_n | ~vdp_port;
    assign msx_psg_ce_n = iorq_n | ~psg_port;
    assign msx_ppi_ce_n = iorq_n | ~ppi_port;

endmodule
