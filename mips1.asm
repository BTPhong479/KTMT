#	div $t0, $t1     # Chia $t0 cho $t1
#        mflo $t2         # Move th??ng t? LO vào $t2
#        mfhi $t3         # Move s? d? t? HI vào $t3
.data
	string: .space 11

.text


	
	li $v0,5
	syscall
	
	li $v1, 4294967295
	bgt $v0,$v1,L1
	




	add $s1, $s1,$v0	#so bi chia n
	li $s2,10	#so chia
	li $s3,10
	li $s4,1
	li $a0,1	# count =1
L:	blt $s1, $s3, L1
	li $a1,0	#sum=0
L3:	blt $s1, $s4,L2
	div $s1, $s2
	mflo $s1 #thuong
	mfhi $s5 #du
	add $a1, $a1,$s5
	j L3
L2:
	addi $s1,$a1,0
	addi $a0,$a0,1
	j L
L1: 
	li $v0,1
	syscall
	


#	int sltt(int n){
#	count =0;
#	while(n>9){
#		sum =0;
#		while(n>0){
#			sum += n%10;
#			n = n/10;
#			}
#		n= sum;
#		count +=1
#		}
#	return count
#	}
