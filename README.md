# NASM
Exemplos em linguagem assembly no pc utilizando o Linux e o Nasm

Utilizaremos o compilador nasm

## Para instalar:

$ sudo apt install nasm

## Para compilar em uma máquina de 32 bits:

$ nasm -f elf exemplo.asm

## Para compilar em uma máquina de 64 bits:

$ nasm -f elf64 exemplo.asm

## Para gerar o executável:

$ ld -s -o exemplo exemplo.o

## Para executar:

$ ./exemplo

## Documentação
https://www.nasm.us/