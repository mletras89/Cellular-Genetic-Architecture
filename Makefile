include ./fpga-settings.mk

PROJECT:=processorElement-Test-$(BOARD)
VIVADO ?= vivado

maxones2x2: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-MaxOne.tcl &

maxones4x4: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-MaxOne4x4.tcl &

maxones8x8: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-MaxOne8x8.tcl &

mmdp2x2: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-MMDP.tcl &

mmdp4x4: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-MMDP4x4.tcl &

mmdp8x8: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-MMDP8x8.tcl &

isopeaks2x2: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-IsoPeaks.tcl &

isopeaks4x4: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-IsoPeaks4x4.tcl &

isopeaks8x8: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-IsoPeaks8x8.tcl &

rastrigin2x2: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Rastrigin.tcl &

rastrigin4x4: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Rastrigin4x4.tcl &

rastrigin8x8: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Rastrigin8x8.tcl &

shubert2x2: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Shubert.tcl &

shubert4x4: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Shubert4x4.tcl &

shubert8x8: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Shubert8x8.tcl &

griewank2x2: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Griewank.tcl &

griewank4x4: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Griewank4x4.tcl &

griewank8x8: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Griewank8x8.tcl &

clean:
	rm -rf ${PROJECT}.*[^'bit']
	rm -rf ${PROJECT}.*[^'bin']
	rm -rf *.log
	rm -rf vivado*
