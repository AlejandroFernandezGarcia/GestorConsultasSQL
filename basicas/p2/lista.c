#include "lista.h"

#define TRUE 1
#define FALSE 0

#define IGUAL 61
#define MENOR 60
#define MAYOR 62

#define MID_EMPLEADO 5
#define MNOMBRE 6
#define MPUESTO 7
#define MANHO 8

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
	int i=0;
	while((tmp->puesto)[i]!='\0'){
		if((tmp->puesto)[i] == '_'){
			(tmp->puesto)[i] = ' ';
		}
		i++;
	}
	tmp->anho = anho;
	tmp->sig = NULL;
	
	while(p->sig != NULL){
		p = p->sig;
	}
	p->sig = tmp;
	return l;
}

nodo* filtrarListaWhere(nodo *l, int operando, int operador, char *operandoS, int operandoInt){
	nodo *resultado;
	resultado = crearLista();
	int bId;
	int bNombre;
	int bPuesto;
	int bAnho;
	nodo *x = l->sig;
	while(x->sig != NULL){
		bId = FALSE;
		bNombre = FALSE;
		bPuesto = FALSE;
		bAnho = FALSE;
		switch(operador){
			case IGUAL:
				switch(operando){
					case MID_EMPLEADO:
						if(x->idEmpleado == operandoInt){
							bId = TRUE;
						}
					break;
					/******************************************/
					/************Que no busque completo************/
					/************que busque alguna palabra de las pertenecientes************/
					case MNOMBRE:
						if(strcmp(x->nombre,operandoS)==0){
							bNombre = TRUE;
						}
					break;
					case MPUESTO:
						if(strcmp(x->puesto,operandoS)==0){
							bPuesto = TRUE;
						}
					break;
					/******************************************/
					case MANHO:
						if(x->anho == operandoInt){
							bAnho = TRUE;
						}
					break;
				}
			break;
			case MENOR:
				switch(operando){
					case MID_EMPLEADO:
						if(x->idEmpleado < operandoInt){
							bId = TRUE;
						}
					break;
					case MANHO:
						if(x->anho < operandoInt){
							bAnho = TRUE;
						}
					break;
				}
			break;
			case MAYOR:
				switch(operando){
					case MID_EMPLEADO:
						if(x->idEmpleado > operandoInt){
							bId = TRUE;
						}
					break;
					case MANHO:
						if(x->anho > operandoInt){
							bAnho = TRUE;
						}
					break;
				}
			break;
		}
		if(bId || bNombre || bPuesto || bAnho){
			resultado=insertarLista(resultado,x->idEmpleado,x->nombre,x->puesto,x->anho);
		}
		x = x->sig;
	}
	return resultado;
}

void filtrarListaSelect(nodo *l, int idEmpleado,char *nombre, char *puesto,int anho){

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
			printf("%d,%s,%s,%d\n",p->idEmpleado,p->nombre,p->puesto,p->anho);
			p=p->sig;	
		}
		
	}
}

