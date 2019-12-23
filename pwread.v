`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 19:09:39
// Design Name: 
// Module Name: pwread
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

module pwread(
    input clk, BTNL, BTNR, BTNU, BTND, BTNC, 
    output wire [2:0] pwinput,
    output wire pw_entered, output wire [2:0] TriLED2
);
    //parameter left = 3'b001, right = 3'b010, up= 3'b011, down = 3'b100, center = 3'b101;
    
    assign pwinput = (BTNL)? 3'b001: (BTNR)? 3'b010: (BTNU)? 3'b011: (BTND)? 3'b100: (BTNC)? 3'b101: 3'b000;
    assign pw_entered = (pwinput != 3'b000)? 1: 0; 
    assign TriLED2[0] = (pw_entered == 1'b1)? 1: 0; assign TriLED2[1] = 0; assign TriLED2[2] = 0;
    
endmodule 
