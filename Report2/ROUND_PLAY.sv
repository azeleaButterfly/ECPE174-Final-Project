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