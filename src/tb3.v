/**
 * Testbench 3 - Boolean operations, shift.
 * Esse testbench realiza testes de lógica booleana
 *
 * O teste efetua todas as operações booleanas implementadas, e esperasse
 * que os resultado das mesmas rodando no nosso processador sejam iguais
 * aos gerados pelos ambientes Mars 4.5 e QtSpim 9.1.12 
 *
 * Os sinais de controle monitorados se referem às entradas de dados dos
 * registradores.
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
        $readmemh("tb2_reduce_split.hex", ram_i.memory);

        $dumpfile("mips_tb2.vcd");
        $dumpvars;

        $display("\t\tMem Read/Write\tMem Address\tMem data\tResult");
        $monitor("\t%d\t%d\t%d\t%d", mips_i.memcontroller_i.mem_mc_rw, mips_i.memcontroller_i.mem_mc_addr, 
                                     mips_i.memcontroller_i.mem_mc_data, mips_i.registers_i.dataa);
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