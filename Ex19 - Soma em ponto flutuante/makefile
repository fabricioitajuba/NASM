NOME = Ex19

# Variáveis para facilitar alterações futuras
NASM    = nasm
GCC     = gcc
ASMFLAGS = -f elf64
CFLAGS   = -no-pie

# Nome do executável final
TARGET   = $(NOME)

# Lista de arquivos objeto (.o) necessários
OBJS     = $(NOME).o

# Regra padrão (é executada ao rodar apenas 'make')
all: $(TARGET)

# Regra para linkar o executável
$(TARGET): $(OBJS)
	$(GCC) $(OBJS) -o $(TARGET) $(CFLAGS)

# Regra para compilar o arquivo .asm em .o
%.o: %.asm
	$(NASM) $(ASMFLAGS) $< -o $@

# Regra para limpar os arquivos gerados temporariamente
clean:
	#rm -f $(OBJS) $(TARGET)
	rm -rf *.o;
	rm -f $(TARGET)

# Evita conflitos caso existam arquivos chamados 'all' ou 'clean'
.PHONY: all clean

