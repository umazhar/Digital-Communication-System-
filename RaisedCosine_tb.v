`timescale 1ps/1ps
module RaisedCosine_tb();
  reg   clk;
  reg   reset;
  reg   clk_enable;
  reg   signed [15:0] In1;  // int16
  wire  ce_out;
  wire  signed [15:0] Out1;  // int16

RaisedCosine DUT(clk,reset,clk_enable,In1,ce_out,Out1);

initial begin
    reset = 1;
    reset = 0;
    reset = 1;
    clk = 1; #20;
    forever begin
        clk = ~clk; #20;
    end
end
initial begin
    forever begin
        clk_enable = 1'b1;
        #20;
        In1 = 16'sd32767;
        #20;
        In1 = -16'sd32768;

   end
end

endmodule