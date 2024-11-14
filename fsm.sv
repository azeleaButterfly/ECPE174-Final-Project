module fsm (
    input logic clk,
    output logic [6:0] highscore
);
/*
FSM For the Simon Says Game

*/
logic [6:0] curr_round = 7'd0;
logic round_in_progress = 1'b0; //
logic round_win = 1'b1;

typedef enum logic [3:0] {IDLE, DISPLAY_SEQUENCE, ROUND_PLAY, INCREMENT_ROUND} State;
@(posedge clk)
    presentState <= nextState;

always_comb begin
    if (curr_round > highscore) begin
        //If highscore is less than the current round, update highscore with the current round 
        highscore <= curr_round;
    end else begin
        highscore <= highscore;
    end
    case (presentState)


    endcase
end



endmodule
