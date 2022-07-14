module part3 (CLOCK_50, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];
	wire enable = 1'b1;

	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////

	wire signed [23:0] filter_out_left, filter_out_right;
	
	assign writedata_left = write_ready ? filter_out_left : writedata_left;
	assign writedata_right = write_ready ? filter_out_right : writedata_right;
	assign read = read_ready;
	assign write = write_ready;
	
	fir_filter FILTER_LEFT(CLOCK_50, readdata_left, filter_out_left, read_ready);
	fir_filter FILTER_RIGHT(CLOCK_50, readdata_right, filter_out_right, read_ready);

/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule

//module noise_generator (clk, enable, Q);
//	input clk, enable;
//	output [23:0] Q;
//	reg [2:0] counter;
//	always@ (posedge clk)
//		if (enable)
//			counter = counter + 1'b1;
//	assign Q = {{10{counter[2]}}, counter, 11'd0};
//endmodule

module noise_generator (clk, enable, reset, Q);
	input clk, enable, reset;
	output [23:0] Q;
	reg [2:0] counter, counter1;
	always@ (posedge clk) begin
		if (enable)
			counter <= counter1;
		else
			counter <= counter;
	end
	always@(*) begin	
	  case (reset)
		1'b1: counter1 = 3'b000;
		1'b0: counter1 = counter + 1'b1;
	  endcase
	end

	assign Q = {{10{counter[2]}}, counter, 11'd0};
endmodule


module fir_filter (clk, in, out, read_ready, write_ready, reset);
    input clk;
    input signed [23:0] in;
    output reg signed [23:0] out;
	input read_ready, write_ready;
	input reset;
	wire [3:0] N = 3'd8;
	wire [7:0] num_words_fifo;
	wire signed [23:0] fifo_out;

	wire empty, full;

    wire enable = 1'b1;
    noise_generator ng(clk, enable, noise, reset);

	wire signed [23:0] divided_in;
	assign divided_in = in >>> N;

	fifo391 FIFO(
		.clock	(clk), 
		.data	(divided_in),
		.rdreq	(read_ready),
		.wrreq	(write_ready),
		.empty	(empty),
		.full	(full),
		.q		(fifo_out),
		.usedw	(num_words_fifo)
	);

	wire signed [23:0] adder_out1;
	assign adder_out1 = -fifo_out + divided_in;

	wire signed [23:0] acc_out;
	vDFFE accumulator(CLOCK50, enable, out, acc_out);
	always @(*) begin
		out = acc_out + adder_out1;
	end
	
	
endmodule

module vDFFE(clk, en, in, out);
    parameter n = 24;  // width
    input  clk, en;
    input  [n-1:0] in ;
    output [n-1:0] out ;
    reg    [n-1:0] out ;
    wire   [n-1:0] next_out ;

    assign next_out = en ? in : out;

    always @(posedge clk)
        out = next_out;  
endmodule