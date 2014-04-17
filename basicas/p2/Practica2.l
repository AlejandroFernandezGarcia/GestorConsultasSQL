%{
	#include <stdlib.h>
	#include "Practica2.tab.h"
	unsigned numComas=0;
	char *p;
%}
%option noyywrap
idEmpleado [1-9][0-9]*
nombreOPuesto [^\x2C\x2E\t\n]+
anho [1-9][0-9]{3}\n
comas [\x2C]
%%
{idEmpleado} {yylval.valInt = atoi(datostext);
				  return ID_EMPLEADO;}
{nombreOPuesto}	{if((numComas % 3)== 1){
							p=(char*) malloc(sizeof(char)*strlen(datostext));
							strcpy(p,datostext);
							yylval.valChar = p;
							return NOMBRE;
						}else{
							p=(char*) malloc(sizeof(char)*strlen(datostext));
							strcpy(p,datostext);
							yylval.valChar = p;
							return PUESTO;
						}}
{anho}	{yylval.valInt = atoi(datostext);
			 return ANHO;}
{comas}	{numComas++;}
%%
