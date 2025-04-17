# Makefile to generate hex files for instruction and data memory from riscv-dv,
# treating the generated .o file as the ELF.

# Paths and configuration
DV_DIR         :=$(CURDIR)/riscv-dv
SIM_DIR        := $(CURDIR)/soc-rtl/src
#OUT_DIR		   := $(DV_DIR)/out_2025-04-17
TODAY := $(shell date +%Y-%m-%d)
OUT_DIR := $(DV_DIR)/out_$(TODAY)


#**************************************************
# ONLY CHANGE TEST_NAME
TEST_NAME      := riscv_arithmetic_basic_test
#**************************************************

LINKER_SCRIPT  := $(DV_DIR)/scripts/link.ld
CORE_LOG       := $(SIM_DIR)/trace_core_00000000.log
SPIKE_LOG      := $(OUT_DIR)/spike_sim/$(TEST_NAME)_0.log
CORE_CSV       := $(OUT_DIR)/core.csv
SPIKE_CSV      := $(OUT_DIR)/spike.csv

# The generated ELF is actually a .o file.
# Adjust the path below based on your riscv-dv output structure.
RV_ELF         := $(OUT_DIR)/asm_test/$(TEST_NAME)_0.o

# Toolchain (adjust if needed)
OBJCOPY        := riscv32-unknown-elf-objcopy

# Conversion script (assumed to be in the current directory)
CONVERT_HEX    := python3 $(DV_DIR)/scripts/convert_hex.py

# Output file names after conversion
INST_CONV_HEX  := $(OUT_DIR)/inst_conv.hex
DATA_CONV_HEX  := $(OUT_DIR)/data_conv.hex

# Temporary hex files (extracted from ELF)
INST_HEX       := $(OUT_DIR)/inst.hex
DATA_HEX       := $(OUT_DIR)/data.hex
TARGET         := rv32i

# Output file names after conversion
CORE_LOG_2_CSV   := python3 $(DV_DIR)/scripts/core_log_to_trace_csv.py
SPIKE_LOG_2_CSV  := python3 $(DV_DIR)/scripts/spike_log_to_trace_csv.py
COMPARE          :=  python3 $(DV_DIR)/scripts/instr_trace_compare.py

.PHONY: all clean dv_gen extract_hex convert_hex_files

#initial install pip

init: 
	cd $(DV_DIR) && \
	pip3 install -r requirements.txt 



# Main flow: generate test, extract hex files, then convert them.
#all: convert_hex_files
all: dv_gen extract_hex convert_hex_files simv compare
# Step 1: Generate test files using riscv-dv (gen, compile, and sim steps)
dv_gen:
	@echo "Running riscv-dv to generate test files..."
	cd $(DV_DIR) && \
		python3 run.py --test $(TEST_NAME) --simulator vcs --target $(TARGET)
	@echo "Test generation complete. (ELF is at $(RV_ELF))"

# Step 2: Extract hex files from the ELF (.o file)
extract_hex: $(RV_ELF)
	@echo "Extracting instruction hex file from ELF (.o)..."
	$(OBJCOPY) -O verilog -j .text $(RV_ELF) $(INST_HEX)
	@echo "Extracting data hex file from ELF (.o)..."
	$(OBJCOPY) -O verilog -j .data  $(RV_ELF) $(DATA_HEX)

# Step 3: Convert the extracted hex files into 32-bit word format using convert_hex.py
convert_hex_files: $(INST_HEX) $(DATA_HEX)
	@echo "Converting instruction hex file..."
	$(CONVERT_HEX) $(INST_HEX) $(INST_CONV_HEX)
	@echo "Converting data hex file..."
	$(CONVERT_HEX) $(DATA_HEX) $(DATA_CONV_HEX)
	@echo "Conversion complete. Files available in $(OUT_DIR):"
	@echo "  Instruction: $(INST_CONV_HEX)"
	@echo "  Data:        $(DATA_CONV_HEX)"

simv:
	cd $(SIM_DIR) && \
	vcs -full64 -f filelist.f -o simv
$(CORE_LOG): $(INST_CONV_HEX) $(DATA_CONV_HEX) simv
	cp $(INST_CONV_HEX) $(SIM_DIR)/tb/inst_formatted.hex
	cp $(DATA_CONV_HEX) $(SIM_DIR)/tb/data_formatted.hex
	@echo "Running the VCS simulation to generate core.log ..."
	cd $(SIM_DIR) && \
	./simv
	cd $(DV_DIR)

$(CORE_CSV): $(CORE_LOG)
	$(CORE_LOG_2_CSV) --log $(CORE_LOG) --csv $(CORE_CSV)

$(SPIKE_CSV): $(SPIKE_LOG)
	$(SPIKE_LOG_2_CSV) --log $(SPIKE_LOG) --csv $(SPIKE_CSV)

compare:  $(SPIKE_CSV) $(CORE_CSV)
	$(COMPARE) --csv_file_1 $(SPIKE_CSV) --csv_file_2 $(CORE_CSV) --csv_name_1 spike --csv_name_2 core

# Clean the output directory
clean:
	rm -rf $(OUT_DIR) 


help:
	@echo ""
	@echo "=== Available Make Targets ==="
	@echo "make init              - only do it once "
	@echo "make all               - Full flow: generate, extract, convert hex"
	@echo "make dv_gen            - Generate test using riscv-dv"
	@echo "make extract_hex       - Extract .text and .data sections from ELF"
	@echo "make convert_hex_files - Convert hex files to formatted output"
	@echo "make simv              - Compile RTL with VCS"
	@echo "make compare           - Compare spike and core traces"
	@echo "make clean             - Delete the output directory"
	@echo "make help              - Show this help message"
	@echo ""
