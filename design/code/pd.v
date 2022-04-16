//OP Codes
`define R_TYPE  7'b0110011
`define I_TYPE  7'b0010011
`define S_TYPE  7'b0100011
`define B_TYPE  7'b1100011
`define LUI     7'b0110111
`define AUIPC   7'b0010111
`define JAL     7'b1101111
`define JALR    7'b1100111
`define LOAD    7'b0000011
`define ECALL   7'b1110011
//OP codes


module pd(
  input clock,
  input reset
);


reg [31:0] PC; // Program counter


/* imemory module/probes */

  wire [31:0] imemory_data_in = 0;
  wire read_write = 0;
  wire [31:0] imemory_data_out;

  imemory imemory_0 (
    .clock(clock),
    .reset(reset),
    .address(PC),
    .data_in(imemory_data_in),
    .read_write(read_write),
    .data_out(imemory_data_out)
  );

/* decode_memory module/probes */ 
  wire [6:0] d_OPC;
  wire [4:0] d_RD;
  wire [4:0] d_RS1;
  wire [4:0] d_RS2;
  wire [2:0] d_func3;
  wire [6:0] d_func7;
  wire [31:0] d_IMM;
  wire [4:0] d_SHAMT;   

  wire [31:0] instDo;

  decode_memory decode_memory_0 (
    .clock(clock),
    .reset(reset),
    .inst(instDo),
    .OPC(d_OPC),
    .RD(d_RD),
    .RS1(d_RS1),
    .RS2(d_RS2),
    .func3(d_func3),
    .func7(d_func7),
    .IMM(d_IMM),
    .SHAMT(d_SHAMT)
  );

/* register module/probes */
  wire c_RegWEn; // register read write read = 0, write = 1

  wire [31:0] r_data_rd;
  wire [31:0] r_data_rs1;
  wire [31:0] r_data_rs2;  

  wire p_RegWEn;
  wire [4:0] addr_Wo;
  wire [31:0] dmemWo;

 
  register_file register_file_0 (
    .clock(clock),
    .reset(reset),
    .write_enable(p_RegWEn),
    .addr_rs1(d_RS1),
    .addr_rs2(d_RS2),
    .addr_rd(addr_Wo),
    .data_rd(dmemWo),
    .data_rs1(r_data_rs1),
    .data_rs2(r_data_rs2)

  );

/* alu module/probes */    

  wire[3:0] c_ALUSel;

  wire [31:0] alu_ALU_res;
  wire [31:0] alu_A;
  wire [31:0] alu_B;

  wire[3:0] p_ALUSel;
    
  

  alu alu_0 (
    .clock(clock),
    .reset(reset),
    .ALUSel(p_ALUSel),
    .A(alu_A),
    .B(alu_B),
    .ALU_res(alu_ALU_res)


  );


/* dmemory module/probes */
  wire c_MemRW ; // select dmemory RW  read = 0, write = 1


  wire [31:0] dmemory_dataR;  
  wire [1:0] dmemory_asize;

  assign dmemory_asize = d_func3[1:0]; 

  wire [31:0] aluMo;
  wire [31:0]dataW;
  wire p_MemRW;
  wire [2:0]func3_Mo;


  dmemory dmemory_0 (
    .clock(clock),
    .reset(reset),
    .address(aluMo),
    .data_in(dataW),
    .read_write(p_MemRW),
    .access_size(func3_Mo),
    .data_out(dmemory_dataR)
  );

/* control module/probes decode */

    
    //internal wires or regs for control
    wire c_PCSel ; //select PC_res pc+4 = 0, alu = 1

    wire[1:0] c_BrUn;// unsigned = b0 = 1,  branch compare b1 = 1
    wire c_BSel ; // select dataB(data_rs2)=0  or Immediate=1
    wire c_ASel ; // select dataA(datars1)=0 or PC=1

    wire[1:0] c_WBSel; //select wb  DataR = 0, alu = 1, pc+4 = 2

    wire BrEQ; //EQ = 1, NEQ = 0
    wire BrLT; // LT = 1 , GT = 0


  cu cu_0 (
    .clock(clock),
    .reset(reset),

    .OPC(d_OPC),
    .func3(d_func3),
    .func7(d_func7),
    

    .BrEQ(BrEQ),
    .BrLT(BrLT),

    .PCSel(c_PCSel), /// 1 == kill
    .RegWEn(c_RegWEn),
    .BrUn(c_BrUn),
    .BSel(c_BSel),
    .ASel(c_ASel),
    .MemRW(c_MemRW),
    .WBSel(c_WBSel),
    .ALUSel(c_ALUSel)


  );

  

