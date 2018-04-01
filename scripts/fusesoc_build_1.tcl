set_property board_part digilentinc.com:arty:part0:1.1 [current_project]
set_property target_language VHDL [current_project]
set_property default_lib work [current_project]

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}

variable script_folder
set script_folder [_tcl::get_script_folder]

set_property  ip_repo_paths  $script_folder/../ip_repo [current_project]
update_ip_catalog






