######################################################################
## Fichero: Alcance.s
## Descripci�n: Programa que calcula el alcance en un movimiento parab�lico
## Fecha �ltima modificaci�n: 2016-03-16

## Autores: Jos� Ignacio G�mez (2016), �scar G�mez (2016)
## Asignatura: E.C. 1� grado
## Grupo de Pr�cticas: 2101
## Grupo de Teor�a: 210
## Pr�ctica: 4
## Ejercicio: 2
######################################################################

.text

main:		
	addi $sp, $0, 0x4000
	lw $s0, theta($0)
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal calculaAlcance
	lw $s1, 0($sp)
	addi $sp, $sp, 4
fin:
	j fin
	
calculaAlcance:
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	sll $t0, $t0, 2
	lw $t1, lut($t0)
	addi $sp, $sp, -4
	sw $t1, 0($sp)	
	jr $ra

.data
lut: 0, 6, 11, 17, 23, 28, 34, 39, 45, 50, 56, 61, 66, 72, 77, 82, 87, 91, 96, 101, 105, 109, 113, 117, 121, 125, 129, 132, 135, 138, 141, 144, 147, 149, 151, 153, 155, 157, 158, 160, 161, 162, 162, 163, 163, 163 ##datos del alcance
theta: 10
