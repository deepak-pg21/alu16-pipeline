// 2-Stage Pipelined 16-bit ALU
// Pipeline latency: 2 clock cycles
// 
// Operation codes (op):
//   0x0: ADD    - Add with carry
//   0x1: SUB    - Subtract with borrow
//   0x2: INC    - Increment
//   0x3: DEC    - Decrement
//   0x4: AND    - Bitwise AND
//   0x5: OR     - Bitwise OR
//   0x6: XOR    - Bitwise XOR
//   0x7: NOT    - Bitwise NOT
//   0x8: SHL    - Shift left
//   0x9: SHR    - Shift right
//   0xA: ROL    - Rotate left
//   0xB: ROR    - Rotate right
//   0xC: CMP_EQ - Compare equal
//   0xD: CMP_LT - Compare less than
//   0xE: CMP_GT - Compare greater than
//   0xF: PASS   - Pass through a
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

    // Stage 2: ALU operations and output registers
    logic [15:0] result_next;
    logic carry_next;

    always_comb begin
        result_next = 16'h0000;
        carry_next = 1'b0;

        case (op_r)
            4'h0: {carry_next, result_next} = a_r + b_r;           // ADD
            4'h1: {carry_next, result_next} = a_r - b_r;           // SUB
            4'h2: {carry_next, result_next} = a_r + 1;             // INC
            4'h3: {carry_next, result_next} = a_r - 1;             // DEC
            4'h4: result_next = a_r & b_r;                         // AND
            4'h5: result_next = a_r | b_r;                         // OR
            4'h6: result_next = a_r ^ b_r;                         // XOR
            4'h7: result_next = ~a_r;                              // NOT
            4'h8: {carry_next, result_next} = {a_r[15], a_r[14:0], 1'b0}; // SHL (shift left)
            4'h9: {result_next, carry_next} = {1'b0, a_r[15:1], a_r[0]}; // SHR (shift right)
            4'hA: result_next = {a_r[14:0], a_r[15]};              // ROL (rotate left)
            4'hB: result_next = {a_r[0], a_r[15:1]};               // ROR (rotate right)
            4'hC: result_next = (a_r == b_r) ? 16'h0001 : 16'h0000; // CMP_EQ
            4'hD: result_next = (a_r < b_r)  ? 16'h0001 : 16'h0000; // CMP_LT
            4'hE: result_next = (a_r > b_r)  ? 16'h0001 : 16'h0000; // CMP_GT
            4'hF: result_next = a_r;                                // PASS
            default: result_next = 16'h0000;
        endcase
    end

    always_ff @(posedge clk) begin
        result <= result_next;
        carry_out <= carry_next;
    end

endmodule
