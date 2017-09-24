######################################################################
## Fichero: Desensamblar.s
## Descripción: Programa de desensamblado
## Fecha última modificación: 2016-03-16

## Autores: José Ignacio Gómez (2016), Óscar Gómez (2016)
## Asignatura: E.C. 1º grado
## Grupo de Prácticas: 2101
## Grupo de Teoría: 210
## Práctica: 4
## Ejercicio: 2
######################################################################

.text
	lui $1, 0xFA # Pone los bits más significativos de $1 a 0xFA
	ori $1, $1, 0xbada # Compara $1 con la función OR con 0xBADA y guarda el resutlado en $1
	lui $2, 0x423F # Pone los bits más significativos de $2 a 0x423F
	ori $2, $2, 0xEFDC # Compara $2 con la función OR con 0xEFDC y guarda el resutlado en $2
	sub $2, $1, $2 # Resta $1 - $2 y lo guarda en $2
	lw $4, cocacola($0) # Carga el dato cocacola (dirección 0x2000) en $4
	lw $5, bo($0) # Carga el dato bo (dirección 0x2004) en $5
	sll $5, $5, 8 # Multiplica $5 por 2^8
	addi $5, $5, 0x00B0 # Suma $5 + 0x00B0 y lo guarda en $5
	lw $6, boba($0) # Carga el dato boba (dirección 0x2008) en $6
	bne $5, $6, targetbne # Salta 4 posiciones, etiqueta targetbne
	xor $4, $5, $5 # Realiza un XOR entre $5 y $5 y lo guarda en $4
targetbne:
	xori $7, $5, 0x7A7A # Realiza un XOR de $5 y 0x7A7A y lo guarda en $7
fin:
	j fin # Bucle final
	
	

.data 0x00002000
	cocacola: 0xc0cac01a
	bo: 0x000000b0
	boba: 0x0000b0ba