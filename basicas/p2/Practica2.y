%{
	#include "lista.c"
	#include <stdio.h>
	void yyerror (char const *);
	extern FILE *yyin;
	nodo *lista;
	nodo *result;
	camposSelect cS;

	
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
%token <valInt> NUMERO
%type <valInt> empleados 
%start S
%%
S : empleados
	| consultas
	;

empleados : empleados NUMERO ',' STRING ',' STRING ',' NUMERO {lista=insertarLista(lista,$2,$4,$6,$8);/*printf("Nombre: %s\n",$3);*/}
	| NUMERO ',' STRING ',' STRING ',' NUMERO {lista=insertarLista(lista,$1,$3,$5,$7);/*printf("Nombre: %s\n",$2);*/}
	;
	
consultas: consultas consulta {imprimirResultado(result,cS);
					cS.idEmpleado=FALSE;cS.nombre=FALSE;cS.puesto=FALSE;cS.anho=FALSE;}
	| consulta {imprimirResultado(result,cS);
					cS.idEmpleado=FALSE;cS.nombre=FALSE;cS.puesto=FALSE;cS.anho=FALSE;}
	;

consulta : select_line from_line
	| select_line from_line where_line
	;
	
select_line : SELECT '*' {cS.idEmpleado=TRUE;cS.nombre=TRUE;cS.puesto=TRUE;cS.anho=TRUE;}
	| SELECT campo 
	| SELECT campo ',' '*' {yyerror("Error sintáctico: no se puede poner '*' e identificadores al mismo tiempo");}
	| SELECT '*' ',' campo {yyerror("Error sintáctico: no se puede poner '*' e identificadores al mismo tiempo");}
	;
	
campo : campo ID_EMPLEADO {cS.idEmpleado=TRUE;}
	| campo NOMBRE {cS.nombre=TRUE;}
	| campo PUESTO {cS.puesto=TRUE;}
	| campo ANHO {cS.anho=TRUE;}
	| campo ',' ID_EMPLEADO {cS.idEmpleado=TRUE;}
	| campo ',' NOMBRE {cS.nombre=TRUE;}
	| campo ',' PUESTO {cS.puesto=TRUE;}
	| campo ',' ANHO {cS.anho=TRUE;}
	| ',' ID_EMPLEADO {cS.idEmpleado=TRUE;}
	| ',' NOMBRE {cS.nombre=TRUE;}
	| ',' PUESTO {cS.puesto=TRUE;}
	| ',' ANHO {cS.anho=TRUE;}
	| ID_EMPLEADO {cS.idEmpleado=TRUE;}
	| NOMBRE {cS.nombre=TRUE;}
	| PUESTO {cS.puesto=TRUE;}
	| ANHO {cS.anho=TRUE;}
	| STRING {char dError[200] = "Error sintáctico: Identificador '";
				 strcat(dError,$1);
				 strcat(dError,"' desconocido");
				 yyerror(dError);}
	;
	
from_line : FROM STRING
	| FROM STRING ';' {result=lista;}
	;

where_line : 
	  WHERE ID_EMPLEADO '<' NUMERO ';' {result=filtrarListaWhere(lista, MID_EMPLEADO, MENOR, NULL, $4);}
	| WHERE ANHO '<' NUMERO ';' {result=filtrarListaWhere(lista, MANHO, MENOR, NULL, $4);}
	| WHERE ID_EMPLEADO '>' NUMERO ';' {result=filtrarListaWhere(lista, MID_EMPLEADO, MAYOR, NULL, $4);}
	| WHERE ANHO '>' NUMERO ';' {result=filtrarListaWhere(lista, MANHO, MAYOR, NULL, $4);}
	| WHERE ID_EMPLEADO '=' NUMERO ';' {result=filtrarListaWhere(lista, MID_EMPLEADO, IGUAL, NULL, $4);}
	| WHERE NOMBRE '=' STRING ';' {result=filtrarListaWhere(lista, MNOMBRE, IGUAL, $4, -1);}
	| WHERE PUESTO '=' STRING ';' {result=filtrarListaWhere(lista, MPUESTO, IGUAL, $4, -1);}
	| WHERE ANHO '=' NUMERO ';' {result=filtrarListaWhere(lista, MANHO, IGUAL, NULL, $4);}
	| WHERE NUMERO '<' ID_EMPLEADO ';' {result=filtrarListaWhere(lista, MID_EMPLEADO, MAYOR, NULL, $2);}
	| WHERE NUMERO '<' ANHO ';' {result=filtrarListaWhere(lista, MANHO, MAYOR, NULL, $2);}
	| WHERE NUMERO '>' ID_EMPLEADO ';' {result=filtrarListaWhere(lista, MID_EMPLEADO, MENOR, NULL, $2);}
	| WHERE NUMERO '>' ANHO ';' {result=filtrarListaWhere(lista, MANHO, MENOR, NULL, $2);}
	| WHERE NUMERO '=' ID_EMPLEADO ';' {result=filtrarListaWhere(lista, MID_EMPLEADO, IGUAL, NULL, $2);}
	| WHERE STRING '=' NOMBRE ';' {result=filtrarListaWhere(lista, MNOMBRE, IGUAL, $2,-1);}
	| WHERE STRING '=' PUESTO ';' {result=filtrarListaWhere(lista, MPUESTO, IGUAL, $2,-1);}
	| WHERE NUMERO '=' ANHO ';' {result=filtrarListaWhere(lista, MANHO, IGUAL, NULL, $2);}
	;
	
%%
int main(){
	lista = crearLista();
	result = crearLista();
	FILE *f;
	f = fopen("Empleados.txt","r");
	yyin= f;
	yyparse();
	//fclose(f);
	//imprimirLista(lista);
	//fclose(yyin);
	f=fopen("Consultas.txt","r");
	yyin=f;
	//fclose(f);
	//while(1){?
	yyparse();
	//}
	//imprimirLista(result);
	
	vaciarLista(lista);
	vaciarLista(result);
	return 0;
}
void yyerror (char const *message) { fprintf (stderr, "%s\n", message);}
