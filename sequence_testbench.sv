module sequence_testbench();

logic clk = 1'b0;
logic [1:0] game_sequence [100];
always begin
    #10 clk <= ~clk;
end
sequence_generationS testGame (.clk(clk), .game_sequence(game_sequence));


initial begin
    int file;
    int count = 32'd0;
    #10000 file = $fopen("./test_sequences.csv", "w");
    for (int i = 0; i < 1000; i++) begin
        #25 if (count >= 32'd99) begin
                $fwrite(file, "%d, ", game_sequence[count]);
                $fwrite(file, "\n");
                count <= 32'd0;
            end else begin
                $fwrite(file, "%d, ", game_sequence[count]); 
                count <= count + 32'd1;
            end
    end
    
    $stop;
end
endmodule