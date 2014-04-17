#include "lista.h"

nodo* crearLista(){
	nodo* l = (nodo*) malloc(sizeof(struct tnodo));
	l->sig = NULL;
	
	return l;
}

nodo* insertarLista(nodo *l,int idEmpleado,char *nombre, char *puesto,int anho){
	nodo* tmp = (nodo*) malloc(sizeof(struct tnodo));      
	if (tmp==NULL){
		printf("Error al reservar memoria \n");
		exit(EXIT_FAILURE);
	}	
	nodo *p = l;
	tmp->nombre = malloc((strlen(nombre)+1)*sizeof(char));
	tmp->puesto = malloc((strlen(puesto)+1)*sizeof(char));
	if (tmp->nombre==NULL){
		printf("Error al reservar memoria \n");
		exit(EXIT_FAILURE);
	}	
	if (tmp->puesto==NULL){
		printf("Error al reservar memoria \n");
		exit(EXIT_FAILURE);
	}
	tmp->idEmpleado = idEmpleado;	
	strcpy(tmp->nombre,nombre);
	strcpy(tmp->puesto,puesto);
	tmp->anho = anho;
	tmp->sig = NULL;
	
	while(p->sig != NULL){
		p = p->sig;
	}
	p->sig = tmp;
	return l;
}

nodo* filtrarLista(nodo *l, int idEmpleado,char *nombre, char *puesto,int anho){
	if(l->sig == NULL){
		return NULL; //lista vacia
	}
	nodo *x = l->sig;
	while((x->sig != NULL)&&((strcmp(x->nombre,nombre))!=0)){
		x = x->sig;
	}
	
	if((strcmp(x->nombre,nombre))==0){
		return x;
	}else return NULL;
}

void vaciarLista(nodo *l){
	nodo *tmp;
	tmp = l;
	l = l->sig;
	free(tmp);
	while(l != NULL){
		tmp = l;
		l = l->sig;
		free(tmp->nombre);
		free(tmp->puesto);
		free(tmp);
	}
}

void imprimirLista(nodo *l){
	nodo *p;
	p=l;
	if(p->sig == NULL){
		printf("Lista vacia \n");
	}else{
		p=p->sig;
		while(p != NULL){
			printf("%s=%s\n",p->nombre,p->puesto);
			p=p->sig;	
		}
		
	}
}

