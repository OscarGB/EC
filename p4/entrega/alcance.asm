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
	addi $sp, $0, 0x4000 # Ponemos sp a 0x4000
	lw $s0, theta($0) # Guardamos el angulo en s0
	addi $sp, $sp, -4 # Disminuimos el puntero a pila para guardar en la posicion correcta
	sw $s0, 0($sp) # Guardamos el angulo en la pila
	jal calculaAlcance # Llamamos a la funcion alcance
	lw $s1, 0($sp) # Cargamos el resultado de la pila
	addi $sp, $sp, 4 # Aumentamos el puntero a pila para recuperar la posici�n original
fin:
	j fin # Bucle final
	
calculaAlcance:
	lw $t0, 0($sp) # Cargamos el dato desde la pila
	addi $sp, $sp, 4 # Aumentamos el puntero a pila para recuperar la posici�n original
	sll $t0, $t0, 2 # Multiplicamos el dato por 4 para poder utilizarlo para acceder al array
	lw $t1, lut($t0) # Accedemos al array y lo guardamos en t1
	addi $sp, $sp, -4 # Disminuimos el valor de sp para poder guardar el dato en la pila
	sw $t1, 0($sp) # Guardamos el resultado en la pila
	jr $ra # Volvemos a la rutina principal

.data
lut: 0, 6, 11, 17, 23, 28, 34, 39, 45, 50, 56, 61, 66, 72, 77, 82, 87, 91, 96, 101, 105, 109, 113, 117, 121, 125, 129, 132, 135, 138, 141, 144, 147, 149, 151, 153, 155, 157, 158, 160, 161, 162, 162, 163, 163, 163 ##datos del alcance
theta: 10 # �ngulo que se quiere obtener
