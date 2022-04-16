
module pipeline_regs(

    input  wire clock,
    input  wire reset,
    input  wire nop,

    input  wire PCSel_f,// PCSel considering forwarding
    input  wire PCSel, //select PC_res pc+4 = 0, alu = 1
    input  wire [1:0] BrUn,
    input  wire RegWEn, // register read write read = 0, write = 1
    input  wire BSel, // select dataB(data_rs2)=0  or Immediate=1
    input  wire ASel, // select dataA(datars1)=0 or PC=1
    input  wire MemRW, // select dmemory RW  read = 0, write = 1
    input  wire [1:0]WBSel, //select wb  DataR = 0, alu = 1, pc+4 = 2
    input  wire [3:0]ALUSel,
    input  wire [31:0]IMM,
    input  wire [2:0] func3,
   
    input  wire [31:0] pcDi,
    input  wire [31:0] instDi,
    input  wire [31:0] rs1Xi,
    input  wire [31:0] rs2Xi,
    input  wire [4:0]  addr_Xi,
    input  wire [31:0] aluMi,
    input  wire [31:0] rs2Mi,
    input  wire [31:0] dmemWi,


    
    output reg BSelX, // select dataB(data_rs2)=0  or Immediate=1
    output reg ASelX, // select dataA(datars1)=0 or PC=1
    output reg MemRWM, // select dmemory RW  read = 0, write = 1
    output reg PCSelX, //select PC_res pc+4 = 0, alu = 1
    output reg [1:0]BrUnX,
    output reg PCSelM, //select PC_res pc+4 = 0, alu = 1
    output reg RegWEnW, // register read write read = 0, write = 1
    output reg [1:0]WBSelW, //select wb  DataR = 0, alu = 1, pc+4 = 2
    output reg [3:0]ALUSelX,
    output reg [2:0] func3_Xo,
    output reg [2:0]func3_Mo,

    output reg [31:0] pcDo,
    output reg [31:0] instDo,
    output reg [31:0] pcXo,
    output reg [31:0] rs1Xo,
    output reg [31:0] rs2Xo,
    output reg [31:0] immXo,
    output reg [31:0] pcMo,
    output reg [31:0] aluMo,
    output reg [31:0] rs2Mo,
    output reg [31:0] dmemWo,
    output reg [4:0]  addr_Wo,
    output reg [31:0] pcWo



);

