main: main.o coroutines.o
	ld -o main main.o coroutines.o /usr/lib/crt1.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

main.o: main.c
	gcc -c main.c

coroutines.o: coroutines.s
	fasm coroutines.s

poc: poc.asm
	fasm poc.s
