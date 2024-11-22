module seedgenerator_testbench();
logic clk = 1'b0;
logic [31:0] a;

seedgenerator seedGen (.clk(clk), .seed(a));

always begin
    #10 clk = ~clk;
end

initial begin
    $monitor("clk: ,  a: ", clk, a);
end

endmodule