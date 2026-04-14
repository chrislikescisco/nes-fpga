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
// Information based on https://www.nesdev.org/wiki/PPU_registers
// Detailed functional explanations for all registers can be found there

/*  PPUCTRL
    CPU_ADDR: 0

    Bits: VPHB SINN
          7654 3210
          
    7   (V)  - Vblank NMI enable
    6   (P)  - PPU master/slave (unused)
    5   (H)  - Sprite height
    4   (B)  - Background tile select
    3   (S)  - Sprite tile select
    2   (I)  - Increment mode
    1-0 (NN) - Nametable select / XY scroll bit 8
*/
logic[7:0] ppuctrl;

/*  PPUMASK
    CPU_ADDR: 1

    Bits: BGRs bMmG
          7654 3210
          
    7-5 (BGR) - Color emphasis
    4 (s)     - Sprite enable
    3 (b)     - Background enable
    2 (M)     - Sprite left column enable
    1 (m)     - Background left column enable
    0 (G)     - Greyscale
*/
logic[7:0] ppumask; 

/*  PPUSTATUS
    CPU_ADDR: 2

    Bits: VSO- ----
          7654 3210
          
    7 (V) - Vblank
    6 (S) - Sprite 0 hit
    5 (O) - Sprite overflow
*/
logic[7:0] ppustatus; 

/*  PPUSCROLL
    CPU_ADDR: 5

    Bits: X[n]  | OR | Y[n]
          7-0          7-0
          
    7-0: X/Y scroll bits
*/
logic[7:0] ppuscroll;

/*  PPUADDR
    CPU_ADDR: 6

    Bits:   --    A[n]
          15-14   13-0
          
    13-0: VRAM address bits
*/
logic[15:0] ppuaddr;

/*  PPUDATA
    CPU_ADDR: 7

    Bits: D[n]
          7-0
          
    7-0: VRAM data bits
*/
logic[7:0] ppudata;

/*  OAMADDR
    CPU_ADDR: 3

    Bits: A[n]
          7-0
          
    7-0: OAM address bits
*/
logic[7:0] oamaddr; 

/*  OAMDATA
    CPU_ADDR: 4

    Bits: D[n]
          7-0
          
    7-0: OAM data bits
*/
logic[7:0] oamdata; 

/*  OAMDMA
    CPU_ADDR: $4014

    Bits: A[n]
          7-0
          
    7-0: OAM DMA address
*/
logic[7:0] oamdma;
/*************************************************** PPU Registers ******************************************************/


/*************************************************** PPU Behavioral Definitions ******************************************************/
logic[15:0] rst_cycles; // The PPU ignores writes for the first 29658 cycles after a reset.
                        // Commercial NES games rely on this behavior to function properly,
                        // so it will be replicated by this design

// Power-on behavior - see https://www.nesdev.org/wiki/PPU_power_up_state
initial begin
    ppuctrl = '0;
    ppumask = '0;
    ppuscroll = '0;
    ppuaddr = '0;
    ppudata = '0;
    rst_cycles = '0;
    ppustatus = '0; // Vblank and overflow are random at startup, but I will leave them at 0 for now
end

// Running routine
always @(posedge clk) begin
    if (rst) begin
        ppuctrl <= '0;
        ppumask <= '0;
        rst_cycles <= '0;
    end else if (rst_cycles < 16'h6AF7) begin // The vblank flab is set once at 27384 cycles, then again at 57165 cycles
        rst_cycles++;                         // this behavior is used by NES games to determine that 29658 cycles have
        if (!cpu_rw && cpu_addr == 3'h0) begin  // passed and they can begin writing to the contents of the registers
            ppuctrl[7] <= '0;
        end       
    end else if (rst_cycles == 16'h6AF7) begin
        ppuctrl[7] <= 1'b1;
        rst_cycles++;
    end else if (rst_cycles < 16'hD4FC) begin
        rst_cycles++;                         // this behavior is used by NES games to determine that 29658 cycles have
        if (!cpu_rw && cpu_addr == 3'h0) begin  // passed and they can begin writing to the contents of the registers
            ppuctrl[7] <= '0;
        end
    end else if (rst_cycles == 16'hD4FC) begin
        ppuctrl[7] <= 1'b1;
        rst_cycles++;
    end else (rst_cycles == 16'hD4FD) begin
        rst_cycles++;                         
        if (!cpu_rw && cpu_addr == 3'h0) begin  
            ppuctrl[7] <= '0;
        end
    end else begin // We can now begin our regular read/write routine
        if (!cpu_rw) begin
            
        end
    end
end