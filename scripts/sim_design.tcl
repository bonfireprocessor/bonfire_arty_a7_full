
################################################################
# This is a generated script based on design: sim_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source sim_design_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# BootMem, bonfire_axi4l2wb, bonfire_axi_top, monitor, zpuino_uart

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a35ticsg324-1L
   set_property BOARD_PART digilentinc.com:arty:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name sim_design

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set RX [ create_bd_port -dir I -type data RX ]
  set Result [ create_bd_port -dir O -from 31 -to 0 Result ]
  set TX [ create_bd_port -dir O -type data TX ]
  set finished [ create_bd_port -dir O finished ]

  # Create instance: BootMem_0, and set properties
  set block_name BootMem
  set block_cell_name BootMem_0
  if { [catch {set BootMem_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $BootMem_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.ADDR_WIDTH {13} \
CONFIG.RamFileName {/home/thomas/Vivado/bonfire_axi_soc/test_sw/zpuino_uart.hex} \
CONFIG.SIZE {8192} \
CONFIG.mode {H} \
 ] $BootMem_0

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0 ]
  set_property -dict [ list \
CONFIG.DATA_WIDTH {128} \
CONFIG.ECC_TYPE {0} \
 ] $axi_bram_ctrl_0

  # Create instance: axi_bram_ctrl_0_bram, and set properties
  set axi_bram_ctrl_0_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 axi_bram_ctrl_0_bram ]
  set_property -dict [ list \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
 ] $axi_bram_ctrl_0_bram

  # Create instance: bonfire_axi4l2wb_0, and set properties
  set block_name bonfire_axi4l2wb
  set block_cell_name bonfire_axi4l2wb_0
  if { [catch {set bonfire_axi4l2wb_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bonfire_axi4l2wb_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.ADRWIDTH {32} \
 ] $bonfire_axi4l2wb_0

  # Create instance: bonfire_axi_top_0, and set properties
  set block_name bonfire_axi_top
  set block_cell_name bonfire_axi_top_0
  if { [catch {set bonfire_axi_top_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $bonfire_axi_top_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.CACHE_SIZE_WORDS {1024} \
CONFIG.DCACHE_LINE_SIZE {4} \
CONFIG.DCACHE_MASTER_WIDTH {128} \
CONFIG.DCACHE_SIZE {2048} \
 ] $bonfire_axi_top_0

  # Create instance: monitor_0, and set properties
  set block_name monitor
  set block_cell_name monitor_0
  if { [catch {set monitor_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $monitor_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.VERBOSE {true} \
 ] $monitor_0

  # Create instance: rst_sim_clk_gen_0_83M, and set properties
  set rst_sim_clk_gen_0_83M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_sim_clk_gen_0_83M ]

  # Create instance: sim_clk_gen_0, and set properties
  set sim_clk_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:sim_clk_gen:1.0 sim_clk_gen_0 ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {83333333} \
CONFIG.INITIAL_RESET_CLOCK_CYCLES {10} \
CONFIG.RESET_POLARITY {ACTIVE_LOW} \
 ] $sim_clk_gen_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
CONFIG.HAS_ARESETN {1} \
 ] $smartconnect_0

  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property -dict [ list \
CONFIG.NUM_CLKS {1} \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {1} \
 ] $smartconnect_1

  # Create instance: zpuino_uart_0, and set properties
  set block_name zpuino_uart
  set block_cell_name zpuino_uart_0
  if { [catch {set zpuino_uart_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $zpuino_uart_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.bits {6} \
CONFIG.extended {true} \
 ] $zpuino_uart_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net bonfire_axi4l2wb_0_WB_MASTER [get_bd_intf_pins bonfire_axi4l2wb_0/WB_MASTER] [get_bd_intf_pins zpuino_uart_0/WB_SLAVE]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_BRAM_A [get_bd_intf_pins BootMem_0/BRAM_A] [get_bd_intf_pins bonfire_axi_top_0/BRAM_A]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_BRAM_B [get_bd_intf_pins BootMem_0/BRAM_B] [get_bd_intf_pins bonfire_axi_top_0/BRAM_B]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_M_AXI_DC [get_bd_intf_pins bonfire_axi_top_0/M_AXI_DC] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_M_AXI_DP [get_bd_intf_pins bonfire_axi_top_0/M_AXI_DP] [get_bd_intf_pins smartconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_M_AXI_IC [get_bd_intf_pins bonfire_axi_top_0/M_AXI_IC] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins bonfire_axi4l2wb_0/S_AXI] [get_bd_intf_pins smartconnect_1/M00_AXI]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins BootMem_0/A_CLK] [get_bd_pins BootMem_0/B_CLK] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins bonfire_axi4l2wb_0/S_AXI_ACLK] [get_bd_pins bonfire_axi_top_0/clk_i] [get_bd_pins monitor_0/clk_i] [get_bd_pins rst_sim_clk_gen_0_83M/slowest_sync_clk] [get_bd_pins sim_clk_gen_0/clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins smartconnect_1/aclk]
  connect_bd_net -net RX_1 [get_bd_ports RX] [get_bd_pins zpuino_uart_0/rx]
  connect_bd_net -net bonfire_axi4l2wb_0_wb_clk_o [get_bd_pins bonfire_axi4l2wb_0/wb_clk_o] [get_bd_pins zpuino_uart_0/wb_clk_i]
  connect_bd_net -net bonfire_axi4l2wb_0_wb_rst_o [get_bd_pins bonfire_axi4l2wb_0/wb_rst_o] [get_bd_pins zpuino_uart_0/wb_rst_i]
  connect_bd_net -net bonfire_axi_top_0_wb_dbus_adr_o [get_bd_pins bonfire_axi_top_0/wb_dbus_adr_o] [get_bd_pins monitor_0/wbs_adr_i]
  connect_bd_net -net bonfire_axi_top_0_wb_dbus_cyc_o [get_bd_pins bonfire_axi_top_0/wb_dbus_cyc_o] [get_bd_pins monitor_0/wbs_cyc_i]
  connect_bd_net -net bonfire_axi_top_0_wb_dbus_dat_o [get_bd_pins bonfire_axi_top_0/wb_dbus_dat_o] [get_bd_pins monitor_0/wbs_dat_i]
  connect_bd_net -net bonfire_axi_top_0_wb_dbus_sel_o [get_bd_pins bonfire_axi_top_0/wb_dbus_sel_o] [get_bd_pins monitor_0/wbs_sel_i]
  connect_bd_net -net bonfire_axi_top_0_wb_dbus_stb_o [get_bd_pins bonfire_axi_top_0/wb_dbus_stb_o] [get_bd_pins monitor_0/wbs_stb_i]
  connect_bd_net -net bonfire_axi_top_0_wb_dbus_we_o [get_bd_pins bonfire_axi_top_0/wb_dbus_we_o] [get_bd_pins monitor_0/wbs_we_i]
  connect_bd_net -net monitor_0_finished_o [get_bd_ports finished] [get_bd_pins monitor_0/finished_o]
  connect_bd_net -net monitor_0_result_o [get_bd_ports Result] [get_bd_pins monitor_0/result_o]
  connect_bd_net -net monitor_0_wbs_ack_o [get_bd_pins bonfire_axi_top_0/wb_dbus_ack_i] [get_bd_pins monitor_0/wbs_ack_o]
  connect_bd_net -net monitor_0_wbs_dat_o [get_bd_pins bonfire_axi_top_0/wb_dbus_dat_i] [get_bd_pins monitor_0/wbs_dat_o]
  connect_bd_net -net rst_sim_clk_gen_0_83M_interconnect_aresetn [get_bd_pins rst_sim_clk_gen_0_83M/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins smartconnect_1/aresetn]
  connect_bd_net -net rst_sim_clk_gen_0_83M_mb_reset [get_bd_pins bonfire_axi_top_0/rst_i] [get_bd_pins monitor_0/rst_i] [get_bd_pins rst_sim_clk_gen_0_83M/mb_reset]
  connect_bd_net -net rst_sim_clk_gen_0_83M_peripheral_aresetn [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins bonfire_axi4l2wb_0/S_AXI_ARESETN] [get_bd_pins rst_sim_clk_gen_0_83M/peripheral_aresetn]
  connect_bd_net -net sim_clk_gen_0_sync_rst [get_bd_pins rst_sim_clk_gen_0_83M/ext_reset_in] [get_bd_pins sim_clk_gen_0/sync_rst]
  connect_bd_net -net zpuino_uart_0_tx [get_bd_ports TX] [get_bd_pins zpuino_uart_0/tx]
  connect_bd_net -net zpuino_uart_0_wb_inta_o [get_bd_pins bonfire_axi_top_0/lirq6_i] [get_bd_pins zpuino_uart_0/wb_inta_o]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DC] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_IC] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x00002000 -offset 0x80000000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs bonfire_axi4l2wb_0/S_AXI/reg0] SEG_bonfire_axi4l2wb_0_reg0


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


