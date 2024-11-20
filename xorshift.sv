/*
Implementing XOR-Shift in system verilog
Got the C code for the algorithm from https://en.wikipedia.org/wiki/Xorshift
Author: Mari Anderson
*/
module xorshift(
    input logic [31:0] a,
    output logic [31:0] x
); 

logic [31:0] x0, x1, x2;
always_comb begin
    x0 <= a;
    if (x0 === 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx) begin // Checks if x0 isn't resolved
        x1 <= 32'd1;
    end else begin
        x1 <= x0 ^ (x0 << 13);
    end
    if (x1 === 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx)begin // Checks if x1 isn't resolved
        x2 <= 32'd1;
    end else begin
        x2 <= x1 ^ (x1 >> 17);
    end
    x <= x2 ^ (x2 << 5);
end

endmodule