
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
set scripts_vivado_version 2018.2
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
xilinx.com:ip:mig_7series:4.1\
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
# MIG PRJ FILE TCL PROCs
##################################################################

proc write_mig_file_design_1_mig_7series_0_0 { str_mig_prj_filepath } {

   file mkdir [ file dirname "$str_mig_prj_filepath" ]
   set mig_prj_file [open $str_mig_prj_filepath  w+]

   puts $mig_prj_file {<?xml version='1.0' encoding='UTF-8'?>}
   puts $mig_prj_file {<!-- IMPORTANT: This is an internal file that has been generated by the MIG software. Any direct editing or changes made to this file may result in unpredictable behavior or data corruption. It is strongly advised that users do not edit the contents of this file. Re-run the MIG GUI with the required settings if any of the options provided below need to be altered. -->}
   puts $mig_prj_file {<Project NoOfControllers="1" >}
   puts $mig_prj_file {    <ModuleName>design_1_mig_7series_0_0</ModuleName>}
   puts $mig_prj_file {    <dci_inouts_inputs>1</dci_inouts_inputs>}
   puts $mig_prj_file {    <dci_inputs>1</dci_inputs>}
   puts $mig_prj_file {    <Debug_En>OFF</Debug_En>}
   puts $mig_prj_file {    <DataDepth_En>1024</DataDepth_En>}
   puts $mig_prj_file {    <LowPower_En>ON</LowPower_En>}
   puts $mig_prj_file {    <XADC_En>Enabled</XADC_En>}
   puts $mig_prj_file {    <TargetFPGA>xc7a35ti-csg324/-1L</TargetFPGA>}
   puts $mig_prj_file {    <Version>2.3</Version>}
   puts $mig_prj_file {    <SystemClock>No Buffer</SystemClock>}
   puts $mig_prj_file {    <ReferenceClock>No Buffer</ReferenceClock>}
   puts $mig_prj_file {    <SysResetPolarity>ACTIVE LOW</SysResetPolarity>}
   puts $mig_prj_file {    <BankSelectionFlag>FALSE</BankSelectionFlag>}
   puts $mig_prj_file {    <InternalVref>1</InternalVref>}
   puts $mig_prj_file {    <dci_hr_inouts_inputs>50 Ohms</dci_hr_inouts_inputs>}
   puts $mig_prj_file {    <dci_cascade>0</dci_cascade>}
   puts $mig_prj_file {    <Controller number="0" >}
   puts $mig_prj_file {        <MemoryDevice>DDR3_SDRAM/Components/MT41K128M16XX-15E</MemoryDevice>}
   puts $mig_prj_file {        <TimePeriod>3000</TimePeriod>}
   puts $mig_prj_file {        <VccAuxIO>1.8V</VccAuxIO>}
   puts $mig_prj_file {        <PHYRatio>4:1</PHYRatio>}
   puts $mig_prj_file {        <InputClkFreq>166.666</InputClkFreq>}
   puts $mig_prj_file {        <UIExtraClocks>0</UIExtraClocks>}
   puts $mig_prj_file {        <MMCM_VCO>666</MMCM_VCO>}
   puts $mig_prj_file {        <MMCMClkOut0> 1.000</MMCMClkOut0>}
   puts $mig_prj_file {        <MMCMClkOut1>1</MMCMClkOut1>}
   puts $mig_prj_file {        <MMCMClkOut2>1</MMCMClkOut2>}
   puts $mig_prj_file {        <MMCMClkOut3>1</MMCMClkOut3>}
   puts $mig_prj_file {        <MMCMClkOut4>1</MMCMClkOut4>}
   puts $mig_prj_file {        <DataWidth>16</DataWidth>}
   puts $mig_prj_file {        <DeepMemory>1</DeepMemory>}
   puts $mig_prj_file {        <DataMask>1</DataMask>}
   puts $mig_prj_file {        <ECC>Disabled</ECC>}
   puts $mig_prj_file {        <Ordering>Normal</Ordering>}
   puts $mig_prj_file {        <CustomPart>FALSE</CustomPart>}
   puts $mig_prj_file {        <NewPartName></NewPartName>}
   puts $mig_prj_file {        <RowAddress>14</RowAddress>}
   puts $mig_prj_file {        <ColAddress>10</ColAddress>}
   puts $mig_prj_file {        <BankAddress>3</BankAddress>}
   puts $mig_prj_file {        <MemoryVoltage>1.35V</MemoryVoltage>}
   puts $mig_prj_file {        <C0_MEM_SIZE>268435456</C0_MEM_SIZE>}
   puts $mig_prj_file {        <UserMemoryAddressMap>BANK_ROW_COLUMN</UserMemoryAddressMap>}
   puts $mig_prj_file {        <PinSelection>}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="R2" SLEW="" name="ddr3_addr[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="R6" SLEW="" name="ddr3_addr[10]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="U6" SLEW="" name="ddr3_addr[11]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="T6" SLEW="" name="ddr3_addr[12]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="T8" SLEW="" name="ddr3_addr[13]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="M6" SLEW="" name="ddr3_addr[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="N4" SLEW="" name="ddr3_addr[2]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="T1" SLEW="" name="ddr3_addr[3]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="N6" SLEW="" name="ddr3_addr[4]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="R7" SLEW="" name="ddr3_addr[5]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="V6" SLEW="" name="ddr3_addr[6]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="U7" SLEW="" name="ddr3_addr[7]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="R8" SLEW="" name="ddr3_addr[8]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="V7" SLEW="" name="ddr3_addr[9]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="R1" SLEW="" name="ddr3_ba[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="P4" SLEW="" name="ddr3_ba[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="P2" SLEW="" name="ddr3_ba[2]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="M4" SLEW="" name="ddr3_cas_n" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="V9" SLEW="" name="ddr3_ck_n[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="U9" SLEW="" name="ddr3_ck_p[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="N5" SLEW="" name="ddr3_cke[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="U8" SLEW="" name="ddr3_cs_n[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="L1" SLEW="" name="ddr3_dm[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="U1" SLEW="" name="ddr3_dm[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="K5" SLEW="" name="ddr3_dq[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="U4" SLEW="" name="ddr3_dq[10]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="V5" SLEW="" name="ddr3_dq[11]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="V1" SLEW="" name="ddr3_dq[12]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="T3" SLEW="" name="ddr3_dq[13]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="U3" SLEW="" name="ddr3_dq[14]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="R3" SLEW="" name="ddr3_dq[15]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="L3" SLEW="" name="ddr3_dq[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="K3" SLEW="" name="ddr3_dq[2]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="L6" SLEW="" name="ddr3_dq[3]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="M3" SLEW="" name="ddr3_dq[4]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="M1" SLEW="" name="ddr3_dq[5]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="L4" SLEW="" name="ddr3_dq[6]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="M2" SLEW="" name="ddr3_dq[7]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="V4" SLEW="" name="ddr3_dq[8]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="T5" SLEW="" name="ddr3_dq[9]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="N1" SLEW="" name="ddr3_dqs_n[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="V2" SLEW="" name="ddr3_dqs_n[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="N2" SLEW="" name="ddr3_dqs_p[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="U2" SLEW="" name="ddr3_dqs_p[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="R5" SLEW="" name="ddr3_odt[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="P3" SLEW="" name="ddr3_ras_n" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="K6" SLEW="" name="ddr3_reset_n" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="P5" SLEW="" name="ddr3_we_n" IN_TERM="" />}
   puts $mig_prj_file {        </PinSelection>}
   puts $mig_prj_file {        <System_Control>}
   puts $mig_prj_file {            <Pin PADName="No connect" Bank="Select Bank" name="sys_rst" />}
   puts $mig_prj_file {            <Pin PADName="No connect" Bank="Select Bank" name="init_calib_complete" />}
   puts $mig_prj_file {            <Pin PADName="No connect" Bank="Select Bank" name="tg_compare_error" />}
   puts $mig_prj_file {        </System_Control>}
   puts $mig_prj_file {        <TimingParameters>}
   puts $mig_prj_file {            <Parameters twtr="7.5" trrd="7.5" trefi="7.8" tfaw="45" trtp="7.5" tcke="5.625" trfc="160" trp="13.5" tras="36" trcd="13.5" />}
   puts $mig_prj_file {        </TimingParameters>}
   puts $mig_prj_file {        <mrBurstLength name="Burst Length" >8 - Fixed</mrBurstLength>}
   puts $mig_prj_file {        <mrBurstType name="Read Burst Type and Length" >Sequential</mrBurstType>}
   puts $mig_prj_file {        <mrCasLatency name="CAS Latency" >5</mrCasLatency>}
   puts $mig_prj_file {        <mrMode name="Mode" >Normal</mrMode>}
   puts $mig_prj_file {        <mrDllReset name="DLL Reset" >No</mrDllReset>}
   puts $mig_prj_file {        <mrPdMode name="DLL control for precharge PD" >Slow Exit</mrPdMode>}
   puts $mig_prj_file {        <emrDllEnable name="DLL Enable" >Enable</emrDllEnable>}
   puts $mig_prj_file {        <emrOutputDriveStrength name="Output Driver Impedance Control" >RZQ/6</emrOutputDriveStrength>}
   puts $mig_prj_file {        <emrMirrorSelection name="Address Mirroring" >Disable</emrMirrorSelection>}
   puts $mig_prj_file {        <emrCSSelection name="Controller Chip Select Pin" >Enable</emrCSSelection>}
   puts $mig_prj_file {        <emrRTT name="RTT (nominal) - On Die Termination (ODT)" >RZQ/6</emrRTT>}
   puts $mig_prj_file {        <emrPosted name="Additive Latency (AL)" >0</emrPosted>}
   puts $mig_prj_file {        <emrOCD name="Write Leveling Enable" >Disabled</emrOCD>}
   puts $mig_prj_file {        <emrDQS name="TDQS enable" >Enabled</emrDQS>}
   puts $mig_prj_file {        <emrRDQS name="Qoff" >Output Buffer Enabled</emrRDQS>}
   puts $mig_prj_file {        <mr2PartialArraySelfRefresh name="Partial-Array Self Refresh" >Full Array</mr2PartialArraySelfRefresh>}
   puts $mig_prj_file {        <mr2CasWriteLatency name="CAS write latency" >5</mr2CasWriteLatency>}
   puts $mig_prj_file {        <mr2AutoSelfRefresh name="Auto Self Refresh" >Enabled</mr2AutoSelfRefresh>}
   puts $mig_prj_file {        <mr2SelfRefreshTempRange name="High Temparature Self Refresh Rate" >Normal</mr2SelfRefreshTempRange>}
   puts $mig_prj_file {        <mr2RTTWR name="RTT_WR - Dynamic On Die Termination (ODT)" >Dynamic ODT off</mr2RTTWR>}
   puts $mig_prj_file {        <PortInterface>AXI</PortInterface>}
   puts $mig_prj_file {        <AXIParameters>}
   puts $mig_prj_file {            <C0_C_RD_WR_ARB_ALGORITHM>RD_PRI_REG</C0_C_RD_WR_ARB_ALGORITHM>}
   puts $mig_prj_file {            <C0_S_AXI_ADDR_WIDTH>28</C0_S_AXI_ADDR_WIDTH>}
   puts $mig_prj_file {            <C0_S_AXI_DATA_WIDTH>128</C0_S_AXI_DATA_WIDTH>}
   puts $mig_prj_file {            <C0_S_AXI_ID_WIDTH>5</C0_S_AXI_ID_WIDTH>}
   puts $mig_prj_file {            <C0_S_AXI_SUPPORTS_NARROW_BURST>1</C0_S_AXI_SUPPORTS_NARROW_BURST>}
   puts $mig_prj_file {        </AXIParameters>}
   puts $mig_prj_file {    </Controller>}
   puts $mig_prj_file {</Project>}

   close $mig_prj_file
}
# End of write_mig_file_design_1_mig_7series_0_0()



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

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.MAX_BURST_LENGTH {1} \
 ] [get_bd_intf_pins /uart1/uart_axibridge1/S_AXI]

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

  # Perform GUI Layout
  regenerate_bd_layout -hierarchy [get_bd_cells /uart1] -layout_string {
   ExpandedHierarchyInLayout: "",
   guistr: "# # String gsaved with Nlview 6.8.5  2018-01-30 bk=1.4354 VDI=40 GEI=35 GUI=JA:1.6 TLS
#  -string -flagsOSRD
preplace port S_AXI_ACLK -pg 1 -y 150 -defaultsOSRD
preplace port S_AXI_ARESETN -pg 1 -y 170 -defaultsOSRD
preplace port wb_inta_o -pg 1 -y 180 -defaultsOSRD
preplace port jd -pg 1 -y 90 -defaultsOSRD
preplace port S_AXI -pg 1 -y 130 -defaultsOSRD
preplace inst zpuino_uart_1 -pg 1 -lvl 2 -y 150 -defaultsOSRD
preplace inst pmod_bridge_0 -pg 1 -lvl 3 -y 90 -defaultsOSRD
preplace inst uart_axibridge1 -pg 1 -lvl 1 -y 150 -defaultsOSRD
preplace netloc Conn1 1 3 1 N
preplace netloc bonfire_axi4l2wb_1_wb_clk_o 1 1 1 N
preplace netloc bonfire_axi4l2wb_1_WB_MASTER 1 1 1 N
preplace netloc zpuino_uart_1_wb_inta_o 1 2 2 610J 180 N
preplace netloc rst_mig_7series_0_83M_peripheral_aresetn 1 0 1 NJ
preplace netloc mig_7series_0_ui_clk 1 0 1 NJ
preplace netloc bonfire_axi4l2wb_1_wb_rst_o 1 1 1 N
preplace netloc zpuino_uart_1_UART 1 2 1 610
preplace netloc bonfire_axi_top_0_axi_periph_M04_AXI 1 0 1 NJ
levelinfo -pg 1 -20 160 470 780 960 -top 0 -bot 290
",
}

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

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.MAX_BURST_LENGTH {1} \
 ] [get_bd_intf_pins /uart0/uart_axibridge_0/S_AXI]

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

  # Perform GUI Layout
  regenerate_bd_layout -hierarchy [get_bd_cells /uart0] -layout_string {
   ExpandedHierarchyInLayout: "",
   guistr: "# # String gsaved with Nlview 6.8.5  2018-01-30 bk=1.4354 VDI=40 GEI=35 GUI=JA:1.6 TLS
#  -string -flagsOSRD
preplace port S_AXI_ACLK -pg 1 -y 80 -defaultsOSRD
preplace port S_AXI_ARESETN -pg 1 -y 100 -defaultsOSRD
preplace port wb_inta_o -pg 1 -y 70 -defaultsOSRD
preplace port usb_uart -pg 1 -y 50 -defaultsOSRD
preplace port S_AXI -pg 1 -y 60 -defaultsOSRD
preplace inst zpuino_uart_0 -pg 1 -lvl 2 -y 80 -defaultsOSRD
preplace inst uart_axibridge_0 -pg 1 -lvl 1 -y 80 -defaultsOSRD
preplace netloc Conn1 1 2 1 NJ
preplace netloc bonfire_axi_top_0_axi_periph_M03_AXI 1 0 1 NJ
preplace netloc zpuino_uart_0_wb_inta_o 1 2 1 NJ
preplace netloc bonfire_axi4l2wb_0_wb_rst_o 1 1 1 N
preplace netloc rst_mig_7series_0_83M_peripheral_aresetn 1 0 1 NJ
preplace netloc bonfire_axi4l2wb_0_wb_clk_o 1 1 1 N
preplace netloc mig_7series_0_ui_clk 1 0 1 NJ
preplace netloc bonfire_axi4l2wb_0_WB_MASTER 1 1 1 N
levelinfo -pg 1 -20 160 470 630 -top -10 -bot 170
",
}

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
  set sys_clock_0 [ create_bd_port -dir I -type clk sys_clock_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   CONFIG.PHASE {0.000} \
 ] $sys_clock_0

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
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_GPIO2_WIDTH {4} \
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

  #set_property -dict [ list \
   #CONFIG.SUPPORTS_NARROW_BURST {0} \
   #CONFIG.NUM_READ_OUTSTANDING {1} \
   #CONFIG.NUM_WRITE_OUTSTANDING {1} \
   #CONFIG.MAX_BURST_LENGTH {1} \
 #] [get_bd_intf_pins /bonfire_gpio_core_0/S_AXI]

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
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $clk_wiz_0

  # Create instance: mig_7series_0, and set properties
  set mig_7series_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.1 mig_7series_0 ]

  # Generate the PRJ File for MIG
  set str_mig_folder [get_property IP_DIR [ get_ips [ get_property CONFIG.Component_Name $mig_7series_0 ] ] ]
  set str_mig_file_name board.prj
  set str_mig_file_path ${str_mig_folder}/${str_mig_file_name}

  write_mig_file_design_1_mig_7series_0_0 $str_mig_file_path

  set_property -dict [ list \
   CONFIG.BOARD_MIG_PARAM {ddr3_sdram} \
   CONFIG.XML_INPUT_FILE {board.prj} \
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
  connect_bd_net -net sys_clock_0_1 [get_bd_ports sys_clock_0] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net wishbone_subsystem_0_ether_irq_out [get_bd_pins bonfire_axi_top_0/ext_irq_i] [get_bd_pins wishbone_subsystem_0/ether_irq_out]
  connect_bd_net -net wishbone_subsystem_0_flash_spi_clk [get_bd_ports flash_spi_clk] [get_bd_pins wishbone_subsystem_0/flash_spi_clk]
  connect_bd_net -net wishbone_subsystem_0_flash_spi_cs [get_bd_ports flash_spi_cs] [get_bd_pins wishbone_subsystem_0/flash_spi_cs]
  connect_bd_net -net wishbone_subsystem_0_flash_spi_mosi [get_bd_ports flash_spi_mosi] [get_bd_pins wishbone_subsystem_0/flash_spi_mosi]
  connect_bd_net -net zpuino_uart_0_wb_inta_o [get_bd_pins bonfire_axi_top_0/lirq6_i] [get_bd_pins uart0/wb_inta_o]
  connect_bd_net -net zpuino_uart_1_wb_inta_o [get_bd_pins bonfire_axi_top_0/lirq5_i] [get_bd_pins uart1/wb_inta_o]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x80E00000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs axi_ethernetlite_0/S_AXI/Reg] SEG_axi_ethernetlite_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80000000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80010000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80040000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs pmod_jb_spi/axi_quad_spi_0/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80020000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs uart0/uart_axibridge_0/S_AXI/reg0] SEG_bonfire_axi4l2wb_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x80030000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs uart1/uart_axibridge1/S_AXI/reg0] SEG_bonfire_axi4l2wb_1_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x80050000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DP] [get_bd_addr_segs bonfire_gpio_core_0/S_AXI/reg0] SEG_bonfire_gpio_core_0_reg0
  create_bd_addr_seg -range 0x10000000 -offset 0x00000000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_IC] [get_bd_addr_segs mig_7series_0/memmap/memaddr] SEG_mig_7series_0_memaddr
  create_bd_addr_seg -range 0x10000000 -offset 0x00000000 [get_bd_addr_spaces bonfire_axi_top_0/M_AXI_DC] [get_bd_addr_segs mig_7series_0/memmap/memaddr] SEG_mig_7series_0_memaddr

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   ExpandedHierarchyInLayout: "",
   guistr: "# # String gsaved with Nlview 6.8.5  2018-01-30 bk=1.4354 VDI=40 GEI=35 GUI=JA:1.6 TLS
#  -string -flagsOSRD
preplace port flash_spi_cs -pg 1 -y 230 -defaultsOSRD
preplace port shield_dp0_dp19 -pg 1 -y 680 -defaultsOSRD
preplace port ddr3_sdram -pg 1 -y 1180 -defaultsOSRD
preplace port flash_spi_mosi -pg 1 -y 270 -defaultsOSRD
preplace port eth_mii -pg 1 -y 60 -defaultsOSRD
preplace port jb -pg 1 -y 890 -defaultsOSRD
preplace port eth_mdio_mdc -pg 1 -y 80 -defaultsOSRD
preplace port sys_clock_0 -pg 1 -y 1440 -defaultsOSRD
preplace port jd -pg 1 -y 1482 -defaultsOSRD
preplace port usb_uart -pg 1 -y 1040 -defaultsOSRD
preplace port flash_spi_miso -pg 1 -y 240 -defaultsOSRD
preplace port push_buttons_4bits -pg 1 -y 430 -defaultsOSRD
preplace port flash_spi_clk -pg 1 -y 250 -defaultsOSRD
preplace port eth_ref_clk -pg 1 -y 1400 -defaultsOSRD
preplace port led_4bits -pg 1 -y 560 -defaultsOSRD
preplace port reset -pg 1 -y 1420 -defaultsOSRD
preplace port jb_miso -pg 1 -y 20 -defaultsOSRD
preplace port dip_switches_4bits -pg 1 -y 410 -defaultsOSRD
preplace inst rst_mig_7series_0_83M -pg 1 -lvl 1 -y 1130 -defaultsOSRD
preplace inst mig_7series_0 -pg 1 -lvl 4 -y 1220 -defaultsOSRD
preplace inst bonfire_gpio_core_0 -pg 1 -lvl 4 -y 720 -defaultsOSRD
preplace inst wishbone_subsystem_0 -pg 1 -lvl 4 -y 260 -defaultsOSRD
preplace inst bonfire_axi_top_0 -pg 1 -lvl 2 -y 960 -defaultsOSRD
preplace inst axi_gpio_0 -pg 1 -lvl 4 -y 560 -defaultsOSRD
preplace inst uart0 -pg 1 -lvl 4 -y 1050 -defaultsOSRD
preplace inst axi_gpio_1 -pg 1 -lvl 4 -y 420 -defaultsOSRD
preplace inst uart1 -pg 1 -lvl 4 -y 1460 -defaultsOSRD
preplace inst axi_ethernetlite_0 -pg 1 -lvl 4 -y 80 -defaultsOSRD
preplace inst BootMem_0 -pg 1 -lvl 3 -y 940 -defaultsOSRD
preplace inst pmod_jb_spi -pg 1 -lvl 4 -y 890 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 3 -y 1430 -defaultsOSRD
preplace inst bonfire_axi_top_0_axi_periph -pg 1 -lvl 3 -y 600 -defaultsOSRD
preplace inst axi_mem_intercon -pg 1 -lvl 3 -y 1180 -defaultsOSRD
preplace netloc bonfire_axi_top_0_axi_periph_M03_AXI 1 3 1 1140
preplace netloc zpuino_uart_0_wb_inta_o 1 1 4 410 1550 NJ 1550 NJ 1550 1570
preplace netloc wishbone_subsystem_0_flash_spi_mosi 1 4 1 NJ
preplace netloc mig_7series_0_mmcm_locked 1 0 5 30 1530 NJ 1530 NJ 1530 NJ 1530 1540
preplace netloc axi_ethernetlite_0_MDIO 1 4 1 NJ
preplace netloc wishbone_subsystem_0_flash_spi_clk 1 4 1 NJ
preplace netloc mig_7series_0_DDR3 1 4 1 NJ
preplace netloc wishbone_subsystem_0_ether_irq_out 1 1 4 400 1330 NJ 1330 NJ 1330 1580
preplace netloc bonfire_axi_top_0_axi_periph_M06_AXI 1 3 1 1120
preplace netloc zpuino_uart_1_wb_inta_o 1 1 4 420 1560 NJ 1560 NJ 1560 1550
preplace netloc rst_mig_7series_0_83M_peripheral_aresetn 1 1 3 N 1170 700 360 1110
preplace netloc pmod_bridge_0_Pmod_out 1 4 1 NJ
preplace netloc bonfire_gpio_core_0_GPIO 1 4 1 NJ
preplace netloc bonfire_axi_top_0_axi_periph_M05_AXI 1 3 1 1130
preplace netloc bonfire_axi_top_0_axi_periph_M01_AXI 1 3 1 1080
preplace netloc bonfire_axi_top_0_BRAM_A 1 2 1 N
preplace netloc axi_mem_intercon_M00_AXI 1 3 1 N
preplace netloc uart1_jd 1 4 1 1580
preplace netloc z_uart0_usb_uart 1 4 1 NJ
preplace netloc axi_gpio_1_GPIO2 1 4 1 NJ
preplace netloc bonfire_axi_top_0_BRAM_B 1 2 1 N
preplace netloc rst_mig_7series_0_83M_mb_reset 1 1 3 390 300 NJ 300 N
preplace netloc mig_7series_0_ui_clk 1 0 5 20 870 400 800 740 350 1100 1320 1530
preplace netloc flash_spi_miso_1 1 0 4 NJ 240 NJ 240 NJ 240 NJ
preplace netloc bonfire_gpio_core_0_rise_irq_o 1 1 4 430 810 760J 840 1060J 970 1570
preplace netloc bonfire_axi_top_0_M_AXI_IC 1 2 1 730
preplace netloc bonfire_axi_top_0_M_AXI_DP 1 2 1 710
preplace netloc bonfire_axi_top_0_M_AXI_DC 1 2 1 720
preplace netloc wishbone_subsystem_0_flash_spi_cs 1 4 1 NJ
preplace netloc clk_wiz_0_clk_out1 1 3 1 1080
preplace netloc axi_gpio_0_GPIO 1 4 1 NJ
preplace netloc bonfire_axi_top_0_axi_periph_M02_AXI 1 3 1 1070
preplace netloc mig_7series_0_ui_clk_sync_rst 1 0 5 20 1540 NJ 1540 NJ 1540 NJ 1540 1560
preplace netloc clk_wiz_0_clk_out2 1 3 1 1140
preplace netloc axi_ethernetlite_0_ip2intc_irpt 1 3 2 1140 160 1580
preplace netloc bonfire_gpio_core_0_fall_irq_o 1 1 4 430 1110 710J 1030 1060J 1120 1530
preplace netloc sys_clock_0_1 1 0 3 NJ 1440 NJ 1440 NJ
preplace netloc clk_wiz_0_clk_out3 1 3 2 1060J 1380 1580J
preplace netloc axi_ethernetlite_0_MII 1 4 1 NJ
preplace netloc axi_gpio_1_GPIO 1 4 1 NJ
preplace netloc bonfire_axi_top_0_WB_DB 1 2 2 690 220 NJ
preplace netloc rst_mig_7series_0_83M_interconnect_aresetn 1 1 2 N 1150 750
preplace netloc reset_1 1 0 4 NJ 1420 NJ 1420 730 1340 1090
preplace netloc bonfire_axi_top_0_axi_periph_M04_AXI 1 3 1 1070
preplace netloc bonfire_axi_top_0_axi_periph_M00_AXI 1 3 1 N
levelinfo -pg 1 0 210 560 910 1380 1600 -top -180 -bot 2030
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


