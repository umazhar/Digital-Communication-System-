`timescale 1ps/1ps
module bpsk_mod_demod_tb();
reg clk;
reg rst;
reg[15:0] input_data;
wire[15:0] bpsk_mod_out;
reg read_ready;

BPSK_mod_demod bpsk(input_data, bpsk_mod_out);

initial begin
    rst = 1;
    rst = 0;
    clk = 1; #20;
    forever begin
        clk = ~clk; #20;
    end
end
initial begin
    forever begin
        input_data = 1; #20;
	input_data = 0; #20;
   end
end

endmodule