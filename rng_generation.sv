module rng_generation(
    input logic clk,
    output logic [31:0] val
);

logic [31:0] seed;
seedgenerator seeding (.clk(clk), .seed(seed));
xorshift generator(.a(seed), .x(val));

endmodule