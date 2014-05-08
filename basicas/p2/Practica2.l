%{
	#include <stdlib.h>
	#include "Practica2.tab.h"
	char *p;
%}
numero [0-9]+
string [^\x2C\x2E\t\n\x3B\x20]+
comas [\x2C]
%%
SELECT {return SELECT;}
ID_EMPLEADO {return ID_EMPLEADO;}
NOMBRE {return NOMBRE;}
PUESTO {return PUESTO;}
ANHO {return ANHO;}
\x2A {return '*';}
FROM {return FROM;}
WHERE {return WHERE;}
\x3C {yylval.valInt = '<';
		return OPERADOR;}
\x3D {yylval.valInt = '=';
		return OPERADOR;}
\x3E {yylval.valInt = '>';
		return OPERADOR;}
\x3B {return ';';}


{numero} {yylval.valInt = atoi(yytext);
				  return NUMERO;}
{string}	{
				p=(char*) malloc(sizeof(char)*strlen(yytext));
				strcpy(p,yytext);
				yylval.valChar = p;
				return STRING;
			}
{comas}	{return ',';}
\n
\x20
%%