/* pipeline regs module/probes */
    wire PCSel_f; // considering forwarding
    wire PCSelX ; //select PC_res pc+4 = 0, alu = 1
    wire p_PCSel ; //select PC_res pc+4 = 0, alu = 1
    wire [1:0]p_BrUn; // unsigned, b0 == 1,  branch compare, b1 ==1
    wire p_BSel ; // select dataB(data_rs2)=0  or Immediate=1
    wire p_ASel ; // select dataA(datars1)=0 or PC=1
    wire[1:0] p_WBSel; //select wb  DataR = 0, alu = 1, pc+4 = 2
    wire [31:0] Imm;
    wire [31:0]rs1Xi;
    wire [31:0]rs2Xi;

    wire [2:0]func3_Xo;
    wire [31:0] pcDo;
    wire [31:0] pcWo;
 
    wire [31:0] pcXo;
    wire [31:0] rs1Xo;
    wire [31:0] rs2Xo;
    wire [31:0] immXo;
    wire [4:0] shamtXo;
    wire [31:0] pcMo;
    wire [31:0] rs2Mo;
    wire [31:0] instMo;
    wire nop;

  pipeline_regs pipeline_regs_0 (

    .clock(clock),
    .reset(reset),
    .nop(nop),

    .PCSel_f(PCSel_f), // PC sel calculated from branch compare with forwarding
    .PCSel(c_PCSel), /// PC sel carried forward 
    .BrUn(c_BrUn),
    .RegWEn(c_RegWEn),
    .BSel(c_BSel),
    .ASel(c_ASel),
    .MemRW(c_MemRW),
    .WBSel(c_WBSel),
    .ALUSel(c_ALUSel),
    .IMM(Imm),
    .func3(d_func3),

    
    .pcDi(PC),
    .instDi(imemory_data_out),
    .rs1Xi(rs1Xi),
    .rs2Xi(rs2Xi),
    .addr_Xi(d_RD),
    .aluMi(alu_ALU_res),
    .rs2Mi(rsB),
    .dmemWi(r_data_rd),

    .BSelX(p_BSel),
    .ASelX(p_ASel),
    .MemRWM(p_MemRW),
    .PCSelX(PCSelX), ///signal for signal.h probes only
    .BrUnX(p_BrUn),
    .PCSelM(p_PCSel),
    .RegWEnW(p_RegWEn),
    .WBSelW(p_WBSel),
    .ALUSelX(p_ALUSel),
    .func3_Xo(func3_Xo),
    .func3_Mo(func3_Mo),

    .pcDo(pcDo),
    .instDo(instDo),
    .pcXo(pcXo),
    .rs1Xo(rs1Xo),
    .rs2Xo(rs2Xo),
    .immXo(immXo),
    .pcMo(pcMo),
    .aluMo(aluMo),
    .rs2Mo(rs2Mo),
    .dmemWo(dmemWo),
    .addr_Wo(addr_Wo),
    .pcWo(pcWo)


  );

  /* decode_memory module/probes 1 for stalling on load in f_cu */ 
  wire [6:0] d1_OPC;
  wire [4:0] d1_RD;
  wire [4:0] d1_RS1;
  wire [4:0] d1_RS2;
  wire [2:0] d1_func3;
  wire [6:0] d1_func7;
  wire [31:0] d1_IMM;
  wire [4:0] d1_SHAMT;   

  decode_memory decode_memory_1 (
    .clock(clock),
    .reset(reset),
    .inst(imemory_data_out),
    .OPC(d1_OPC),
    .RD(d1_RD),
    .RS1(d1_RS1),
    .RS2(d1_RS2),
    .func3(d1_func3),
    .func7(d1_func7),
    .IMM(d1_IMM),
    .SHAMT(d1_SHAMT)
  );


  /* Fprwarding control module/probes */

  wire f_ALU_a;
  wire f_ALU_b;
  wire f_W_a;
  wire f_W_b;
  wire f_dataW;
  wire nop_reg;



  f_cu f_cu_0 (
    .clock(clock),
    .reset(reset),

    .addrD(d_RD),
    .addrA(d_RS1),
    .addrB(d_RS2),
    .OPC(d_OPC),

    .addrA1(d1_RS1),
    .addrB1(d1_RS2),
    .OPC1(d1_OPC),
    
    .f_W_a(f_W_a),
    .f_W_b(f_W_b),
    .f_dataW(f_dataW),
    .f_ALU_a(f_ALU_a),
    .f_ALU_b(f_ALU_b),
    .nop(nop),
    .nop_reg(nop_reg)


  );


 /// ..................Forwarding control............///


