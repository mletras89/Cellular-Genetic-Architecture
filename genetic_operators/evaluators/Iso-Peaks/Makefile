include ../../../fpga-settings.mk

PROJECT:=isoPeaksTest-$(BOARD)
VIVADO ?= vivado


gui: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run.tcl &
	
clean:
	rm -rf ${PROJECT}.*[^'bit']
	rm -rf ${PROJECT}.*[^'bin']
	rm -rf *.log
	rm -rf vivado*
