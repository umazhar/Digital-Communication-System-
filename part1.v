module part1 (CLOCK_50, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input CLOCK_50, CLOCK2_50;
	input [2:0] KEY;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];
	wire enable = 1'b1;
	wire CLOCK_1;
	wire CLOCK_10;

	/////////////////////////////////
	// Your code goes here 
//	/////////////////////////////////

    assign writedata_left = write_ready ? rom_data_extended : writedata_left;
    assign writedata_right = write_ready ? rom_data_extended : writedata_right;
    assign read = read_ready;
    assign write = write_ready;

    reg [15:0] address = 16'd0; 
    wire signed [15:0] rom_data;
    wire signed [23:0] rom_data_extended;
    reg [2:0] count = 3'd0;
    wire signed [15:0] bpsk_out;
    wire en;
    wire signed [15:0] bpsk_in;
    wire signed [15:0] packed_out;
    wire [15:0] im;

    wire signed [15:0] mod_out;
    wire signed [15:0] demod_out;
    wire signed [15:0] demod_in;
    wire signed [15:0] filter_in;
    wire signed [15:0] filter_out;

	//assign demod_in = filter_out;

  rom_q R1(address,CLOCK_50,rom_data);
  pll_1mhz pll(CLOCK_50, reset, CLOCK_1);
//	pll_10MHz(CLOCK_50, reset, CLOCK_10);

  Modulation_DataShifter data_shifter(
                      .reset          (reset), 
                      .clk            (CLOCK_50), 
                      .input_data     (rom_data), 
                      .output_data    (bpsk_in), 
                      .en             (en), 
                      .read_ready     (read_ready)
  );
  
  BPSK_Modulator mod( 
                      .In1            (bpsk_in), 
                      .Output_re      (mod_out), 
                      .Output_im      (im)
  );

  BPSK_Demodulator demod(
                      .Output_re      (demod_in), //real input
                      .Output_im      (im),        //im input
                      .Out1           (bpsk_out)             
  );

	Modulation_DataPacker data_packer(
                      .en             (en), 
                      .reset          (reset), 
                      .clk            (CLOCK_50), 
                      .demod_out      (bpsk_out), 
                      .BPSK_MOD_OUT   (packed_out), 
                      .read_ready     (read_ready)
  ); 

  channel CH(
                      .CLOCK_1(CLOCK_1),
                      .CLOCK_50(CLOCK_50), 
                      .channel_input(mod_out), 
                      .channel_output(demod_in), 
                      .reset(reset),
                      .KEY(KEY)
  );
    

   wire clk_enable = 1;
	 wire ce_out;

   //assign filter_in = mod_out;

	 //RaisedCosine raised_cosine(CLOCK_50,reset,clk_enable,filter_in,ce_out,filter_out);

    always @ (negedge write_ready) 
          begin 
              //address = address + 16'd1;
          if (count<5)
            count = count + 3'd1;
          else begin
            count = 3'd0;
            address = address + 16'd1;
          end
        end
        
