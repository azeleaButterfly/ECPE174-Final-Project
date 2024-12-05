module synchronizer(
input logic key, clk,
output logic ctrl
);
logic Q0,Q1,Q2;

always_ff @(posedge clk) begin  //synchronizer ff2
    Q0 <= key;
    Q1 <= Q0;
    Q2 <= Q1;
end

assign ctrl = (!Q1 && Q2);


endmodule