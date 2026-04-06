# FPGA NES Project

This project implements a **Nintendo Entertainment System (NES) on an FPGA**, using the **ULX3S 85K** development board and targeting the **Colorlight i5**. The goal is to recreate NES functionality—including CPU, PPU, and basic peripherals—while exploring analog and digital video output methods.

---

## Table of Contents

- [Project Overview](#project-overview)  
- [Hardware Requirements](#hardware-requirements)  
- [Video Output](#video-output)  
  - [VGA](#vga)  
  - [HDMI](#hdmi)  
  - [Composite / NTSC](#composite--ntsc)  
- [Development Roadmap](#development-roadmap)  
- [Software](#software)  
- [Getting Started](#getting-started)  
- [License](#license)  

---

## Project Overview

The FPGA NES project replicates the classic NES hardware on modern FPGAs. The main components are:

- **CPU**: Emulates the 6502 processor  
- **PPU**: Generates NES graphics output  
- **APU / Audio**: Basic sound generation (future work)  
- **Peripherals**: Support for NES controllers and potential expansion

This project also serves as a foundation for future FPGA-based retro console projects.

---

## Hardware Requirements

### Development Board

- **ULX3S 85K**  
  - 84K LUTs
  - HDMI output for digital video  
  - On-board SRAM and flash for ROM and video buffering  

- **Colorlight i5 (Target Board)**  
  - 24K LUTs  
  - SODIMM form factor (requires breakout board)  
  - SDRAM for ROM and video buffering  

### Optional Breakout Board

- For analog outputs (VGA or composite) on the Colorlight i5, a custom breakout board converts digital FPGA outputs to analog signals.

---

## Video Output

The project supports multiple display methods:

### VGA

- FPGA outputs **RGB digital signals** per pixel  
- Horizontal and vertical sync signals generated in the FPGA (**VGA timing generator module**)  
- Breakout board uses **resistor ladder DACs** to convert multi-bit RGB to analog voltages  
- VGA is the simplest analog output method for development

### HDMI

- ULX3S 85K has native HDMI output  
- Digital RGB output is converted to HDMI standard in the FPGA  
- HDMI requires scaling or padding because NES resolution (256x240) is lower than standard HDMI resolutions  
- Compatible with HDMI-to-CRT converters for analog displays

### Composite / NTSC

- Composite video is a **single analog wire carrying sync, brightness (luma), and color (chroma)**  
- Full NTSC requires precise timing:
  - Horizontal sync (HSYNC) and vertical sync (VSYNC) embedded  
  - Luma (pixel brightness) per scanline  
  - Chroma (color) encoded as a 3.579545 MHz sine wave with phase shifts for NES color  
  - Colorburst signal for TV color calibration  
- Hybrid NTSC simplifies implementation:
  - Precomputed waveforms per NES color stored in LUTs  
  - FPGA still generates sync and outputs waveform samples to DAC  
  - Easier and more resource-friendly than full NTSC while maintaining CRT compatibility  
- Output via RCA using resistor ladder DAC and optional low-pass filter

---

## Development Roadmap

1. Add **PPU** for graphics output
2. Implement **NES CPU** on ULX3S 85K 
3. Add **APU / audio** and controller support  
4. Develop HDMI output for testing and debugging  
5. Extend to **VGA output**  
6. Design **Colorlight i5 breakout board** for VGA / composite  
7. Implement **full NTSC composite** (optional, for authentic NES output)  

---

## Software

- NES programs run on FPGA CPU via ROM loaded into SRAM  
- Development can include **assembly or C-level code**  
- PPU and timing modules are implemented in **SystemVerilog / Verilog**

---

## Getting Started

1. Flash the FPGA using **ULX3S USB-Blaster**  
2. Load a test NES ROM  
3. Connect display:
   - VGA: resistor ladder DAC to monitor  
   - HDMI: ULX3S HDMI output to monitor / converter  
   - Composite: breakout board → RCA → CRT  
4. Run simulation for CPU and PPU to verify timing and video output  

---
