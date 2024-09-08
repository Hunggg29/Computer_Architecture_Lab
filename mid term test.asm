.data
Message:.asciiz  " i    power(2,i)   square(i)  Hexadecimal(i)"
mes3: .asciiz "0x"
space: .asciiz "        " #kho?ng tr?ng
.text
main:	
   	li $v0, 5             # ??c s? nguy�n t? b�n ph�m 
   	syscall              
   	move $t0, $v0        # l?u s? nguy�n v�o $t0
   	addi $t9, $t0, 0      # sao ch�p gi� tr? i sang $t9
 
	li $v0, 4 	#in d�ng ??u ti�n c?a b?ng 
 	la $a0, Message
 	syscall
 	
 	li $v0, 11 #in k� t? xu?ng d�ng 
 	li $a0, '\n'
 	syscall
 		
 
   	# g?i h�m t�nh l?y th?a c?a 2 (2^i)
  	move $a0, $t0          # l?u gi� tr? c?a i v�o $a0
   	jal power                 # g?i h�m power
   	move $s3, $v0          # l?u k?t qu? v�o $s3
 
	# g?i h�m t�nh b�nh ph??ng c?a s? nguy�n (i^2)
	move $a0, $t0          # l?u gi� tr? c?a i v�o $a0
   	jal  square             # g?i h�m square
   	move $s4, $v0          # l?u k?t qu? v�o $s4
        
        
        li $v0, 1                     # in ra s? nguy�n ?� nh?p v�o t? b�n ph�m
	add $a0, $zero, $t9        
	syscall                     
 
	li $v0, 4                     # ?n ra d?u c�ch 
  	la $a0, space                   
  	syscall                        
 
	li $v0, 1                     # in ra gi� tr? c?a h�m power
	add $a0, $zero, $s3          
	syscall                        
 
	li $v0, 4                     # ?n ra d?u c�ch 
  	la $a0, space                  
  	syscall                       
 
	li $v0, 1                     # in ra g�� tr? c?a h�m square
	add $a0, $zero, $s4           
	syscall
	                      
	li $v0, 4                     # in ra ??u c�ch 
  	la $a0, space                  
  	syscall                       
 	# g?i h�m ?? chuy?n sang s? hexa
        jal Hexa
	
exit:
        li $v0, 10		# k?t th�c ch??ng tr�nh 
        syscall

#h�m ?? t�nh power
 power:	
 	li $t0, 0 # kh?i t?o y = 0
 	li $t1, 1 #Kh?i t?o s? nh�n b?t ??u t? 1 
 loop_power:
 	beq $t0,$a0,end_power #y=i th� chuy?n end_power
 	sll $t1,$t1,1 #Nh�n v?i 2 
 	addi $t0,$t0,1 #y=y+1
 	j loop_power #ti?p t?c v�ng l?p 
 end_power:
 	move $v0,$t1 #??a k?t qu? thu ???c sang h�m $v0 
 	jr $ra #quay l?i 
 #h�m ?? t�nh square
 square:
 	mul $v0,$a0,$a0 #v0=a0*a0
 	jr $ra # quay l?i 
 #h�m ?? chuy?n sang ch? s? hexa 
Hexa: 
	add $v0,$t9,$zero	# sao ch�p gi� tr? c?a i v�o $v0 
	add $a0, $0, $v0 	# sao ch�p gi� tr? c?a i v�o $a0
	li $s7,16	#s7 = 16
	add $s1,$0,$0  # kh?i t?o i=0 
loop2:
	div $a0,$s7	# chia i cho 16 
	mfhi $t0        # $t0 ch?a ph?n d? 
	mflo $t1 	#t1 ch?a ph?n nguy�n 
	sw  $t0,0($sp)	# l?u ph?n d?u v�o ??nh ng?n x?p 
	beq $t1,$0,end_loop2	# n?u ph?n nguy�n =0 th� tho�t kh?i v�ng l?p 
	subi $sp,$sp,4	# gi?m con tr? ng?n x?p ?? l?u ph?n d? m?i 
	add $a0,$0,$t1	# c?p nh?t gi� tr? i b?ng ph?n nguy�n m?i 
	addi $s1,$s1,1  #i=i+1
	j loop2   # l?p l?i v�ng l?p 
end_loop2:
	li $v0, 4       #in chu?i mes3
	la $a0, mes3
	syscall
printHexa:
            
            slti $t1,$s1,0 #n?u i<0 
            beq $t1,1,exit2 # tho�t kh?i h�m printHexa
            lw $a0,0($sp) # l?y ph?n d? t? ??nh ng?n x?p 
            slti $t0, $a0, 10 # n?u ph?n d? < 10
            beq $t0, $0, else # chuy?n sang else
            li $v0,1 # n?u kh�ng th� in ra ch? s? Hexa
            syscall
            j end_if
            else:
                  addi $a0, $a0, -10 #??i gi� tr? ph?n d? ?? in ch? s? hexa
                  addi $a0, $a0, 'A' #??i gi� tr? ph?n d? ?? in ch? s? hexa
                  li $v0, 11    #in ch? s? hexa 
                  syscall
            end_if:

            subi $s1,$s1,1 #i=i-1
            addi $sp,$sp,4 #t?ng con tr? ng?n x?p l�n  
            j printHexa #l?p l?i h�m ?? in ra c�c ch? s? hexa ti?p theo 
exit2:
	jr $ra #quay l?i 