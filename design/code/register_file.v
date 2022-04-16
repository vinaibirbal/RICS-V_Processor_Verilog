`define offset 	32'h01000000


module register_file(
  input  wire clock,
  input wire reset,
  input  wire write_enable,


  input  wire [4:0] addr_rs1,
  input  wire [4:0] addr_rs2,
  input  wire [4:0] addr_rd,

  input  wire [31:0] data_rd,
  output  wire [31:0] data_rs1,
  output  wire [31:0] data_rs2
);


reg [31:0] register[0:31]; 

integer i; //for loop

/*
//reg [32:0] wrd; // word to split into bytes
 integer i; //for loop

//initial load registers
 initial begin 
    for(i=0; i< 32; i=i+1) begin
      register[i] = 3*i + 1; 
       
    end

end  
*/


//Combinational logic for read putputs
assign data_rs1 = register[addr_rs1];
assign data_rs2 = register[addr_rs2];

 //   end


 //Sequential logic for write input
  always @(posedge clock or posedge reset) begin

    if(reset) begin

      for(i=0; i< 32; i=i+1) begin

        register[i] = 0;
    
      end
      register[2] = `offset + `MEM_DEPTH;

    end

    if (write_enable && addr_rd != 5'b00000) 
      register[addr_rd] <= data_rd;
  
    /*else begin
      
     // $display("memory: %d : %h, %h, %h, %h", i, memory[i], memory[i + 1],memory[i + 2],memory[i + 3]);
    end*/

  end
  
endmodule
