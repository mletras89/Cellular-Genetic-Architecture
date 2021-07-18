source tcl/common.tcl

set PROJECT processorElement-Test-$BOARD
set CONSTRS constraints

# create project
create_project $PROJECT . -force -part $::env(XILINX_PART)
set_property board_part $XILINX_BOARD [current_project]

set_property target_language VHDL [current_project]

# reading vhdl files
read_vhdl ./processor_element/vhd/datatypes_mmdp.vhd
read_vhdl ./processor_element/vhd/processor_element_mmdp.vhd
read_vhdl ./processor_element/vhd/register_bank_fitness_mmdp.vhd
read_vhdl ./processor_element/vhd/register_bank_temporal_fitness_mmdp.vhd
read_vhdl ./processor_element/vhd/register_bank_temporal_mmdp.vhd
read_vhdl ./processor_element/vhd/register_bank_mmdp.vhd

# reading genetic operators
read_vhdl ./genetic_operators/crossover/vhd/crossover.vhd
read_vhdl ./genetic_operators/mutation/vhd/mutation.vhd
read_vhdl ./genetic_operators/selection/vhd/anisotropic_selection.vhd
read_vhdl ./register/vhd/basic_register.vhd

read_vhdl ./genetic_operators/evaluators/MMDP/vhd/evaluator.vhd
read_vhdl ./genetic_operators/vhd/genetic_operators.vhd
# reading rng
read_vhdl ./rng/vhd/rng_xoshiro128plusplus_64bits.vhdl
read_vhdl ./rng/vhd/rng_xoshiro128plusplus.vhdl
#reading top
read_vhdl ./vhd/top_module_mmdp8x8.vhd

set_property SOURCE_SET sources_1 [get_filesets sim_1]

# launching synthesis
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1

# including sim sources
add_files -fileset sim_1 -norecurse ./vhd/tb_top_module_mmdp8x8.vhd
set_property top tb_top_module_mmdp8x8 [get_filesets sim_1]

set_property top_lib xil_defaultlib [get_filesets sim_1]
launch_simulation
