
`define offset 	32'h01000000 //offset for main memory



module decode_memory(
    input  wire clock,
    input  wire reset,
    input  wire [31:0] inst,

    output reg [6:0] OPC,
    output reg [4:0] RD,
    output reg [4:0] RS1,
    output reg [4:0] RS2,
    output reg [2:0] func3,
    output reg [6:0] func7,
    output reg [31:0] IMM,
    output reg [4:0] SHAMT
);
//internal wires for imm and shant
wire[19:0] imm_20;
wire[11:0] imm_12;

//assign func3 = inst[14:12];
//assign func7 = inst[31:25];
assign imm_20 = {20{inst[31]}};
assign imm_12 = {12{inst[31]}};

//Decode stage combinaional

always @( * ) begin

    OPC = inst[6:0];

    case(OPC)
  //      `R_TYPE: begin
        7'b0110011: begin   //R type

            RD = inst[11:7];
            RS1 = inst[19:15];
            RS2 = inst[24:20];
            func3 = inst[14:12];
            func7 = inst[31:25];
            IMM = 0;
            SHAMT = 0;

            
        end 

        7'b0010011: begin //I type 
            RD = inst[11:7];
            RS1 = inst[19:15];
            RS2 = 0;
            func3 = inst[14:12];
            func7 = 0;
            IMM[11:0] = inst[31:20];
            IMM[31:12] = imm_20;
            SHAMT = 0 ;
            if(func3 == 3'b001||func3 == 3'b101)begin //SLLI, SRLI or SRAI
                SHAMT = inst[24:20];

            end


            
        end 
        7'b1100111: begin // JALR
            RD = inst[11:7];
            RS1 = inst[19:15];
            RS2 = 0;
            func3 = inst[14:12];
            func7 = 0;
            IMM[11:0] = inst[31:20];
            IMM[31:12] = imm_20;
            SHAMT = 0;


            
        end 

       // `S_TYPE: begin
        7'b0100011: begin
            RD = 0;
            RS1 = inst[19:15];
            RS2 = inst[24:20];
            func3 = inst[14:12];
            func7 = 0;
            IMM[4:0] = inst[11:7];
            IMM[11:5] = inst[31:25];
            IMM[31:12] = imm_20;
            SHAMT = 0;

            
        end

       // `B_TYPE: begin
        7'b1100011: begin
            RD = 0;
            RS1 = inst[19:15];
            RS2 = inst[24:20];
            func3 = inst[14:12];
            func7 = 0;
            IMM[0] = 0;
            IMM[4:1] = inst[11:8];
            IMM[10:5] = inst[30:25];
            IMM[11] = inst[7];
            IMM[31:12] = imm_20;
            SHAMT = 0;

            
        end 

        //`LUI 
        7'b0110111: begin
            RD = inst[11:7];
            RS1 = 0;
            RS2 = 0;
            func3 = 0;
            func7 = 0;
            IMM[31:12] = inst[31:12];
            IMM[11:0] = {12{1'b0}};
            SHAMT = 0;

            
        end 
        //`AUIPC
        7'b0010111: begin
            RD = inst[11:7];
            RS1 = 0;
            RS2 = 0;
            func3 = 0;
            func7 = 0;
            IMM[31:12] = inst[31:12];
            IMM[11:0] = {12{1'b0}};
            SHAMT = 0;

            
        end 
        

        //`JAL: begin
        7'b1101111: begin
            RD = inst[11:7];
            RS1 = 0;
            RS2 = 0;
            func3 = 0;
            func7 = 0;
            IMM[0]= 0; 
            IMM[10:1] = inst[30:21];
            IMM[11] = inst[20];
            IMM[19:12] = inst[19:12];
            IMM[31:20] = imm_12;
            SHAMT = 0;

            
        end 

        //`LOAD: begin
        7'b0000011: begin
            RD = inst[11:7];
            RS1 = inst[19:15];
            RS2 = 0;
            func3 = inst[14:12];
            func7 = 0;
            IMM[11:0] = inst[31:20];
            IMM[31:12] = imm_20;
            SHAMT = 0;

            
        end 

        //`ECALL: begin
        7'b1110011: begin
            RD = 0;
            RS1 = 0;
            RS2 = 0;
            func3 = 0;
            func7 = 0;
            IMM = 0;
            SHAMT = 0;

            
        end 

        default: begin
            RD = 0;
            RS1 = 0;
            RS2 = 0;
            func3 = 0;
            func7 = 0;
            IMM = 0;
            SHAMT = 0;
            
        end
    endcase
    

end






// PC incrementation


endmodule