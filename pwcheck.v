`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 17:16:57
// Design Name: 
// Module Name: pwcheck
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

`timescale 1ns/1ps

module pwcheck(
    input rst, clk, pwstart, pw_entered, 
    input [2:0] pwinput,
    output wire pw_correct, pwdone
    );

reg [3:0] ps, ns; //4bit 
reg pw_correct_in, pwdone_in;
parameter [3:0] 
            S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3= 4'b0011, S4 = 4'b0100, 
            S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111, S8 = 4'b1000, 
            E9 = 4'b1001, E10 = 4'b1010, E11 = 4'b1011, E12 = 4'b1100, E13 = 4'b1101, E14 = 4'b1110, E15 = 4'b1111;
            
parameter [2:0]
		    left = 3'b001, right = 3'b010, up= 3'b011, down = 3'b100, center = 3'b101; //handles midway error during password input


always @(posedge clk) begin
    if (!rst) begin ps <= S0; end
    else begin ps <= ns; end 
end

always @(*) begin
    if (!rst) begin ns = S0; pw_correct_in = 0; pwdone_in = 0; end
    else if (rst & pwstart) begin
        
        case (ps)
            S0: begin if (pw_entered != 1) ns = S0;
                      else ns = S1; 
                      pw_correct_in = 0; pwdone_in = 0; 
                end

            S1: begin if ((pw_entered == 1) & (pwinput == left)) ns = S2;
                      else if ((pw_entered == 1) & (pwinput != left)) ns = E9; 
                      else ns = S1; //wait for new input 
                      pw_correct_in = 0; pwdone_in = 0;
                end
                
            S2: begin if (pw_entered == 1) ns = S2;
                      else ns = S3;         
                      pw_correct_in = 0; pwdone_in = 0; 
                end
                    
            S3: begin if ((pw_entered == 1) & (pwinput == right)) ns = S4;
                      else if ((pw_entered == 1) & (pwinput != right)) ns = E11; 
                      else ns = S3;
                      pw_correct_in = 0; pwdone_in = 0;
                end          
                
            S4: begin if (pw_entered == 1) ns = S4;
                       else ns = S5; 
                       pw_correct_in = 0; pwdone_in = 0;         
                end          

            S5: begin if ((pw_entered == 1) & (pwinput == up)) ns = S6;
                      else if ((pw_entered == 1) & (pwinput != up)) ns = E13;
                      else ns = S5; 
                      pw_correct_in = 0; pwdone_in = 0;
                end   
                                
            S6: begin if (pw_entered == 1) ns = S6;
                      else ns = S7;            
                      pw_correct_in = 0; pwdone_in = 0; 
                end                    
                
            S7: begin if ((pw_entered == 1) & (pwinput == center)) ns = S8;
                      else if ((pw_entered == 1) & (pwinput != center)) ns = E15; 
                      else ns = S7;
                      pw_correct_in = 0; pwdone_in = 0;
                end    
                
            S8: begin if (pw_entered == 1) ns = S8; //FINAL state, all correct, go back to S0 when button is no longer being pressed
                      else ns = S0;
                      pw_correct_in = 1; pwdone_in = 1;
                end
                
            E9: begin if (pw_entered == 1) ns = E9;///pw_entered = 1 from previous input, wait until pw_entered = 0 again
                      else ns = E10;      //if pw_entered = 0 again, go to E2
                      pw_correct_in = 0; pwdone_in = 0;
                end    
                
            E10: begin if (pw_entered == 1) ns = E11; // wait for pw_entered = 1, as in wait for next input, thus NEW INPUT2 = > E3
                      else ns = E10;    //if new input has not come in stay in this state 
                      pw_correct_in = 0; pwdone_in = 0;       
                end    
                
            E11: begin if (pw_entered == 1) ns = E11; //pw_entered = 1 from previous input, wait until pw_entered = 0 again 
                      else ns = E12;    //if pw_entered = 0 again, go to E4 and wait for new input  
                      pw_correct_in = 0; pwdone_in = 0;   
                end                                         
                     
            E12: begin if (pw_entered == 1) ns = E13; // wait for pw_entered = 1, as in wait for next input, thus NEW INPUT3 = > E5
                      else ns = E12;    //if new input has not come in stay in this state 
                pw_correct_in = 0; pwdone_in = 0;     
                end         
                
            E13: begin if (pw_entered == 1) ns = E13; //pw_entered = 1 from previous input, wait until pw_entered = 0 again 
                          else ns = E14;    //if pw_entered = 0 again, go to E14 and wait for new input  ]     
                 pw_correct_in = 0; pwdone_in = 0;  
                end              
                
            E14: begin if (pw_entered == 1) ns = E15; // wait for pw_entered = 1, as in wait for next input, thus NEW INPUT4 = > E15
                          else ns = E14;    //if new input has not come in stay in this state 
                 pw_correct_in = 0; pwdone_in = 0;    
                end       
                
            E15: begin if (pw_entered == 1) ns = E15; // as long as button is pressed stay here
                      else ns = S0;    //if not pressed, go back to S0
                 pw_correct_in = 0; pwdone_in = 1;     
                end         
                                          
            default: begin ns = S0; pw_correct_in = 0; pwdone_in = 0; end
            
            endcase
            end
            
      else begin ns = S0; pw_correct_in = 0; pwdone_in = 0; end 
       

end 

//always@(*) begin 

//                  if (!rst) begin pw_correct_in = 0; pwdone_in = 0; end 
//                  else if (pwinput == left) begin pw_correct_in = 1; pwdone_in = 1;end 
//                  else if (pwinput == 3'b000) begin pw_correct_in = 0; pwdone_in = 0; end  
//                  else pw_correct_in = 0; pwdone_in = 1; 
//                  //else begin pw_correct_in = 0; pwdone_in = 0; end
//          end 
assign pw_correct = pw_correct_in; 
assign pwdone = pwdone_in;


endmodule




//reference ------------------------------------------------------------------------------------------------------
/*set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { BTNL }] 001; 1
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { BTNR }]; 010 2
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { BTNU }]; 011 3
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { BTND }]; 100 4
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { BTNC }]; 101  5*/ 

/*input clk; // 100 MHz
input rst_n;
input BTNL, BTNR, BTNU, BTND, BTNC;
input [15:0] SW;
output [15:0] LED;
output [2:0] TriLED1;
output [2:0] TriLED2;

// 7-Segment display
output AN0, AN1, AN2, AN3, AN4, AN5, AN6, AN7;
output CA, CB, CC, CD, CE, CF, CG, DP;

assign LED = SW; */
