#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
nodo* filtrarLista(nodo *l, int idEmpleado,char *nombre, char *puesto,int anho);
void vaciarLista(nodo *l);
void imprimirLista(nodo *l);
