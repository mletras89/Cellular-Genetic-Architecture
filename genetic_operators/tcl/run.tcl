source tcl/common.tcl

set PROJECT geneticOperators-Test-$BOARD
set CONSTRS constraints

# create project
create_project $PROJECT . -force -part $::env(XILINX_PART)
set_property board_part $XILINX_BOARD [current_project]

set_property target_language VHDL [current_project]

# reading vhdl files
read_vhdl ./vhd/genetic_operators.vhd
read_vhdl ./crossover/vhd/crossover.vhd
read_vhdl ./mutation/vhd/mutation.vhd
read_vhdl ./selection/vhd/anisotropic_selection.vhd
read_vhdl ./../register/vhd/basic_register.vhd

puts $::env(PROBLEM)

if {[string compare $::env(PROBLEM) "isopeaks"] == 0} {
  read_vhdl ./evaluators/Iso-Peaks/vhd/evaluator.vhd
  read_vhdl ./vhd/genetic_operators.vhd
}

if {[string compare $::env(PROBLEM) "rastrigin"] == 0} {
  read_vhdl ./evaluators/Rastrigin/vhd/evaluator.vhd
  read_vhdl ./evaluators/Rastrigin/vhd/Rastrigin_pkg.vhd
  read_vhdl ./vhd/genetic_operators_cont.vhd
}

if {[string compare $::env(PROBLEM) "griewank"] == 0} {
  read_vhdl ./evaluators/Griewank/vhd/evaluator.vhd
  read_vhdl ./vhd/genetic_operators_cont.vhd
}

if {[string compare $::env(PROBLEM) "shubert"] == 0} {
  read_vhdl ./evaluators/Shubert/vhd/evaluator.vhd
  read_vhdl ./vhd/genetic_operators_cont.vhd
}

if {[string compare $::env(PROBLEM) "maxones"] == 0} {
  read_vhdl ./evaluators/MMDP/vhd/evaluator.vhd
  read_vhdl ./vhd/genetic_operators_mmdp.vhd
}


if {[string compare $::env(PROBLEM) "mmdp"] == 0} {
  read_vhdl ./evaluators/Max-Ones/vhd/evaluator.vhd
  read_vhdl ./vhd/genetic_operators.vhd
}

#read_vhdl ./vhd/top_crossover.vhd

set_property SOURCE_SET sources_1 [get_filesets sim_1]

# launching synthesis
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1

# including sim sources

if {[string compare $::env(PROBLEM) "isopeaks"] == 0} {
	add_files -fileset sim_1 -norecurse ./vhd/tb_genetic_operators.vhd
	set_property top tb_genetic_operators [get_filesets sim_1]
}

if {[string compare $::env(PROBLEM) "rastrigin"] == 0} {



}

if {[string compare $::env(PROBLEM) "griewank"] == 0} {


}

if {[string compare $::env(PROBLEM) "shubert"] == 0} {


}

if {[string compare $::env(PROBLEM) "maxones"] == 0} {
	add_files -fileset sim_1 -norecurse ./vhd/tb_genetic_operators.vhd
	set_property top tb_genetic_operators [get_filesets sim_1]
}

if {[string compare $::env(PROBLEM) "mmdp"] == 0} {
	add_files -fileset sim_1 -norecurse ./vhd/tb_genetic_operators_mmdp.vhd
	set_property top tb_genetic_operators_mmdp [get_filesets sim_1]
}


set_property top_lib xil_defaultlib [get_filesets sim_1]
launch_simulation
