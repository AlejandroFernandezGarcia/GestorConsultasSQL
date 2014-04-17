%{
	#include "lista.c"
	#include <stdio.h>
	void yyerror (char const *);
	nodo *lista;
%}
%union{
	int valInt;
	char *valChar;
}
%error-verbose
%token <valInt> ID_EMPLEADO
%token <valChar> NOMBRE
%token <valChar> PUESTO
%token <valInt> ANHO
%type <valInt> empleados;
%start S
%%
S : empleados;

empleados : empleados ID_EMPLEADO NOMBRE PUESTO ANHO {lista=insertarLista(lista,$2,$3,$4,$5);/*printf("Nombre: %s\n",$3);*/}
	| ID_EMPLEADO NOMBRE PUESTO ANHO {lista=insertarLista(lista,$1,$2,$3,$4);/*printf("Nombre: %s\n",$2);*/}
	;
%%
int main(){
	lista = crearLista();
	yyparse();
	imprimirLista(lista);
	return 0;
}
void yyerror (char const *message) { fprintf (stderr, "%s\n", message);}
