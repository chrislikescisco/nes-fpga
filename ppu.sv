// Chris Niebauer 2025
// University of Florida

// Pinout based on the NESDev Wiki: https://www.nesdev.org/wiki/PPU_pinout
// I have OCD

/*************************************************** PPU I/O Pins ******************************************************/
module ppu (                         // For the time being original I/O functionality remains unmodified
    // CPU Pins:
    input  logic             clk,   // 21.4 MHz CPU Clock
    input  logic             rst,   // NOTE: rst is ACTIVE LOW
    input  logic          cpu_rw,   // R/W bit for PPU registers
    input  logic[7:0]    cpu_din,   // Data-in from CPU  --  These were the same pins in the original PPU
    output logic[7:0]   cpu_dout,   // Data-out to CPU   --  but that would make this design much more confusing
    input  logic[2:0]   cpu_addr,   // Used by CPU to select one of the PPU registers to read/write to
    input  logic              cs,   // Used to map PPU regs to CPU address space
    input  logic[3:0]     ext_in,   // Supports chaining two PPUs together, unused in the original console
    output logic[3:0]    ext_out,   // Replaced with RGB in later models, which we may also do
    output logic             int,   // Interrupt pin that feeds into CPU

    // SRAM Pins:
    output logic[13:0] sram_addr,   // Address bits for SRAM
    input  logic[7:0]   sram_din,   // Data-in from SRAM  --  Similarly to before, these were on the same pins, and were
    output logic[7:0]  sram_dout,   // Data-out to SRAM   --  also combined with ram_addr[7:0]
    output logic         sram_rd,   // RD bit for SRAM (NOTE: sram_rd/wr are ACTIVE LOW)
    output logic         sram_wr,   // WR bit fot SRAM -- Not asserted when writing to internal pallette range
    output logic            vout    // Video output (originally composite video, will be HDMI in future revisions)
    
    // NOTE: Since we are not using combined address/data pins, I did not include the ALE pin from the original design
);
/*************************************************** PPU I/O Pins ******************************************************/

/*************************************************** PPU Registers ******************************************************/
// PPUCTRL $2000
// Bits: VPHB SINN
//       0123 4567
// V - NMI (non-maskable interrupt) enable, 
logic[7:0] ppuctrl;
logic[7:0] ppumask; 
logic[7:0] ppustatus; 
logic[7:0] ppuscroll;
logic[7:0] ppuaddr;
logic[7:0] ppudata;
logic[7:0] oamaddr; 
logic[7:0] oamdata; 
logic[7:0] oamdma; 