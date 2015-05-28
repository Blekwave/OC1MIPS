/**
 * Testbench 2 - ALU, Branching, Memory access
 * Esse testbench realiza testes aritméticos e de acesso à memória
 *
 * O teste cria um vetor de 1 a 20 na memória; depois prossegue para acumular
 * a soma desses valores, obtendo-os de volta da memória, e somando-os um a um num
 * registrador; e no final escreve esse resultado, soma de todos os números de 1 a
 * 20, na posição de memória consecutiva ao último elemento do vetor de 20 elementos
 * Depois disso, carrega esse número recém-calculado para s3, que, se tudo der
 * certo, deverá receber 210 (1+2+3..+20 = 210) vindo da memória
 *
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