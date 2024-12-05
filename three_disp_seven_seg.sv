/*
Display Module for showing the current round number
Designed to display integers 0 - 100
*/
module three_disp_seven_seg(
    input logic [7:0] a,
    output logic [0:6] display0,
    output logic [0:6] display1,
    output logic [0:6] display2
);

always_comb begin
        if (a > 8'd100) begin
            display0 <= 7'b1111110;
            display1 <= 7'b1111110;
            display2 <= 7'b1111110;
        end else if (a === 8'd100) begin
            display0 <= 7'b0000001;
            display1 <= 7'b0000001;
            display2 <= 7'b1001111;
        end else if (a === 8'd0) begin
            display0 <= 7'b0000001;
            display1 <= 7'b0000001;
            display2 <= 7'b0000001;
        end else begin
            display2 <= 7'b0000001;

            case (a / 10)
                8'd0: display1 <= 7'b0000001; //0
                8'd1: display1 <= 7'b1001111; //1
                8'd2: display1 <= 7'b0010010; //2
                8'd3: display1 <= 7'b0000110; //3
                8'd4: display1 <= 7'b1001100; //4
                8'd5: display1 <= 7'b0100100; //5
                8'd6: display1 <= 7'b0100000; //6
                8'd7: display1 <= 7'b0001111; //7
                8'd8: display1 <= 7'b0000000; //8
                8'd9: display1 <= 7'b0001100; //9 
                default: display1 <= 7'b1111110;
            endcase

            case (a % 10)
                8'd0: display0 <= 7'b0000001; //0
                8'd1: display0 <= 7'b1001111; //1
                8'd2: display0 <= 7'b0010010; //2
                8'd3: display0 <= 7'b0000110; //3
                8'd4: display0 <= 7'b1001100; //4
                8'd5: display0 <= 7'b0100100; //5
                8'd6: display0 <= 7'b0100000; //6
                8'd7: display0 <= 7'b0001111; //7
                8'd8: display0 <= 7'b0000000; //8
                8'd9: display0 <= 7'b0001100; //9 
                default: display0 <= 7'b1111110; 
            endcase
    end
end



endmodule