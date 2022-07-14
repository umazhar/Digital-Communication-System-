// -------------------------------------------------------------
// 
// File Name: hdlsrc\RaisedCosine\RaisedCosine_tc.v
// Created: 2022-06-15 13:39:56
// 
// Generated by MATLAB 9.12 and HDL Coder 3.20
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: RaisedCosine_tc
// Source Path: RaisedCosine_tc
// Hierarchy Level: 1
// 
// Master clock enable input: clk_enable
// 
// enb_1_25000000_1: identical to clk_enable
// enb_1_100000000_1: 4x slower than clk with phase 1
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module RaisedCosine_tc
          (clk,
           reset,
           clk_enable,
           enb_1_25000000_1,
           enb_1_100000000_1);


  input   clk;
  input   reset;
  input   clk_enable;
  output  enb_1_25000000_1;
  output  enb_1_100000000_1;


  reg [1:0] count4;  // ufix2
  wire phase_all;
  reg  phase_1;
  wire phase_1_tmp;


  always @ (posedge clk or posedge reset)
    begin: Counter4
      if (reset == 1'b1) begin
        count4 <= 2'b01;
      end
      else begin
        if (clk_enable == 1'b1) begin
          if (count4 >= 2'b11) begin
            count4 <= 2'b00;
          end
          else begin
            count4 <= count4 + 2'b01;
          end
        end
      end
    end // Counter4

  assign phase_all = clk_enable ? 1'b1 : 1'b0;

  always @ (posedge clk or posedge reset)
    begin: temp_process1
      if (reset == 1'b1) begin
        phase_1 <= 1'b1;
      end
      else begin
        if (clk_enable == 1'b1) begin
          phase_1 <= phase_1_tmp;
        end
      end
    end // temp_process1

  assign  phase_1_tmp = (count4 == 2'b00 && clk_enable == 1'b1) ? 1'b1 : 1'b0;

  assign enb_1_25000000_1 =  phase_all & clk_enable;

  assign enb_1_100000000_1 =  phase_1 & clk_enable;


endmodule  // RaisedCosine_tc
