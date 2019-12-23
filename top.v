`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 20:24:29
// Design Name: 
// Module Name: top
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





module top(
clk, 
rst, 
BTNL, 
BTNR,
BTNU,
BTND,
BTNC,
SW, 
LED, TriLED1, TriLED2,
seg,
digit
);

input clk; // 100 MHz
input rst;
input BTNL, BTNR, BTNU, BTND, BTNC;
input [15:0] SW;
output [15:0] LED;  
// 7-Segment display
output [6:0] seg;
output [7:0] digit;
output [2:0] TriLED1, TriLED2;

wire enter, exit, full, pw_correct, pwdone, pw_entered, pwstart;
wire [3:0] enter_car_nb, exit_car_nb, car_nb; 
wire [2:0] pwinput; 
wire [1:0] segstate;

readinput RI(clk, rst, SW, car_nb, enter, exit);      
parking_controller PC(clk, rst, exit, enter, pw_correct, pwdone, SW, car_nb, TriLED1, LED, segstate, pwstart, full);
pwread PWR(clk, BTNL, BTNR, BTNU, BTND, BTNC, pwinput, pw_entered, TriLED2);          
pwcheck PWC(rst, clk, pwstart, pw_entered, pwinput, pw_correct, pwdone);   
sevensegment SS(clk, rst, segstate, digit, seg);       

/*  input clk, rst, exit, enter, pw_correct, pwdone,
    input [3:0] enter_car_nb, exit_car_nb,
    output reg [15:0] LED,
    output reg [1:0] segstate,//0 : off, 1: on
    output wire full
 */             
                     
endmodule
