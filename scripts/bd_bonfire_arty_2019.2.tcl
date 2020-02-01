
################################################################
# This is a generated script based on design: design_1
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
set scripts_vivado_version 2019.2
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
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# BootMem, bonfire_axi_top, wishbone_subsystem, bonfire_axi4l2wb, zpuino_uart, bonfire_axi4l2wb, zpuino_uart

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
variable design_name
set design_name design_1

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

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_ethernetlite:3.0\
xilinx.com:ip:axi_gpio:2.0\
bonfirecpu.eu:user:bonfire_gpio_core:1.2.2\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:mig_7series:4.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axi_quad_spi:3.2\
digilentinc.com:ip:pmod_bridge:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
BootMem\
bonfire_axi_top\
wishbone_subsystem\
bonfire_axi4l2wb\
zpuino_uart\
bonfire_axi4l2wb\
zpuino_uart\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: uart1
proc create_hier_cell_uart1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_uart1() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 jd


  # Create pins
  create_bd_pin -dir I -type clk S_AXI_ACLK
  create_bd_pin -dir I -type rst S_AXI_ARESETN
  create_bd_pin -dir O wb_inta_o

  # Create instance: pmod_bridge_0, and set properties
  set pmod_bridge_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:pmod_bridge:1.0 pmod_bridge_0 ]
  set_property -dict [ list \
   CONFIG.Bottom_Row_Interface {Disabled} \
   CONFIG.PMOD {jd} \
   CONFIG.Top_Row_Interface {UART} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $pmod_bridge_0

  # Create instance: uart_axibridge1, and set properties
  set block_name bonfire_axi4l2wb
  set block_cell_name uart_axibridge1
  if { [catch {set uart_axibridge1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $uart_axibridge1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADRWIDTH {4} \
   CONFIG.FAST_READ_TERM {false} \
 ] $uart_axibridge1

  # Create instance: zpuino_uart_1, and set properties
  set block_name zpuino_uart
  set block_cell_name zpuino_uart_1
  if { [catch {set zpuino_uart_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $zpuino_uart_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.bits {6} \
   CONFIG.extended {true} \
 ] $zpuino_uart_1

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins jd] [get_bd_intf_pins pmod_bridge_0/Pmod_out]
  connect_bd_intf_net -intf_net bonfire_axi4l2wb_1_WB_MASTER [get_bd_intf_pins uart_axibridge1/WB_MASTER] [get_bd_intf_pins zpuino_uart_1/WB_SLAVE]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M04_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins uart_axibridge1/S_AXI]
  connect_bd_intf_net -intf_net zpuino_uart_1_UART [get_bd_intf_pins pmod_bridge_0/UART_Top_Row] [get_bd_intf_pins zpuino_uart_1/UART]

  # Create port connections
  connect_bd_net -net bonfire_axi4l2wb_1_wb_clk_o [get_bd_pins uart_axibridge1/wb_clk_o] [get_bd_pins zpuino_uart_1/wb_clk_i]
  connect_bd_net -net bonfire_axi4l2wb_1_wb_rst_o [get_bd_pins uart_axibridge1/wb_rst_o] [get_bd_pins zpuino_uart_1/wb_rst_i]
  connect_bd_net -net mig_7series_0_ui_clk [get_bd_pins S_AXI_ACLK] [get_bd_pins uart_axibridge1/S_AXI_ACLK]
  connect_bd_net -net rst_mig_7series_0_83M_peripheral_aresetn [get_bd_pins S_AXI_ARESETN] [get_bd_pins uart_axibridge1/S_AXI_ARESETN]
  connect_bd_net -net zpuino_uart_1_wb_inta_o [get_bd_pins wb_inta_o] [get_bd_pins zpuino_uart_1/wb_inta_o]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: uart0
proc create_hier_cell_uart0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_uart0() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 usb_uart


  # Create pins
  create_bd_pin -dir I -type clk S_AXI_ACLK
  create_bd_pin -dir I -type rst S_AXI_ARESETN
  create_bd_pin -dir O wb_inta_o

  # Create instance: uart_axibridge_0, and set properties
  set block_name bonfire_axi4l2wb
  set block_cell_name uart_axibridge_0
  if { [catch {set uart_axibridge_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $uart_axibridge_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADRWIDTH {4} \
   CONFIG.FAST_READ_TERM {false} \
 ] $uart_axibridge_0

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
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins usb_uart] [get_bd_intf_pins zpuino_uart_0/UART]
  connect_bd_intf_net -intf_net bonfire_axi4l2wb_0_WB_MASTER [get_bd_intf_pins uart_axibridge_0/WB_MASTER] [get_bd_intf_pins zpuino_uart_0/WB_SLAVE]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M03_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins uart_axibridge_0/S_AXI]

  # Create port connections
  connect_bd_net -net bonfire_axi4l2wb_0_wb_clk_o [get_bd_pins uart_axibridge_0/wb_clk_o] [get_bd_pins zpuino_uart_0/wb_clk_i]
  connect_bd_net -net bonfire_axi4l2wb_0_wb_rst_o [get_bd_pins uart_axibridge_0/wb_rst_o] [get_bd_pins zpuino_uart_0/wb_rst_i]
  connect_bd_net -net mig_7series_0_ui_clk [get_bd_pins S_AXI_ACLK] [get_bd_pins uart_axibridge_0/S_AXI_ACLK]
  connect_bd_net -net rst_mig_7series_0_83M_peripheral_aresetn [get_bd_pins S_AXI_ARESETN] [get_bd_pins uart_axibridge_0/S_AXI_ARESETN]
  connect_bd_net -net zpuino_uart_0_wb_inta_o [get_bd_pins wb_inta_o] [get_bd_pins zpuino_uart_0/wb_inta_o]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: pmod_jb_spi
proc create_hier_cell_pmod_jb_spi { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pmod_jb_spi() - Empty argument(s)!"}
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 AXI_LITE

  create_bd_intf_pin -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 jb


  # Create pins
  create_bd_pin -dir I -type clk ext_spi_clk
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: axi_quad_spi_0, and set properties
  set axi_quad_spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0 ]
  set_property -dict [ list \
   CONFIG.C_FIFO_DEPTH {0} \
   CONFIG.C_SCK_RATIO {8} \
   CONFIG.C_USE_STARTUP {0} \
   CONFIG.C_USE_STARTUP_INT {0} \
   CONFIG.FIFO_INCLUDED {0} \
   CONFIG.Multiples16 {1} \
   CONFIG.QSPI_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_quad_spi_0

  # Create instance: pmod_bridge_0, and set properties
  set pmod_bridge_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:pmod_bridge:1.0 pmod_bridge_0 ]
  set_property -dict [ list \
   CONFIG.Bottom_Row_Interface {Disabled} \
   CONFIG.PMOD {jb} \
   CONFIG.Top_Row_Interface {SPI} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $pmod_bridge_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_quad_spi_0_SPI_0 [get_bd_intf_pins axi_quad_spi_0/SPI_0] [get_bd_intf_pins pmod_bridge_0/SPI_Top_Row]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M05_AXI [get_bd_intf_pins AXI_LITE] [get_bd_intf_pins axi_quad_spi_0/AXI_LITE]
  connect_bd_intf_net -intf_net pmod_bridge_0_Pmod_out [get_bd_intf_pins jb] [get_bd_intf_pins pmod_bridge_0/Pmod_out]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins ext_spi_clk] [get_bd_pins axi_quad_spi_0/ext_spi_clk]
  connect_bd_net -net mig_7series_0_ui_clk [get_bd_pins s_axi_aclk] [get_bd_pins axi_quad_spi_0/s_axi_aclk]
  connect_bd_net -net rst_mig_7series_0_83M_peripheral_aresetn [get_bd_pins s_axi_aresetn] [get_bd_pins axi_quad_spi_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

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
  set ddr3_sdram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3_sdram ]

  set dip_switches_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 dip_switches_4bits ]

  set eth_mdio_mdc [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 eth_mdio_mdc ]

  set eth_mii [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mii_rtl:1.0 eth_mii ]

  set jb [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 jb ]

  set jd [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:pmod_rtl:1.0 jd ]

  set led_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 led_4bits ]

  set push_buttons_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 push_buttons_4bits ]

  set shield_dp0_dp19 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 shield_dp0_dp19 ]

  set usb_uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 usb_uart ]


  # Create ports
  set eth_ref_clk [ create_bd_port -dir O -type clk eth_ref_clk ]
  set flash_spi_clk [ create_bd_port -dir O flash_spi_clk ]
  set flash_spi_cs [ create_bd_port -dir O flash_spi_cs ]
  set flash_spi_miso [ create_bd_port -dir I flash_spi_miso ]
  set flash_spi_mosi [ create_bd_port -dir O flash_spi_mosi ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset
  set sys_clock [ create_bd_port -dir I -type clk -freq_hz 100000000 sys_clock ]
  set_property -dict [ list \
   CONFIG.PHASE {0.000} \
 ] $sys_clock

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
   CONFIG.RamFileName {/home/thomas/development/bonfire/bonfire_arty_a7_full/scripts/../compiled_code/ARTY_AXI_monitor.hex} \
   CONFIG.SIZE {16384} \
   CONFIG.mode {H} \
 ] $BootMem_0

  # Create instance: axi_ethernetlite_0, and set properties
  set axi_ethernetlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0 ]
  set_property -dict [ list \
   CONFIG.C_INCLUDE_INTERNAL_LOOPBACK {1} \
   CONFIG.C_RX_PING_PONG {1} \
   CONFIG.C_TX_PING_PONG {0} \
   CONFIG.MDIO_BOARD_INTERFACE {eth_mdio_mdc} \
   CONFIG.MII_BOARD_INTERFACE {eth_mii} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_ethernetlite_0

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {0} \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {4} \
   CONFIG.C_IS_DUAL {0} \
   CONFIG.GPIO2_BOARD_INTERFACE {Custom} \
   CONFIG.GPIO_BOARD_INTERFACE {led_4bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_GPIO2_WIDTH {4} \
   CONFIG.C_GPIO_WIDTH {4} \
   CONFIG.C_INTERRUPT_PRESENT {0} \
   CONFIG.C_IS_DUAL {1} \
   CONFIG.GPIO2_BOARD_INTERFACE {push_buttons_4bits} \
   CONFIG.GPIO_BOARD_INTERFACE {dip_switches_4bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_1

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
   CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.S00_HAS_DATA_FIFO {1} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $axi_mem_intercon

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
   CONFIG.CACHE_LINE_SIZE_WORDS {16} \
   CONFIG.CACHE_SIZE_WORDS {8192} \
   CONFIG.DCACHE_LINE_SIZE {4} \
   CONFIG.DCACHE_MASTER_WIDTH {128} \
   CONFIG.DCACHE_SIZE {2048} \
 ] $bonfire_axi_top_0

  # Create instance: bonfire_axi_top_0_axi_periph, and set properties
  set bonfire_axi_top_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 bonfire_axi_top_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {7} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $bonfire_axi_top_0_axi_periph

  # Create instance: bonfire_gpio_core_0, and set properties
  set bonfire_gpio_core_0 [ create_bd_cell -type ip -vlnv bonfirecpu.eu:user:bonfire_gpio_core:1.2.2 bonfire_gpio_core_0 ]
  set_property -dict [ list \
   CONFIG.ADRWIDTH {15} \
   CONFIG.FAST_READ_TERM {TRUE} \
   CONFIG.NUM_GPIO {20} \
 ] $bonfire_gpio_core_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {118.758} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {166.666} \
   CONFIG.CLKOUT2_JITTER {114.829} \
   CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {175.402} \
   CONFIG.CLKOUT3_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {25} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {5} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {40} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $clk_wiz_0

  # Create instance: mig_7series_0, and set properties
  set mig_7series_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0 ]
  set_property -dict [ list \
   CONFIG.BOARD_MIG_PARAM {ddr3_sdram} \
 ] $mig_7series_0

  # Create instance: pmod_jb_spi
  create_hier_cell_pmod_jb_spi [current_bd_instance .] pmod_jb_spi

  # Create instance: rst_mig_7series_0_83M, and set properties
  set rst_mig_7series_0_83M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_mig_7series_0_83M ]

  # Create instance: uart0
  create_hier_cell_uart0 [current_bd_instance .] uart0

  # Create instance: uart1
  create_hier_cell_uart1 [current_bd_instance .] uart1

  # Create instance: wishbone_subsystem_0, and set properties
  set block_name wishbone_subsystem
  set block_cell_name wishbone_subsystem_0
  if { [catch {set wishbone_subsystem_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $wishbone_subsystem_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MDIO [get_bd_intf_ports eth_mdio_mdc] [get_bd_intf_pins axi_ethernetlite_0/MDIO]
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MII [get_bd_intf_ports eth_mii] [get_bd_intf_pins axi_ethernetlite_0/MII]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports led_4bits] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO [get_bd_intf_ports dip_switches_4bits] [get_bd_intf_pins axi_gpio_1/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO2 [get_bd_intf_ports push_buttons_4bits] [get_bd_intf_pins axi_gpio_1/GPIO2]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins mig_7series_0/S_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_BRAM_A [get_bd_intf_pins BootMem_0/BRAM_A] [get_bd_intf_pins bonfire_axi_top_0/BRAM_A]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_BRAM_B [get_bd_intf_pins BootMem_0/BRAM_B] [get_bd_intf_pins bonfire_axi_top_0/BRAM_B]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_M_AXI_DC [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins bonfire_axi_top_0/M_AXI_DC]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_M_AXI_DP [get_bd_intf_pins bonfire_axi_top_0/M_AXI_DP] [get_bd_intf_pins bonfire_axi_top_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_M_AXI_IC [get_bd_intf_pins axi_mem_intercon/S01_AXI] [get_bd_intf_pins bonfire_axi_top_0/M_AXI_IC]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_WB_DB [get_bd_intf_pins bonfire_axi_top_0/WB_DB] [get_bd_intf_pins wishbone_subsystem_0/WB_DB]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M01_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M02_AXI [get_bd_intf_pins axi_ethernetlite_0/S_AXI] [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M03_AXI [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M03_AXI] [get_bd_intf_pins uart0/S_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M04_AXI [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M04_AXI] [get_bd_intf_pins uart1/S_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M05_AXI [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M05_AXI] [get_bd_intf_pins pmod_jb_spi/AXI_LITE]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M06_AXI [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M06_AXI] [get_bd_intf_pins bonfire_gpio_core_0/S_AXI]
  connect_bd_intf_net -intf_net bonfire_gpio_core_0_GPIO [get_bd_intf_ports shield_dp0_dp19] [get_bd_intf_pins bonfire_gpio_core_0/GPIO]
  connect_bd_intf_net -intf_net mig_7series_0_DDR3 [get_bd_intf_ports ddr3_sdram] [get_bd_intf_pins mig_7series_0/DDR3]
  connect_bd_intf_net -intf_net pmod_bridge_0_Pmod_out [get_bd_intf_ports jb] [get_bd_intf_pins pmod_jb_spi/jb]
  connect_bd_intf_net -intf_net uart1_jd [get_bd_intf_ports jd] [get_bd_intf_pins uart1/jd]
  connect_bd_intf_net -intf_net z_uart0_usb_uart [get_bd_intf_ports usb_uart] [get_bd_intf_pins uart0/usb_uart]

  # Create port connections
  connect_bd_net -net axi_ethernetlite_0_ip2intc_irpt [get_bd_pins axi_ethernetlite_0/ip2intc_irpt] [get_bd_pins wishbone_subsystem_0/ether_irq_in]
  connect_bd_net -net bonfire_gpio_core_0_fall_irq_o [get_bd_pins bonfire_axi_top_0/lirq3_i] [get_bd_pins bonfire_gpio_core_0/fall_irq_o]
  connect_bd_net -net bonfire_gpio_core_0_rise_irq_o [get_bd_pins bonfire_axi_top_0/lirq4_i] [get_bd_pins bonfire_gpio_core_0/rise_irq_o]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins mig_7series_0/sys_clk_i] [get_bd_pins pmod_jb_spi/ext_spi_clk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins mig_7series_0/clk_ref_i]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_ports eth_ref_clk] [get_bd_pins clk_wiz_0/clk_out3]
  connect_bd_net -net flash_spi_miso_1 [get_bd_ports flash_spi_miso] [get_bd_pins wishbone_subsystem_0/flash_spi_miso]
  connect_bd_net -net mig_7series_0_mmcm_locked [get_bd_pins mig_7series_0/mmcm_locked] [get_bd_pins rst_mig_7series_0_83M/dcm_locked]
  connect_bd_net -net mig_7series_0_ui_clk [get_bd_pins BootMem_0/A_CLK] [get_bd_pins BootMem_0/B_CLK] [get_bd_pins axi_ethernetlite_0/s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins bonfire_axi_top_0/clk_i] [get_bd_pins bonfire_axi_top_0_axi_periph/ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M00_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M01_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M02_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M03_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M04_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M05_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M06_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/S00_ACLK] [get_bd_pins bonfire_gpio_core_0/S_AXI_ACLK] [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins pmod_jb_spi/s_axi_aclk] [get_bd_pins rst_mig_7series_0_83M/slowest_sync_clk] [get_bd_pins uart0/S_AXI_ACLK] [get_bd_pins uart1/S_AXI_ACLK] [get_bd_pins wishbone_subsystem_0/clk_i]
  connect_bd_net -net mig_7series_0_ui_clk_sync_rst [get_bd_pins mig_7series_0/ui_clk_sync_rst] [get_bd_pins rst_mig_7series_0_83M/ext_reset_in]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins mig_7series_0/sys_rst]
  connect_bd_net -net rst_mig_7series_0_83M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/ARESETN] [get_bd_pins rst_mig_7series_0_83M/interconnect_aresetn]
  connect_bd_net -net rst_mig_7series_0_83M_mb_reset [get_bd_pins bonfire_axi_top_0/rst_i] [get_bd_pins rst_mig_7series_0_83M/mb_reset] [get_bd_pins wishbone_subsystem_0/rst_i]
  connect_bd_net -net rst_mig_7series_0_83M_peripheral_aresetn [get_bd_pins axi_ethernetlite_0/s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M00_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M01_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M02_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M03_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M04_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M05_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M06_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/S00_ARESETN] [get_bd_pins bonfire_gpio_core_0/S_AXI_ARESETN] [get_bd_pins mig_7series_0/aresetn] [get_bd_pins pmod_jb_spi/s_axi_aresetn] [get_bd_pins rst_mig_7series_0_83M/peripheral_aresetn] [get_bd_pins uart0/S_AXI_ARESETN] [get_bd_pins uart1/S_AXI_ARESETN]
  connect_bd_net -net sys_clock_1 [get_bd_ports sys_clock] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net wishbone_subsystem_0_ether_irq_out [get_bd_pins bonfire_axi_top_0/ext_irq_i] [get_bd_pins wishbone_subsystem_0/ether_irq_out]
  connect_bd_net -net wishbone_subsystem_0_flash_spi_clk [get_bd_ports flash_spi_clk] [get_bd_pins wishbone_subsystem_0/flash_spi_clk]
  connect_bd_net -net wishbone_subsystem_0_flash_spi_cs [get_bd_ports flash_spi_cs] [get_bd_pins wishbone_subsystem_0/flash_spi_cs]
  connect_bd_net -net wishbone_subsystem_0_flash_spi_mosi [get_bd_ports flash_spi_mosi] [get_bd_pins wishbone_subsystem_0/flash_spi_mosi]
  connect_bd_net -net zpuino_uart_0_wb_inta_o [get_bd_pins bonfire_axi_top_0/lirq6_i] [get_bd_pins uart0/wb_inta_o]
  connect_bd_net -net zpuino_uart_1_wb_inta_o [get_bd_pins bonfire_axi_top_0/lirq5_i] [get_bd_pins uart1/wb_inta_o]

  # Create address segments
  assign_bd_address -offset 0x80E00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs axi_ethernetlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x80040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs pmod_jb_spi/axi_quad_spi_0/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x80050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs bonfire_gpio_core_0/S_AXI/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_IC] [get_bd_addr_segs mig_7series_0/memmap/memaddr] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DC] [get_bd_addr_segs mig_7series_0/memmap/memaddr] -force
  assign_bd_address -offset 0x80030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs uart1/uart_axibridge1/S_AXI/reg0] -force
  assign_bd_address -offset 0x80020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs uart0/uart_axibridge_0/S_AXI/reg0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


