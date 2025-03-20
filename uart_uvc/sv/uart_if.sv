interface uart_if #(parameter CLOCK_FREQ = 192000) (input clk);
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import uart_pkg::*;

    logic tx, rx;
    int baud_rate = 9600;
    bit parity_mode;

 task tx_2_rx(input uart_packet packet);
    int baud_counter = 0;
    int baud_limit = 0;
    logic parity_bit;
    logic [10:0] shift_reg;  // Start bit, 8 data bits, parity bit, Stop bit

    baud_limit = (CLOCK_FREQ / baud_rate) - 1;
    parity_mode = packet.parity_mode;

    // Calculate Parity
    parity_bit = calc_parity(packet.data, packet.parity_mode);

    // Shift register format: Start bit (0), 8 data bits, parity, stop bit (1)
    shift_reg = {1'b0, packet.data, parity_bit, 1'b1};

    // Debug statement
    $display("TX: shift_reg = %b, parity_bit = %b, stop_bit = %b", shift_reg, parity_bit, shift_reg[10]);

    // Start Transmission
    for (int i = 0; i < 11; i++) begin
        baud_counter = 0;
        @(negedge clk);  // Sync with the clock edge
        tx <= shift_reg[i];  // Send bit

        // Wait for full bit time (baud rate)
        while (baud_counter < baud_limit) begin
            @(negedge clk);  // Wait for next clock edge
            baud_counter++;

            if (baud_counter == baud_limit / 2) begin
                @(negedge clk);  // Wait for stability
                rx <= tx;  // Update rx at the middle of the bit time
            end
        end
    end
endtask
    task rx_2_data(output bit [7:0] data);
        logic calculated_parity;
        logic received_parity;
        logic stop_bit;
        logic [10:0] shift_reg = 11'b0;  // 11 bits: start, 8 data, parity, stop

        // Wait for the start bit to be detected (rx == 0)
        int timeout = 0;
        @(negedge clk);
        while (rx != 0 && timeout < 1000) begin
            @(negedge clk);
            timeout++;
        end
        if (timeout >= 1000) begin
            `uvm_error("RX", "Start bit not detected within timeout period")
            return;
        end

        // Sample the serial data (11 bits: start, 8 data, parity, stop)
        for (int i = 0; i < 11; i++) begin
            // Wait for the middle of the bit period
            repeat ((CLOCK_FREQ / baud_rate) / 2) @(negedge clk);
            shift_reg[i] = rx;  // Sample the bit

            // Wait for the second half of the bit period
            repeat ((CLOCK_FREQ / baud_rate) / 2) @(negedge clk);
        end

        // Debug statement
        $display("RX: shift_reg = %b, parity_bit = %b, stop_bit = %b", shift_reg, shift_reg[9], shift_reg[10]);

        // Extract data from shift register
        data = shift_reg[8:1];  // Extract the 8 data bits
        received_parity = shift_reg[9];  // Parity bit
        stop_bit = shift_reg[10];  // Stop bit

        // Verify the stop bit
        if (stop_bit != 1'b1) begin
            $display("Error: Stop bit is not 1!");
        end

        // Calculate the expected parity
        calculated_parity = calc_parity(data, parity_mode);

        // Verify the parity
        if (calculated_parity != received_parity) begin
            $display("Error: Parity mismatch! Expected: %b, Received: %b", calculated_parity, received_parity);
            `uvm_info("zMISMATCH", "Error: Parity mismatch!", UVM_HIGH)
        end else begin
            $display("Parity check passed!");
        end

        // Output the received packet data
        $display("Received Packet: Data = %h, Parity = %b, Stop Bit = %b", data, received_parity, stop_bit);
    endtask

    // Function to Calculate Parity
    function logic calc_parity(input logic [7:0] data, input bit parity_type);
        case (parity_type)
            1'b0: calc_parity = ^data;     // Even parity
            1'b1: calc_parity = ~(^data);  // Odd parity
            default: calc_parity = 1'b0;   // Default case
        endcase
    endfunction
endinterface