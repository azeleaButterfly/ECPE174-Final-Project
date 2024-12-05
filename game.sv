module game (
    input logic [3:0] keys,
    input logic clk,
    output logic play_led,
    output logic [3:0] key_leds,
    output logic [0:6] display0,
    output logic [0:6] display1,
    output logic [0:6] display2,
    output logic [0:6] display3,
    output logic [0:6] display4,
    output logic [0:6] display5,
    output logic [0:6] display6,
    output logic [0:6] display7
);

/*External Module Instantation*/
sequence_generation sequence_gen (.clk(clk), .start(start), .game_sequence(genned_sequence));
clockdiv game_clock(.iclk(clk), .oclk(game_clk));
synchronizer key0_sync(.clk(game_clk), .key(keys[0]), .ctrl(synced_keys[0]));
synchronizer key1_sync(.clk(game_clk), .key(keys[1]), .ctrl(synced_keys[1]));
synchronizer key2_sync(.clk(game_clk), .key(keys[2]), .ctrl(synced_keys[2]));
synchronizer key3_sync(.clk(game_clk), .key(keys[3]), .ctrl(synced_keys[3]));
three_disp_seven_seg round_disp(.a(currRound), .display0(display0), .display1(display1), .display2(display2));
three_disp_seven_seg highscore_disp(.a(high_score), .display0(display4), .display1(display5), .display2(display6));


/*State Type and Variable Declaration */
typedef enum logic [1:0] {IDLE, DISPLAY_SEQUENCE, ROUND_PLAY, ROUND_LOST} State;
State prev_state = IDLE;
State present_state = IDLE;
State next_state;

/*Variable Declaration*/
logic [1:0] genned_sequence [100];
logic game_clk, round_clk, rng_clk;
logic start = 1'b0;
logic [3:0] synced_keys;
logic [7:0] currRound = 8'd1;
logic [7:0] subRound = 8'd0;
logic [7:0] high_score = 8'd0;
logic [4:0] seq_disp_count = 5'b00000; //How many times to display the led
logic [11:0] round_timer = 12'd0;
logic [1:0] user_input = 2'b00;
/*FSM Logic*/
always @(posedge game_clk) begin
    case (present_state)
        IDLE:
        begin
            currRound <= 8'd0;
            play_led <= 1'b0;
            start <= 1'b0;
            if (synced_keys != 4'b0000) begin
                next_state <= DISPLAY_SEQUENCE;
                currRound <= 8'd1;
            end else begin
                next_state <= IDLE;
            end
        end
        
		DISPLAY_SEQUENCE:
        begin
            start <= 1'b1;
            play_led <= 1'b0;
            if (prev_state == IDLE || prev_state == ROUND_PLAY) begin
                subRound <= 8'd0;

            end else begin
                subRound <= subRound;
            end
            if (subRound >= currRound )begin
                subRound <= 8'd0;
                next_state <= ROUND_PLAY;
            end else begin
                case (genned_sequence[subRound])
                2'b00: key_leds <= 4'b0001; //LEDG0
                2'b01: key_leds <= 4'b0010; //LEDG2
                2'b10: key_leds <= 4'b0100; //LEDG4
                2'b11: key_leds <= 4'b1000; //LEDG6
                default: key_leds <= 4'b0000;
            endcase
                seq_disp_count <= seq_disp_count + 8'd1;
                if (seq_disp_count == 5'b11111) begin
                    subRound <= subRound + 8'd1;
                    seq_disp_count <= 5'd0;
                end else begin
                    subRound <= subRound;
                end
                next_state <= DISPLAY_SEQUENCE;
            end
        end

        ROUND_PLAY:
        begin
            key_leds = synced_keys;
            start = 1'b1;
            play_led = 1'b1;
            //Start of round, set subround counter to 0
            if (prev_state == DISPLAY_SEQUENCE) begin
                subRound = 8'd0;
                round_timer = 12'd0;
            end else begin
                subRound = subRound;
            end

            //If too much time in a round has been taken, lose
            if (round_timer == 12'hFFF) begin
                next_state = ROUND_LOST;
                round_timer = 12'd0;
            end else begin
                next_state = next_state;
                round_timer = round_timer + 12'd1;
            end
            //If Input, Check that input is correct
            if (synced_keys != 4'b0000) begin
                case (synced_keys)
                    4'b0001: user_input = 2'b00;
                    4'b0010: user_input = 2'b01;
                    4'b0100: user_input = 2'b10;
                    4'b1000: user_input = 2'b11;
                    default: next_state = ROUND_PLAY;
                endcase
                //Compare against the current value in the sequence
                if (user_input == genned_sequence[subRound]) begin
                    subRound = subRound + 8'd1;
                    if (subRound >= currRound) begin
                        subRound = 8'd0;
                        currRound = currRound + 8'd1;
                        next_state = DISPLAY_SEQUENCE;
                    end else begin
                        next_state = ROUND_PLAY;
                    end
                end else begin
                    next_state = ROUND_LOST;
                end
            end else begin
                //No Input, Do not increment subRound
                subRound = subRound;                
            end
            
        end


        ROUND_LOST:
        begin
            if (currRound > high_score) begin
                high_score <= currRound;
            end else begin
                high_score <= high_score;
            end
            key_leds <= 4'b0000;
            play_led <= 1'b0;
            next_state <= IDLE;
            currRound <= 8'd0;
            round_timer <= 12'd0;
        end
		default: 
        begin
            play_led <= 1'b0;
            key_leds <= 4'b0000;
            next_state <= IDLE;
            start <= 1'b0;
            subRound <= 8'd0;
            currRound <= 8'd0;
            round_timer <= 12'd0;
            high_score <= high_score;
        end
    endcase
end

always_ff @(negedge clk) begin
    prev_state <= present_state;
    present_state <= next_state;
end


always_comb begin
    display7 <= 7'b1001000; //Highscore H
    display3 <= 7'b1111010; //Round r
end

endmodule
