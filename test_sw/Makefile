
.PHONY: all clean

ARCH ?= rv32im
ABI=ilp32
PLATFORM ?= ARTY_AXI

BOOTLINK=wildfboot.ld


TARGET_PREFIX ?= riscv-none-embed
TARGET_CC := $(TARGET_PREFIX)-gcc
TARGET_LD := $(TARGET_PREFIX)-gcc
TARGET_SIZE := $(TARGET_PREFIX)-size
TARGET_OBJCOPY := $(TARGET_PREFIX)-objcopy
HEXDUMP ?= hexdump


PLATFORMDIR=../lib/bonfire-software/platform

LINKDEF?=$(PLATFORMDIR)/$(PLATFORM)/firmware.ld


TARGET_CFLAGS +=  -march=$(ARCH) -mabi=$(ABI) -Wall -Os -g  -fomit-frame-pointer \
	-ffreestanding -fno-builtin  \
	-Wall -Werror=implicit-function-declaration \
	-D$(PLATFORM) -I$(PLATFORMDIR) -I$(PLATFORMDIR)/$(PLATFORM) 

TARGET_LDFLAGS += -march=$(ARCH) -mabi=$(ABI) -nostartfiles   \
	-Wl,-m,elf32lriscv --specs=nano.specs -Wl,-T$(LINKDEF) \
	-Wl,--gc-sections

all:  memsim.hex zpuino_uart.hex


%.o : %.S
	$(TARGET_CC) $(TARGET_CFLAGS) -c $<

%.o : %.c
	$(TARGET_CC) $(TARGET_CFLAGS) -c $<



%.hex : %.elf
	$(TARGET_OBJCOPY)  -O binary $< $(basename $@).bin
	$(HEXDUMP) -v -e '1/4 "%08x\n"' $(basename $@).bin >$@
	$(TARGET_PREFIX)-objdump -S -d $< >$(basename $@).lst
	$(TARGET_PREFIX)-objdump -s $< >$(basename $@).dmp
	$(TARGET_PREFIX)-size  $<

	
memsim.elf: start.o memsim.o  mempattern.o
	$(TARGET_LD) -o $@ $(TARGET_LDFLAGS) start.o memsim.o  mempattern.o
	

zpuino_uart.elf: start.o zpuino_uart.o
	$(TARGET_LD) -o $@ $(TARGET_LDFLAGS) start.o zpuino_uart.o

	
dram_codesim.elf : start.o dram_codesim.o
	$(TARGET_LD) -o $@ $(TARGET_LDFLAGS) start.o dram_codesim.o


	
	

