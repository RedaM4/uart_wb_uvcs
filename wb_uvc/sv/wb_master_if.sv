//NEEDS A REALLY GOOD REVISION


typedef enum bit [1:0] {WRITE, READ, IDLE, NULL} m_state_t;
interface wb_master_if (input clock, input reset );
timeunit 1ns;
timeprecision 100ps;

import uvm_pkg::*;
`include "uvm_macros.svh"

import wb_pkg::*;

  logic       [31:0]    ADR_O;
  logic       [7:0]     DAT_I;
  logic       [7:0]     DAT_O;
  logic                 WE_O;
  logic                 STB_O;
  logic                 ACK_I;



  task wb_reset();
    @(posedge reset);
    ADR_O       <=  'hz;
    DAT_I       <= 8'b0;
    DAT_O       <= 8'b0;
    WE_O        <= 1'b0;
    ACK_I       <= 1'b0;
    disable send_to_dut;
  endtask
  
  task send_to_dut(input bit [31:0]  address,
                         bit [7:0]  data,
                        m_state_t m_state,
                        );

  case (m_state)
    WRITE:
    begin
      if(STB_O==0)
      begin
    @(negedge clock)
    DAT_O <= data;
    ADR_O <= address;
    WE_O  <= 1'b1;
    //STB_O <= 1'b1;

    @(negedge clock) 
    start_master();
      end
    end


    READ:
    begin
      if(STB_O==0)
        begin
    @(negedge clock)
    ADR_O <= address;
    WE_O  <= 1'b0;
    //STB_O <= 1'b1;

    @(negedge clock) 
    start_master();
        end
    end

    IDLE:
        begin
      if(STB_O==0)
        begin
        //DO NOTHING
        end
    end

    NULL:
`uvm_error("--INTERFACE--", "WB INTERFACE RECIEVED NULL MASTER STATE");

  endcase

  endtask : send_to_dut

/*
  // Collect Packets
  task collect_packet(output bit [5:0]  length,
                         bit [1:0]  addr,
                         bit [7:0]  payload[],
                         bit [7:0]  parity);
      //Monitor looks at the bus on posedge (Driver uses negedge)
      //@(posedge in_data_vld);

      @(posedge clock iff (!in_suspend & in_data_vld))
      // trigger for transaction recording
      monstart = 1'b1;

      `uvm_info("YAPP_IF", "collect packets", UVM_HIGH)
      // Collect Header {Length, Addr}
      { length, addr }  = in_data;
      payload = new[length]; // Allocate the payload
      // Collect the Payload
      foreach (payload [i]) begin
         @(posedge clock iff (!in_suspend))
         payload[i] = in_data;
      end

      // Collect Parity and Compute Parity Type
       @(posedge clock iff !in_suspend)
         parity = in_data;
      // reset trigger
      monstart = 1'b0;
  endtask : collect_packet

*/
task send_ack()
ACK_I = 1'b1;
endtask

task start_master()
STB_O = 1'b1;
endtask

task end_master()
STB_O <= 1'b0;
ACK_I <= 1'b0;
endtask

task slave_write(input [7:0] data)
DAT_I = data;
endtask



endinterface : wb_if

