######################################################################
## Fichero: Vectores.asm
## Descripción: Programa ensamblador 
## Fecha última modificación: 2016-03-09
## Autores: José Ignacio Gómez García (2016), Óscar Gómez Borzdynski (2016)
## Asignatura: E.C. 1º grado
## Grupo de Prácticas: 2101 
## Grupo de Teoría: 210
## Práctica: 4
## Ejercicio: 1
######################################################################
 
#############################
# Equivalente en C
# #define N 10 //Deberá funcionar para valores de N entre 5 y 20
# int A[N]={2,2,4,6,5,6,7,8,9,10};
# int B[N]={-1,-5,4,10,1,-2,5,10,-10,0};
# int C[N];
# int main()
# {
# 	int i;
# 	for(i=0; i<N; i++)
# 		C[i]=A[i]-B[i]*8;
# 	while(1);
# }
#############################
  
####################################################################
# $t0 es i
# $t1 es N
# $t2 es la comprobación del slt
# $t3 es A[i]
# $t4 es B[i]
# $s0 es 8*B[i]
# $s1 es A[i] - 8*B[i], que es el resultado final de cada iteración
####################################################################
.text 
main:	addi $t0, $0, 0 #inicializamos un 0 en $t0
	lw $t1, N #Cargamos n en $t1 
	add $t1, $t1, $t1 # Multiplicamos N por 4 para los bucles
	add $t1, $t1, $t1
for: 	slt $t2, $t0, $t1 # Si i<4N continua el bucle, ya que i aumenta de 4 en 4 y queremos N iteraciones
	beq $t2, $0, bucle # Si no es la condición anterior, sale del for
	lw $t3, A($t0) # $t3 = A[i]
	lw $t4, B($t0) # $t4 = B[i]
	add $s0, $t4, $t4 # Multiplicamos 8 * B[i]
	add $s0, $s0, $s0
	add $s0, $s0, $s0
	sub $s1, $t3, $s0 # Restamos A[i] - B[i]*8
	sw $s1, C($t0) # Guardamos el resultado en C[i]
	addi $t0, $t0, 4 # Incrementamos el dato i 
	j for # Volvemos al bucle for
	
bucle: j bucle

.data: 0x2000
N: 6 #número de elementos del vector
A: 2, 4, 6, 8, 10, 12 #vector A
B: -1,-5, 4, 10, 1, -5 #vector B
C: .space 40 #vector C, destino de las operaciones a realizar
