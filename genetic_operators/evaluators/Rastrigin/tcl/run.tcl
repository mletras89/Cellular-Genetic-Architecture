source tcl/common.tcl

set PROJECT rastriginTest-$BOARD
set CONSTRS constraints

# create project
create_project $PROJECT . -force -part $::env(XILINX_PART)
set_property board_part $XILINX_BOARD [current_project]

set_property target_language VHDL [current_project]

# reading vhdl files
read_vhdl ./vhd/evaluator.vhd
read_vhdl ./vhd/Rastrigin_pkg.vhd

set_property SOURCE_SET sources_1 [get_filesets sim_1]

# launching synthesis
update_compile_order -fileset sources_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1

# including sim sources
add_files -fileset sim_1 -norecurse ./vhd/tb_rastrigin.vhd

set_property top tb_rastrigin [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
launch_simulation
