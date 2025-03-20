interface uart_if #(parameter CLOCK_FREQ = 192000) (input clk);
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import uart_pkg::*;

    logic tx, rx;
    int baud_rate = 9600;
   // bit parity_mode;

 task tx_2_rx(input uart_packet packet);
    int baud_counter = 0;
    int baud_limit = 0;
    logic parity_bit = 0;
    logic [10:0] shift_reg;  // Start bit, 8 data bits, parity bit, Stop bit
    baud_limit = (CLOCK_FREQ / baud_rate) - 1;

    shift_reg = {1'b1, packet.data[0], packet.data[1], packet.data[2], packet.data[3], packet.data[4], packet.data[5], packet.data[6], packet.data[7],parity_bit , 1'b0}; 
for (int i = 0; i < 11; i++) begin
        baud_counter = 0;
        @(negedge clk);  // Sync with the clock edge
        tx <= shift_reg[i];  // Send bit

        // Wait for full bit time (baud rate)
        while (baud_counter < baud_limit) begin
            @(negedge clk);  // Wait for next clock edge
            baud_counter++;
        end
        if (baud_counter == baud_limit) begin
            rx <= tx;
        end

    end
    $display("sent shift_reg: %b", shift_reg);  // Show the 8 bits of data
  

endtask


  task rx_2_data(output bit [7:0] data);
    logic [10:0] shift_reg = 11'h0;  // 11 bits: start, 8 data, parity, stop
    logic [2:0] sample_bits;
     int baud_limit = 0;
    int baud_counter = 0;
    baud_limit = (CLOCK_FREQ / baud_rate) - 1;



    wait(rx == 1);  // Wait for start bit (0)
        // Majority voting logic for each bit


    for (int i = 0; i < 11; i++) begin
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);  
        sample_bits[0] = rx;
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);
        sample_bits[1] = rx;
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);
        sample_bits[2] = rx;
        // Majority voting logic for each bit
     
        shift_reg[i] = (sample_bits[0] & sample_bits[1]) | (sample_bits[1] & sample_bits[2]) | (sample_bits[0] & sample_bits[2]);
    end

    // Reversed order (LSB first)
    
    data = shift_reg[8:1];  // Extract the 8 data bits, LSB first


       // Display the entire received packet (including start, data, and stop bits)
    $display("\n\nReceived Packet (Start bit + Data bits + Parity bit + Stop bit):");
    $display("Start Bit: %b", shift_reg[0]);  // Start bit (should be 0)
    $display("Data Bits: %b", shift_reg[8:1]);  // Data bits (8 bits)
    $display("Parity Bit: %b", shift_reg[9]);  // Parity bit (you can add parity check logic here)
    $display("Stop Bit: %b", shift_reg[10]);  // Stop bit (should be 1)

    // Display the extracted data
    $display("Extracted shift_reg: %b", shift_reg);  // Show the 8 bits of data
endtask


    // Function to Calculate Parity
    function logic calc_parity(input logic [7:0] data, input bit parity_type);
        case (parity_type)
            1'b0: calc_parity = ^data;     // Even parity
            1'b1: calc_parity = ~(^data);  // Odd parity
            default: calc_parity = 1'b0;   // Default case
        endcase
    endfunction
    
   //--------------------------------------------------------------\\
   
    task rx_2_tx(input uart_packet packet);
    int baud_counter = 0;
    int baud_limit = 0;
    logic parity_bit = 0;
    logic [10:0] shift_reg;  // Start bit, 8 data bits, parity bit, Stop bit
    baud_limit = (CLOCK_FREQ / baud_rate) - 1;

    shift_reg = {1'b1, packet.data[0], packet.data[1], packet.data[2], packet.data[3], packet.data[4], packet.data[5], packet.data[6], packet.data[7],parity_bit , 1'b0}; 
for (int i = 0; i < 11; i++) begin
        baud_counter = 0;
        @(negedge clk);  // Sync with the clock edge
        rx <= shift_reg[i];  // Send bit

        // Wait for full bit time (baud rate)
        while (baud_counter < baud_limit) begin
            @(negedge clk);  // Wait for next clock edge
            baud_counter++;
        end
        if (baud_counter == baud_limit) begin
            tx <= rx;
        end

    end
    $display("sent shift_reg: %b", shift_reg);  // Show the 8 bits of data
  

endtask


  task tx_2_data(output bit [7:0] data);
    logic [10:0] shift_reg = 11'h0;  // 11 bits: start, 8 data, parity, stop
    logic [2:0] sample_bits;
     int baud_limit = 0;
    int baud_counter = 0;
    baud_limit = (CLOCK_FREQ / baud_rate) - 1;



    wait(tx == 1);  // Wait for start bit (0)
        // Majority voting logic for each bit


    for (int i = 0; i < 11; i++) begin
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);  
        sample_bits[0] = tx;
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);
        sample_bits[1] = tx;
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);
        sample_bits[2] = tx;
        // Majority voting logic for each bit
     
        shift_reg[i] = (sample_bits[0] & sample_bits[1]) | (sample_bits[1] & sample_bits[2]) | (sample_bits[0] & sample_bits[2]);
    end

    // Reversed order (LSB first)
    
    data = shift_reg[8:1];  // Extract the 8 data bits, LSB first


       // Display the entire received packet (including start, data, and stop bits)
    $display("\n\nTXReceived Packet (Start bit + Data bits + Parity bit + Stop bit):");
    $display("Start Bit: %b", shift_reg[0]);  // Start bit (should be 0)
    $display("Data Bits: %b", shift_reg[8:1]);  // Data bits (8 bits)
    $display("Parity Bit: %b", shift_reg[9]);  // Parity bit (you can add parity check logic here)
    $display("Stop Bit: %b", shift_reg[10]);  // Stop bit (should be 1)

    // Display the extracted data
    $display("Extracted shift_reg: %b", shift_reg);  // Show the 8 bits of data
endtask



endinterface