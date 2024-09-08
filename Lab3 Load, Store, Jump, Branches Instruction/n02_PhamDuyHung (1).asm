.eqv KEY_CODE 	0xFFFF0004 	# ASCII code from keyboard, 1 byte
.eqv KEY_READY 	0xFFFF0000 	# =1 if has a new keycode ?  			
.eqv MONITOR_SCREEN 0x10010000 

.eqv khoangcach 10 		# khoang cach giua 2 duong tron 
.eqv YELLOW 	0x00FFFF66	# mau cua duong tron 
.eqv BLACK	0x00000000 	# mau den trung voi background

# Thiet lap ky tu 
.eqv KEY_a 	0x00000061	# di chuyen sang trai
.eqv KEY_A 	0x00000041
.eqv KEY_d	0x00000064	# di chuyen sang phai
.eqv KEY_D	0x00000044
.eqv KEY_s	0x00000073	# di chuyen xuong duoi
.eqv KEY_S	0x00000053	
.eqv KEY_w	0x00000077	# di chuyen len tren
.eqv KEY_W	0x00000057
.eqv KEY_ENTER  0x0000000A	# dung lai

.data
circle:		.space 1000 	# mang de luu cac diem cua duong tron 
.text
setup:
	li $s0, 256 		# x = 255 khoi tao toa do ban dau x0 cua duong tron
	li $s1, 256 		# y = 255 khoi tao toa do ban dau y0 cua duong tron
	li $s2, 20 		# ban kinh duong tron R = 20 
	li $s3, 512 		# chieu rong man hinh = 512
	li $s4, 512 		# chieu dai man hinh = 512
	li $s5, YELLOW 		# duong tron co mau vang
	li $t6, khoangcach 	# khoang cach giua 2 duong tron
	li $s7, 0 		# toa do x hien tai cua tam duong tron dx = 0
	li $t8, 0 		# toa do y hien tai cua tam duong tron dy =0 
	li $t9, 200 		# toc do di chuyen cua hinh tron la 1

#--------------------------------------------------------------------------------------------------------------------------------------------------
# HAM KHOI TAO TOA DO DUONG TRON

khoi_tao:
	li $t0, 0  		#khoi tao i =0( toa do cua x)
	la $t5, circle 		#luu dia chi cua mang vao thanh ghi t5
circle_loop: 			# tao vong lap cho i di tu 0 > R
	slt $v0, $t0, $s2	# v0 = 1 neu i < R
	beq $v0, $0, ket_thuc	# neu i > R thi nhay toi end
	mul $s6, $s2, $s2 	# s6 = R*R = R^2
	mul $t3, $t0, $t0 	# t3 = i*i = i^2
	sub $t3, $s6, $t3	# t3 = R^2 - i^2
	move $v1, $t3		# v1 = t3
	jal sqrt 		# nhay den ham tinh can cua t3
	sw $a0, 0($t5)  	# luu gia tri cua a0 = sqrt(R^2-i^2) (toa do cua y) luu vao mang du lieu
	addi $t0, $t0, 1   	# i = i+1
	add $t5, $t5, 4   	# di den vi tri tiep theo cua mang de luu du lieu  
	j circle_loop
ket_thuc:

#---------------------------------------------------------------------------------------------------------------------------------------------------	
# HAM NHAP VA DOC DU LIEU TU BAN PHIM

bat_dau:
doc_ky_tu:
	lw $k1, KEY_READY 	# kiem tra xem da nhap ki tu vao hay chua
	beqz $k1, check_vi_tri 	# neu chua nhap ki tu, nhay den ham check_vi_tri
	lw $k0, KEY_CODE 	# neu da nhap ki tu, doc ma ki tu vao thanh ghi k0
	beq $k0, KEY_A, case_a 	# di sang trai
	beq $k0, KEY_a, case_a
	beq $k0, KEY_D, case_d 	# di sang phai
	beq $k0, KEY_d, case_d
	beq $k0, KEY_S, case_s 	# di xuong duoi
	beq $k0, KEY_s, case_s
	beq $k0, KEY_W, case_w 	# di len tren 
	beq $k0, KEY_w, case_w
	beq $k0, KEY_ENTER, case_enter # dung lai
	j   check_vi_tri 	# sau khi nhap ki tu thi nhay den ham check_vi_tri
	nop
