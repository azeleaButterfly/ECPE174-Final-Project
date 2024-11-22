module xorshift_testbench();
logic [31:0] a;
logic [31:0] x;

xorshift testMod(.a(a), .x(x));

initial begin
    int file;
    file = $fopen("./xor_test_output.txt", "w");
    a <= 32'd0;
    #150 $monitor("%b, %b", a, x);
    for (int i = 0; i < 32'd4294967295; i++) begin
        #5 a <= a + 32'd1;
        $fwrite(file, "%d\n, ", x % 4); //for validating that the RNG follows a uniform distribution
    end
    $fclose(file);
    $stop;
end

endmodule