`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/28 17:14:50
// Design Name: 
// Module Name: sevensegment
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


module sevensegment(
    input clk, rst,
    input [1:0] segstate,
    output reg [7:0] digit,
    output reg [6:0] seg
    );

reg [55:0] seg1; //56bit
//reg [6:0] seg;
//reg [7:0] digit;


reg [31:0] count; //32bit
reg clk_10000;

always @(posedge clk or negedge rst)begin  // clock ???
   if (!rst) begin
       count <= 32'd0;
       clk_10000 <= 0;
   end
   else begin
       if(count=='d10000) begin
            count<=32'd0;
            clk_10000<=~clk_10000;
        end
        else begin
        count<=count+1;
        end
    end
end

always@(posedge clk_10000 or negedge rst) begin // digit 
   if(!rst) begin
      digit <= 8'b11111110;
   end
   else if(clk_10000) begin
       digit <= {digit[6:0], digit[7]};
   end

end

always@(segstate) begin
   case(segstate)
        2'b00: seg1 = 56'b1111111_1111111_1111111_1111111_0111000_1000001_1110001_1110001; //Full
        2'b01: seg1 = 56'b1111111_1111111_1111111_0110000_1101010_1110000_0110000_1111010; // Enter
        2'b10: seg1 = 56'b1111111_1111111_1111111_0110000_1111010_1111010_1100010_1111010; //Error   
        2'b11: seg1 = 56'b1111111_1111111_1111111_1111111_1111111_1111111_1111111_1111111; // ? ?? default
      default : seg1 = 56'b0000000_0000000_0000000_0000000_0000000_0000000_0000000_0000000;
    endcase
end

always @(digit or seg1) begin
    case(digit)
        8'b11111110: seg = seg1[6:0];
        8'b11111101: seg = seg1[13:7];
        8'b11111011: seg = seg1[20:14];
        8'b11110111: seg = seg1[27:21];
        8'b11101111: seg = seg1[34:28];
        8'b11011111: seg = seg1[41:35];
        8'b10111111: seg = seg1[48:42];
        8'b01111111: seg = seg1[55:49];
        default : seg = 7'b0;
    endcase
end
    

endmodule
