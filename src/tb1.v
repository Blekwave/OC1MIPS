/**
 * Testbench 1 - ALU, Shift, Branching
 * Esse testbench realiza testes aritméticos, realizando adições e shifts.
 * Os sinais de controle monitorados se referem às entradas da ALU, ao opcode 
 * e à saída desse módulo, assim como a entrada do Shifter, do valor de shift 
 * e da sua saída.
 */
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
        $readmemh("tb1_shiftme_split.hex", ram_i.memory);

        $dumpfile("mips_tb1.vcd");
        $dumpvars;

        $display("\t\tAluA\tAluB\tAluOut\tAluOP\tShiftIn\tShiftAmt\tResult");
        $monitor("\t%d%d%d\t%d\t%d\t%d%d\t%d", mips_i.execute_i.id_ex_rega, mips_i.execute_i.mux_imregb, mips_i.execute_i.aluout, mips_i.execute_i.id_ex_aluop,
                                 mips_i.execute_i.id_ex_regb, mips_i.execute_i.id_ex_shiftamt, mips_i.execute_i.result);
        #5000 $finish;
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