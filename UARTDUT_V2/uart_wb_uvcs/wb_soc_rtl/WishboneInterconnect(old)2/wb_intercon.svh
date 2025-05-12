// IO
wire [31:0] wb_m2s_io_adr;
wire [31:0] wb_m2s_io_dat;
wire  [3:0] wb_m2s_io_sel;
wire        wb_m2s_io_we;
wire        wb_m2s_io_cyc;
wire        wb_m2s_io_stb;
wire  [2:0] wb_m2s_io_cti;
wire  [1:0] wb_m2s_io_bte;
wire [31:0] wb_s2m_io_dat;
wire        wb_s2m_io_ack;
wire        wb_s2m_io_err;
wire        wb_s2m_io_rty;

// SPI FLASH
wire [31:0] wb_m2s_spi_flash_adr;
wire [31:0] wb_m2s_spi_flash_dat;
wire  [3:0] wb_m2s_spi_flash_sel;
wire        wb_m2s_spi_flash_we;
wire        wb_m2s_spi_flash_cyc;
wire        wb_m2s_spi_flash_stb;
wire  [2:0] wb_m2s_spi_flash_cti;
wire  [1:0] wb_m2s_spi_flash_bte;
wire [31:0] wb_s2m_spi_flash_dat;
wire        wb_s2m_spi_flash_ack;
wire        wb_s2m_spi_flash_err;
wire        wb_s2m_spi_flash_rty;

// UART
wire [31:0] wb_m2s_uart_adr;
wire [31:0] wb_m2s_uart_dat;
wire  [3:0] wb_m2s_uart_sel;
wire        wb_m2s_uart_we;
wire        wb_m2s_uart_cyc;
wire        wb_m2s_uart_stb;
wire  [2:0] wb_m2s_uart_cti;
wire  [1:0] wb_m2s_uart_bte;
wire [31:0] wb_s2m_uart_dat;
wire        wb_s2m_uart_ack;
wire        wb_s2m_uart_err;
wire        wb_s2m_uart_rty;

// GPIO
wire [31:0] wb_m2s_gpio_adr;
wire [31:0] wb_m2s_gpio_dat;
wire  [3:0] wb_m2s_gpio_sel;
wire        wb_m2s_gpio_we;
wire        wb_m2s_gpio_cyc;
wire        wb_m2s_gpio_stb;
wire  [2:0] wb_m2s_gpio_cti;
wire  [1:0] wb_m2s_gpio_bte;
wire [31:0] wb_s2m_gpio_dat;
wire        wb_s2m_gpio_ack;
wire        wb_s2m_gpio_err;
wire        wb_s2m_gpio_rty;


// IMEM
wire [31:0] wb_m2s_imem_adr;
wire [31:0] wb_m2s_imem_dat;
wire  [3:0] wb_m2s_imem_sel;
wire        wb_m2s_imem_we;
wire        wb_m2s_imem_cyc;
wire        wb_m2s_imem_stb;
wire  [2:0] wb_m2s_imem_cti;
wire  [1:0] wb_m2s_imem_bte;
wire [31:0] wb_s2m_imem_dat;
wire        wb_s2m_imem_ack;
wire        wb_s2m_imem_err;
wire        wb_s2m_imem_rty;


// DMEM
wire [31:0] wb_m2s_dmem_adr;
wire [31:0] wb_m2s_dmem_dat;
wire  [3:0] wb_m2s_dmem_sel;
wire        wb_m2s_dmem_we;
wire        wb_m2s_dmem_cyc;
wire        wb_m2s_dmem_stb;
wire  [2:0] wb_m2s_dmem_cti;
wire  [1:0] wb_m2s_dmem_bte;
wire [31:0] wb_s2m_dmem_dat;
wire        wb_s2m_dmem_ack;
wire        wb_s2m_dmem_err;
wire        wb_s2m_dmem_rty;


// CLINT
wire [31:0] wb_m2s_clint_adr;
wire [31:0] wb_m2s_clint_dat;
wire  [3:0] wb_m2s_clint_sel;
wire        wb_m2s_clint_we;
wire        wb_m2s_clint_cyc;
wire        wb_m2s_clint_stb;
wire  [2:0] wb_m2s_clint_cti;
wire  [1:0] wb_m2s_clint_bte;
wire [31:0] wb_s2m_clint_dat;
wire        wb_s2m_clint_ack;
wire        wb_s2m_clint_err;
wire        wb_s2m_clint_rty;

// PTC
wire [31:0] wb_m2s_ptc_adr;
wire [31:0] wb_m2s_ptc_dat;
wire  [3:0] wb_m2s_ptc_sel;
wire        wb_m2s_ptc_we;
wire        wb_m2s_ptc_cyc;
wire        wb_m2s_ptc_stb;
wire  [2:0] wb_m2s_ptc_cti;
wire  [1:0] wb_m2s_ptc_bte;
wire [31:0] wb_s2m_ptc_dat;
wire        wb_s2m_ptc_ack;
wire        wb_s2m_ptc_err;
wire        wb_s2m_ptc_rty;
