#------------------------------------------------------ 
#           col 0x1    col 0x2    col 0x4     col 0x8  
# 
#  row 0x1      0         1          2           3            
#             0x11      0x21        0x41        0x81          
# 
#  row 0x2      4         5          6           7 
#             0x12      0x22        0x42        0x82 
# 
#  row 0x4      8         9          a           b  
#             0x14      0x24        0x44        0x84 
# 
#  row 0x8      c         d          e           f 
#             0x18      0x28        0x48        0x88 
# 
#------------------------------------------------------ 
# command row number of hexadecimal keyboard (bit 0 to 3) 
# Eg. assign 0x1, to get key button 0,1,2,3 
#     assign 0x2, to get key button 4,5,6,7 
# NOTE must reassign value for this address before reading, 
# eventhough you only want to scan 1 row 
.eqv IN_ADDRESS_HEXA_KEYBOARD       0xFFFF0012 
# receive row and column of the key pressed, 0 if not key pressed  
# Eg. equal 0x11, means that key button 0 pressed. 
# Eg. equal 0x28, means that key button D pressed. 
.eqv OUT_ADDRESS_HEXA_KEYBOARD      0xFFFF0014 
.eqv  HEADING    0xffff8010    # Integer: An angle between 0 and 359 
                               # 0 : North (up) 
                               # 90: East (right) 
                               # 180: South (down) 
                               # 270: West  (left) 
.eqv  MOVING     0xffff8050    # Boolean: whether or not to move 
.eqv  LEAVETRACK 0xffff8020    # Boolean (0 or non-0): 
                               #    whether or not to leave a track 
.eqv  WHEREX     0xffff8030    # Integer: Current x-location of MarsBot 
.eqv  WHEREY     0xffff8040    # Integer: Current y-location of MarsBot 
 
 
.data 
Array1 : .word 145, 3000, 0, 180, 12000, 1, 75, 3050, 1, 45, 3050, 1, 15, 3050, 1, 345,3050,1,315,3050,1,285,3050,1,90,13000,0,255,3150,1,225,2900,1,180,6000,1,135,2900,1,105,3150,1,90,8000,0,270,5000,1,0,6000,1,90,5000,1,270,5000,0,0,6000,1,90,5000,1,-1
Array2 : .word 145, 3000, 0, 180,12000,1,80,2500,1,60,2500,1,0,3000,1,300,2500,1,280,2500,1,80,2500,1,60,2500,1,0,3000,1,300,2500,1,280,2500,1,90,8000,0,90,10000,1,270,5000,0,180,12000,1,90,9000,0,0,12000,1,100,2500,1,120,2500,1,180,3000,1,240,2500,1,260,2500,1,-1
Array3: .word 145, 3000,0, 90, 9000,1,270,4500,0,180,12000,1,270,4500,0,90,9000,1,90,7500,0,0,12000,1,270,4500,0,90,9000,1,180,6000,0,90,3000,1,270,3000,0,180,3000,1,90,3000,0,270,3000,1,180,3000,1,90,3000,1,90,2000,0,0,5000,0,45,1414,1,90,4000,1,135,1414,1,180,4000,1,225,1414,1,270,4000,1,315,1414,1,0,10000,1,45,1414,1,90,4000,1,135,1414,1,-1

.text 
main:            
li    $t1,   IN_ADDRESS_HEXA_KEYBOARD 
li    $t2,   OUT_ADDRESS_HEXA_KEYBOARD 
li    $t3,   0x01
li	$t4, 0x02
li	$t5, 0x04
li	$t6, 0x08      

# check row 4 with key C, D, E, F  
polling:         
sb    $t3,   0($t1 )   
lb    $a0,   0($t2)    
bnez $a0, print
nop
sb    $t4,   0($t1 )   
lb    $a0,   0($t2)    
bnez $a0, print
nop
sb    $t5,   0($t1 )   
lb    $a0,   0($t2)    
bnez $a0, print
nop
sb    $t6,   0($t1 )   
lb    $a0,   0($t2)    
bnez $a0, print
nop

j polling
print:       
li    $v0,   34        # print integer (hexa) 
syscall 
li $s4, 0x11
li $s5, 0x12
li $s6, 0x14
beq $a0, $s4,VE1
beq $a0, $s5,VE2
beq $a0, $s6,VE3
sleep:       
li    $a0,   1000       # sleep 100ms 
li    $v0,   32 
syscall        
back_to_polling: 
j     polling          # continue polling

stop: li $v0, 10
	syscall
	
GO:     li    $at, MOVING     # change MOVING port 
        addi  $k0, $zero,1    # to  logic 1, 
        sb    $k0, 0($at)     # to start running 
        nop         
        jr    $ra 
        nop 
#----------------------------------------------------------- 
# STOP procedure, to stop running 
# param[in]    none 
#-----------------------------------------------------------
STOP:   li    $at, MOVING     # change MOVING port to 0 
        sb    $zero, 0($at)   # to stop 
        nop 
        li $v0, 10
        syscall
        jr    $ra 
        nop 
#----------------------------------------------------------- 
# TRACK procedure, to start drawing line  
# param[in]    none 
#-----------------------------------------------------------              
TRACK:  li    $at, LEAVETRACK # change LEAVETRACK port 
        addi  $k0, $zero,1    # to  logic 1, 
        sb    $k0, 0($at)     # to start tracking 
        nop 
        jr    $ra 
        nop         
#----------------------------------------------------------- 
# UNTRACK procedure, to stop drawing line 
# param[in]    none 
#-----------------------------------------------------------         
UNTRACK:li    $at, LEAVETRACK # change LEAVETRACK port to 0 
        sb    $zero, 0($at)   # to stop drawing tail 
        nop 
        jr    $ra 
        nop 
        
               
TRACKUNTRACK:
	li	$at, LEAVETRACK
	sw	$s3, 0($at)
	nop
	jr $ra
	nop       

	
#----------------------------------------------------------- 
# ROTATE procedure, to rotate the robot 
# param[in]    $a0, An angle between 0 and 359 
#                   0 : North (up) 
#                   90: East  (right) 
#                  180: South (down) 
#                  270: West  (left) 
#-----------------------------------------------------------  
ROTATE: li    $at, HEADING    # change HEADING port 
        sw    $a0, 0($at)     # to rotate robot 
        nop 
        jr    $ra 
        nop 
       
VE1: la $s0, Array1
	          # draw track line 
	jal     GO
        nop 
        j Again
VE2: la $s0, Array2
	          # draw track line 
	jal     GO
        nop 
        j Again
VE3: la $s0, Array3
	          # draw track line 
	jal     GO
        nop 


Again:  
	lw $s1,0($s0)
        lw $s2,4($s0)
        lw $s3,8($s0)
        
        
        addi	$a0, $s1, 0
chek:   bltz    $s1, STOP        
        jal     ROTATE 
        nop 
	jal	TRACKUNTRACK
	nop
sleep10: 
	 addi    $v0,$zero,32    # Keep running by sleeping in 1000 ms 
         addi    $a0, $s2 , 0       
         syscall 
         nop 
         nop
         jal UNTRACK
         nop 
      
         nop
         addi $s0, $s0, 12
         j Again
        
        
        
        
end_main: 
