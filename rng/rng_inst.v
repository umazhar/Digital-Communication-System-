	rng u0 (
		.clock          (<connected-to-clock>),          //    clock.clk
		.resetn         (<connected-to-resetn>),         //    reset.reset_n
		.rand_num_data  (<connected-to-rand_num_data>),  // rand_num.data
		.rand_num_ready (<connected-to-rand_num_ready>), //         .ready
		.rand_num_valid (<connected-to-rand_num_valid>), //         .valid
		.start          (<connected-to-start>)           //     call.enable
	);

