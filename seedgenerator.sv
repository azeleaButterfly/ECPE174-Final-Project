module seedgenerator(
    input logic clk, 
    output logic[31:0] seed
);

always @(posedge clk) begin
    if (seed === 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) begin
        seed <= 32'd0;
    end else begin
        seed <= seed + 1;
    end
end
    
endmodule