//    assign rom_data_extended = {rom_data,8'd0};
	assign rom_data_extended = {packed_out,8'd0};	

  
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires: 
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule


module Modulation_DataShifter (reset, clk, input_data, output_data, en, read_ready);
//(reset, clk, input_data, output_data, en, read_ready);
// datashifter
  `define STATE0 2'b00
  `define STATE1 2'b01
  `define STATE2 2'b10
  `define STATE3 2'b11

  input reset, clk, read_ready;
  input  [15:0] input_data;
  output [15:0] output_data;
  output reg en;
  reg [15:0] sample;
  reg [1:0] current_state;
  reg [6:0] count;

  reg signal_en;
  assign output_data = {15'd0, sample[0]};
  always @ (posedge clk or posedge reset  ) begin
    if (reset) begin
      signal_en = 1'b0;
		sample = 16'b0;
      current_state = `STATE0;
      en = 1'b0;
      count = 1'b0;
    end 
  
    else if (current_state == `STATE0) begin
      
      signal_en <= 1'b1;
      sample <= input_data;
      current_state <= (read_ready)? `STATE1:`STATE0;

    end
          
    else if (current_state == `STATE1) begin
      signal_en <= 1'b1;
      if (count < 16) begin
        sample <= sample >> 1;
        count <= count + 1;
      end
      
      else begin
        count <= 0;
        signal_en <= 1'b0;
        current_state <= `STATE2;
      end 
    end
          
    else if (current_state == `STATE2) begin
        signal_en <= 1'b0;
        en <= 1'b1;
        current_state <= `STATE3;
     
    end 
    
    else if (current_state == `STATE3) begin
        en <= 1'b0;
        signal_en <= 1'b0;
        current_state <= `STATE0;
     
    end
    
    else begin
        current_state <= `STATE0;
    end 
  end
endmodule

module Modulation_DataPacker ( en, reset, clk, demod_out, BPSK_MOD_OUT, read_ready);
  
  `define STATE0 2'b00
  `define STATE1 2'b01
  
  input reset,  clk, en, read_ready;
  input [15:0] demod_out;

  output reg[15:0] BPSK_MOD_OUT;
  
  reg BPSK_de;
  reg [1:0] current_state;
  reg [15:0] de_sample;
  reg [6:0] count;
  wire first_bit;

  assign first_bit = demod_out[0];
  
  always @ (posedge clk) begin
    if (reset) begin
      de_sample = 16'b0;
      count = 0;
      current_state = `STATE0;
    end 
    
           
    else begin
      if (current_state == `STATE0) begin
        if (count < 16) begin            
          de_sample = de_sample  >> 1;
			de_sample[15] <= first_bit;
          count <= count + 1;
        end 
        
        else begin
          count = 0;
          current_state = `STATE1;
        end
         
      end
      
      else if (current_state == `STATE1) begin
        if (en == 1'b1) begin
          BPSK_MOD_OUT <= de_sample;
          current_state <= `STATE1;
        end 
       	else if (read_ready) begin
       	  current_state <= `STATE0;
     	  end
        else begin
          current_state <= `STATE1;
        end 
      end
      
      else begin
        current_state <= `STATE1;
     	end  
    end
  end
endmodule 

module noise_generator (clk, enable, reset, Q);
	input clk, enable, reset;
	output [23:0] Q;
	reg [2:0] counter, counter1;
	always@ (posedge clk) begin
		if (enable)
			counter <= counter1;
		else
			counter <= counter;
	end
	always@(*) begin	
	  case (reset)
		1'b1: counter1 = 3'b000;
		1'b0: counter1 = counter + 1'b1;
	  endcase
	end

	assign Q = {{10{counter[2]}}, counter, 11'd0};
endmodule

module filter(CLOCK_50, in, out, read_ready, reset);
    input CLOCK_50, reset;
    input signed [23:0] in;
    output signed [23:0] out;
    input read_ready;

    //registers for 8 stage filter
	reg signed [23:0] buff0, buff1, buff2, buff3, buff4, buff5, buff6, buff7;
	reg signed [23:0] sum;
	wire signed [23:0] noise;

  wire enable = 1'b1;
  noise_generator ng(CLOCK_50, enable, reset, noise);

    always @ (posedge CLOCK_50)
	begin
		if(read_ready == 1'b1)
			begin
				buff0 <= in >>> 3;
				buff1 <= buff0;
				buff2 <= buff1;
			   buff3 <= buff2;
				buff4 <= buff3;
				buff5 <= buff4;
				buff6 <= buff5;
				buff7 <= buff6;
			end
	end
//
	always @(*) begin
		sum = buff0 + buff1 + buff2 + buff3 + buff4 + buff5 + buff6 + buff7;	
	end
	assign out = sum;
	
endmodule