///internal regs
    
    reg [4:0]  addr_Xo;
    reg [4:0]  addr_Mo;
    
  

   
    reg RegWEnX; // register read write read = 0, write = 1
    reg MemRWX; // select dmemory RW  read = 0, write = 1
    //reg [1:0]WBSelX; //select wb  DataR = 0, alu = 1, pc+4 = 2
    
    //reg PCSelM; //select PC_res pc+4 = 0, alu = 1
    reg RegWEnM; // register read write read = 0, write = 1
    reg [1:0]WBSelM; //select wb  DataR = 0, alu = 1, pc+4 = 2




 //Sequential logic for write input
  always @(posedge clock or posedge reset) begin

    if(reset) begin  //might have to have separate reset for nop

        BSelX <= 0;
        ASelX <= 0;
        MemRWM <= 0;
        //PCSelW <= 0;
        RegWEnW <= 0;
        WBSelW <= 0;
        ALUSelX <= 0;
        func3_Xo <= 0;

        PCSelX <= 0;
        BrUnX <= 0;
        RegWEnX <= 0;
        MemRWX <= 0;
        //WBSelX <= 0;
        PCSelM <= 0;
        RegWEnM <= 0;
        WBSelM <= 0;
        func3_Mo <= 0;

        instDo <= 0;
        pcXo <= 0;
        rs1Xo <= 0;
        rs2Xo <= 0;
        immXo <= 0;
        pcMo <= 0;
        aluMo <= 0;
        rs2Mo <= 0;
        dmemWo <= 0;
        addr_Wo <= 0;

        pcDo <= 0;
        addr_Xo <= 0;
        addr_Mo <= 0;
        pcWo <= 0;
    




    end
    else if (nop) begin
        
        //PCSelW  <= PCSelM;
        RegWEnW  <= RegWEnM;
        WBSelW  <= WBSelM;
        pcWo <= pcMo;
    
        MemRWM  <= MemRWX;
        PCSelM  <= PCSelX;
        RegWEnM  <= RegWEnX;
        WBSelM  <= WBSel;
        func3_Mo  <= func3_Xo;     
        
        BSelX  <= 0;
        ASelX  <= 0;
        ALUSelX  <= 0;
        PCSelX  <= 0;
        BrUnX <= 0;
        RegWEnX  <= 0;
        MemRWX  <= 0;
        //WBSelX  <= 0;

        dmemWo  <= dmemWi;
        addr_Wo  <= addr_Mo;

        pcMo  <= pcXo;
        aluMo  <= aluMi;
        rs2Mo  <= rs2Mi;

        pcXo  <= 0;
        rs1Xo  <= 0;
        rs2Xo  <= 0;
        immXo  <= 0;

 
        addr_Mo  <= addr_Xo;
        addr_Xo  <= 0;
        func3_Xo  <= 0;

        //instDo  <= instDi;
        //pcDo  <= pcDi; 



    end
    else if (PCSel_f) begin
        
        // PCSelW  <= PCSelM;
        RegWEnW  <= RegWEnM;
        WBSelW  <= WBSelM;
        pcWo <= pcMo;
    
        MemRWM  <= MemRWX;
        PCSelM  <= PCSelX;
        RegWEnM  <= RegWEnX;
        WBSelM  <= WBSel;
        func3_Mo  <= func3_Xo;     
        
        BSelX  <= 0;
        ASelX  <= 0;
        ALUSelX  <= 0;
        PCSelX  <= 0;
        BrUnX <= 0;
        RegWEnX  <= 0;;
        MemRWX  <= 0;
       // WBSelX  <= 0;

        dmemWo  <= dmemWi;
        addr_Wo  <= addr_Mo;

        pcMo  <= pcXo;
        aluMo  <= aluMi;
        rs2Mo  <= rs2Mi;

        pcXo  <= 0;
        rs1Xo  <= 0;
        rs2Xo  <= 0;
        immXo  <= 0;

        instDo  <= 0;
        pcDo  <= 0; 
        
        addr_Mo  <= addr_Xo;
        addr_Xo  <= 0;
        func3_Xo  <= 0;
    end

    else begin
    
       // PCSelW  <= PCSelM;
        RegWEnW  <= RegWEnM;
        WBSelW  <= WBSelM;
        pcWo <= pcMo;
    
        MemRWM  <= MemRWX;
        PCSelM  <= PCSelX;
        RegWEnM  <= RegWEnX;
        WBSelM  <= WBSel;
        func3_Mo  <= func3_Xo;     
        
        BSelX  <= BSel;
        ASelX  <= ASel;
        ALUSelX  <= ALUSel;
        PCSelX  <= PCSel;
        BrUnX <= BrUn;
        RegWEnX  <= RegWEn;
        MemRWX  <= MemRW;
       // WBSelX  <= WBSel;

        dmemWo  <= dmemWi;
        addr_Wo  <= addr_Mo;

        pcMo  <= pcXo;
        aluMo  <= aluMi;
        rs2Mo  <= rs2Mi;

        pcXo  <= pcDo;
        rs1Xo  <= rs1Xi;
        rs2Xo  <= rs2Xi;
        immXo  <= IMM;

        instDo  <= instDi;

        pcDo  <= pcDi; 
        addr_Mo  <= addr_Xo;
        addr_Xo  <= addr_Xi;
        func3_Xo  <= func3;

    end


   
   


 end
  

endmodule
