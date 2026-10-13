NOME = Ex20
NASM     = nasm
GCC      = gcc
ASMFLAGS = -f elf64
CFLAGS   = -no-pie
TARGET   = $(NOME)
OBJS     = $(NOME).o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(GCC) $(OBJS) -o $(TARGET) $(CFLAGS)

%.o: %.asm
	$(NASM) $(ASMFLAGS) $< -o $@

clean:
	rm -f *.o
	rm -f $(TARGET)

.PHONY: all clean
