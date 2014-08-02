#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct tcamposSelect{
	int idEmpleado;
	int nombre;
	int puesto;
	int anho;
}camposSelect;

struct tnodo {
	int idEmpleado;
	char *nombre;
	char *puesto;
	int anho;
	
	struct tnodo *sig;
};
typedef struct tnodo nodo;

nodo* crearLista();
nodo* insertarLista(nodo *l,int idEmpleado,char *nombre, char *puesto,int anho);
nodo* filtrarListaWhere(nodo *l, int operando, int operador, char *operandoS, int operandoInt);
void vaciarLista(nodo *l);
void imprimirLista(nodo *l);
void imprimirResultado(nodo *l,camposSelect sC);
