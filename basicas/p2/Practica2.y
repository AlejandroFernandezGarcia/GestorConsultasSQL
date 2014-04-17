%{
	#include <stdio.h>
	void yyerror (char const *);
	
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

empleados : empleados ID_EMPLEADO NOMBRE PUESTO ANHO {printf("Nombre: %s\n",$3);}
	| ID_EMPLEADO NOMBRE PUESTO ANHO {printf("Nombre: %s\n",$2);}
	;
%%
int main(){
	yyparse();
	return 0;
}
void yyerror (char const *message) { fprintf (stderr, "%s\n", message);}
