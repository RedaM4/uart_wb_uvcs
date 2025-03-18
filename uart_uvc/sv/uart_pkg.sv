// uart_pkg.sv
package uart_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Include all necessary UART UVC files
  `include "uart_if.sv"
  `include "uart_packet.sv"
  `include "uart_env.sv"
  `include "uart_rx_agent.sv"
  `include "uart_rx_driver.sv"
  `include "uart_rx_monitor.sv"
  `include "uart_rx_seqs.sv"
  `include "uart_rx_sequencer.sv"
  `include "uart_tx_agent.sv"
  `include "uart_tx_driver.sv"
  `include "uart_tx_monitor.sv"
  `include "uart_tx_seqs.sv"
  `include "uart_tx_sequencer.sv"

endpackage : uart_pkg
