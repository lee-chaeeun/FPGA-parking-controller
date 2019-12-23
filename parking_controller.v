`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/23 17:31:08
// Design Name: 
// Module Name: parking_controller
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


module parking_controller(
    input clk, rst, exit, enter, pw_correct, pwdone,
    input [15:0] SW,
    input [3:0] car_nb, output wire [2:0] TriLED1,
    output wire [15:0] LED, 
    output wire [1:0] segstate, output wire pwstart, //0 : off, 1: on
    output wire full
    );
    reg [3:0] parked_car; // 4bit
   // reg [1:0] nextsegstate;
    reg [15:0] LED_in;
    reg [1:0] segstate_in;
    reg pwstart_in;
    parameter [2:0] s0 =3'b000, s1=3'b001, s2=3'b010, s3=3'b011, s4=3'b100, s5=3'b101;
    //s0 idle, s1 wait for pw, s2 parking
    parameter [1:0] seg_full=2'b00, seg_enter=2'b01, seg_error=2'b10, seg_off=3'b11;
    reg [1:0] preState, nextState;
    //reg[1:0] segstate;
    //STATE UPDATE
    //wire full;
    
    //full 이랑 exit을 state로 만들 것인가.


always @ (posedge clk) begin //sequential
        if (!rst) //Synchronous Reset
           begin preState <= s0; 
                 
                 LED_in <=16'b0;
           end 
           
        else begin 
        preState <= nextState; 
        if (preState == s2) begin  LED_in[car_nb] <= 1'b1; end
        else if (preState == s3) begin  LED_in[car_nb] <= 1'b0; end 
        else begin  LED_in <= LED_in; end 
        end     
    end
//    always @ (posedge clk) begin //sequential
//            if (!rst)  LED_in <=16'b0;
//            else begin 
//                if (nextState == s2) begin parked_car <= parked_car + 4'b0001; LED_in[car_nb] <= 1'b1; end
//            else if (nextState == s3) begin parked_car <= parked_car - 4'b0001; LED_in[car_nb] <= 1'b0; end 
//            else begin parked_car <= parked_car; LED_in <= LED_in; end 
//            end     
//        end
//    always @ (posedge clk) begin //sequential
//            if (!rst) preState <= s0; 
//            else preState <= nextState; 
//    end
    
    
    always @(posedge clk) begin
        if (!rst) segstate_in <= seg_off;
        else begin 
            if(full & !(preState==s3)) segstate_in <= seg_full;
            else if(enter|(preState==s3)) segstate_in <= seg_off;
            else if(pw_correct && pwdone) segstate_in <= seg_enter;
            else if(!pw_correct && pwdone) segstate_in <= seg_error;
        else segstate_in<=segstate_in; end 
    end
//     always @(posedge clk) begin
//           if (!rst) segstate_in <= seg_off;
//           else begin 
//                if(exit|enter) segstate_in<=seg_off;
//                else if(full) segstate_in<=seg_full;
//                else if(pw_correct && pwdone) segstate_in <= seg_enter;
//                else if(!pw_correct && pwdone) segstate_in <= seg_error;
//           else segstate_in<=segstate_in; end 
//       end
   // pw_correct, pw_entered pw_entered? 1??? ??
    
    always @(*) begin          
             if (!rst) begin             
             //LED=16'b0;
             //parked_car=4'b0000;
             //segstate=2'b11;
             pwstart_in = 1'b0;
             nextState=s0;
             end 
             
             else begin 
             case(preState)
                s0:  begin 
//                     if(enter & !full) nextState = s1;//IDLE
//                     else if (exit) nextState = s3; 
//                     else nextState=s0;
                     pwstart_in = 0;
                     if(exit) nextState=s3;
                     else if(enter & !full) nextState=s1;
                     else nextState=s0;
                     end
                     
                s1: begin
                    if(!pwdone) nextState = s1; //ENTER = 1, WAIT FOR PW CHECK
                    else if(pwdone & pw_correct) nextState = s2; //right and enter
                    //else if(pwdone & !pw_correct) nextState = s0; // wrong
                    else nextState = s0;
                    //segstate=segstate;
                    pwstart_in = 1'b1;
                    //LED = LED;
                    end
                    
                s2: begin  //CORRECT & ENTER
                    nextState = s0;
                    pwstart_in = 1'b0; //initialize
                  //  segstate = 2'b01; //enter
                    //LED[enter_car_nb] = 1'b1;
                    end

                 s3: begin 
                     nextState = s0; //EXIT  
                     pwstart_in = 1'b0;
                    // segstate=segstate;
                     //LED[exit_car_nb] = 1'b0;
                    end    
                               
                default:  begin
                          nextState = s0; 
                          pwstart_in = 1'b0; 
                          //segstate=segstate; 
                          end
            endcase  
            end             
         end
         
         assign full = (LED == 16'b1111_1111_1111_1111)? 1'b1:1'b0; 
         assign LED = LED_in; 
         assign segstate = segstate_in; 
         assign pwstart = pwstart_in;
         assign TriLED1[1] = (pwstart)? 1:0; assign TriLED1[0] = 0; assign TriLED1[2] = 0;
          

endmodule
