module Mips (
    input clock,
    input reset,
    //RAM
    output [17:0] addr,
    inout [15:0] data,
    output wre,
    output oute,
    output hb_mask,
    output lb_mask,
    output chip_en
);
    // wire clock;
    // wire reset;
    // wires da ram

    /////////////////////
    // PIPELINE STAGES //
    /////////////////////

    ///////////
    // Fetch //
    ///////////
    Fetch fetch_i (
        .clock(clock),
        .reset(reset),
        //Execute
        .ex_if_stall(ex_if_stall),
        //Decode
        .if_id_nextpc(if_id_nextpc),
        .if_id_instruc(if_id_instruc),
        .id_if_selpcsource(id_if_selpcsource),
        .id_if_rega(id_if_rega),
        .id_if_pcimd2ext(id_if_pcimd2ext),
        .id_if_pcindex(id_if_pcindex),
        .id_if_selpctype(id_if_selpctype),
        //Memory Controller
        .if_mc_en(if_mc_en),
        .if_mc_addr(if_mc_addr),
        .mc_if_data(mc_if_data)
    );
    //Execute
    wire ex_if_stall;
    //Decode
    wire [31:0] if_id_nextpc;
    wire [31:0] if_id_instruc;
    wire id_if_selpcsource;
    wire [31:0] id_if_rega;
    wire [31:0] id_if_pcimd2ext;
    wire [31:0] id_if_pcindex;
    wire [1:0] id_if_selpctype;
    //Memory Controller
    wire if_mc_en;
    wire [17:0] if_mc_addr;
    wire [31:0] mc_if_data;

    ////////////
    // Decode //
    ////////////
    Decode decode_i (
        .clock(clock),
        .reset(reset),
        //Fetch
        .if_id_instruc(if_id_instruc),
        .if_id_nextpc(if_id_nextpc),
        .id_if_selpcsource(id_if_selpcsource),
        .id_if_rega(id_if_rega),
        .id_if_pcimd2ext(id_if_pcimd2ext),
        .id_if_pcindex(id_if_pcindex),
        .id_if_selpctype(id_if_selpctype),
        //Execute
        .id_ex_selalushift(id_ex_selalushift),
        .id_ex_selimregb(id_ex_selimregb),
        .id_ex_aluop(id_ex_aluop),
        .id_ex_unsig(id_ex_unsig),
        .id_ex_shiftop(id_ex_shiftop),
        .id_ex_shiftamt(id_ex_shiftamt),
        .id_ex_rega(id_ex_rega),
        .id_ex_readmem(id_ex_readmem),
        .id_ex_writemem(id_ex_writemem),
        .id_ex_regb(id_ex_regb),
        .id_ex_imedext(id_ex_imedext),
        .id_ex_selwsource(id_ex_selwsource),
        .id_ex_regdest(id_ex_regdest),
        .id_ex_writereg(id_ex_writereg),
        .id_ex_writeov(id_ex_writeov),
        //Registers
        .id_reg_addra(addra),
        .id_reg_addrb(addrb),
        .reg_id_dataa(dataa),
        .reg_id_datab(datab),
        .reg_id_ass_dataa(ass_dataa),
        .reg_id_ass_datab(ass_datab)
    );
    //Execute
    wire id_ex_selalushift;
    wire id_ex_selimregb;
    wire [2:0] id_ex_aluop;
    wire id_ex_unsig;
    wire [1:0] id_ex_shiftop;
    wire [4:0] id_ex_shiftamt;
    wire [31:0] id_ex_rega;
    wire id_ex_readmem;
    wire id_ex_writemem;
    wire [31:0] id_ex_regb;
    wire [31:0] id_ex_imedext;
    wire id_ex_selwsource;
    wire [4:0] id_ex_regdest;
    wire id_ex_writereg;
    wire id_ex_writeov;


    /////////////
    // Execute //
    /////////////
    Execute execute_i(
        .clock(clock),
        .reset(reset),
        //Decode
        .id_ex_selalushift(id_ex_selalushift),
        .id_ex_selimregb(id_ex_selimregb),
        .id_ex_aluop(id_ex_aluop),
        .id_ex_unsig(id_ex_unsig),
        .id_ex_shiftop(id_ex_shiftop),
        .id_ex_shiftamt(id_ex_shiftamt),
        .id_ex_rega(id_ex_rega),
        .id_ex_readmem(id_ex_readmem),
        .id_ex_writemem(id_ex_writemem),
        .id_ex_regb(id_ex_regb),
        .id_ex_imedext(id_ex_imedext),
        .id_ex_selwsource(id_ex_selwsource),
        .id_ex_regdest(id_ex_regdest),
        .id_ex_writereg(id_ex_writereg),
        .id_ex_writeov(id_ex_writeov),
        //Fetch
        .ex_if_stall(ex_if_stall),
        //Memory
        .ex_mem_readmem(ex_mem_readmem),
        .ex_mem_writemem(ex_mem_writemem),
        .ex_mem_regb(ex_mem_regb),
        .ex_mem_selwsource(ex_mem_selwsource),
        .ex_mem_regdest(ex_mem_regdest),
        .ex_mem_writereg(ex_mem_writereg),
        .ex_mem_wbvalue(ex_mem_wbvalue)
    );
    //Memory
    wire ex_mem_readmem;
    wire ex_mem_writemem;
    wire [31:0] ex_mem_regb;
    wire ex_mem_selwsource;
    wire [4:0] ex_mem_regdest;
    wire ex_mem_writereg;
    wire [31:0] ex_mem_wbvalue;


    ////////////
    // Memory //
    ////////////
    Memory memory_i (
        .clock(clock),
        .reset(reset),
        //Execute
        .ex_mem_readmem(ex_mem_readmem),
        .ex_mem_writemem(ex_mem_writemem),
        .ex_mem_regb(ex_mem_regb),
        .ex_mem_selwsource(ex_mem_selwsource),
        .ex_mem_regdest(ex_mem_regdest),
        .ex_mem_writereg(ex_mem_writereg),
        .ex_mem_wbvalue(ex_mem_wbvalue),
        //Memory Controller
        .mem_mc_rw(mem_mc_rw),
        .mem_mc_en(mem_mc_en),
        .mem_mc_addr(mem_mc_addr),
        .mem_mc_data(mem_mc_data),
        //Writeback
        .mem_wb_regdest(mem_wb_regdest),
        .mem_wb_writereg(mem_wb_writereg),
        .mem_wb_wbvalue(mem_wb_wbvalue)
    );
    //Memory Controller
    wire mem_mc_rw;
    wire mem_mc_en;
    wire [17:0] mem_mc_addr;
    wire [31:0] mem_mc_data;
    //Writeback
    wire [4:0] mem_wb_regdest;
    wire mem_wb_writereg;
    wire [31:0] mem_wb_wbvalue;

    ///////////////
    // Writeback //
    ///////////////
    Writeback writeback_i (
        //Memory
        .mem_wb_regdest(mem_wb_regdest),
        .mem_wb_writereg(mem_wb_writereg),
        .mem_wb_wbvalue(mem_wb_wbvalue),
        //Registers
        .wb_reg_en(wb_reg_en),
        .wb_reg_addr(wb_reg_addr),
        .wb_reg_data(wb_reg_data)
    );


    ///////////////
    // Registers //
    ///////////////
    Registers registers_i (
        .clock(clock),
        .reset(reset),
        .addra(addra),
        .dataa(dataa),
        .ass_dataa(ass_dataa),
        .addrb(addrb),
        .datab(datab),
        .ass_datab(ass_datab),
        .enc(enc),
        .addrc(addrc),
        .datac(datac),
        .addrout(addrout),
        .regout(regout)
    );
    wire [4:0] addra;
    wire [31:0] dataa;
    wire [31:0] ass_dataa;
    wire [4:0] addrb;
    wire [31:0] datab;
    wire [31:0] ass_datab;
    wire enc;
    wire [4:0] addrc;
    wire [31:0] datac;
    wire [4:0] addrout;
    wire [31:0] regout;

    ///////////////////
    // MemController //
    ///////////////////
    MemController memcontroller_i (
        .clock(clock),
        .reset(reset),
        //Fetch
        .if_mc_en(if_mc_en),
        .if_mc_addr(if_mc_addr),
        .mc_if_data(mc_if_data),
        //Memory
        .mem_mc_rw(mem_mc_rw),
        .mem_mc_en(mem_mc_en),
        .mem_mc_addr(mem_mc_addr),
        .mem_mc_data(mem_mc_data),
        //Ram
        .mc_ram_addr(addr),
        .mc_ram_wre(wre),
        .mc_ram_data(data)
    );


    /////////
    // RAM //
    /////////
    Ram ram_i (
        .addr(addr),
        .data(data),
        .wre(wre),
        .oute(oute),
        .hb_mask(hb_mask),
        .lb_mask(lb_mask),
        .chip_en(chip_en)
    );

endmodule