case_a:
	jal go_left
	j check_vi_tri
case_d:
	jal go_right 
	j check_vi_tri
case_s:
	jal go_down
	j check_vi_tri
case_w:
	jal go_up
	j check_vi_tri
case_enter:
	li $v0, 10
	syscall

#-----------------------------------------------------------------------------------------------------------------------------------------------------
# CAC HAM DI CHUYEN

go_right: 			# cap nhat toa do cua x, giu nguyen toa do cua y
	add $s7, $0, $t6 	# toa do x cua duong tron moi = + khoang cach giua 2 duong tron 
	li $t8 , 0 
	jr $ra
go_left: 			# cap nhat toa do cua x, giu nguyen toa do cua y
	sub $s7, $0, $t6 	# toa do x cua duong tron moi = - khoang cach giua 2 duong tron
	li $t8, 0
	jr $ra
go_up: 				# cap nhat toa do cua y, giu nguyen toa do cua x
	li $s7, 0
	sub $t8, $0, $t6 	# toa do y cua duong tron moi = - khoang cach giua 2 duong tron 
	jr $ra
go_down: 			# cap nhat toa do cua y, giu nguyen toa do cua x
	li $s7, 0
	add $t8, $0, $t6 	# toa do y cua duong tron moi = + khoang cach giua 2 duong tron 
	jr $ra

#----------------------------------------------------------------------------------------------------------------------------------------------------
# HAM KIEM TRA VI TRI CUA DUONG TRON (xem duong tron co cham vao cac canh cua man hinh hay ko)

check_vi_tri:
ben_phai:
	add $v0, $s0, $s2 	# v0 = x0 + R, toa do x0 ban dau cua duong tron + ban kinh R
	add $v0, $v0, $s7 	# v0 = x0 + R + x, toa do x0 ban dau cua duong tron + ban kinh R + toa do x hien tai cua duong tron
	slt $v1, $v0, $s3 	# neu v0 < 512 thì v1 = 1 
	bne $v1, $0, ben_trai  
	jal go_left
	nop
ben_trai:
	sub $v0, $s0, $s2 	# v0 = x0 - R, toa do x0 ban dau cua duong tron - ban kinh R
	add $v0, $v0, $s7 	# v0 = x0 - R + x, toa do x0 ban dau cua duong tron - ban kinh R + toa do x hien tai cua duong tron
	slt $v1, $v0, $0 	# neu v0 < 0 thi v1 = 1
	beq $v1, $0, ben_tren
	jal go_right
	nop
ben_tren:
	sub $v0, $s1, $s2 	# v0 = y0 - R, toa do y0 ban dau cua duong tron - ban kinh R
	add $v0, $v0, $t8 	# v0 = y0 - R + y, toa do y0 ban dau cua duong tron - ban kinh R + toa do y hien tai cua duong tron 
	slt $v1, $v0, $0 	# neu v0 < 0 thi v1 = 1
	beq $v1, $0, ben_duoi # v1 = 1 thi nhay den ham ben_duoi
	jal go_down			# neu v0 > 0 thi nhay den ham go_down 
	nop
ben_duoi:
	add $v0, $s1, $s2 	# v0 = y0 + R, toa do y0 ban dau cua duong tron - ban kinh R 
	add $v0, $v0, $t8 	# v0 = y0 + R + y, toa do y0 ban dau cua duong tron - ban kinh R + toa do y hien tai cua duong tron
	slt $v1, $v0, $s4 	# neu v0 < 512 thi v1 = 1
	bne $v1, $0, ham_ve_duong_tron # v1 = 1 => duong tron thoa man thi nhay den ham_ve_duong_tron
	jal go_up 			# neu v0 < 512 thi nhay den ham go_up
	nop
	
#--------------------------------------------------------------------------------------------------------------------------------------------------
# HAM VE DUONG TRON

