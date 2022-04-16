`define offset 	32'h01000000 //offset for main memory

//OP codes


module cu(
    input  wire clock,
    input  wire reset,
      
    input wire [6:0] OPC,
    input wire [2:0] func3,
    input wire [6:0] func7,


    input wire BrEQ, //EQ = 1, NEQ = 0
    input wire BrLT, // LT = 1 , GT = 0
    
    //internal wires or regs for control
    output reg PCSel, //select PC_res pc+4 = 0, alu = 1
    output reg RegWEn, // register read write read = 0, write = 1
    output reg [1:0] BrUn, // unsigned = b0 = 1,  branch compare b1 = 1
    output reg BSel, // select dataB(data_rs2)=0  or Immediate=1
    output reg ASel, // select dataA(datars1)=0 or PC=1
    output reg MemRW, // select dmemory RW  read = 0, write = 1
    output reg [1:0]WBSel, //select wb  DataR = 0, alu = 1, pc+4 = 2
    output reg [3:0]ALUSel

); 


//internal wires


// control signal combinaional


always @( * ) begin

    BrUn[0] = func3[1];
    ALUSel[3] = (func7 == 0)? 0 : 1;

    case(OPC)
  //      `R_TYPE: begin
        7'b0110011: begin   //R type


            PCSel = 0; //select PC_res pc+4 = 0, alu = 1
            RegWEn = 1; // register read write read = 0, write = 1
            BSel = 0; // select dataB(data_rs2)=0  or Immediate=1
            ASel = 0; // select dataA(datars1)=0 or PC=1
            MemRW = 0; // select dmemory RW  read = 0, write = 1
            WBSel = 2'b01; //select wb  DataR = 0, alu = 1, pc+4 = 2

            ALUSel[2:0] = func3; //OP
            BrUn[1] = 0;

       
  
        end 

        7'b0010011: begin //I type 

            PCSel = 0; //select PC_res pc+4 = 0, alu = 1
            RegWEn = 1; // register read write read = 0, write = 1
            BSel = 1; // select dataB(data_rs2)=0  or Immediate=1
            ASel = 0; // select dataA(datars1)=0 or PC=1
            MemRW = 0; // select dmemory RW  read = 0, write = 1
            WBSel = 2'b01; //select wb  DataR = 0, alu = 1, pc+4 = 2

            ALUSel[2:0] = func3; // OP
            BrUn[1] = 0;



            
        end 
        7'b1100111: begin // JALR

            PCSel = 1; //select PC_res pc+4 = 0, alu = 1
            RegWEn = 1; // register read write read = 0, write = 1
            BSel = 1; // select dataB(data_rs2)=0  or Immediate=1
            ASel = 0; // select dataA(datars1)=0 or PC=1
            MemRW = 0; // select dmemory RW  read = 0, write = 1
            WBSel = 2'b10; //select wb  DataR = 0, alu = 1, pc+4 = 2

            ALUSel[2:0] = 3'b000; // AND
            BrUn[1] = 0;

            
        end 

       // `S_TYPE: begin
        7'b0100011: begin


            PCSel = 0; //select PC_res pc+4 = 0, alu = 1
            RegWEn = 0; // register read write read = 0, write = 1
            BSel = 1; // select dataB(data_rs2)=0  or Immediate=1
            ASel = 0; // select dataA(datars1)=0 or PC=1
            MemRW = 1; // select dmemory RW  read = 0, write = 1
            WBSel = 2'b01; //select wb  DataR = 0, alu = 1, pc+4 = 2

            ALUSel[2:0] = 3'b000; // AND
            BrUn[1] = 0;

            
        end

       // `B_TYPE: begin
        7'b1100011: begin


           /* case(func3)
                3'b000: PCSel = BrEQ ? 1 : 0; // BEQ
                3'b001: PCSel = BrEQ ? 0 : 1; //BNE
                3'b100: PCSel = BrLT ? 1 : 0; //BLT
                3'b101: PCSel = BrLT ? 0 : 1; //BGE
                3'b110: PCSel = BrLT ? 1 : 0; //BLTU
                3'b111: PCSel = BrLT ? 0 : 1; //BGEU
                default:  PCSel = 0; //select PC_res pc+4 = 0, alu = 1
            endcase*/

            PCSel = 0;
            RegWEn = 0; // register read write read = 0, write = 1 // unsigned = 1
            BSel = 1; // select dataB(data_rs2)=0  or Immediate=1
            ASel = 1; // select dataA(datars1)=0 or PC=1
            MemRW = 0; // select dmemory RW  read = 0, write = 1
            WBSel = 2'b01; //select wb  DataR = 0, alu = 1, pc+4 = 2

            ALUSel[2:0] = 3'b000; // AND
            BrUn[1] = 1'b1;


            
        end 

        //`LUI 
        7'b0110111: begin

            PCSel = 0; //select PC_res pc+4 = 0, alu = 1
            RegWEn = 1; // register read write read = 0, write = 1
            BSel = 1; // select dataB(data_rs2)=0  or Immediate=1
            ASel = 0; // select dataA(datars1)=0 or PC=1
            MemRW = 0; // select dmemory RW  read = 0, write = 1
            WBSel = 2'b01; //select wb  DataR = 0, alu = 1, pc+4 = 2

            ALUSel[2:0] = 3'b000; // AND
            BrUn[1] = 0;
            
        end 
        //`AUIPC
        7'b0010111: begin

            PCSel = 0; //select PC_res pc+4 = 0, alu = 1
            RegWEn = 1; // register read write read = 0, write = 1
            BSel = 1; // select dataB(data_rs2)=0  or Immediate=1
            ASel = 1; // select dataA(datars1)=0 or PC=1
            MemRW = 0; // select dmemory RW  read = 0, write = 1
            WBSel = 2'b01; //select wb  DataR = 0, alu = 1, pc+4 = 2

            ALUSel[2:0] = 3'b000; // AND
            BrUn[1] = 0;

            
        end 
        

        //`JAL: begin
        7'b1101111: begin

            PCSel = 0; //select PC_res pc+4 = 0, alu = 1
            RegWEn = 1; // register read write read = 0, write = 1
            BSel = 1; // select dataB(data_rs2)=0  or Immediate=1
            ASel = 1; // select dataA(datars1)=0 or PC=1
            MemRW = 0; // select dmemory RW  read = 0, write = 1
            WBSel = 2'b10; //select wb  DataR = 0, alu = 1, pc+4 = 2

            ALUSel[2:0] = 3'b000; // AND
            BrUn[1] = 0;

            
        end 

        //`LOAD: begin
        7'b0000011: begin 

            PCSel = 0; //select PC_res pc+4 = 0, alu = 1
            RegWEn = 1; // register read write read = 0, write = 1
            BSel = 1; // select dataB(data_rs2)=0  or Immediate=1
            ASel = 0; // select dataA(datars1)=0 or PC=1
            MemRW = 0; // select dmemory RW  read = 0, write = 1
            WBSel = 2'b00; //select wb  DataR = 0, alu = 1, pc+4 = 2

            ALUSel[2:0] = 3'b000; // AND
            BrUn[1] = 0;

        end

        //`ECALL: begin
        7'b1110011: begin

            PCSel = 0; //select PC_res pc+4 = 0, alu = 1
            RegWEn = 0; // register read write read = 0, write = 1
            BSel = 0; // select dataB(data_rs2)=0  or Immediate=1
            ASel = 0; // select dataA(datars1)=0 or PC=1
            MemRW = 0; // select dmemory RW  read = 0, write = 1
            WBSel = 2'b01; //select wb  DataR = 0, alu = 1, pc+4 = 2

            ALUSel[2:0] = 3'b000; // AND
            BrUn[1] = 0;


            
        end 

        default: begin


            PCSel = 0; //select PC_res pc+4 = 0, alu = 1
            RegWEn = 0; // register read write read = 0, write = 1
            BSel = 0; // select dataB(data_rs2)=0  or Immediate=1
            ASel = 0; // select dataA(datars1)=0 or PC=1
            MemRW = 0; // select dmemory RW  read = 0, write = 1
            WBSel = 2'b01; //select wb  DataR = 0, alu = 1, pc+4 = 2

            ALUSel[2:0] = 3'b000; // AND
            BrUn[1] = 0;

            
        end

    endcase
    

end







    //$dislay("BNEA:::%d: L :::::%h", B_EN, PC);

endmodule