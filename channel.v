  `define GOODSTATE 2'd0
  `define BADSTATE 2'd1

`timescale 1ps/1ps

module channel(CLOCK_1,CLOCK_50, channel_input, channel_output, reset, KEY);
    input [15:0] channel_input;
    input CLOCK_50;
    input CLOCK_1;
    //input reset;
    input [2:0] KEY;
    output reg [15:0] channel_output;
    input reset;

    reg rst_n, init, ce;
    wire [15:0] good_ch_AWGN;
    wire [15:0] bad_ch_AWGN; 
    wire [31:0] seed0, seed1;

    wire [6:0] random_integer;
    reg reset_gen;

    reg current_state;

    assign seed0 = 32'd321675456;
    assign seed1 = 32'd321675456;

    boxmuller BM(CLOCK_1,rst_n,init,ce,seed0,seed1,x_en,good_ch_AWGN,bad_ch_AWGN);
    random_int_gen INTGEN(CLOCK_1, reset_gen, random_integer);
    
    always @(posedge CLOCK_50 or posedge reset) begin
            if (reset) begin
                reset_gen <= 1'b0;
                rst_n <= 1'b1;
                ce <= 1'b1;
                init <= 1'b1;
                current_state <= `GOODSTATE;
            end

            else if (current_state == `GOODSTATE) begin
                reset_gen <= 1'b1;
                init <= 1'b0;
                rst_n <= 1'b1;
                current_state <= (random_integer < 7'd6) ? `BADSTATE: `GOODSTATE; 
            end
            else if (current_state == `BADSTATE) begin
                reset_gen <= 1'b1;
                init <= 1'b0;
                rst_n <= 1'b1;
                current_state <= (random_integer < 7'd26) ? `BADSTATE: `GOODSTATE;
            end
    end

    //AWGN CODE
    
    // always @(*) begin             
    //     case (current_state)
    //         `GOODSTATE : channel_output = channel_input + good_ch_AWGN;
    //         `BADSTATE : channel_output = channel_input + bad_ch_AWGN;
    //         default : channel_output = channel_input;
    //     endcase
    // end

    //DEMO CODE

    always @(*) begin             
        case (KEY)
            ~KEY[1] : channel_output = channel_input + good_ch_AWGN;
            ~KEY[2] : channel_output = channel_input + bad_ch_AWGN;
            default : channel_output = channel_input;
        endcase
    end


endmodule


//generates 7 bit (2^7 = 128 max) random integer. 
module random_int_gen(clk, rst_n, data);
    input clk;
    input rst_n;
    output reg [6:0] data;

    wire feedback = data[6] ^ data[0];

    always @(posedge clk or negedge rst_n)
    if (~rst_n) 
        data <= 6'd63;
    else
        data <= {data[6:0], feedback} ;

endmodule

module random_int_gen_tb;

reg clk, rst_n;
wire [6:0] data;

random_int_gen DUT(clk, rst_n, data);

initial begin //using the clk and make the time is 5 second each
    clk=1'b0;
    #5;
    forever begin
        clk=1'b1; #5;
        clk=1'b0; #5;
    end
end

initial begin
    rst_n = 0; #5;
    rst_n = 1; #5;
    #1000; $stop;
end
endmodule


