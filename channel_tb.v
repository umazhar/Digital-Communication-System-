`timescale 1ps/1ps

module channel_tb();
    reg reset;
    reg clk_10;
    reg clk_50;
    reg [2:0] KEY;
    reg [15:0] channel_input;
    wire [15:0] channel_output;

    channel CH(clk_10, clk_50, channel_input, channel_output, reset, KEY);

    initial begin //using the clk and make the time is 5 second each
        clk_10=1'b0;
        #1;
        forever begin
            clk_10=1'b1; #1;
            clk_10=1'b0; #1;
        end
    end

    initial begin //using the clk and make the time is 5 second each
        clk_50=1'b0;
        #50;
        forever begin
            clk_50=1'b1; #50;
            clk_50=1'b0; #50;
        end
    end

    initial begin //using the clk and make the time is 5 second each
        forever begin
            // clk=1'b1; #40;
            // clk=1'b0; #40;
            channel_input = 16'd43224; #2;
            channel_input = 16'd34232; #2;
            channel_input = 16'd15423; #2;
            channel_input = 16'd45765; #2;
            channel_input = 16'd36554; #2;
            channel_input = 16'd45432; #2;
            channel_input = 16'd55475; #2;
            channel_input = 16'd3765; #2;
            channel_input = 16'd27566; #2;
        end
    end

    initial begin
        reset = 1'b1; #2;
        reset = 1'b0; #2;

        #100000;
        $stop;

    end
    


endmodule
