%{
	#include <stdlib.h>
	unsigned numComas=0;
%}
idEmpleado [1-9][0-9]*
nombreOPuesto [^\x2C\x2E\t\n]+
anho [1-9][0-9]{3}\n
comas [\x2C]
%%
{idEmpleado} {printf("Id empleado: %s\n",yytext);}
{nombreOPuesto}	{if((numComas % 3)== 1){
							printf("Nombre: %s\n",yytext);
						}else{
							printf("Puesto: %s\n",yytext);
						}}
{anho}	{printf("Año: %s\n",yytext);}
{comas}	{numComas++;}
%%
main(){
	yylex();
	exit(0);
}
