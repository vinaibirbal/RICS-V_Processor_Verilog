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


///module for forwarding control


module f_cu(

    input  wire clock,
    input  wire reset,
      
    input wire [4:0] addrD,
    input wire [4:0] addrA,
    input wire [4:0] addrB,
    input wire [6:0] OPC,

    input wire [4:0] addrA1,
    input wire [4:0] addrB1,
    input wire [6:0] OPC1,

    
    //internal wires or regs for control
    output reg f_W_a, /// 1 =  forward writeback to A
    output reg f_W_b, /// 1 =  forward writeback to A
    output reg f_dataW, /// 1 = forward write back to dataw
    output reg f_ALU_a,/// 1 =  forward M to ALU A
    output reg f_ALU_b,/// 1 =  forward M to ALU B
    output reg nop,/// 1 =  nop - data hazard
    output reg nop_reg



); 

//internal regs
reg [4:0] addrD_reg;
reg [4:0] addrB_reg;
reg [4:0] addrD2_reg;
reg[6:0] OPC_reg;
reg [6:0] OPC2_reg;








// control signal combinaional
reg W_En_m; // only forward for signals that would chnage reg values
reg W_En_w;

//W_En_m <= (OPC_reg == `R_TYPE ||OPC_reg == `I_TYPE || OPC_reg == `AUIPC ||OPC_reg == `LUI ||  OPC_reg == `JAL || OPC_reg == `JALR ||OPC_reg == `LOAD ) ? 1 :0 ;
//W_En_w <= (OPC2_reg == `R_TYPE ||OPC2_reg == `I_TYPE || OPC2_reg == `AUIPC ||OPC2_reg == `LUI ||  OPC2_reg == `JAL || OPC2_reg == `JALR ||OPC2_reg == `LOAD ) ? 1 :0 ;


//assign f_dataW = (addrB_reg == addrD2_reg && addrB_reg != {5{1'b0}} && W_En_w) ? 1:0 ;
//assign f_W_a = (addrA == addrD2_reg && addrA != {5{1'b0}} && W_En_w)? 1:0;
//assign f_W_b = (addrB == addrD2_reg && addrB != {5{1'b0}} && W_En_w)? 1:0;
//assign f_ALU_a = (addrA == addrD_reg && addrA != {5{1'b0}} && W_En_m)? 1:0;
//assign f_ALU_b = (addrB == addrD_reg && addrB != {5{1'b0}} && W_En_m)? 1:0;
//assign nop = (OPC == `LOAD && (addrA1 == addrD && addrA1 != {5{1'b0}} || (addrB1 == addrD && addrB1 != {5{1'b0}}  && OPC1 != `S_TYPE ))) ? 1:0;


always @( posedge clock or posedge reset) begin

    W_En_m <= (OPC == `R_TYPE ||OPC == `I_TYPE || OPC == `AUIPC ||OPC == `LUI ||  OPC == `JAL || OPC == `JALR ||OPC == `LOAD ) ? 1 :0 ;
    W_En_w <= (OPC_reg == `R_TYPE ||OPC_reg == `I_TYPE || OPC_reg == `AUIPC ||OPC_reg == `LUI ||  OPC_reg == `JAL || OPC_reg == `JALR ||OPC_reg == `LOAD ) ? 1 :0 ;
    
    if(reset)begin

        addrD_reg <=0;
        addrB_reg <= 0;
        addrD2_reg <= 0;
        OPC_reg <= 0;
        OPC2_reg <= 0;
        nop_reg <= 0;

    

    end

    else if(nop)begin

        f_W_a <= (addrA == addrD2_reg && addrA != {5{1'b0}} && W_En_w)? 1:0;
        f_W_b <= (addrB == addrD2_reg && addrB != {5{1'b0}} && W_En_w)? 1:0;

        OPC2_reg <= OPC_reg;
        addrD2_reg <= addrD_reg;
        addrB_reg  <= 0;
        addrD_reg  <= 0;
        OPC_reg <= 0;
        
        nop <= 0;
        nop_reg <= 1'b1;


    end

    else if (OPC1 == `JAL)begin

        f_dataW <= (addrB_reg == addrD2_reg && addrB_reg != {5{1'b0}} && W_En_w) ? 1:0 ;
        f_W_a <= (addrA == addrD2_reg && addrA != {5{1'b0}} && W_En_w)? 1:0;
        f_W_b <= (addrB == addrD2_reg && addrB != {5{1'b0}} && W_En_w)? 1:0;
        f_ALU_a <= (addrA == addrD_reg && addrA != {5{1'b0}} && W_En_m)? 1:0;
        f_ALU_b <= (addrB == addrD_reg && addrB != {5{1'b0}} && W_En_m)? 1:0;
       
        nop <= 1;

        OPC2_reg <= OPC_reg;
        addrD2_reg <= addrD_reg;
        addrB_reg  <= addrB;
        addrD_reg  <= addrD;
        OPC_reg <= OPC;
        nop_reg <= 0;



    end

    else begin 

        f_dataW <= (addrB_reg == addrD2_reg && addrB_reg != {5{1'b0}} && W_En_w) ? 1:0 ;
        f_W_a <= (addrA == addrD2_reg && addrA != {5{1'b0}} && W_En_w)? 1:0;
        f_W_b <= (addrB == addrD2_reg && addrB != {5{1'b0}} && W_En_w)? 1:0;
        f_ALU_a <= (addrA == addrD_reg && addrA != {5{1'b0}} && W_En_m)? 1:0;
        f_ALU_b <= (addrB == addrD_reg && addrB != {5{1'b0}} && W_En_m)? 1:0;
        nop <= (OPC == `LOAD && (addrA1 == addrD && addrA1 != {5{1'b0}} || (addrB1 == addrD && addrB1 != {5{1'b0}}  && OPC1 != `S_TYPE ))) ? 1:0;

        OPC2_reg <= OPC_reg;
        addrD2_reg <= addrD_reg;
        addrB_reg  <= addrB;
        addrD_reg  <= addrD;
        OPC_reg <= OPC;
        nop_reg <= 0;
        
    //&& addrA1 != {5{1'b0}} 
    

    end

    

end

endmodule