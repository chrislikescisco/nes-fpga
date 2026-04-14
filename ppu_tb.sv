// Chris Niebauer 2025
// University of Florida

// Simple monolithic testbench intended solely for testing the most basic PPU functionality

module ppu_tb();

logic clk = 1'b0;
clk_gen : initial begin
    forever #5 clk <= ~clk;
end
logic clk, rst, cpu_rw, cs, interrupt, sram_rd, sram_wr, vout;
logic[7:0] cpu_din, cpu_dout, sram_din, sram_dout;
logic[2:0] cpu_addr;
logic[3:0] ext_in, ext_out;
logic[13:0] sram_addr;

ppu dut (
    .*
);

initial begin
    @(posedge clk); // Wait one cycle so we can verify powerup behavior
    assert (ppuctrl == '0) $display("PPUCONTROL initialized correctly");
        else $error("PPUCONTROL incorrectly initialized, value is %h", ppuctrl);
    assert (ppumask == '0) $display("PPUCONTROL initialized correctly");
        else $error("PPUCONTROL incorrectly initialized, value is %h", ppumask);
    disable(clk_gen);
end