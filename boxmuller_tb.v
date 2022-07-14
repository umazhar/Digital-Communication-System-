`timescale 1ps/1ps
module boxmuller_tb();
    reg                   clock               ;
    reg                   rst_n               ;
    reg                   init                ;
    reg                   ce                  ;
    reg  [31:0]           seed0               ;
    reg  [31:0]           seed1               ;
    wire                  x_en                ;
    wire [15:0]           good_ch_AWGN        ;
    wire [15:0]           bad_ch_AWGN         ;

    boxmuller DUT(clock, rst_n, init, ce, seed0, seed1, x_en, good_ch_AWGN, bad_ch_AWGN);

    initial begin
    clock = 1; #20;
    forever begin
        clock = ~clock; #20; end
    end
    initial begin
     begin
            seed0 = 32'd321675456;
            seed1 = 32'd321675456;
            rst_n = 1'b1;
            init  = 1'b1;
            ce    = 1'b1;
            #40;
            init = 1'b0;
            #1000000;

   end
end

endmodule