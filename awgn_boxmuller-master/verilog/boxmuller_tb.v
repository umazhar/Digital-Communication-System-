module boxmuller_tb();
    reg                   clock               ;
    reg                   rst_n               ;
    reg                   init                ;
    reg                   ce                  ;
    reg  [31:0]           seed0               ;
    reg  [31:0]           seed1               ;

    //output
    wire                  x_en                ;
    wire [15:0]           x0                  ;
    wire [15:0]           x1                  ;

    boxmuller DUT(clock, rst_n, init, ce, seed0, seed1, x_en, x0, x1);

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
                //rst_n = 1'b1;
                //#1;
                //#1000;
                init = 1'b0;

            //     //#1000;
            //     ce = 1'b1;
            // #200;
            // init = 0;
            // #200;
            // rst_n = 0;
            // #200;
            #1000000;

   end
end

endmodule