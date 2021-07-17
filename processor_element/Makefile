include ../fpga-settings.mk

PROJECT:=processorElement-Test-$(BOARD)
VIVADO ?= vivado

maxones: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-MaxOne.tcl &

mmdp: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-IsoPeaks.tcl &

isopeaks: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-IsoPeaks.tcl &

rastrigin: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Rastrigin.tcl &

shubert: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Shubert.tcl &

griewank: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run-Griewank.tcl &

clean:
	rm -rf ${PROJECT}.*[^'bit']
	rm -rf ${PROJECT}.*[^'bin']
	rm -rf *.log
	rm -rf vivado*
