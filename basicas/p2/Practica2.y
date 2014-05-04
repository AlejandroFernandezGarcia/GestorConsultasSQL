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
%token <valInt> OPERADOR
%type <valInt> identificador_n identificador_s
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
	| error {cS.idEmpleado=FALSE;cS.nombre=FALSE;cS.puesto=FALSE;cS.anho=FALSE;}
	;

consulta : select_line from_line
	| select_line from_line where_line
	;
	
select_line : SELECT '*' {cS.idEmpleado=TRUE;cS.nombre=TRUE;cS.puesto=TRUE;cS.anho=TRUE;}
	| SELECT campos 
	| SELECT campos ',' '*' {yyerror("Error sintáctico: no se puede poner '*' e identificadores al mismo tiempo");YYERROR;}
	| SELECT '*' ',' campos {yyerror("Error sintáctico: no se puede poner '*' e identificadores al mismo tiempo");YYERROR;}
	// Sobra?¿?¿| STRING {yyerror("Error sintáctico: La consulta debe comenzar por SELECT");YYERROR;}
	| STRING '*' {yyerror("Error sintáctico: La consulta debe comenzar por SELECT");YYERROR;}
	| STRING campos {yyerror("Error sintáctico: La consulta debe comenzar por SELECT");YYERROR;}
	;
	
campos : campos ',' campo
	| campo
	| campo campo {yyerror("Error sintáctico: Los identificadores tienen que ir separados por comas");YYERROR;}
	;
	
campo : ID_EMPLEADO {cS.idEmpleado=TRUE;}
	| NOMBRE {cS.nombre=TRUE;}
	| PUESTO {cS.puesto=TRUE;}
	| ANHO {cS.anho=TRUE;}
	| STRING {char dError[200] = "Error sintáctico: Identificador '";
				 strcat(dError,$1);
				 strcat(dError,"' desconocido");
				 yyerror(dError);
				 YYERROR;}
	;
	
from_line : FROM STRING {if(!(((strcmp($2,"EMPLEADO")==0))||(strcmp($2,"empleado")==0))){
									char dError[200] = "Error: La tabla '";
									strcat(dError,$2);
									strcat(dError,"' no existe");
									yyerror(dError);
									YYERROR;
								}}
	| FROM STRING ';' {if(!(((strcmp($2,"EMPLEADO")==0))||(strcmp($2,"empleado")==0))){
									char dError[200] = "Error: La tabla '";
									strcat(dError,$2);
									strcat(dError,"' no existe");
									yyerror(dError);
									YYERROR;
								}else{
								result=lista;}}
	;


identificador_n : ID_EMPLEADO {$$ = MID_EMPLEADO;}
	| ANHO {$$ = MANHO;}
	;
	
identificador_s : NOMBRE {$$ = MNOMBRE;}
	| PUESTO {$$ = MPUESTO;}
	;
	
where_line: WHERE where_exp
	| STRING where_exp {yyerror("Error: palabra clave WHERE no encontrada");YYERROR;}
	;	
	
where_exp : identificador_s OPERADOR STRING ';' {if($2 != IGUAL){
																		  		yyerror("Error: los string solo admiten el operador '='");YYERROR;
																		  	}else{
																		  		{result=filtrarListaWhere(lista, $1, IGUAL, $3, -1);}
																		  	}}
	| STRING OPERADOR identificador_s ';' {if($2 != IGUAL){
															  		yyerror("Error: los string solo admiten el operador '='");YYERROR;
															  	}else{
															  		{result=filtrarListaWhere(lista, $3, IGUAL, $1, -1);}
															  	}}
	| identificador_n OPERADOR NUMERO ';' {result=filtrarListaWhere(lista, $1, $2, NULL, $3);}
	| NUMERO OPERADOR identificador_n ';' {result=filtrarListaWhere(lista, $3, $2, NULL, $1);}
	//Errores incompatibilidad de tipos
	| identificador_n OPERADOR STRING ';' {yyerror("Error: tipos no comparables (número con string)");YYERROR;}
	| STRING OPERADOR identificador_n ';' {yyerror("Error: tipos no comparables (string con número)");YYERROR;}
	| identificador_s OPERADOR NUMERO ';' {yyerror("Error: tipos no comparables (string con número)");YYERROR;}
	| NUMERO OPERADOR identificador_s ';' {yyerror("Error: tipos no comparables (número con string)");YYERROR;}
	//Errores dos indentificadores
	| identificador_n OPERADOR identificador_n ';' {yyerror("Error: no se pueden comparar dos identificadores");YYERROR;}
	| identificador_s OPERADOR identificador_s ';' {yyerror("Error: no se pueden comparar dos identificadores");YYERROR;}
	| identificador_s OPERADOR identificador_n ';' {yyerror("Error: no se pueden comparar dos identificadores");YYERROR;}
	| identificador_n OPERADOR identificador_s ';' {yyerror("Error: no se pueden comparar dos identificadores");YYERROR;}
	//Errores dos operandos
	| NUMERO OPERADOR NUMERO ';' {yyerror("Error: no se pueden comparar dos operandos");YYERROR;}
	| STRING OPERADOR STRING ';' {yyerror("Error: no se pueden comparar dos operandos");YYERROR;}
	| NUMERO OPERADOR STRING ';' {yyerror("Error: no se pueden comparar dos operandos");YYERROR;}
	| STRING OPERADOR NUMERO ';' {yyerror("Error: no se pueden comparar dos operandos");YYERROR;}
	;
	
	//el where tengo que sacarlo para controlar el error de que la primera palabra no sea un WHERE
	//lo mismo con el ; ya que sino tengo que duplicar todo.
	/*Errores 2 operandos seguidos*/
	/*Errores 2 identificadores seguidos*/
	
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
void yyerror (char const *message) { 
	fprintf (stderr,"%s\n", message);
}
