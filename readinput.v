`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/23 16:11:40
// Design Name: 
// Module Name: readinput
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

module readinput(
    input clk, rst,
    input [15:0] SW,
    output wire [3:0] car_nb,
    output wire enter, exit
    );
    //switch 0:off, 1: on
    reg [3:0] car_nb_in;
    //reg enter,exit;
    reg diff2;
    reg [15:0] present;
    reg [15:0] past;
    reg enter_in, exit_in;
    wire diff;
    //reg [15:0] diff_location;
   // we don't use diff location any more. we use past^present right away

    always @(posedge clk) begin 
        if(!rst) begin
            present <=0;
            past<=0;
            
        end
        else begin
            present <= SW;
            past <= present; // ?? ? ?? flipflop? ???
            end    
    end
    assign diff = (past==present)? 0:1; //diff? ?? ?? 1??? 
    
    always @(posedge clk) begin
        if(!rst) diff2<=0;
        else diff2<=diff;
    end
    always @(posedge clk) begin
        if(!rst) begin
            exit_in<=1'b0;
            enter_in<=1'b0;
        end
        else if(diff2) begin
            if(present[car_nb_in]) begin
                 enter_in<=1'b1;
                 exit_in<=1'b0;
            end
            else begin
                exit_in<=1'b1;
                enter_in<=1'b0;
            end 
        end   
        else begin
            exit_in<=1'b0;
            enter_in<=1'b0;
        end
    end

//    always@(negedge SW[car_nb]) begin
//        if (SW[car_nb]==0) exit_in<=1'b1;
//        else exit_in<=1'b0;
//    end
    always@(posedge clk) begin
        if(!rst) begin 
        car_nb_in <=0;
        // enter_in<=0; 
       // exit_in<=0;
        end
        else if(diff) begin
             //diff_location <= past^present; //xor? ??? ??? ???. ^ ? bitwise ????
            case(past^present)
                16'b0000000000000001: car_nb_in <= 'b0000; //??? ??? 4bit ? 0~15 ??? ???
                16'b0000000000000010: car_nb_in <= 'b0001;
                16'b0000000000000100: car_nb_in <= 'b0010;
                16'b0000000000001000: car_nb_in <= 'b0011;
                16'b0000000000010000: car_nb_in <= 'b0100;
                16'b0000000000100000: car_nb_in <= 'b0101;
                16'b0000000001000000: car_nb_in <= 'b0110;
                16'b0000000010000000: car_nb_in <= 'b0111;
                16'b0000000100000000: car_nb_in <= 'b1000;
                16'b0000001000000000: car_nb_in <= 'b1001;        
                16'b0000010000000000: car_nb_in <= 'b1010;
                16'b0000100000000000: car_nb_in <= 'b1011;        
                16'b0001000000000000: car_nb_in <= 'b1100;
                16'b0010000000000000: car_nb_in <= 'b1101;
                16'b0100000000000000: car_nb_in <= 'b1110;
                16'b1000000000000000: car_nb_in <= 'b1111;
                default: car_nb_in <='b0000;
            endcase
            
//            if(present[car_nb]==0)begin //1? ??? enter
//                 enter_in<=0; 
//                 exit_in<=1;
//            end
//            else begin
//                 enter_in<=1; 
//                 exit_in<=0;
//            end

      end
//      else begin //present? past? ???
//              enter_in<=0;
//              exit_in<=0;
//      end     
                                     
      end
//we assign enter, exit, enter_car_nb, exit_car_nb with combinational always block
// to prevent time delay of clock. it is still okay since car_nb does not change until SW //changes.


assign car_nb = car_nb_in; 
assign enter = enter_in;
assign exit = exit_in;
    
endmodule
