create_hw_cfgmem -hw_device [lindex [get_hw_devices xc7a35t_0] 0] [lindex [get_cfgmem_parts {mt25ql128-spi-x1_x2_x4}] 0]
write_cfgmem  -format mcs -size 16 -interface SPIx4 -loadbit {up 0x00000000 "/home/thomas/development/fusesoc_build/vivado2021.2/bonfire-arty-a7_0/bld-vivado/bonfire-arty-a7_0.runs/impl_1/design_1_wrapper.bit" } -file "/home/thomas/bonfire.mcs"
