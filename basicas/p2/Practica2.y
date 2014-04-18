%{
	#include "lista.c"
	#include <stdio.h>
	void yyerror (char const *);
	extern FILE *yyin;
	nodo *lista;
	char const errorDescription;
	
%}
%union{
	int valInt;
	char *valChar;
}
%error-verbose
%token <valInt> ID_EMPLEADO
%token <valChar> STRING
%token <valChar> NOMBRE
%token <valChar> PUESTO
%token <valInt> ANHO
%token <valInt> SELECT
%token <valInt> FROM
%token <valInt> TABLA
%token <valInt> WHERE
%token <valInt> VALOR_I
%token <valInt> NUMERO
%type <valInt> empleados 
%start S
%%
S : empleados
	| consulta
	;

empleados : empleados NUMERO ',' STRING ',' STRING ',' NUMERO {lista=insertarLista(lista,$2,$4,$6,$8);/*printf("Nombre: %s\n",$3);*/}
	| NUMERO ',' STRING ',' STRING ',' NUMERO {lista=insertarLista(lista,$1,$3,$5,$7);/*printf("Nombre: %s\n",$2);*/}
	;
	
consulta : select_line from_line
	| select_line from_line where_line
	;
	
select_line : SELECT '*'
	| SELECT campo
	| SELECT campo ',' '*' {yyerror("Error sintáctico: no se puede poner '*' e identificadores al mismo tiempo");}
	| SELECT '*' ',' campo {yyerror("Error sintáctico: no se puede poner '*' e identificadores al mismo tiempo");}
	;
	
campo : campo ID_EMPLEADO 
	| campo NOMBRE 
	| campo PUESTO 
	| campo ANHO 
	| campo ',' ID_EMPLEADO
	| campo ',' NOMBRE
	| campo ',' PUESTO
	| campo ',' ANHO
	| ',' ID_EMPLEADO 
	| ',' NOMBRE
	| ',' PUESTO
	| ',' ANHO
	| ID_EMPLEADO
	| NOMBRE
	| PUESTO
	| ANHO
	| STRING {char dError[200] = "Error sintáctico: Identificador '";
				 strcat(dError,$1);
				 strcat(dError,"' desconocido");
				 yyerror(dError);}
	;
	
from_line : FROM STRING
	| FROM STRING ';' {printf("Consulta bien hecha");}
	;

where_line : where_line WHERE
	| ID_EMPLEADO '<' VALOR_I ';' 
	| NOMBRE '<' STRING ';'
	| PUESTO '<' STRING ';'
	| ANHO '<' VALOR_I ';'
	| ID_EMPLEADO '>' VALOR_I ';'
	| NOMBRE '>' STRING ';'
	| PUESTO '>' STRING ';'
	| ANHO '>' VALOR_I ';'
	| ID_EMPLEADO '=' VALOR_I ';'
	| NOMBRE '=' STRING ';'
	| PUESTO '=' STRING ';'
	| ANHO '=' VALOR_I ';'
	| VALOR_I '<' ID_EMPLEADO ';'
	| STRING '<' NOMBRE ';'
	| STRING '<' PUESTO ';'
	| VALOR_I '<' ANHO ';'
	| VALOR_I '>' ID_EMPLEADO ';'
	| STRING '>' NOMBRE ';'
	| STRING '>' PUESTO ';'
	| VALOR_I '>' ANHO ';'
	| VALOR_I '=' ID_EMPLEADO ';'
	| STRING '=' NOMBRE ';'
	| STRING '=' PUESTO ';'
	| VALOR_I '=' ANHO ';'
	;
	
%%
int main(){
	lista = crearLista();
	FILE *f;
	/*f = fopen("Empleados.txt","r");
	yyin= f;
	yyparse();
	//fclose(f);
	imprimirLista(lista);*/
	//fclose(yyin);
	f=fopen("Consultas.txt","r");
	yyin=f;
	//fclose(f);
	//while(1){?
		yyparse();
	//}
	
	
	vaciarLista(lista);
	return 0;
}
void yyerror (char const *message) { fprintf (stderr, "%s\n", message);}
