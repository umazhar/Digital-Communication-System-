	component rng is
		port (
			clock          : in  std_logic                     := 'X'; -- clk
			resetn         : in  std_logic                     := 'X'; -- reset_n
			rand_num_data  : out std_logic_vector(31 downto 0);        -- data
			rand_num_ready : in  std_logic                     := 'X'; -- ready
			rand_num_valid : out std_logic;                            -- valid
			start          : in  std_logic                     := 'X'  -- enable
		);
	end component rng;

	u0 : component rng
		port map (
			clock          => CONNECTED_TO_clock,          --    clock.clk
			resetn         => CONNECTED_TO_resetn,         --    reset.reset_n
			rand_num_data  => CONNECTED_TO_rand_num_data,  -- rand_num.data
			rand_num_ready => CONNECTED_TO_rand_num_ready, --         .ready
			rand_num_valid => CONNECTED_TO_rand_num_valid, --         .valid
			start          => CONNECTED_TO_start           --     call.enable
		);

