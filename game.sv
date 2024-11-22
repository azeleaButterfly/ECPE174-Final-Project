module game (
    input logic clk,
	input logic [3:0] key,
    output logic [3:0] key_leds ,
    output logic [0:6] round_num1,
    output logic [0:6] round_num2,
    output logic [0:6] round_num3
);

logic [1:0] genned_sequence [100];
int currRound = 32'd0;
// logic [7:0] subRound = 8'd0; //round 2 has 2 rounds, etc
logic start = 1'b0;
logic game_clk;

sequence_generation sequence_gen (.clk(clk), .start(start), .game_sequence(genned_sequence));
clockdiv game_clock(.iclk(clk), .oclk(game_clk));
three_disp_seven_seg disp(.a(currRound), .display0(round_num1), .display1(round_num2), .display2(round_num3));
always_comb begin //Code to test the display of the sequence
    if (~key[0] || ~key[1] || ~key[2] || ~key[3]) begin
        //Buttons active low, for now just hold to test the LED display
        start <= 1'b1; 
    end else begin
        start <= 1'b0;
    end
end

always @(posedge game_clk) begin
    if (start) begin
        if (currRound > 32'd99) begin
            currRound <= 32'd0;
            case (genned_sequence[currRound])
                2'b00: key_leds <= 4'b0001;
                2'b01: key_leds <= 4'b0010;
                2'b10: key_leds <= 4'b0100;
                2'b11: key_leds <= 4'b1000;
                default:
                    key_leds <= 4'b0000; 
            endcase 
        end
        else begin
           currRound <= currRound + 32'd1;
           case (genned_sequence[currRound])
                    2'b00: key_leds <= 4'b0001;
                    2'b01: key_leds <= 4'b0010;
                    2'b10: key_leds <= 4'b0100;
                    2'b11: key_leds <= 4'b1000;
                    default: key_leds <= 4'b0000; 
            endcase 
        end 
    end else begin
            key_leds <= 4'b0000;
		    currRound <= 32'd0;
		    //subRound <= 8'd0;
        end
end

endmodule