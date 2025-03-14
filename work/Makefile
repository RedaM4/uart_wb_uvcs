# Compiler options
VCS = vcs -full64 -ntb_opts uvm -sverilog -debug_all -kdb -cm line+cond+fsm+branch -timescale=1ns/1ns
SIMV = simv

# Default test and verbosity (can be overridden)
TEST ?= base_test
VER ?= UVM_HIGH  

# Filelists for Compilation
SLAVE_FILELIST  = ../uart_slave/tb/uart_slave_filelist.f
MASTER_FILELIST = ../uart_master/tb/uart_master_filelist.f
SYSTEM_FILELIST = ../uart_system/tb/uart_integ_filelist.f

# Simulation Binaries
SLAVE_SIM  = simv_slave
MASTER_SIM = simv_master
SYSTEM_SIM = simv_system

# Ensure logs directory exists
logs:
	@mkdir -p ../logs

# Compilation Targets
compile_slave cs:
	@echo "🔧 Compiling UART Slave UVC..."
	$(VCS) -f $(SLAVE_FILELIST) -o $(SLAVE_SIM)

compile_master cm:
	@echo "🔧 Compiling UART Master UVC..."
	$(VCS) -f $(MASTER_FILELIST) -o $(MASTER_SIM)

compile_system css:
	@echo "🔧 Compiling UART System UVC with DUT..."
	$(VCS) -f $(SYSTEM_FILELIST) -o $(SYSTEM_SIM)

# Run Individual Tests
run_slave rs: logs
	@echo "🚀 Running UART Slave Test: $(TEST)"
	./$(SLAVE_SIM) +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VER) +ntb_random_seed_automatic -l ../logs/run_slave_$(TEST).log

run_master rm: logs
	@echo "🚀 Running UART Master Test: $(TEST)"
	./$(MASTER_SIM) +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VER) +ntb_random_seed_automatic -l ../logs/run_master_$(TEST).log

run_system rss: logs
	@echo "🚀 Running UART System Test: $(TEST)"
	./$(SYSTEM_SIM) +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(VER) +ntb_random_seed_automatic -l ../logs/run_system_$(TEST).log

# Run Regression Tests
regress_slave res:
	@echo "🚀 Running Regression for UART Slave"
	./$(SLAVE_SIM) -f ../uart_slave/tb/run_tests.f -l ../logs/regression_slave.log

regress_master rem:
	@echo "🚀 Running Regression for UART Master"
	./$(MASTER_SIM) -f ../uart_master/tb/run_tests.f -l ../logs/regression_master.log

regress_system ress:
	@echo "🚀 Running Regression for UART System"
	./$(SYSTEM_SIM) -f ../uart_system/tb/run_tests.f -l ../logs/regression_system.log

# Run All Regression Tests
regress_all ra:
	@echo "🚀 Running Full Regression for All UVCs"
	make res && make rem && make ress

# Collect Coverage
coverage:
	@echo "📊 Generating Coverage Report..."
	urg -dir simv.vdb -report ../logs/coverage_report

# Clean Simulation Binaries
clean:
	@echo "🧹 Cleaning up compiled files..."
	rm -rf $(SLAVE_SIM) $(MASTER_SIM) $(SYSTEM_SIM) csrc DVEfiles ucli.key *.vpd *.daidir

# Clean Logs
clean_logs:
	@echo "🧹 Cleaning all logs..."
	rm -rf ../logs/*.log

# Help Command
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  compile_slave (cs)  Compile only the UART Slave UVC"
	@echo "  compile_master (cm) Compile only the UART Master UVC"
	@echo "  compile_system (css) Compile the entire UART system (includes DUT)"
	@echo "  run_slave (rs)      Run a single UART Slave test"
	@echo "  run_master (rm)     Run a single UART Master test"
	@echo "  run_system (rss)    Run a single UART System test"
	@echo "  regress_slave (res) Run Regression Tests for UART Slave"
	@echo "  regress_master (rem) Run Regression Tests for UART Master"
	@echo "  regress_system (ress) Run Regression Tests for UART System"
	@echo "  regress_all (ra)    Run All Regression Tests (Slave, Master, System)"
	@echo "  coverage            Generate Coverage Report"
	@echo "  clean               Remove compiled files"
	@echo "  clean_logs          Remove all logs"
	@echo "  help                Show this help message"