wire [31:0]rsA;
wire [31:0]rsB;


// forwarding mux for rs1 input to control mux
assign rsA = f_ALU_a ? aluMo :  (f_W_a ? dmemWo : rs1Xo);

// forwarding mux for rs2 input to control mux
assign rsB = f_ALU_b ? aluMo : (f_W_b ? dmemWo : rs2Xo);

// forwarding mux for dataw input

assign dataW = f_dataW ? dmemWo : rs2Mo;

//branch comparsion......................................///

  wire PCSel_B; // branch or not on compare

  wire BrEQU;
  wire BrLTU;

  wire BrEQS;
  wire BrLTS;
  

  assign BrEQU = ($unsigned(rsA) == $unsigned(rsB)) ? 1 : 0; //BLTU
  assign BrLTU = ($unsigned(rsA) < $unsigned(rsB)) ? 1: 0; //BGEU  
  assign BrEQS = ($signed(rsA) == $signed(rsB)) ? 1 : 0; //BLTS
  assign BrLTS = ($signed(rsA) < $signed(rsB)) ? 1: 0; //BGES

  assign BrEQ = p_BrUn[0] ? BrEQU : BrEQS;
  assign BrLT = p_BrUn[0] ? BrLTU : BrLTS;

  assign PCSel_B =  (func3_Xo == 3'b000) ? (BrEQ ? 1 : 0) : // BEQ
                    (func3_Xo == 3'b001) ? (BrEQ ? 0 : 1) ://BNE
                    (func3_Xo == 3'b100) ? (BrLT ? 1 : 0) ://BLT
                    (func3_Xo == 3'b101) ? (BrLT ? 0 : 1) ://BGE
                    (func3_Xo == 3'b110) ? (BrLT ? 1 : 0) ://BLTU
                    (func3_Xo == 3'b111) ? (BrLT ? 0 : 1) ://BGEU
                    0;
      
  assign PCSel_f = (p_BrUn[1]== 1'b1) ? PCSel_B : PCSelX; // brach comparison considering forwarding

  ////.......Forwarding..............................////

///////////NOP and Stall...............................................................................///////////////


/// updating rs1 and rs2 regs when nop followed by bypass or when bypass needed from write to rx registers
assign rs1Xi = (addr_Wo == d_RS1 && addr_Wo != {5{1'b0}} && p_RegWEn) ? dmemWo : nop_reg ? (f_W_a ? dmemWo:r_data_rs1): r_data_rs1;
assign rs2Xi = (addr_Wo == d_RS2 && addr_Wo != {5{1'b0}} && p_RegWEn) ? dmemWo : nop_reg ? (f_W_b ? dmemWo:r_data_rs2): r_data_rs2;
//assign rs1Xi =  nop_reg ? (f_W_a ? dmemWo:r_data_rs1): r_data_rs1;
//assign rs2Xi =  nop_reg ? (f_W_b ? dmemWo:r_data_rs2): r_data_rs2;



//Control Signal muxes............................................................/////

//Immediate

wire [31:0] shamt;
assign shamt[31:5] = {27{1'b0}};
assign shamt[4:0] = d_SHAMT;
assign Imm = (c_BSel == 1'b1 && c_ALUSel[1:0] == 2'b01) ? shamt : d_IMM ;

//A_ALU
assign alu_A = p_ASel ? pcXo : rsA;

//B_ALU
assign alu_B = p_BSel ? immXo : rsB;

//DataD- wb
wire [31:0]pcMo_4;
assign pcMo_4 = (pcMo == {32{1'b0}}) ? 0 : pcMo + 4;

assign r_data_rd = (p_WBSel == 2'b01) ? aluMo : (p_WBSel== 2'b10 ? pcMo_4 : dmemory_dataR);


//PC_ increment
wire [31:0]PC_4;
assign PC_4 = (PC == {32{1'b0}}) ? 0 : PC + 4;
wire[31:0] PC_nextvalue;
assign PC_nextvalue =  PCSel_f  ? alu_ALU_res : PC_4;

// JAL adder for unconditional jump target address

wire[31:0] JAL_PC;

assign JAL_PC = pcDo + d_IMM;







///..................................................................................///



// PC implementation

always @(posedge clock or posedge reset) begin

    if (reset)

      PC <= `offset;

    else if(d_OPC == `JAL && PC != JAL_PC)

      PC <= JAL_PC;

    else if (nop == 1'b0)

      PC <= PC_nextvalue;


  end
  ///////////////////////////



endmodule

