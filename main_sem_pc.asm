.data
	myFile: .asciiz "C:\\Users\\mathe\\Documents\\curso\\organização\\trabalho 01\\text.bin"      # filename for input
	buffer: .space 4000
	newline: .asciiz "\n"
	done: .asciiz "\n Programa terminado \n"

.text
	main:
	
		la $a1, myFile	#posiciona o arquivo
		jal openfile	#abre o arquivo
		
		addi	$sp, $sp, -4
		sw		$v1, 0($sp)
		#move $s0, $v1   #salva o descritor do arquivo retornado da função
		
		jal readfile	#le o arquivo
		
		li $v0, 4
		la $a0, done
		syscall
		
		li $v0, 10      # Finish the Program
		syscall
		
	
	openfile:
		li   $v0, 13          # id para abrir um arquivo
		move $a0, $a1      	  # nome da variavel
		li   $a1, 0           # flag para leitura
		li   $a2, 0           # não usado
		syscall               # abre o arquivo
		move $v1, $v0         # retorna o descritor do arquivo
		
		jr $ra  
	
	readfile:
	
		move $s0, $ra # guardar o registrador de jump
		
		while:
			li   $v0, 14        # id para ler arquivo							
			lw   $a0, 0($sp)		# descritor do arquivo
			la   $a1, buffer    # endereço do buffer
			li   $a2,  4        # quantidade de bytes para ler
			syscall             # lê o arquivo
			
			beq $v0, $zero, exit # se o retorno for nulo, acaba o loop
			
			la $t0, buffer		# pega a primeira posição do buffer
			lw $t1, 0($t0)
						
			move $a1, $t1		#posiciona a instrução em decimal
			#srl $a1, $a1, 26	#pega o op code
			

			jal print_binary	#transforma em binario
			
			
			
			#printa nova linha
			li $v0, 4
			la $a0, newline
			syscall
		
			j while		#repete o loop
	
		exit:
			move $ra, $s0 	#recupera o endereço de jump
			jr $ra			#jump
	
		
	
	print_binary:
	
		move	$t0, $a1
		addi	$t1, $zero, 31	# constant shift amount
		addi	$t2, $zero, 0	# variable shift amount
		addi	$t3, $zero, 32	# exit condition
		
		print_binary_loop:
			beq	$t2, $t3, return
		
			sllv	$a0, $t0, $t2
			srlv	$a0, $a0, $t1
			
			
		
			li	$v0, 1		# PRINT_INT
			syscall
		
			addi	$t2, $t2, 1
			j	print_binary_loop
		
		return:
		
			jr $ra
	
