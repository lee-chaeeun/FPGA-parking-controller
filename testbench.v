

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 18:42:13
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench;

parameter ckPeriod = 5;//
reg clk = 1'b0; 
reg rst= 1'b0;//
reg BTNL, BTNR, BTNU, BTND, BTNC;
reg [15:0] SW;

wire [15:0] LED;   
wire [6:0] seg;
wire [7:0] digit;

top U1 (clk, rst, BTNL, BTNR, BTNU, BTND, BTNC, SW, LED, seg, digit);  

always #ckPeriod clk = ~clk;
integer i,j, k, result;
//reg [15:0] k=1000000000000000;

initial begin 
#12 rst = 1'b1;
SW = 16'b0;

BTNL = 1'b0; BTNR = 1'b0; BTNU = 1'b0; BTND = 1'b0; BTNC =1'b0;
result = $fopen("result.txt");

while(rst) begin
  for (i= 0; i<16; i=i+1) begin
    SW[i] = 1'b1;
//    if ((i!=6) & (i!=7)) begin
        #24 BTNL = 1'b1; 
        #37 BTNL=1'b0; #52 BTNR = 1'b1; 
        #37 BTNR=1'b0; #52 BTNU = 1'b1; 
        #37 BTNU=1'b0; #52 BTNC = 1'b1; 
	    #37 BTNC = 1'b0; 
//	    end
//    else if ((i==6)& (i!=7)) begin
//        #100 BTNR = 1'b1;
//        #37 BTNR=1'b0; #52 BTNL = 1'b1; 
//        #37 BTNL=1'b0; #52 BTNU = 1'b1; 
//        #37 BTNU=1'b0; #52 BTNC = 1'b1;
//	    #37 BTNC = 1'b0; 
//	    end 
//    else if ((i!=6)& (i==7)) begin
//        #100 BTNL = 1'b1; 
//        #37 BTNL=1'b0; #52 BTNR = 1'b1; 
//        #37 BTNR=1'b0; #52 BTNC = 1'b1; 
//        #37 BTNC=1'b0; #52 BTNU = 1'b1; 
//	    #37 BTNU = 1'b0; 
//	    end  
      
     $fdisplay(result, "time = %d, LED[%i], =%b", $time, i, LED);
  end
  #10; for (k= 9; k>0; k=k-1)  #100 SW[k] = 1'b0; 
end

end

initial #500000 $stop;

endmodule
