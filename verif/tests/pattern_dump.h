/**
* The following code dumps the traces as patterns
*/
integer __dump_fd;
reg[128 * 6 - 1:0] pattern_dump;
initial begin
  __dump_fd = $fopen(`PATTERN_DUMP_FILE, "w");
end
always @(negedge clock) begin : pattern_dump_proc
  reg[127:0] stage;
  if(reset == 0) begin
    // F stage
    stage = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    stage[`__F_PC] = dut.core.`F_PC;
    stage[`__F_INSN] = dut.core.`F_INSN;
    pattern_dump[`__F_RNG] = stage;
    
    // D stage
    stage = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    stage[`__D_PC] = dut.core.`D_PC;
    stage[`__D_OPCODE] = dut.core.`D_OPCODE;
    stage[`__D_RD] = dut.core.`D_RD;
    stage[`__D_RS1] = dut.core.`D_RS1;
    stage[`__D_RS2] = dut.core.`D_RS2;
    stage[`__D_FUNCT3] = dut.core.`D_FUNCT3;
    stage[`__D_FUNCT7] = dut.core.`D_FUNCT7;
    stage[`__D_IMM] = dut.core.`D_IMM;
    stage[`__D_SHAMT] = dut.core.`D_SHAMT;
    pattern_dump[`__D_RNG] = stage;
    
    // R stage
    stage = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    stage[`__R_READ_RS1] = dut.core.`R_READ_RS1;
    stage[`__R_READ_RS2] = dut.core.`R_READ_RS2;
    stage[`__R_READ_RS1_DATA] = dut.core.`R_READ_RS1_DATA;
    stage[`__R_READ_RS2_DATA] = dut.core.`R_READ_RS2_DATA;
    pattern_dump[`__R_RNG] = stage;
    
    // E stage
    stage = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    stage[`__E_PC] = dut.core.`E_PC;
    stage[`__E_ALU_RES] = dut.core.`E_ALU_RES;
    stage[`__E_BR_TAKEN] = dut.core.`E_BR_TAKEN;
    pattern_dump[`__E_RNG] = stage;
    
    // M stage
    stage = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    stage[`__M_PC] = dut.core.`M_PC;
    stage[`__M_ADDRESS] = dut.core.`M_ADDRESS;
    stage[`__M_RW] = dut.core.`M_RW;
    stage[`__M_SIZE_ENCODED] = dut.core.`M_SIZE_ENCODED;
    stage[`__M_DATA] = dut.core.`M_DATA;
    pattern_dump[`__M_RNG] = stage;
    
    // W stage
    stage = 128'hxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    stage[`__W_PC] = dut.core.`W_PC;
    stage[`__W_ENABLE] = dut.core.`W_ENABLE;
    stage[`__W_DESTINATION] = dut.core.`W_DESTINATION;
    stage[`__W_DATA] = dut.core.`W_DATA;
    pattern_dump[`__W_RNG] = stage;
    
    $fwrite(__dump_fd, "%0x\n", pattern_dump);
  end
end