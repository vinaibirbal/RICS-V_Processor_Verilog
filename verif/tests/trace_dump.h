/** Trace format per cycle
* [F] pc_address content
* [D] pc_address opcode rd rs1 rs2 funct3 funct7 imm shamt
* [R] rs1 rs2 rd data_rs1 data_rs2 we
* [E] pc_address alu_result branch_taken
* [M] pc_address memory_address read_write memory_size memory_data
* [W] pc_address write rd datard
*/
integer __trace_fd;
initial begin
  __trace_fd = $fopen(`TRACE_FILE, "w");
end
always @(negedge clock) begin
  if(reset == 0) begin
  // F stage trace dump
  $fwrite(__trace_fd, "[F] %x %x\n",
    dut.core.`F_PC,
    dut.core.`F_INSN);
  $fflush(__trace_fd);
  
  // D stage trace dump
  $fwrite(__trace_fd, "[D] %x %x %x %x %x %x %x %x %x\n",
    dut.core.`D_PC,
    dut.core.`D_OPCODE,
    dut.core.`D_RD,
    dut.core.`D_RS1,
    dut.core.`D_RS2,
    dut.core.`D_FUNCT3,
    dut.core.`D_FUNCT7,
    dut.core.`D_IMM,
    dut.core.`D_SHAMT);
  $fflush(__trace_fd);
  
  // R stage trace dump
  $fwrite(__trace_fd, "[R] %x %x %x %x\n",
    dut.core.`R_READ_RS1,
    dut.core.`R_READ_RS2,
    dut.core.`R_READ_RS1_DATA,
    dut.core.`R_READ_RS2_DATA);
  $fflush(__trace_fd);
  
  // E stage trace dump
  $fwrite(__trace_fd, "[E] %x %x %x\n",
    dut.core.`E_PC,
    dut.core.`E_ALU_RES,
    dut.core.`E_BR_TAKEN);
  $fflush(__trace_fd);
  
  // M stage trace dump
  $fwrite(__trace_fd, "[M] %x %x %x %x %x\n",
    dut.core.`M_PC,
    dut.core.`M_ADDRESS,
    dut.core.`M_RW,
    dut.core.`M_SIZE_ENCODED,
    dut.core.`M_DATA);
  $fflush(__trace_fd);
  
  // W stage trace dump
  $fwrite(__trace_fd, "[W] %x %x %x %x\n",
    dut.core.`W_PC,
    dut.core.`W_ENABLE,
    dut.core.`W_DESTINATION,
    dut.core.`W_DATA);
  $fflush(__trace_fd);
  
  end
end