ham_ve_duong_tron:
	li $s5, BLACK 		# xoa hinh tron cu (ve hinh tron trung voi mau nen)
	jal draw
	add $s0, $s0, $s7 	# cap nhat toa do x cua duong tron, x0 = x0 + x
	add $s1, $s1, $t8 	# cap nhat toa do y cua duong tron, y0 = y0 + y
	li $s5, YELLOW 		# ve hinh tron moi mau vang
	jal draw 
	addi $a0, $t9, 0 	# dung 1 khoang thoi gian roi moi ve duong tron moi 
	li $v0, 32
	syscall
	j bat_dau
draw:
	add $sp, $sp, -4 
	sw $ra, 0($sp)
	li $t0, 0 		# khoi tao i = 0
loop_draw:
	slt $v0, $t0, $s2 	# neu i < R thi v0 = 1
	beq $v0, $zero, end_draw # neu v0 = 0 => i > R thi ket thuc ve
	sll $t5, $t0, 2 	# t5 = i * 4
	lw $t3, circle($t5) # t3 = sqrt(R^2-i^2) trong mang du lieu cac diem cua duong tron
	move $a0, $t0 		# a0 = i (toa do cua x)
	move $a1, $t3 		# a1 = j = sqrt(R^2 - i^2) (toa do cua y)
	jal ve_diem 		# ve 2 diem (x0 + i, y0 + j) ; (x0 + j, y0 + i) tren phan tu thu I
	sub $a1, $0, $t3 
	jal ve_diem 		# ve 2 diem (x0 + i, y0 - j) ; (x0 + j, y0 - i) tren phan tu thu II
	sub $a0, $0, $t0 
	jal ve_diem 		# ve 2 diem (x0 - i, y0 - j) ; (x0 - j, y0 -i) tren phan tu thu III
	add $a1, $0 , $t3 
	jal ve_diem 		# ve 2 diem (x0 - i, y0 + j) ; (x0 - j, y0 + i) tren phan tu thu IV
	addi $t0, $t0, 1 	# i = i + 1 de ve cac diem tiep theo 
	j loop_draw
end_draw:
	lw $ra, 0($sp)
	jr $ra

# Ham ve cac diem tren duong tron 	
ve_diem:
	add $t1, $s0, $a0 	# xi = x0 + i
	add $t4, $s1, $a1 	# yi = y0 + j
	mul $t2, $t4, $s3 	# t2 = yi * chieu dai cua man hinh
	add $t1, $t2, $t1 	# t1 = yi * chieu dai cua man hinh + xi (Toa do 1 chieu cua diem anh)
	sll $t1, $t1, 2 	# nhan t3 * 4 de chuyen thanh dia chi tuong doi cua diem anh
	sw $s5, MONITOR_SCREEN($t1) # ve anh (ghi gia tri mau vao bo nho man hinh)
	add $t1, $s0, $a1 	# xi = x0 + j
	add $t4, $s1, $a0 	# yi = y0 + i
	mul $t2, $t4, $s3 	# t2 = yi * chieu dai cua man hinh
	add $t1, $t2, $t1 	# t1 = yi * chieu dai cua man hinh +  xi (Toa do 1 chieu cua diem anh)
	sll $t1, $t1, 2 	# nhan t3 * 4 ta duoc dia chi tuong doi cua diem anh
	sw $s5, MONITOR_SCREEN($t1) # ve anh (ghi gia tri mau vao bo nho man hinh)	
	jr $ra
	
sqrt: # ham tinh can cua t3 
	mtc1	 $v1, $f1	# dua gia tri trong thanh ghi v1 vao thanh ghi f1
	cvt.s.w	 $f1, $f1 	# chuyen gia tri cua f1 tuong duong voi gia tri so nguyen 32 bit
	sqrt.s	 $f1, $f1 	# tinh can bac hai cua gia tri thanh ghi f1
	cvt.w.s	 $f1, $f1 	# chuyen f1 ve dang 32-bit
	mfc1	 $a0, $f1 	# dat gia tri thanh ghi a0=f1
	jr	 $ra
	
#end of project
