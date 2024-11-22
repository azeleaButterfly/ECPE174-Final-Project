module game (
    input logic [3:0] key,
    input logic clk,
    output logic [3:0] key_leds
);

logic [1:0] genned_sequence [100];
int currRound = 32'd0;
logic start;
logic game_clk;

sequence_generation sequence_gen (.clk(clk), .game_sequence(genned_sequence));
clockdiv game_clock(.iclk(clk), .oclk(game_clk));
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
        if (currRound > 99) begin
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
                   default:
                       key_leds <= 4'b0000; 
               endcase 
        end 
    end else begin
        key_leds <= 4'b000;
        end
end

endmodule