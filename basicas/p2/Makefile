CC=gcc
TEST=Empleados.txt
SOURCE=Practica2

all:
	flex $(SOURCE).l
	bison -o $(SOURCE).tab.c $(SOURCE).y -yd
	$(CC) -o $(SOURCE) lex.yy.c $(SOURCE).tab.c -lfl -ly
run: all
	cat $(TEST) | ./$(SOURCE)
clean:
	rm $(SOURCE) lex.yy.c $(SOURCE).tab.c $(SOURCE).tab.h *.~
