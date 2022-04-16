

module alu(
    input  wire clock,
    input  wire reset,

    input wire [3:0] ALUSel,
    input wire [31:0] A,
    input wire [31:0] B,
    
    output reg [31:0] ALU_res
    
); 

//internal wires or regs for control



//Decode stage combinaional

always @( * ) begin
    
  
    case(ALUSel)
  //      `R_TYPE: begin
        4'b0000:  ALU_res = $signed(A) + $signed(B);  // ADD
        4'b1000:  ALU_res = $signed(A) - $signed(B); // add or sub
        4'b0001:  ALU_res = $unsigned(A) << $unsigned(B[4:0]); //sll
        4'b0010:  ALU_res = $signed(A) < $signed(B) ? 1:0 ; //slt // compare signed may be kinda sketch
        4'b0011:  ALU_res = $unsigned(A) < $unsigned(B) ? 1:0 ;//sltu // compare unsigned
        4'b0100:  ALU_res = $unsigned(A) ^ $unsigned(B); //XOR
        4'b0101:  ALU_res = $unsigned(A) >> $unsigned(B[4:0]);//srl
        4'b1101:  ALU_res = $signed(A) >>> $unsigned(B[4:0]); // sra
        4'b0110:  ALU_res = $unsigned(A) | $unsigned(B); //OR
        4'b0111:  ALU_res = $unsigned(A) & $unsigned(B); //AND
        
        default:  ALU_res = A + B;

    endcase
    

end








endmodule