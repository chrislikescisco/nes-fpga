// Chris Niebauer 2025
// University of Florida

// Simple monolithic testbench intended solely for testing the most basic PPU functionality

module ppu_tb();

logic clk = 1'b0;
initial begin : clk_gen
    forever #5 clk <= ~clk;
end
logic rst, cpu_rw, cs, interrupt, sram_rd, sram_wr, vout;
logic[7:0] cpu_din, cpu_dout, sram_din, sram_dout;
logic[2:0] cpu_addr;
logic[3:0] ext_in, ext_out;
logic[13:0] sram_addr;

ppu dut (
    .*
);

// In the future, a more robust testbench will have temporal assertions to verify register
// states at various times. This is sufficient for the time being, but I would add an
// assert property that checks $stable for registers during the vblank period
initial begin
    // Verify powerup behavior
    @(posedge clk);
    assert (dut.ppuctrl == '0) $display("PPUCONTROL initialized correctly");
        else $error("PPUCONTROL incorrectly initialized, value is %h", dut.ppuctrl);
    assert (dut.ppumask == '0) $display("PPUMASK initialized correctly");
        else $error("PPUMASK incorrectly initialized, value is %h", dut.ppumask);
    assert (dut.ppuscroll == '0) $display("PPUSCROLL initialized correctly");
        else $error("PPUSCROLL incorrectly initialized, value is %h", dut.ppuscroll);
    assert (dut.ppuaddr == '0) $display("PPUADDR initialized correctly");
        else $error("PPUADDR incorrectly initialized, value is %h", dut.ppuaddr);
    assert (dut.ppudata == '0) $display("PPUDATA initialized correctly");
        else $error("PPUDATA incorrectly initialized, value is %h", dut.ppudata);
    assert (dut.ppustatus == '0) $display("PPUSTATUS initialized correctly");
        else $error("PPUSTATUS incorrectly initialized, value is %h", dut.ppustatus);
    // Mimic startup wait routine
    while(cpu_dout[7] !== 1'b1) begin
        cpu_addr <= 3'h2;
        cpu_rw <= 1'b0;
        @(posedge clk);
    end
    @(posedge clk);
    while(cpu_dout[7] !== 1'b1) begin
        cpu_addr <= 3'h2;
        cpu_rw <= 1'b0;
        @(posedge clk);
    end
    assert ($time / 10 == 57165) $display("Waited for correct number of cycles");
        else $error("Waited for %0d cycles", $time/10);
    // Begin reading/writing to registers and verify output
    cpu_addr <= 3'h4;
    cpu_din <= 8'h2;
    cpu_rw <= 1'b1;
    @(posedge clk);
    cpu_addr <= 3'h7;
    cpu_din <= 8'h4;
    cpu_rw <= 1'b1;
    @(posedge clk);
    cpu_addr <= 3'h0;
    cpu_din <= 8'h4;
    @(posedge clk);
    cpu_addr <= 3'h1;
    cpu_din <= 8'd5;
    assert(sram_dout == 8'h6) $display("Correct result of internal addition");
        else $error("Incorrect addition result of %0d", sram_dout);
    @(posedge clk);
    rst <= 1'b1;
    @(posedge clk);
    rst <= 1'b0;
    @(posedge clk);
   
    assert (dut.ppuctrl == '0) $display("PPUCONTROL reset correctly");
            else $error("PPUCONTROL incorrectly reset, value is %h", dut.ppuctrl);
    assert (dut.ppumask == '0) $display("PPUMASK reset correctly");
        else $error("PPUMASK incorrectly reset, value is %h", dut.ppumask);
    // Mimic startup wait routine
    while(cpu_dout[7] !== 1'b1) begin
        cpu_addr <= 3'h2;
        cpu_rw <= 1'b0;
        @(posedge clk);
    end
    @(posedge clk);
    while(cpu_dout[7] !== 1'b1) begin
        cpu_addr <= 3'h2;
        cpu_rw <= 1'b0;
        @(posedge clk);
    end
    assert (dut.rst_cycles == 57165) $display("Waited for correct number of cycles");
        else $error("Waited for %0d cycles", $time/10);
    $display("Testbench finished!");
    disable clk_gen;
end

endmodule;