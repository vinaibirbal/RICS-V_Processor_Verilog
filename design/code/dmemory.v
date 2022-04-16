`define offset 	32'h01000000


module dmemory(
  input  wire clock,
  input wire reset,
  input  wire [31:0] address,
  input  wire [31:0] data_in,
  input  wire read_write,
  input wire [2:0] access_size,
  output wire [31:0] data_out 
);


reg [31:0] temparr[0:`LINE_COUNT - 1];
reg [7:0]memory[0:`MEM_DEPTH - 1];

//reg [32:0] wrd; // word to split into bytes
integer i; //for loop

// 0 or sign padding
wire [7:0]pad0;
wire[7:0]padsign;

assign pad0 = {8{1'b0}};
assign padsign = (access_size[1:0] == 2'b01) ? {8{memory[address - `offset][7]}} :{8{memory[address - `offset + 1][7]}} ;

/////////////////////////////


//Combinational logic for read
assign data_out[7:0] =  memory[address - `offset];// byte

assign data_out[15:8] = (access_size[1:0] != 2'b00) ? memory[address - `offset + 1] : (access_size[2] ? pad0 : padsign) ; // half word or byte and pad

assign data_out[23:16] = (access_size[1:0] == 2'b10) ? memory[address - `offset + 2] : (access_size[2] ? pad0 : padsign) ; // word or halfword and pad
assign data_out[31:24] = (access_size[1:0] == 2'b10) ? memory[address - `offset + 3] : (access_size[2] ? pad0 : padsign) ; // word or halfword and pad

 //Sequential logic for write
  always @(posedge clock or posedge reset) begin

    if(reset)begin
      
      $readmemh (`MEM_PATH,temparr);
    
      for(i=0; i<`LINE_COUNT; i=i+1) begin

        memory[i*4] = temparr[i][7:0];
        memory[i*4 + 1] = temparr[i][15:8];
        memory[i*4 + 2] = temparr[i][23:16];
        memory[i*4 + 3] = temparr[i][31:24]; 
        
      end

    end

    if (read_write) begin // 3 writes full word also
        memory[address - `offset] = data_in[7:0];
        if(access_size[1:0] != 2'b00)
          memory[address  - `offset + 1] = data_in[15:8];
        if(access_size[1:0] == 2'b10) begin

          memory[address - `offset + 2] = data_in[23:16];
          memory[address  - `offset + 3] = data_in[31:24];     
        
        end 
            
    end
    /*else begin
      data_out[7:0] = memory[address - `offset];
      data_out[15:8] = memory[address - `offset + 1];
      data_out[23:16] = memory[address - `offset + 2];
      data_out[31:24] = memory[address - `offset + 3];
     // $display("memory: %d : %h, %h, %h, %h", i, memory[i], memory[i + 1],memory[i + 2],memory[i + 3]);
    end*/

  end
  
endmodule
