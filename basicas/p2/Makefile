CC=gcc
CFLAGS= -lfl
TEST=Empleados.txt

all:
	flex Practica2.l
	$(CC) lex.yy.c $(CFLAGS) -o Practica2.out
execute: all
	cat $(TEST) | ./Practica2.out
clean:
	rm -f *.out *.c *~
