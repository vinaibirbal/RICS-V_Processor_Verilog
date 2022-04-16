
/* Your Code Below! Enable the following define's 
 * and replace ??? with actual wires */
// ----- signals -----
// You will also need to define PC properly
`define F_PC                PC
`define F_INSN              imemory_data_out

`define D_PC                pcDo  
`define D_OPCODE            d_OPC     //d_xxxx is decode_memory signal
`define D_RD                d_RD
`define D_RS1               d_RS1
`define D_RS2               d_RS2
`define D_FUNCT3            d_func3
`define D_FUNCT7            d_func7
`define D_IMM               d_IMM
`define D_SHAMT             d_SHAMT

`define R_WRITE_ENABLE      p_RegWEn
`define R_WRITE_DESTINATION addr_Wo
`define R_WRITE_DATA        dmemWo
`define R_READ_RS1          d_RS1
`define R_READ_RS2          d_RS2
`define R_READ_RS1_DATA     r_data_rs1
`define R_READ_RS2_DATA     r_data_rs2

`define E_PC                pcXo
`define E_ALU_RES           alu_ALU_res
`define E_BR_TAKEN          PCSel_f

`define M_PC                pcMo
`define M_ADDRESS           aluMo
`define M_RW                p_MemRW
`define M_SIZE_ENCODED      func3_Mo
`define M_DATA              dmemory_dataR

`define W_PC                pcWo
`define W_ENABLE            p_RegWEn
`define W_DESTINATION       addr_Wo
`define W_DATA              dmemWo

// ----- signals -----

// ----- design -----
`define TOP_MODULE                 pd
// ----- design -----
