module ece593_alu #(
    parameter INPUT_DATABUS_WIDTH = 16,
    parameter RESULTBUS_WIDTH = 32
)(
    input  logic [INPUT_DATABUS_WIDTH-1:0] A, B,    // Input data buses
    input  logic [2:0] op_sel,   // Operation selector
    input  logic clk, rst,       // Clock and reset
    input  logic start_op,       // Start operation signal
    output logic [RESULTBUS_WIDTH-1:0] result,  // Result bus
    output logic end_op          // Operation complete signal
);
    logic [RESULTBUS_WIDTH-1:0] temp;
    logic [1:0] mul_count;          // Counter for multiplication cycles
    logic mul_cycle_progress;         

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            temp <= 32'b0;
            end_op <= 1'b0;
            mul_count <= 2'b0;
            mul_cycle_progress <= 1'b0;
        end else begin
            end_op <= 1'b0; // Default value (not asserted)

            if (start_op) begin
                case (op_sel)
                    3'b000: begin
                        temp <= temp;  // No-op
                        end_op <= 1'b1; // Immediate completion
                    end
                    3'b001: begin
                        temp <= A + B; // Addition
                        end_op <= 1'b1; // Immediate completion
                    end
                    3'b010: begin
                        temp <= A - B; // Subtraction
                        end_op <= 1'b1; // Immediate completion
                    end
                    3'b011: begin
                        temp <= A ^ B; // XOR
                        end_op <= 1'b1; // Immediate completion
                    end
                    3'b100: begin
                        if (!mul_cycle_progress) begin
                            mul_cycle_progress <= 1'b1;
                            mul_count <= 2'b0;
                            temp <= A * B; // Start multiplication
                        end else if (mul_count < 2) begin
                            mul_count <= mul_count + 1;
                        end else begin
                            mul_cycle_progress <= 1'b0;
                            end_op <= 1'b1; // Assert after 3 cycles
                        end
                    end
                    3'b101: begin
                        temp <= A & B; // AND
                        end_op <= 1'b1; // Immediate completion
                    end
                    3'b110, 3'b111: begin
                        temp <= 32'b0; // Display operation
                        end_op <= 1'b1; // Immediate completion
                    end
                    default: begin
                        temp <= 32'b0; // Invalid operation
                        end_op <= 1'b0; // Not completed
                    end
                endcase
            end
        end
    end

    assign result = temp;

endmodule
