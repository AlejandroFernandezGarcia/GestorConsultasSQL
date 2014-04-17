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
%token <valInt> ID_EMPLEADO
%token <valChar> NOMBRE
%token <valChar> PUESTO
%token <valInt> ANHO
%type <valInt> empleados
%start S
%%
S : empleados
	| consulta
	;

empleados : empleados ID_EMPLEADO NOMBRE PUESTO ANHO {lista=insertarLista(lista,$2,$3,$4,$5);/*printf("Nombre: %s\n",$3);*/}
	| ID_EMPLEADO NOMBRE PUESTO ANHO {lista=insertarLista(lista,$1,$2,$3,$4);/*printf("Nombre: %s\n",$2);*/}
	;
	
consulta : select_line from_line
	| select_line from_line where_line
	;
	
select_line : SELECT '*'
	| SELECT
	| select_line ID_EMPLEADO ','
	| select_line NOMBRE ','
	| select_line PUESTO ','
	| select_line ANHO ','
	| ID_EMPLEADO
	| NOMBRE
	| PUESTO
	| ANHO
	;
	
from_line : FROM TABLA;

where_line : where_line WHERE
	| VALOR '<' CAMPO ';'
	| VALOR '>' CAMPO ';'
	| VALOR '=' CAMPO ';'
	| CAMPO '<' VALOR ';'
	| CAMPO '>' VALOR ';'
	| CAMPO '=' VALOR ';'
	;
%%
int main(){
	lista = crearLista();
	
	/*yy1in=fopen( "entrada.conf","rt");
   if (!yyin)
   	cout<<"error al abrir"<<endl;

   yy1parse();*/
	
	datosparse();
	
	imprimirLista(lista);
	vaciarLista(lista);
	return 0;
}
void yyerror (char const *message) { fprintf (stderr, "%s\n", message);}
