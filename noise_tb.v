module noise_generator_tb();
    reg clk, enable;
    wire [23:0] Q;
    reg reset;
    reg err;

    noise_generator DUT (clk, enable, reset, Q);

    initial begin
        clk = 0; #5;
        forever begin
            clk = 1; #5;
            clk = 0; #5;
        end
    end 
    
    initial begin
        enable = 1'b1;
	reset = 1'b1;
        #10;
        $display("Output is %b", Q);
        #10;
        $display("Output is %b", Q);
        #10;
	reset = 1'b0;
        $display("Output is %b", Q);
        #10;
        $display("Output is %b", Q);
        #10;
        $display("Output is %b", Q);
        #10;
        $display("Output is %b", Q);
        #10;
        $display("Output is %b", Q);
        #10;
        $display("Output is %b", Q);
        #10;
        $display("Output is %b", Q);
                
        

    end
endmodule   