
module rng (
	clock,
	resetn,
	rand_num_data,
	rand_num_ready,
	rand_num_valid,
	start);	

	input		clock;
	input		resetn;
	output	[31:0]	rand_num_data;
	input		rand_num_ready;
	output		rand_num_valid;
	input		start;
endmodule
