
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
set scripts_vivado_version 2017.4
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
# BootMem, bonfire_axi_top, bonfire_axi4l2wb, bonfire_axi4l2wb, wishbone_subsystem, zpuino_uart, zpuino_uart

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
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:clk_wiz:5.4\
xilinx.com:ip:mig_7series:4.0\
xilinx.com:ip:proc_sys_reset:5.0\
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
bonfire_axi4l2wb\
bonfire_axi4l2wb\
wishbone_subsystem\
zpuino_uart\
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
  set led_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 led_4bits ]
  set push_buttons_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 push_buttons_4bits ]

  # Create ports
  set eth_ref_clk [ create_bd_port -dir O -type clk eth_ref_clk ]
  set flash_spi_clk [ create_bd_port -dir O flash_spi_clk ]
  set flash_spi_cs [ create_bd_port -dir O flash_spi_cs ]
  set flash_spi_miso [ create_bd_port -dir I flash_spi_miso ]
  set flash_spi_mosi [ create_bd_port -dir O flash_spi_mosi ]
  set jb_cs [ create_bd_port -dir O -from 0 -to 0 jb_cs ]
  set jb_miso [ create_bd_port -dir I jb_miso ]
  set jb_mosi [ create_bd_port -dir O jb_mosi ]
  set jb_sclk [ create_bd_port -dir O jb_sclk ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset
  set sys_clock_0 [ create_bd_port -dir I -type clk sys_clock_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   CONFIG.PHASE {0.000} \
 ] $sys_clock_0
  set uart0_rxd [ create_bd_port -dir I -type data uart0_rxd ]
  set uart0_txd [ create_bd_port -dir O -type data uart0_txd ]
  set uart1_rts [ create_bd_port -dir O uart1_rts ]
  set uart1_rxd [ create_bd_port -dir I uart1_rxd ]
  set uart1_txd [ create_bd_port -dir O -type data uart1_txd ]

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
   CONFIG.RamFileName {/home/thomas/development/Vivado/bonfire-axi-soc/scripts/../lib/bonfire-software/monitor/ARTY_AXI_monitor.hex} \
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
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_GPIO2_WIDTH {4} \
   CONFIG.C_GPIO_WIDTH {4} \
   CONFIG.C_IS_DUAL {1} \
   CONFIG.GPIO2_BOARD_INTERFACE {push_buttons_4bits} \
   CONFIG.GPIO_BOARD_INTERFACE {led_4bits} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_GPIO_WIDTH {4} \
   CONFIG.GPIO_BOARD_INTERFACE {dip_switches_4bits} \
   CONFIG.USE_BOARD_FLOW {false} \
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

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.MAX_BURST_LENGTH {256} \
 ] [get_bd_intf_pins /bonfire_axi_top_0/M_AXI_DC]

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.MAX_BURST_LENGTH {1} \
 ] [get_bd_intf_pins /bonfire_axi_top_0/M_AXI_DP]

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.MAX_BURST_LENGTH {256} \
 ] [get_bd_intf_pins /bonfire_axi_top_0/M_AXI_IC]

  # Create instance: bonfire_axi_top_0_axi_periph, and set properties
  set bonfire_axi_top_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 bonfire_axi_top_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {6} \
   CONFIG.SYNCHRONIZATION_STAGES {2} \
 ] $bonfire_axi_top_0_axi_periph

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.4 clk_wiz_0 ]
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
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $clk_wiz_0

  # Create instance: mig_7series_0, and set properties
  set mig_7series_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.0 mig_7series_0 ]
  set_property -dict [ list \
   CONFIG.BOARD_MIG_PARAM {ddr3_sdram} \
 ] $mig_7series_0

  # Create instance: rst_mig_7series_0_83M, and set properties
  set rst_mig_7series_0_83M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_mig_7series_0_83M ]

  # Create instance: uart_0, and set properties
  set block_name bonfire_axi4l2wb
  set block_cell_name uart_0
  if { [catch {set uart_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $uart_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADRWIDTH {4} \
   CONFIG.FAST_READ_TERM {false} \
 ] $uart_0

  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {4} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
 ] [get_bd_intf_pins /uart_0/S_AXI]

  # Create instance: uart_1, and set properties
  set block_name bonfire_axi4l2wb
  set block_cell_name uart_1
  if { [catch {set uart_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $uart_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.ADRWIDTH {4} \
   CONFIG.FAST_READ_TERM {false} \
 ] $uart_1

  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {4} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
 ] [get_bd_intf_pins /uart_1/S_AXI]

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
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MDIO [get_bd_intf_ports eth_mdio_mdc] [get_bd_intf_pins axi_ethernetlite_0/MDIO]
  connect_bd_intf_net -intf_net axi_ethernetlite_0_MII [get_bd_intf_ports eth_mii] [get_bd_intf_pins axi_ethernetlite_0/MII]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports led_4bits] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO2 [get_bd_intf_ports push_buttons_4bits] [get_bd_intf_pins axi_gpio_0/GPIO2]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO [get_bd_intf_ports dip_switches_4bits] [get_bd_intf_pins axi_gpio_1/GPIO]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins mig_7series_0/S_AXI]
  connect_bd_intf_net -intf_net bonfire_axi4l2wb_0_WB_MASTER [get_bd_intf_pins uart_0/WB_MASTER] [get_bd_intf_pins zpuino_uart_0/WB_SLAVE]
  connect_bd_intf_net -intf_net bonfire_axi4l2wb_1_WB_MASTER [get_bd_intf_pins uart_1/WB_MASTER] [get_bd_intf_pins zpuino_uart_1/WB_SLAVE]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_BRAM_A [get_bd_intf_pins BootMem_0/BRAM_A] [get_bd_intf_pins bonfire_axi_top_0/BRAM_A]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_BRAM_B [get_bd_intf_pins BootMem_0/BRAM_B] [get_bd_intf_pins bonfire_axi_top_0/BRAM_B]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_M_AXI_DC [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins bonfire_axi_top_0/M_AXI_DC]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_M_AXI_DP [get_bd_intf_pins bonfire_axi_top_0/M_AXI_DP] [get_bd_intf_pins bonfire_axi_top_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_M_AXI_IC [get_bd_intf_pins axi_mem_intercon/S01_AXI] [get_bd_intf_pins bonfire_axi_top_0/M_AXI_IC]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_WB_DB [get_bd_intf_pins bonfire_axi_top_0/WB_DB] [get_bd_intf_pins wishbone_subsystem_0/WB_DB]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M01_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M02_AXI [get_bd_intf_pins axi_ethernetlite_0/S_AXI] [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M03_AXI [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M03_AXI] [get_bd_intf_pins uart_0/S_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M04_AXI [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M04_AXI] [get_bd_intf_pins uart_1/S_AXI]
  connect_bd_intf_net -intf_net bonfire_axi_top_0_axi_periph_M05_AXI [get_bd_intf_pins axi_quad_spi_0/AXI_LITE] [get_bd_intf_pins bonfire_axi_top_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net mig_7series_0_DDR3 [get_bd_intf_ports ddr3_sdram] [get_bd_intf_pins mig_7series_0/DDR3]

  # Create port connections
  connect_bd_net -net axi_ethernetlite_0_ip2intc_irpt [get_bd_pins axi_ethernetlite_0/ip2intc_irpt] [get_bd_pins wishbone_subsystem_0/ether_irq_in]
  connect_bd_net -net axi_quad_spi_0_io0_o [get_bd_ports jb_mosi] [get_bd_pins axi_quad_spi_0/io0_o]
  connect_bd_net -net axi_quad_spi_0_sck_o [get_bd_ports jb_sclk] [get_bd_pins axi_quad_spi_0/sck_o]
  connect_bd_net -net axi_quad_spi_0_ss_o [get_bd_ports jb_cs] [get_bd_pins axi_quad_spi_0/ss_o]
  connect_bd_net -net bonfire_axi4l2wb_0_wb_clk_o [get_bd_pins uart_0/wb_clk_o] [get_bd_pins zpuino_uart_0/wb_clk_i]
  connect_bd_net -net bonfire_axi4l2wb_0_wb_rst_o [get_bd_pins uart_0/wb_rst_o] [get_bd_pins zpuino_uart_0/wb_rst_i]
  connect_bd_net -net bonfire_axi4l2wb_1_wb_clk_o [get_bd_pins uart_1/wb_clk_o] [get_bd_pins zpuino_uart_1/wb_clk_i]
  connect_bd_net -net bonfire_axi4l2wb_1_wb_rst_o [get_bd_pins uart_1/wb_rst_o] [get_bd_pins zpuino_uart_1/wb_rst_i]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins mig_7series_0/sys_clk_i]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins mig_7series_0/clk_ref_i]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_ports eth_ref_clk] [get_bd_pins clk_wiz_0/clk_out3]
  connect_bd_net -net flash_spi_miso_1 [get_bd_ports flash_spi_miso] [get_bd_pins wishbone_subsystem_0/flash_spi_miso]
  connect_bd_net -net jb_miso_1 [get_bd_ports jb_miso] [get_bd_pins axi_quad_spi_0/io1_i]
  connect_bd_net -net mig_7series_0_mmcm_locked [get_bd_pins mig_7series_0/mmcm_locked] [get_bd_pins rst_mig_7series_0_83M/dcm_locked]
  connect_bd_net -net mig_7series_0_ui_clk [get_bd_pins BootMem_0/A_CLK] [get_bd_pins BootMem_0/B_CLK] [get_bd_pins axi_ethernetlite_0/s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_quad_spi_0/s_axi_aclk] [get_bd_pins bonfire_axi_top_0/clk_i] [get_bd_pins bonfire_axi_top_0_axi_periph/ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M00_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M01_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M02_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M03_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M04_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/M05_ACLK] [get_bd_pins bonfire_axi_top_0_axi_periph/S00_ACLK] [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins rst_mig_7series_0_83M/slowest_sync_clk] [get_bd_pins uart_0/S_AXI_ACLK] [get_bd_pins uart_1/S_AXI_ACLK] [get_bd_pins wishbone_subsystem_0/clk_i]
  connect_bd_net -net mig_7series_0_ui_clk_sync_rst [get_bd_pins mig_7series_0/ui_clk_sync_rst] [get_bd_pins rst_mig_7series_0_83M/ext_reset_in]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins mig_7series_0/sys_rst]
  connect_bd_net -net rst_mig_7series_0_83M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/ARESETN] [get_bd_pins rst_mig_7series_0_83M/interconnect_aresetn]
  connect_bd_net -net rst_mig_7series_0_83M_mb_reset [get_bd_pins bonfire_axi_top_0/rst_i] [get_bd_pins rst_mig_7series_0_83M/mb_reset] [get_bd_pins wishbone_subsystem_0/rst_i]
  connect_bd_net -net rst_mig_7series_0_83M_peripheral_aresetn [get_bd_pins axi_ethernetlite_0/s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_quad_spi_0/s_axi_aresetn] [get_bd_pins bonfire_axi_top_0_axi_periph/M00_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M01_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M02_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M03_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M04_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/M05_ARESETN] [get_bd_pins bonfire_axi_top_0_axi_periph/S00_ARESETN] [get_bd_pins mig_7series_0/aresetn] [get_bd_pins rst_mig_7series_0_83M/peripheral_aresetn] [get_bd_pins uart_0/S_AXI_ARESETN] [get_bd_pins uart_1/S_AXI_ARESETN]
  connect_bd_net -net sys_clock_0_1 [get_bd_ports sys_clock_0] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net uart0_rxd_1 [get_bd_ports uart0_rxd] [get_bd_pins zpuino_uart_0/rx]
  connect_bd_net -net uart1_rxd_1 [get_bd_ports uart1_rxd] [get_bd_pins zpuino_uart_1/rx]
  connect_bd_net -net wishbone_subsystem_0_ether_irq_out [get_bd_pins bonfire_axi_top_0/ext_irq_i] [get_bd_pins wishbone_subsystem_0/ether_irq_out]
  connect_bd_net -net wishbone_subsystem_0_flash_spi_clk [get_bd_ports flash_spi_clk] [get_bd_pins wishbone_subsystem_0/flash_spi_clk]
  connect_bd_net -net wishbone_subsystem_0_flash_spi_cs [get_bd_ports flash_spi_cs] [get_bd_pins wishbone_subsystem_0/flash_spi_cs]
  connect_bd_net -net wishbone_subsystem_0_flash_spi_mosi [get_bd_ports flash_spi_mosi] [get_bd_pins wishbone_subsystem_0/flash_spi_mosi]
  connect_bd_net -net zpuino_uart_0_tx [get_bd_ports uart0_txd] [get_bd_pins zpuino_uart_0/tx]
  connect_bd_net -net zpuino_uart_0_wb_inta_o [get_bd_pins bonfire_axi_top_0/lirq6_i] [get_bd_pins zpuino_uart_0/wb_inta_o]
  connect_bd_net -net zpuino_uart_1_enabled [get_bd_ports uart1_rts] [get_bd_pins zpuino_uart_1/enabled]
  connect_bd_net -net zpuino_uart_1_tx [get_bd_ports uart1_txd] [get_bd_pins zpuino_uart_1/tx]
  connect_bd_net -net zpuino_uart_1_wb_inta_o [get_bd_pins bonfire_axi_top_0/lirq5_i] [get_bd_pins zpuino_uart_1/wb_inta_o]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x80E00000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs axi_ethernetlite_0/S_AXI/Reg] SEG_axi_ethernetlite_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80000000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80010000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80040000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs axi_quad_spi_0/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80020000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs uart_0/S_AXI/reg0] SEG_bonfire_axi4l2wb_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x80030000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs uart_1/S_AXI/reg0] SEG_bonfire_axi4l2wb_1_reg0
  create_bd_addr_seg -range 0x10000000 -offset 0x00000000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DC] [get_bd_addr_segs mig_7series_0/memmap/memaddr] SEG_mig_7series_0_memaddr
  create_bd_addr_seg -range 0x10000000 -offset 0x00000000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_IC] [get_bd_addr_segs mig_7series_0/memmap/memaddr] SEG_mig_7series_0_memaddr


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


