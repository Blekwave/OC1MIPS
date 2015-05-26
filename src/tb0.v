module Mips_TB;
    reg clock, reset;

    /////////
    // RAM //
    /////////
    
    wire [17:0] addr;
    wire [15:0] data;
    wire wre;
    wire oute;
    wire hb_mask;
    wire lb_mask;
    wire chip_en;

    Ram ram_i (
        .addr(addr),
        .data(data),
        .wre(wre),
        .oute(oute),
        .hb_mask(hb_mask),
        .lb_mask(lb_mask),
        .chip_en(chip_en)
    );

    //////////
    // MIPS //
    //////////

    Mips mips_i (
        .clock(clock),
        .reset(reset),
        //RAM
        .addr(addr),
        .data(data),
        .wre(wre),
        .oute(oute),
        .hb_mask(hb_mask),
        .lb_mask(lb_mask),
        .chip_en(chip_en)
    );

    initial begin
        $readmemh("arithmetics_split.hex", ram_i.memory);

        $dumpfile("mips_tb0.vcd");
        $dumpvars;

        #500 $finish;
    end

    initial begin
        clock <= 0;
        reset <= 1;
        #2 reset <= 0;
        #2 reset <= 1;
    end

    always begin
        #3 clock <= ~clock;
    end

endmodule