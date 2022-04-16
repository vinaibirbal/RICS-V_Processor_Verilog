task check_F;
  input integer idx;
  output reg res;
  output reg[4095:0] msg;
  begin : check_F_func
    reg[31:0]       pc;
    reg[31:0]       insn;
 
    reg[127:0] p;
    p = pattern[idx][`__F_RNG];
    
    pc              = p[`__F_PC];
    insn            = p[`__F_INSN];
    if(
      (^pc !== 1'bx && pc !== dut.core.`F_PC) ||
      (^insn !== 1'bx && insn !== dut.core.`F_INSN) 
    ) begin
      $sformat(msg, "F stage mismatch: expected PC=%x, INSN=%x, got PC=%x, INSN=%x", 
        pc, insn,
        dut.core.`F_PC, dut.core.`F_INSN);
      res = 0;
    end else begin
      res = 1;
    end
  end
endtask

task check_D;
  input integer idx;
  output reg res;
  output reg[4095:0] msg;
  begin : check_D_func
    reg[31:0]       pc;
    reg[6:0]        opcode;
    reg[4:0]        rd;
    reg[4:0]        rs1;
    reg[4:0]        rs2;
    reg[2:0]        funct3;
    reg[6:0]        funct7;
    reg[31:0]       imm;
    reg[4:0]        shamt;
 
    reg[127:0] p;
    p = pattern[idx][`__D_RNG];
    
    pc              = p[`__D_PC];
    opcode          = p[`__D_OPCODE];
    rd              = p[`__D_RD];
    rs1             = p[`__D_RS1];
    rs2             = p[`__D_RS2];
    funct3          = p[`__D_FUNCT3];
    funct7          = p[`__D_FUNCT7];
    imm             = p[`__D_IMM];
    shamt           = p[`__D_SHAMT];
    if(
      (^pc !== 1'bx && pc !== dut.core.`D_PC) ||
      (^opcode !== 1'bx && opcode !== dut.core.`D_OPCODE) ||
      (^rd !== 1'bx && rd !== dut.core.`D_RD) ||
      (^rs1 !== 1'bx && rs1 !== dut.core.`D_RS1) ||
      (^rs2 !== 1'bx && rs2 !== dut.core.`D_RS2) ||
      (^funct3 !== 1'bx && funct3 !== dut.core.`D_FUNCT3) ||
      (^funct7 !== 1'bx && funct7 !== dut.core.`D_FUNCT7) ||
      (^imm !== 1'bx && imm !== dut.core.`D_IMM) ||
      (^shamt !== 1'bx && shamt !== dut.core.`D_SHAMT) 
    ) begin
      $sformat(msg, "D stage mismatch: expected PC=%x, OPCODE=%x, RD=%x, RS1=%x, RS2=%x, FUNCT3=%x, FUNCT7=%x, IMM=%x, SHAMT=%x, got PC=%x, OPCODE=%x, RD=%x, RS1=%x, RS2=%x, FUNCT3=%x, FUNCT7=%x, IMM=%x, SHAMT=%x", 
        pc, opcode, rd, rs1, rs2, funct3, funct7, imm, shamt,
        dut.core.`D_PC, dut.core.`D_OPCODE, dut.core.`D_RD, dut.core.`D_RS1, dut.core.`D_RS2, dut.core.`D_FUNCT3, dut.core.`D_FUNCT7, dut.core.`D_IMM, dut.core.`D_SHAMT);
      res = 0;
    end else begin
      res = 1;
    end
  end
endtask

task check_R;
  input integer idx;
  output reg res;
  output reg[4095:0] msg;
  begin : check_R_func
    reg[4:0]        read_rs1;
    reg[4:0]        read_rs2;
    reg[31:0]       read_rs1_data;
    reg[31:0]       read_rs2_data;
 
    reg[127:0] p;
    p = pattern[idx][`__R_RNG];
    
    read_rs1        = p[`__R_READ_RS1];
    read_rs2        = p[`__R_READ_RS2];
    read_rs1_data   = p[`__R_READ_RS1_DATA];
    read_rs2_data   = p[`__R_READ_RS2_DATA];
    if(
      (^read_rs1 !== 1'bx && read_rs1 !== dut.core.`R_READ_RS1) ||
      (^read_rs2 !== 1'bx && read_rs2 !== dut.core.`R_READ_RS2) ||
      (^read_rs1_data !== 1'bx && read_rs1_data !== dut.core.`R_READ_RS1_DATA) ||
      (^read_rs2_data !== 1'bx && read_rs2_data !== dut.core.`R_READ_RS2_DATA) 
    ) begin
      $sformat(msg, "R stage mismatch: expected READ_RS1=%x, READ_RS2=%x, READ_RS1_DATA=%x, READ_RS2_DATA=%x, got READ_RS1=%x, READ_RS2=%x, READ_RS1_DATA=%x, READ_RS2_DATA=%x", 
        read_rs1, read_rs2, read_rs1_data, read_rs2_data,
        dut.core.`R_READ_RS1, dut.core.`R_READ_RS2, dut.core.`R_READ_RS1_DATA, dut.core.`R_READ_RS2_DATA);
      res = 0;
    end else begin
      res = 1;
    end
  end
endtask

task check_E;
  input integer idx;
  output reg res;
  output reg[4095:0] msg;
  begin : check_E_func
    reg[31:0]       pc;
    reg[31:0]       alu_res;
    reg[0:0]        br_taken;
 
    reg[127:0] p;
    p = pattern[idx][`__E_RNG];
    
    pc              = p[`__E_PC];
    alu_res         = p[`__E_ALU_RES];
    br_taken        = p[`__E_BR_TAKEN];
    if(
      (^pc !== 1'bx && pc !== dut.core.`E_PC) ||
      (^alu_res !== 1'bx && alu_res !== dut.core.`E_ALU_RES) ||
      (^br_taken !== 1'bx && br_taken !== dut.core.`E_BR_TAKEN) 
    ) begin
      $sformat(msg, "E stage mismatch: expected PC=%x, ALU_RES=%x, BR_TAKEN=%x, got PC=%x, ALU_RES=%x, BR_TAKEN=%x", 
        pc, alu_res, br_taken,
        dut.core.`E_PC, dut.core.`E_ALU_RES, dut.core.`E_BR_TAKEN);
      res = 0;
    end else begin
      res = 1;
    end
  end
endtask

task check_M;
  input integer idx;
  output reg res;
  output reg[4095:0] msg;
  begin : check_M_func
    reg[31:0]       pc;
    reg[31:0]       address;
    reg[0:0]        rw;
    reg[1:0]        size_encoded;
    reg[31:0]       data;
 
    reg[127:0] p;
    p = pattern[idx][`__M_RNG];
    
    pc              = p[`__M_PC];
    address         = p[`__M_ADDRESS];
    rw              = p[`__M_RW];
    size_encoded    = p[`__M_SIZE_ENCODED];
    data            = p[`__M_DATA];
    if(
      (^pc !== 1'bx && pc !== dut.core.`M_PC) ||
      (^address !== 1'bx && address !== dut.core.`M_ADDRESS) ||
      (^rw !== 1'bx && rw !== dut.core.`M_RW) ||
      (^size_encoded !== 1'bx && size_encoded !== dut.core.`M_SIZE_ENCODED) ||
      (^data !== 1'bx && data !== dut.core.`M_DATA) 
    ) begin
      $sformat(msg, "M stage mismatch: expected PC=%x, ADDRESS=%x, RW=%x, SIZE_ENCODED=%x, DATA=%x, got PC=%x, ADDRESS=%x, RW=%x, SIZE_ENCODED=%x, DATA=%x", 
        pc, address, rw, size_encoded, data,
        dut.core.`M_PC, dut.core.`M_ADDRESS, dut.core.`M_RW, dut.core.`M_SIZE_ENCODED, dut.core.`M_DATA);
      res = 0;
    end else begin
      res = 1;
    end
  end
endtask

task check_W;
  input integer idx;
  output reg res;
  output reg[4095:0] msg;
  begin : check_W_func
    reg[31:0]       pc;
    reg[0:0]        enable;
    reg[4:0]        destination;
    reg[31:0]       data;
 
    reg[127:0] p;
    p = pattern[idx][`__W_RNG];
    
    pc              = p[`__W_PC];
    enable          = p[`__W_ENABLE];
    destination     = p[`__W_DESTINATION];
    data            = p[`__W_DATA];
    if(
      (^pc !== 1'bx && pc !== dut.core.`W_PC) ||
      (^enable !== 1'bx && enable !== dut.core.`W_ENABLE) ||
      (^destination !== 1'bx && destination !== dut.core.`W_DESTINATION) ||
      (^data !== 1'bx && data !== dut.core.`W_DATA) 
    ) begin
      $sformat(msg, "W stage mismatch: expected PC=%x, ENABLE=%x, DESTINATION=%x, DATA=%x, got PC=%x, ENABLE=%x, DESTINATION=%x, DATA=%x", 
        pc, enable, destination, data,
        dut.core.`W_PC, dut.core.`W_ENABLE, dut.core.`W_DESTINATION, dut.core.`W_DATA);
      res = 0;
    end else begin
      res = 1;
    end
  end
endtask
