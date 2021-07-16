include ../fpga-settings.mk

PROJECT:=geneticOperators-Test-$(BOARD)
VIVADO ?= vivado


#It is required to define the enviroment variable PROBLEM_EVALUATOR

gui: ## Generates the Vivado Project 
	$(VIVADO) -mode gui -source tcl/run.tcl &
clean:
	rm -rf ${PROJECT}.*[^'bit']
	rm -rf ${PROJECT}.*[^'bin']
	rm -rf *.log
	rm -rf vivado*
