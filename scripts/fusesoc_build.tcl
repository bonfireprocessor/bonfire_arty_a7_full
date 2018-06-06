set_property board_part digilentinc.com:arty:part0:1.1 [current_project]
set_property target_language VHDL [current_project]


namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}

variable script_folder
set script_folder [_tcl::get_script_folder]
puts $script_folder

# Add local ip repos
set_property  ip_repo_paths [ concat  $script_folder/../ip_repo $script_folder/../bonfire-gpio-ip ] [current_project ]
update_ip_catalog


# Import Block Design
set vivado_version [version -short]

source $script_folder/bd_bonfire_arty_$vivado_version.tcl


save_bd_design
regenerate_bd_layout
set_property -dict [list CONFIG.RamFileName $script_folder/../compiled_code/ARTY_AXI_monitor.hex] [get_bd_cells BootMem_0]


#Build HDL Wrapper
make_wrapper -files [get_files [get_property FILE_NAME [current_bd_design ]]] -top
#export_simulation -of_objects [get_files [current_project].srcs/sources_1/bd/design_1/design_1.bd] -directory /home/thomas/development/fusesoc/build/bonfire-arty_0/bld-vivado/bonfire-arty_0.ip_user_files/sim_scripts -ip_user_files_dir /home/thomas/development/fusesoc/build/bonfire-arty_0/bld-vivado/bonfire-arty_0.ip_user_files -ipstatic_source_dir /home/thomas/development/fusesoc/build/bonfire-arty_0/bld-vivado/bonfire-arty_0.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/thomas/development/fusesoc/build/bonfire-arty_0/bld-vivado/bonfire-arty_0.cache/compile_simlib/modelsim} {questa=/home/thomas/development/fusesoc/build/bonfire-arty_0/bld-vivado/bonfire-arty_0.cache/compile_simlib/questa} {ies=/home/thomas/development/fusesoc/build/bonfire-arty_0/bld-vivado/bonfire-arty_0.cache/compile_simlib/ies} {vcs=/home/thomas/development/fusesoc/build/bonfire-arty_0/bld-vivado/bonfire-arty_0.cache/compile_simlib/vcs} {riviera=/home/thomas/development/fusesoc/build/bonfire-arty_0/bld-vivado/bonfire-arty_0.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
add_files -norecurse [current_proj].srcs/sources_1/bd/design_1/hdl/design_1_wrapper.vhd
set_property top design_1_wrapper [current_fileset]
update_compile_order -fileset sources_1

