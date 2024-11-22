module sequence_generation(
    input logic clk,
    input logic start,
    output logic [1:0] game_sequence [100]
);

logic [31:0] val;
int count = 32'd0;
logic [31:0] intermed_val;
rng_generation generator(.clk(clk), .val(val));

//Generate Sequence Here:
always @(posedge clk) begin
    if (start) begin
        count <= count;
        game_sequence <= game_sequence;
    end else begin
        if (count >= 32'd100) begin
            count <= 32'd0;
            intermed_val <= val % 4;
            game_sequence[count] <= intermed_val[1:0];
        end else begin
            count <= count + 32'd1;
            intermed_val <= val % 4;
            game_sequence[count] <= intermed_val[1:0];
        end
    end
    
    
end

endmodule