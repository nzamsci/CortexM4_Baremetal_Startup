TOOLCHAIN = arm-none-eabi-
CC = $(TOOLCHAIN)gcc
LD = $(CC)
OBJCOPY = $(TOOLCHAIN)objcopy
OBJDUMP = $(TOOLCHAIN)objdump

CC_FLAGS = -c -mthumb -mcpu=cortex-m4 -fdiagnostics-color=never
LINKER_SCRIPT = arm_gcc.ld
LD_FLAGS = -T$(LINKER_SCRIPT) -nostartfiles --specs=nosys.specs -fdiagnostics-color=never 

all: prog.elf prog.bin debug clean

prog.bin: prog.elf
	$(OBJCOPY) -O binary $< $@

prog.elf: main.o startup.o
	$(LD) $^ $(LD_FLAGS) -o $@
	
main.o:
startup.o:

%.o: %.c
	$(CC) $< $(CC_FLAGS) -o $@ 
	
debug: main.o startup.o prog.elf
	$(OBJDUMP) prog.elf --section-headers > "debug/prog_headers.txt"
	$(OBJDUMP) prog.elf --disassemble-all > "debug/prog_disassembly.txt"
	$(OBJDUMP) main.o --section-headers > "debug/main_headers.txt"
	$(OBJDUMP) startup.o --section-headers > "debug/startup_headers.txt"
	
# use special windows commands to clean object files
clean: 
	 -del -fR *.o	
	


