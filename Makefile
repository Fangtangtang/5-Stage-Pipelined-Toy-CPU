# current path
prefix = $(shell pwd)

# Folder Path
src = $(prefix)/src
testspace = $(prefix)/testspace
sim_testcase = $(prefix)/testcase
fpga_testcase = $(prefix)/testcase/fpga
sim = $(prefix)/sim
sys = $(prefix)/sys

# toolchain path
riscv_toolchain = /opt/riscv
# bin path
riscv_bin = $(riscv_toolchain)/bin


_no_testcase_name_check:
	@$(if $(strip $(name)),, echo 'Missing Testcase Name')
	@$(if $(strip $(name)),, exit 1)

# All build result are put at testspace/test
# compile verilog project with iverilog
# complie $(sim)/my_tb.v and related files under common
# if compile all the files, include not needed
build_sim:
	@ iverilog -o $(testspace)/test $(sim)/testbench.v 


build_sim_test: _no_testcase_name_check
	@$(riscv_bin)/riscv32-unknown-elf-as -o $(sys)/rom.o -march=rv32i $(sys)/rom.s
	@cp $(sim_testcase)/*$(name)*.c $(testspace)/test.c
	@$(riscv_bin)/riscv32-unknown-elf-gcc -o $(testspace)/test.o -I $(sys) -c $(testspace)/test.c -march=rv32i  -mabi=ilp32 -Wall
	@$(riscv_bin)/riscv32-unknown-elf-ld -T $(sys)/memory.ld $(sys)/rom.o $(testspace)/test.o -L $(riscv_toolchain)/riscv32-unknown-elf/lib/ -L $(riscv_toolchain)/lib/gcc/riscv32-unknown-elf/10.1.0/ -lc -lgcc -lm -lnosys -o $(testspace)/test.om
	@$(riscv_bin)/riscv32-unknown-elf-objcopy -O verilog $(testspace)/test.om $(testspace)/test.data
	@$(riscv_bin)/riscv32-unknown-elf-objdump -D $(testspace)/test.om > $(testspace)/test.dump

# run
run_sim:
	@cd $(testspace) && ./test

# clear
clear:
	@rm $(sys)/rom.o $(testspace)/test*

test_sim: build_sim build_sim_test run_sim


# .PHONY 在 Makefile 中用于声明伪目标
# 告诉 Make 工具该目标不对应一个实际的文件，而是需要执行相应的命令块
# make safely
.PHONY: _no_testcase_name_check build_sim build_sim_test run_sim clear test_sim
