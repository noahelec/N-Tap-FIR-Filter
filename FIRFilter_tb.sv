`timescale 1ns / 1ps

module kepq4_tb;

// Parameters matching the DUT (Device Under Test)
localparam integer TB_N = 4;
localparam integer TB_COEFF_WIDTH = 8;
localparam integer TB_DATA_WIDTH = 8;
localparam integer TB_ACC_WIDTH = 16;
// Specify coefficients for testing purposes
localparam [TB_N*TB_COEFF_WIDTH-1:0] TB_COEFFS = {8'd1, 8'd2, 8'd3, 8'd4};

// Testbench Signals
reg clk;
reg reset;
reg signed [TB_DATA_WIDTH-1:0] data_in;
wire signed [TB_DATA_WIDTH-1:0] data_out;

// Instantiate the Module Under Test (MUT)
kepq4 #(
    .N(TB_N),
    .COEFF_WIDTH(TB_COEFF_WIDTH),
    .DATA_WIDTH(TB_DATA_WIDTH),
    .ACC_WIDTH(TB_ACC_WIDTH),
    .COEFFS(TB_COEFFS)
) uut (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .data_out(data_out)
);

// Clock Generation (100 MHz for example)
initial clk = 0;
always #5 clk = ~clk; // 100MHz, 10ns period

// Test Stimulus: Reset, Input Patterns, etc.
initial begin
    // Initialize
    reset = 1;
    data_in = 0;
    #15; // Apply reset
    reset = 0;

    // Test sequence
    @(posedge clk); data_in = 12; // Example input data
    @(posedge clk); data_in = -8;
    @(posedge clk); data_in = 7;
    @(posedge clk); data_in = 15;
    @(posedge clk); data_in = -5;
    // Add more input patterns as needed for comprehensive testing

    // Wait some cycles
    repeat (5) @(posedge clk);

    // End of Test
    $stop;
end

// Monitor Outputs
initial begin
    $monitor("Time=%t, reset=%0d, data_in=%0d, data_out=%0d",
              $time, reset, data_in, data_out);
end

endmodule
