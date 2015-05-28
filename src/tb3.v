/**
 * Testbench 3 - Boolean operations, shift.
 * Esse testbench realiza testes de lógica booleana
 *
 * O teste efetua todas as operações booleanas implementadas, e esperasse
 * que os resultado das mesmas rodando no nosso processador sejam iguais
 * aos gerados pelos ambientes Mars 4.5 e QtSpim 9.1.12 . 15 testes são
 * efetuados para cada, começando com os bits de 16384 e 16385, sendo que
 * cada operação é testada antes de "shiftear" os dois números para a direita
 * em uma casa.
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

        $display("Results - compare with known values");
        $display("\t\tBoolean test\tBoolean immediate");
        $monitor("\t%d\t%d", mips_i.registers_i.registers[16], mips_i.registers_i.registers[17]);
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