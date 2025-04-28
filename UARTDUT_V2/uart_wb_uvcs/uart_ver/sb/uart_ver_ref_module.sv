class uart_ver_ref ;

  logic [7:0] lsr;
  logic [7:0] ier; 
  logic [7:0] iir;
  logic [7:0] fcr;
  logic [7:0] lcr;
  logic [7:0] mcr;
  logic [7:0] msr;
  logic [7:0] di1;
  logic [7:0] di2;

int tx_fifo_count;
int rx_fifo_count;

function new ();

  lsr= 0;
  ier= 0; 
  iir= 0;
  fcr= 0;
  lcr= 0;
  mcr= 0;
  msr= 0;
  di1= 0;
  di2= 0;

tx_fifo_count = 0;
rx_fifo_count = 0;
  
  endfunction


  function update ( bit [7:0] addr , bit [7:0] data , bit write);
  if(write) begin 
    case (addr)
      8'h1: ier = data; 
      8'h2: fcr = data; 
      8'h3: lcr = data;  
      8'h4: mcr = data; 
      8'h7: di1 = data;
      8'h6: di2 = data; 
      8'h0: begin
        tx_fifo_count ++;
        lsr[5]=0;
      end
      default: ;
    endcase
  end else begin
      case (addr)
      8'h0: begin
        if( rx_fifo_count > 1) begin
        rx_fifo_count --;
        if(rx_fifo_count == 0)begin
        lsr[0]=0;
         end
        end
       end
       8'h5: begin
        msr[3:0] =0;
       end
        default: ;
      endcase
  end
  endfunction

  function bit [7:0] read ( bit [7:0] addr );

       case (addr)
      8'h0: return ( rx_fifo_count > 0) ? 8'hXX : 8'b00;    
      8'h1: return ier; 
      8'h2: return iir; 
      8'h3: return lcr;  
      8'h4: return mcr;
      8'h4: return msr;
      8'h6: return di2; 
      8'h7: return di1;
      default: return 8'b00;
    endcase
  endfunction

endclass 
