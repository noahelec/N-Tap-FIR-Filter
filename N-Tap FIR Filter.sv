module kepq4 #(
    parameter integer N = 4, // Number of taps
    parameter integer COEFF_WIDTH = 8, // Bit-width of coefficients
    parameter integer DATA_WIDTH = 8, // Bit-width of input and output data
    parameter integer ACC_WIDTH = 16, // Bit-width of accumulator
    parameter [N*COEFF_WIDTH-1:0] COEFFS = {8'd1, 8'd2, 8'd3, 8'd4} // Default coefficients
)(
    input wire clk, // Clock signal
    input wire reset, // Reset signal, active high
    input wire signed [DATA_WIDTH-1:0] data_in, // Input data sample
    output reg signed [DATA_WIDTH-1:0] data_out // Filtered output data
);

// Internal signals
reg signed [DATA_WIDTH-1:0] shift_reg [0:N-1]; // Shift register for input samples
wire signed [COEFF_WIDTH-1:0] coeffs [0:N-1]; // Coefficients array
reg signed [ACC_WIDTH-1:0] accumulator; // Accumulator for the sum

// Assign coefficients from the parameter using a generate block
generate
    genvar i;
    for (i = 0; i < N; i = i + 1) begin : assign_coeffs
        assign coeffs[i] = COEFFS[i*COEFF_WIDTH +: COEFF_WIDTH];
    end
endgenerate

// Shift register logic and FIR filter computation
always @(posedge clk or posedge reset) begin
    integer j;
    if (reset) begin
        for (j = 0; j < N; j = j + 1) begin
            shift_reg[j] <= 0;
        end
        accumulator <= 0;
        data_out <= 0;
    end else begin
        // Shift operation
        for (j = N-1; j > 0; j = j - 1) begin
            shift_reg[j] <= shift_reg[j-1];
        end
        shift_reg[0] <= data_in;

        // FIR filter computation
        accumulator = 0;
        for (j = 0; j < N; j = j + 1) begin
            accumulator = accumulator + shift_reg[j] * coeffs[j];
        end
        data_out <= accumulator[N-1:0]; // Truncate or adjust as needed
    end
end

endmodule
