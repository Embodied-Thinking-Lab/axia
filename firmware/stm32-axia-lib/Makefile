
# toolchain
CROSS_COMPILE = arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
SIZE = $(CROSS_COMPILE)size

# target architechture
CPU = -mcpu=cortex-m4 -mthumb
FPU = -mfpu=fpv4-sp-d16 -mfloat-abi=hard

ARCH_FLAGS = $(CPU) $(FPU)


# project dirs
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin

TARGET = $(BIN_DIR)/stm32-blink.elf
BIN_FILE = $(BIN_DIR)/stm32-blink.bin
HEX_FILE = $(BIN_DIR)/stm32-blink.hex
MAP_FILE = $(BIN_DIR)/stm32-blink.map


# stm32 dependencies
CMSIS_DIR = ../STM32CubeF4/Drivers/CMSIS
DEVICE_DIR = $(CMSIS_DIR)/Device/ST/STM32F4xx

# compiler flags
CPPFLAGS = \
	-Iinclude \
	-I$(CMSIS_DIR)/Include \
	-I$(DEVICE_DIR)/Include \
	-DSTM32F446xx

CFLAGS = $(ARCH_FLAGS) \
	-std=gnu11 \
	-Wall \
	-Wextra \
	-Wpedantic \
	-g3 \
	-O0 \
	-ffunction-sections \
	-fdata-sections \
	-fno-common

ASFLAGS = $(ARCH_FLAGS) -g3

DEPFLAGS = -MMD -MP


# linker config
LDSCRIPT = linker/STM32F446RETX_FLASH.ld

LDFLAGS = $(ARCH_FLAGS) \
	--specs=nosys.specs \
	-T$(LDSCRIPT) \
	-Wl,--gc-sections \
	-Wl,-Map=$(MAP_FILE) \
	-nostartfiles


# source files

C_SOURCES = \
	src/main.c \
	src/uart_print.c \
	src/system_stm32f4xx.c \
	src/runtime.c \
	src/voltage.c \

ASM_SOURCES = \
	startup/startup_stm32f446xx.s


# object files

C_OBJECTS = $(patsubst src/%.c,$(OBJ_DIR)/src/%.o,$(C_SOURCES))

ASM_OBJECTS = $(patsubst startup/%.s,$(OBJ_DIR)/startup/%.o,$(ASM_SOURCES))

OBJECTS = $(C_OBJECTS) $(ASM_OBJECTS)

DEPFILES = $(C_OBJECTS:.o=.d)


# build targets

all: $(TARGET) $(BIN_FILE) $(HEX_FILE) size


# Create directories
dirs:
	mkdir -p $(OBJ_DIR)/src $(OBJ_DIR)/startup $(BIN_DIR)

# Compile C sources
$(OBJ_DIR)/src/%.o: src/%.c | dirs
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEPFLAGS) -c $< -o $@

# Assemble startup code
$(OBJ_DIR)/startup/%.o: startup/%.s | dirs
	$(CC) $(ASFLAGS) -c $< -o $@

# Link firmware
$(TARGET): $(OBJECTS) $(LDSCRIPT) | dirs
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

# Generate binary
$(BIN_FILE): $(TARGET)
	$(OBJCOPY) -O binary $< $@

# Generate Intel HEX
$(HEX_FILE): $(TARGET)
	$(OBJCOPY) -O ihex $< $@

# Display memory usage
size: $(TARGET)
	$(SIZE) $<

# Remove build artifacts
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all dirs size clean

# Include automatically generated header dependencies
-include $(DEPFILES)
