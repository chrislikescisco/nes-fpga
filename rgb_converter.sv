// Kyle Jeter 2026
// University of Florida
// Description: Simple converter for NES-specific 6-bit color code to RGB.
// Concept reference: https://www.nesdev.org/wiki/PPU_palettes
// Color codes source: https://www.nesdev.org/wiki/File:2C02G_wiki.pal
module rgb_converter(
    input logic [5:0] nes_color,
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);

always_comb begin
    unique case(nes_color)

        6'h00: 
            {red, green, blue} = 24'h626262;
        6'h01: 
            {red, green, blue} = 24'h001FB2;
        6'h02: 
            {red, green, blue} = 24'h2404C8;
        6'h03: 
            {red, green, blue} = 24'h5200B2;
        6'h04: 
            {red, green, blue} = 24'h730076;
        6'h05: 
            {red, green, blue} = 24'h800024;
        6'h06: 
            {red, green, blue} = 24'h730B00;
        6'h07: 
            {red, green, blue} = 24'h522800;
        6'h08:  
            {red, green, blue} = 24'h244400;
        6'h09:  
            {red, green, blue} = 24'h005700;
        6'h0A: 
            {red, green, blue} = 24'h005C00;
        6'h0B: 
            {red, green, blue} = 24'h005324;
        6'h0C: 
            {red, green, blue} = 24'h003C76;
        6'h0D: 
            {red, green, blue} = 24'h000000;
        6'h0E: 
            {red, green, blue} = 24'h000000;
        6'h0F: 
            {red, green, blue} = 24'h000000;
        6'h10: 
            {red, green, blue} = 24'hABABAB;
        6'h11: 
            {red, green, blue} = 24'h0D57FF;
        6'h12: 
            {red, green, blue} = 24'h4B30FF;
        6'h13: 
            {red, green, blue} = 24'h8A13FF;
        6'h14: 
            {red, green, blue} = 24'hBC08D6;
        6'h15: 
            {red, green, blue} = 24'hD21269;
        6'h16: 
            {red, green, blue} = 24'hC72E00;
        6'h17: 
            {red, green, blue} = 24'h9D5400;
        6'h18: 
            {red, green, blue} = 24'h607B00;
        6'h19: 
            {red, green, blue} = 24'h209800;
        6'h1A: 
            {red, green, blue} = 24'h00A300;
        6'h1B: 
            {red, green, blue} = 24'h009942;
        6'h1C: 
            {red, green, blue} = 24'h007DB4;
        6'h1D: 
            {red, green, blue} = 24'h000000;
        6'h1E: 
            {red, green, blue} = 24'h000000;
        6'h1F: 
            {red, green, blue} = 24'h000000;
        6'h20: 
            {red, green, blue} = 24'hFFFFFF;
        6'h21: 
            {red, green, blue} = 24'h53AEFF;
        6'h22: 
            {red, green, blue} = 24'h9085FF;
        6'h23: 
            {red, green, blue} = 24'hD365FF;
        6'h24: 
            {red, green, blue} = 24'hFF57FF;
        6'h25: 
            {red, green, blue} = 24'hFF5DCF;
        6'h26: 
            {red, green, blue} = 24'hFF7757;
        6'h27: 
            {red, green, blue} = 24'hFA9E00;
        6'h28: 
            {red, green, blue} = 24'hBDC700;
        6'h29:  
            {red, green, blue} = 24'h7AE700;
        6'h2A: 
            {red, green, blue} = 24'h43F611;
        6'h2B: 
            {red, green, blue} = 24'h26EF7E;
        6'h2C: 
            {red, green, blue} = 24'h2CD5F6;
        6'h2D: 
            {red, green, blue} = 24'h4E4E4E;
        6'h2E: 
            {red, green, blue} = 24'h000000;
        6'h2F: 
            {red, green, blue} = 24'h000000;
        6'h30: 
            {red, green, blue} = 24'hFFFFFF;
        6'h31: 
            {red, green, blue} = 24'hB6E1FF;
        6'h32: 
            {red, green, blue} = 24'hCED1FF;
        6'h33: 
            {red, green, blue} = 24'hE9C3FF;
        6'h34: 
            {red, green, blue} = 24'hFFBCFF;
        6'h35: 
            {red, green, blue} = 24'hFFBDF4;
        6'h36:
            {red, green, blue} = 24'hFFC6C3;
        6'h37: 
            {red, green, blue} = 24'hFFD59A;
        6'h38: 
            {red, green, blue} = 24'hE9E681;
        6'h39: 
            {red, green, blue} = 24'hCEF481;
        6'h3A: 
            {red, green, blue} = 24'hB6FB9A;
        6'h3B: 
            {red, green, blue} = 24'hA9FAC3;
        6'h3C: 
            {red, green, blue} = 24'hA9F0F4;
        6'h3D: 
            {red, green, blue} = 24'hB8B8B8;
        6'h3E: 
            {red, green, blue} = 24'h000000;
        6'h3F: 
            {red, green, blue} = 24'h000000;

        default: 
            {red, green, blue} = 24'h000000;

    endcase
end

endmodule