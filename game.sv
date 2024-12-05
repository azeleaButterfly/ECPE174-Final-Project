module game (
    input logic [3:0] keys,
    input logic clk,
    output logic [3:0] key_leds,
    output logic [0:6] display0,
    output logic [0:6] display1,
    output logic [0:6] display2
);

/*External Module Instantation*/
sequence_generation sequence_gen (.clk(clk), .start(start), .game_sequence(genned_sequence));
clockdiv game_clock(.iclk(clk), .oclk(game_clk));
round_clockdiv round_clock(.iclk(clk), .oclk(round_clk));
synchronizer key0_sync(.clk(game_clk), .key(keys[0]), .ctrl(synced_keys[0]));
synchronizer key1_sync(.clk(game_clk), .key(keys[1]), .ctrl(synced_keys[1]));
synchronizer key2_sync(.clk(game_clk), .key(keys[2]), .ctrl(synced_keys[2]));
synchronizer key3_sync(.clk(game_clk), .key(keys[3]), .ctrl(synced_keys[3]));
three_disp_seven_seg round_disp(.a(currRound), .display0(display0), .display1(display1), .display2(display2));

/*State Type and Variable Declaration */
typedef enum logic [1:0] {IDLE, DISPLAY_SEQUENCE, ROUND_PLAY, ROUND_LOST} State;
State prev_state = IDLE;
State present_state = IDLE;
State next_state;

/*Variable Declaration*/
logic [1:0] genned_sequence [100];
logic [1:0] user_input [100];
logic game_clk, round_clk;
logic start;
logic [3:0] synced_keys;
logic [7:0] currRound = 8'd0;
logic [7:0] subRound = 8'd0;
logic [7:0] high_score = 8'd0;

/*FSM Logic*/
always_comb begin
    case (present_state)
        IDLE:
        begin
            next_state <= next_state;
            high_score <= high_score;
            subRound <= subRound;
            high_score <= high_score;
            start <= 1'b0;
            if (synced_keys != 4'd0) begin
                next_state <= DISPLAY_SEQUENCE;
                key_leds <= 4'd0;
                subRound <= 8'd0;
            end else begin
                next_state <= IDLE;
                key_leds <= 4'd0;
                subRound <= 8'd0;
            end
            next_state <= next_state;
            high_score <= high_score;
            key_leds <= 4'd0;
            subRound <= 8'd0;
        end
        
		DISPLAY_SEQUENCE:
        begin
            next_state <= next_state;
            high_score <= high_score;
            subRound <= subRound;
            start <= 1'b1;
            if (prev_state == IDLE || prev_state == ROUND_PLAY) begin
                subRound <= 8'd0;
                next_state <= next_state;
                key_leds <= key_leds;
            end else begin
				if (subRound > currRound) begin
					subRound <= 8'd0;
					next_state <= ROUND_PLAY;
                    key_leds <= 4'd0;
                    high_score <= high_score;
				end	else begin
	 	 	 		subRound <= subRound + 8'd1;
                    next_state <= next_state;
                    high_score <= high_score;
                    case (genned_sequence[subRound])
                        2'b00: 
                        begin
                            key_leds <= 4'b0001;
                            next_state <= next_state;
                            subRound <= subRound;
                        end
                        
                        2'b01: 
                        begin
                            key_leds <= 4'b0010;
                            next_state <= next_state;
                            subRound <= subRound;
                        end
                        2'b10: begin
                            key_leds <= 4'b0100;
                            next_state <= next_state;
                            subRound <= subRound;
                        end
                        2'b11: 
                        begin 
                            key_leds <= 4'b1000;
                            next_state <= next_state;
                            subRound <= subRound;
                        end 
                        default: 
                        begin
                            key_leds <= 4'b0000;
                            next_state <= next_state;
                            subRound <= subRound;
                        end
                    endcase
                    next_state <= DISPLAY_SEQUENCE;
				end
                next_state <= DISPLAY_SEQUENCE;
			end
            next_state <= next_state;
            start <= 1'b1;
            key_leds <= key_leds;
            high_score <= high_score;
            subRound <= subRound;
        end
        
		ROUND_PLAY:
        begin
            next_state <= next_state;
            high_score <= high_score;
            subRound <= subRound;
			if (prev_state == DISPLAY_SEQUENCE) begin
                subRound <= 8'd0;
                next_state <= next_state;
                high_score <= high_score;
            end else begin
                next_state <= next_state;
                high_score <= high_score;
                subRound <= subRound;
                    if (round_clk == 1'b0) begin
				        next_state <= ROUND_LOST;
                        key_leds <= 4'd0;
                        subRound <= 8'd0;
                        high_score <= high_score;
			        end	else begin
                        next_state <= next_state;
                        high_score <= high_score;
                        subRound <= subRound;
				        if (synced_keys != 4'd0) begin
					        case (synced_keys)
					        	4'b0001: 
                                begin 
                                    user_input[subRound] <= 2'b00;
                                    next_state <= next_state;
                                    key_leds <= key_leds;
                                    subRound <= subRound;
                                end

					        	4'b0010:
                                begin
                                    user_input[subRound] <= 2'b01;
                                    next_state <= next_state;
                                    key_leds <= key_leds;
                                    subRound <= subRound;
                                end 

					        	4'b0100:
                                begin
                                    user_input[subRound] <= 2'b10;
                                    next_state <= next_state;
                                    key_leds <= key_leds;
                                    subRound <= subRound;
                                end 
					        	4'b1000: begin
                                    user_input[subRound] <= 2'b11;
                                    next_state <= next_state;
                                    key_leds <= key_leds;
                                    subRound <= subRound;
                                end 
					        	default: begin
                                    user_input[subRound] <= 2'b00;
                                    next_state <= next_state;
                                    key_leds <= key_leds;
                                    subRound <= subRound;
                                end
                        
				                endcase
					if (user_input[subRound] == user_input[subRound]) begin
	 	 	 	 		subRound <= subRound + 8'd1;
                        key_leds <= key_leds;
						next_state <= ROUND_PLAY;
                    end else begin
                        subRound <= subRound;
                        key_leds <= key_leds;
						next_state <= ROUND_LOST;
                    end
				end else begin
	 	 	 		next_state <= ROUND_PLAY;
                    key_leds <= key_leds;
                    subRound <= subRound;
				end	
	 	 	 		next_state <= ROUND_PLAY;
                    key_leds <= key_leds;
                    subRound <= subRound;
			end
            next_state <= next_state;
            key_leds <= key_leds;
            subRound <= subRound;
            end
			key_leds <= key_leds;
            subRound <= subRound;
            start <= 1'b1;
        end

	 	ROUND_LOST:
		begin
            next_state <= next_state;
            high_score <= high_score;
            subRound <= subRound;
			if (currRound > high_score) begin
				high_score <= currRound;
                subRound <= subRound;
                next_state <= next_state;
			end	else begin
	 	 		high_score <= high_score;
                subRound <= subRound;
                next_state <= next_state;
			end
            key_leds <= 4'b0000;
            start <= 1'b0;
            subRound <= 8'd0;
            high_score <= high_score;
			next_state <= IDLE;
		end	

		default: 
        begin
            key_leds <= 4'b0000;
            next_state <= IDLE;
            start <= 1'b0;
            subRound <= 8'd0;
            high_score <= high_score;
        end
    endcase
end

always_ff @(negedge clk) begin
    prev_state = present_state;
    present_state = next_state;
end


endmodule
