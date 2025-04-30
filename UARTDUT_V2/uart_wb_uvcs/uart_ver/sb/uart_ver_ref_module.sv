typedef enum bit {ODD_PARITY, EVEN_PARITY} parity_mode_t;
typedef enum bit {WRITE, READ} STATE;

class uart_ver_ref;

  logic [7:0] lsr;      // Line Status Register
  logic [7:0] ier;      // Interrupt Enable Register
  logic [7:0] iir;      // Interrupt Identification Register
  logic [7:0] fcr;      // FIFO Control Register
  logic [7:0] lcr;      // Line Control Register
  logic [7:0] mcr;      // Modem Control Register
  logic [7:0] msr;      // Modem Status Register

  rand parity_mode_t parity_mode; // 1 = Even, 0 = Odd
  STATE mode;

  logic [7:0] rx_queue[$];
  logic [7:0] tx_queue[$];

  logic [7:0] div_latch_lsb;  // Divisor Latch Byte 1 (LSB) when DLAB = 1
  logic [7:0] div_latch_msb;  // Divisor Latch Byte 2 (MSB) when DLAB = 1

  function new ();
    lsr = 8'b00000000; // Initial values for registers
    ier = 8'b00000000;
    iir = 8'b00000000;
    fcr = 8'b00000000;
    lcr = 8'b00000000;
    mcr = 8'b00000000;
    msr = 8'b00000000;
    div_latch_lsb = 8'b00000000;
    div_latch_msb = 8'b00000000;
    parity_mode = EVEN_PARITY;
  endfunction

function logic parity_calc(input logic [7:0] data, input bit mode);
    if (mode == 1)
        parity_calc = ~^data;
    else
        parity_calc = ^data;
endfunction


function update (bit [7:0] addr, bit [7:0] data, bit write);
    mode = (write == 1) ? WRITE : READ;
    display_regs();
    if (write) begin
        case (addr)
            8'h0: begin 
              if(lcr[6]) begin
                div_latch_lsb = data;
              end else begin
                tx_queue.push_back(data);     
                lsr[5] = 0;     
                lsr[6] = 0; 
              end   
            end
            8'h1: begin 
              if(lcr[6]) begin
                div_latch_msb = data;
              end else begin
                ier = data;     
              end   
            end       
            8'h2: fcr = data;        
            8'h3: lcr = data;        
            8'h4: mcr = data;       

            default: ;
        endcase
        display_regs();
    end else begin
        case (addr)
            8'h0: begin 
              if(lcr[6]) begin
                div_latch_lsb = data;
              end else begin
                rx_queue.push_back(data);     
                lsr[0] = 0;      
              end   
            end
            8'h1: begin
              if(lcr[6]) begin
                div_latch_msb = data;
              end 
            end
            8'h2: iir = data;
            8'h5: begin
                  if(rx_queue.size() > 0) lsr[0] = 1;
                  else lsr[0] = 0;
                  if(parity_calc(data, parity_mode)) lsr[2] = 0;
                  else lsr[2] = 1;
                  if(tx_queue.size() > 0) begin lsr[5] = 0; lsr[6] = 0; end
                  else begin lsr[5] = 1; lsr[6] = 1; end
                  if(lsr[2]) lsr[7] = 1;
                  else lsr[7] = 0;
            end
            8'h6: msr = data;
            default: ;
        endcase
          display_regs();
    end
endfunction


  function bit [7:0] read(bit [7:0] addr);
  logic [7:0] temp;
    if (lcr[6] == 1) begin  // If DLAB is set
      case (addr)
        8'h0: return div_latch_lsb; // Divisor Latch Byte 1 (LSB)
        8'h1: return div_latch_msb; // Divisor Latch Byte 2 (MSB)
        default: return 8'bx;
        
      endcase
      display_regs();
    end else begin
      case (addr)
        8'h0: if(mode == WRITE) begin 
                   temp = tx_queue.pop_front();
                  $display("1");
                    display_queues();

                  if(tx_queue.size() == 0) begin 
                      lsr[5] = 1; lsr[6] = 1; 
                  end 
                  $display("2");
                    display_queues();

                  return temp;
        end else begin 
            $display("3");
            display_queues();
               temp = rx_queue.pop_front();
              if(rx_queue.size() == 0) begin 
                lsr[0] = 1; 
              end 
              $display("4");
                display_queues();
              $display("temp = %h", temp);

              return temp;
        end
        8'h1: return ier;           
        8'h2: if(mode == WRITE) return fcr;
              else return iir;
        8'h3: return lcr;           // Line Control Register
        8'h4: return mcr;           // Modem Control Register
        8'h5: return temp;           // Line Status Register
        8'h6: return msr;           // Modem Status Register
        default: return 8'bx;
      endcase
      display_regs();
    end
  endfunction


  function void display_regs();
  $display("==== UART Registers ====");
  $display("IER  = 0x%0h", ier);
  $display("IIR  = 0x%0h", iir);
  $display("FCR  = 0x%0h", fcr);
  $display("LCR  = 0x%0h", lcr);
  $display("MCR  = 0x%0h", mcr);
  $display("LSR  = %0b", lsr);
  $display("MSR  = 0x%0h", msr);
  $display("DIV_LATCH_LSB = 0x%0h", div_latch_lsb);
  $display("DIV_LATCH_MSB = 0x%0h", div_latch_msb);
  $display("========================");
  display_queues();
endfunction

function void display_queues();
  $display("==== UART Queues ====");
  $display("TX Queue: size = %0d", tx_queue.size());
  foreach (tx_queue[i]) begin
    $display("  TX[%0d] = 0x%0h", i, tx_queue[i]);
  end

  $display("RX Queue: size = %0d", rx_queue.size());
  foreach (rx_queue[i]) begin
    $display("  RX[%0d] = 0x%0h", i, rx_queue[i]);
  end
  $display("======================");
endfunction


endclass