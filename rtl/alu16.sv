module alu16 (
    input logic clk,
    input logic [15:0] a,
    input logic [15:0] b,
    input logic [3:0] op,
    output logic [15:0] result,
    output logic carry_out
);

    // Stage 1 registers
    logic [15:0] a_r, b_r;
    logic [3:0]  op_r;

    always_ff @(posedge clk) begin
        a_r <= a;
        b_r <= b;
        op_r <= op;
    end

    // Stage 2 logic placeholder
    // (Full logic will be added later in Week 1)

endmodule
