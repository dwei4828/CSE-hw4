############## FULL NAME ##############
############## SBUID #################
############## NETID ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_person
create_person:	
	move $t0, $a0
	lw $t1, 0($t0) # total nodes
	addi $t0, $t0, 8
	lw $t2, 0($t0) # size of nodes
	addi $t0, $t0, 8
	lw $t3, 0($t0) # curr nodes
	ble $t1, $t3, error
	
	addi $t4, $t3, 1
	sw $t4, 0($t0)
	
	addi $t0, $t0, 8
	mul $t5, $t2, $t3
	add $t0, $t0, $t5
	move $t6, $t0 # store address
	
	li $t7, 4
	div $t2, $t7
	mflo $t8
	li $t9, 0
	
	loop1:
	    sw $t9, 0($t0)
	    addi $t0, $t0, 4
	    addi $t8, $t8, -1
	    beqz $t8, success
	    j loop1
	
	success:
	    move $v0, $t6 
	    jr $ra   
	    
	error:
	    li $t1, -1
	    move $v0, $t1
	    jr $ra

.globl add_person_property
add_person_property:
    move $t0, $a2
    lb $t1, 0($t0)
    li $t2, 78
    bne $t1, $t2, errorAdd
    
    lb $t1, 1($t0)
    li $t2, 65
    bne $t1, $t2, errorAdd
    
    lb $t1, 2($t0)
    li $t2, 77
    bne $t1, $t2, errorAdd
    
    lb $t1, 3($t0)
    li $t2, 69
    bne $t1, $t2, errorAdd
    
    move $t0, $a0
    addi $t0, $t0, 8
    li $t9, 4
    lw $t1, 0($t0)
    move $t6, $t1 # save size
    div $t1, $t9
    mflo $t8
    move $t2, $a1
    
    #check if address is in range
    addi $t0, $t0, 8
    lw $t7, 0($t0) #curr nodes
    addi $t0, $t0, 8
    blt $t2, $t0, errorAdd
    mul $t7, $t7, $t6
    add $t0, $t0, $t7
    bgt $t2, $t0, errorAdd
    
    move $t0, $a3
    li $t1, 0 #length counter
    
    loop3: #find the length
    	lb $t2, 0($t0)
    	beqz $t2, endLoop3
    	addi $t1, $t1, 1
    	addi $t0, $t0, 1
    	j loop3
    	
    endLoop3:
    	bgt $t1, $t6, errorAdd
    	move $t8, $t1 #save length
    	
    move $t0, $a0
    addi $t0, $t0, 16
    lw $t1, 0($t0) # current nodes
    addi $t0, $t0, 8
    li $t2, 0 # counter for length
    li $t9, 0 # counter for person
    move $t7, $t0
    
    loop4: #check if it is unique
    	move $t3, $a3
    	beq $t1, $t9, endLoop4
    	move $t0, $t7
    	add $t7, $t7, $t6
    	addi $t9, $t9, 1
    	
    	loop5:
    	    lb $t4, 0($t0)
    	    lb $t5, 0($t3)
            bne $t4, $t5, loop4
            beqz $t4, loop4
    	    addi $t3, $t3, 1
    	    addi $t0, $t0, 1
    	    addi $t2, $t2, 1
    	    beq $t2, $t8, errorAdd
    	    j loop5
    
    endLoop4:
    	move $t0, $a1
    	move $t1, $a3
    	li $t3, 0 # counter
    	loop6:
    	    lb $t2, 0($t1)
    	    beqz $t2, fillUpNode
    	    sb $t2, 0($t0)
    	    addi $t1, $t1, 1
    	    addi $t0, $t0, 1
    	    addi $t3, $t3, 1
    	    beq $t3, $t6, successAddPerson 
    	    j loop6
    	
    	fillUpNode:
    	    beq $t3, $t6, successAddPerson
    	    sb $t2, 0($t0)
    	    addi $t0, $t0, 1
    	    addi $t3, $t3, 1
    	    j fillUpNode
    	    
   successAddPerson:
   	li $v0, 1
   	jr $ra
    	
    errorAdd:
    	li $v0, 0
    	jr $ra

.globl get_person
get_person:
    addi $sp, $sp, -36
    sw $t0, 32($sp)
    sw $t1, 28($sp)
    sw $t2, 24($sp)
    sw $t3, 20($sp)
    sw $t4, 16($sp)
    sw $t5, 12($sp)
    sw $t6, 8($sp)
    sw $t7, 4($sp)
    sw $t8, 0($sp)
    
    move $t0, $a0
    addi $t0, $t0, 8
    lw $t2, 0($t0) #size
    addi $t0, $t0, 8
    lw $t3, 0($t0) #curr nodes
    addi $t0, $t0, 8
    li $t4, 0 #counter
    move $t7, $t0
    
    getLoop1:
    	beq $t4, $t3, errorGet
    	move $t1, $a1
    	move $t0, $t7
    	add $t7, $t7, $t2
    	addi $t4, $t4, 1
    	li $t8, 0
    	getLoop2:
    	    lbu $t5, 0($t0)
    	    lbu $t6, 0($t1)
    	    bne $t5, $t6, getLoop1
    	    beqz $t5, successGet
    	    addi $t0, $t0, 1
    	    addi $t1, $t1, 1
    	    addi $t8, $t8, 1
    	    beq $t8, $t2, checkNext
    	    j getLoop2
    	
    	checkNext:
    	    lbu $t6, 0($t1)
    	    beqz $t6, successGet
    	    j getLoop1
    	    
    successGet:
    	sub $t7, $t7, $t2
    	move $v0, $t7
    	j doneGet
    
    errorGet:
    	li $v0, 0
    	j doneGet
    
    doneGet:
    	lw $t0, 32($sp)
   	lw $t1, 28($sp)
  	lw $t2, 24($sp)
    	lw $t3, 20($sp)
    	lw $t4, 16($sp)
    	lw $t5, 12($sp)
    	lw $t6, 8($sp)
    	lw $t7, 4($sp)
    	lw $t8, 0($sp)
    	addi $sp, $sp, 36
    	jr $ra

.globl add_relation
add_relation:
    addi $sp, $sp, -20
    sw $a0, 16($sp)
    sw $a1, 12($sp)
    sw $a2, 8($sp)
    sw $ra, 4($sp)
    
    jal get_person
    move $t1, $v0
    beqz $t1, errorAddRelation
    
    move $a1, $a2
    jal get_person
    move $t2, $v0
    beqz $t2, errorAddRelation
    
    beq $t1, $t2, errorAddRelation
    
    move $t0, $a0
    
    lw $s3, 0($t0) #max nodes
    
    addi $t0, $t0, 4
    lw $s1, 0($t0) #max edges
    
    addi $t0, $t0, 4
    lw $s2, 0($t0) #size of nodes
    
    addi $t0, $t0, 12
    lw $s4, 0($t0) #curr edges
    move $t7, $t0 #save address to increment curr edges by one if added
    
    ble $s1, $s4, errorAddRelation
    
    li $t3, 0 #counter
    addi $t0, $t0, 4 #go to set of nodes
    mul $t4, $s2, $s3
    add $t0, $t0, $t4 #go to set of edges
    
    rLoop1:
    	beq $t3, $s4, addR
    	lw $t5, 0($t0)
    	addi $t0, $t0, 4
    	lw $t6, 0($t0)
    	bne $t5, $t1, check #if person 1 = first name
    	bne $t6, $t2, increment 
    	j errorAddRelation
    	check:
    	    bne $t5, $t2, increment #if person 1 = second name
    	    bne $t6, $t1, increment
    	    j errorAddRelation
    	increment:
    	    addi $t3, $t3, 1
    	    addi $t0, $t0, 8
    	    j rLoop1
    	    
    addR:
    	addi $t8, $s4, 1
    	sw $t8, 0($t7) #increment curr edges by one
    	
    	sw $t1, 0($t0)
    	addi $t0, $t0, 4
    	sw $t2, 0($t0)
    	addi $t0, $t0, 4
    	li $t1, 0
    	sw $t1, 0($t0)
    	li $v0, 1
    	j doneAddR
    	
    errorAddRelation:
    	li $v0, 0
    	j doneAddR
    doneAddR:
    	lw $a0, 16($sp)
    	lw $a1, 12($sp)
    	lw $a2, 8($sp)
    	lw $ra, 4($sp)
    	addi $sp, $sp, 20
    	jr $ra

.globl add_relation_property
add_relation_property:
    lw $t0, 0($sp)
    li $t1, 1
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    bne $t0, $t1, errorAddP #check if prop_val == 1
    
    move $t0, $a3
    lb $t1, 0($t0)
    li $t2, 70
    bne $t1, $t2, errorAddP
    
    lb $t1, 1($t0)
    li $t2, 82
    bne $t1, $t2, errorAddP
    
    lb $t1, 2($t0)
    li $t2, 73
    bne $t1, $t2, errorAddP
    
    lb $t1, 3($t0)
    li $t2, 69
    bne $t1, $t2, errorAddP
    
    lb $t1, 4($t0)
    li $t2, 78
    bne $t1, $t2, errorAddP
    
    lb $t1, 5($t0)
    li $t2, 68
    bne $t1, $t2, errorAddP
    
    move $t0, $a0
    lw $s1, 0($t0) #max nodes
    
    addi $t0, $t0, 4
    lw $s2, 0($t0) #max edges
    
    addi $t0, $t0, 4
    lw $s3, 0($t0) #size of nodes
    
    addi $t0, $t0, 12
    lw $s4, 0($t0) #curr edges
    
    li $t3, 0 #length counter
    li $t4, 0 #length counter2
    move $t1, $a1
    move $t2, $a2
    findLengthLoop1:
    	lb $t5, 0($t1)
    	beqz $t5, findLengthLoop2
    	addi $t3, $t3, 1
    	addi $t1, $t1, 1
    	j findLengthLoop1
    
    findLengthLoop2:
    	lb $t6, 0($t2)
    	beqz $t6, foundLength
    	addi $t4, $t4, 1
    	addi $t2, $t2, 1
    	j findLengthLoop2
    	
    foundLength:
    	move $s5, $t3 #first length
    	move $s6, $t4 #second length
    	move $t1, $a1
    	move $t2, $a2
    	
    bgt $s5, $s3, truncateLoop1
    j checkC2
    
    truncateLoop1:
    	add $t1, $t1, $s3
    	lb $t3, 0($t1)
    	beqz $t3, checkC2
    	li $t9, 0
    	sb $t9, 0($t1)
    	addi $t1, $t1, 1
    	j truncateLoop1
    	
    checkC2:
    	bgt $s6, $s3, truncateLoop2
    	j skipTruncate
    	
    truncateLoop2:
    	add $t2, $t2, $s3
    	lb $t3, 0($t2)
    	beqz $t3, skipTruncate
    	li $t9, 0
    	sb $t9, 0($t2)
    	addi $t2, $t2, 1
    	j truncateLoop1
    	
    skipTruncate:
    
    jal get_person
    move $t1, $v0
    beqz $t1, errorAddP
    
    move $a1, $a2
    jal get_person
    move $t2, $v0
    beqz $t2, errorAddP
    
    li $t3, 0 #counter
    addi $t0, $t0, 4 #go to set of nodes
    mul $t4, $s1, $s3
    add $t0, $t0, $t4 #go to set of edges

    rLoop2:
        beq $t3, $s4, errorAddP
        lw $t5, 0($t0)
    	addi $t0, $t0, 4
    	lw $t6, 0($t0)
    	
    	bne $t5, $t1, check1 #if person 1 = first name
    	bne $t6, $t2, increment1
        j addRP
        check1:
            bne $t5, $t2, increment1 #if person 1 = second name
    	    bne $t6, $t1, increment1
    	    j addRP
    	increment1:
    	    addi $t3, $t3, 1
    	    addi $t0, $t0, 8
    	    j rLoop2
    
    addRP:
    	addi $t0, $t0, 4
    	li $t1, 1
    	sw $t1, 0($t0)
    	li $v0, 1
    	j doneAddRP
    	
    errorAddP:
    	li $v0, 0
    	j doneAddRP
    	
    doneAddRP:
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	jr $ra
    
.globl is_a_distant_friend
is_a_distant_friend:

    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal get_person
    move $s1, $v0
    beqz $s1, notExist
    
    move $a1, $a2
    jal get_person
    move $s2, $v0
    beqz $s2, notExist
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    move $t0, $a0
    lw $t1, 0($t0) #max nodes
    addi $t0, $t0, 8
    lw $t2, 0($t0) #size of nodes
    addi $t0, $t0, 12
    lw $s3, 0($t0) #curr edges
    addi $t0, $t0, 4  #begining of set of nodes
    mul $t1, $t1, $t2
    add $t0, $t0, $t1 #begining of set of edges
    move $s4, $t0 #save address
    
    li $t1, 0 #counter
    li $s5, 4
    
    checkDirect:
    	beq $t1, $s3, endcheck
    	lw $t2, 0($t0)
    	addi $t0, $t0, 4
    	lw $t3, 0($t0)
    	
    	
    	bne $s1, $t2, checkOther
    	beq $s2, $t3, checkOne
    	
    	checkOther:
    	bne $s1, $t3, skipD
    	beq $s2, $t2, checkOne
    	
    	checkOne:
    	addi $t0, $t0, 4
    	lw $t4, 0($t0)
    	li $t9, 1
    	beq $t4, $t9, errorD
    	
    	skipD:
    	addi $t0, $t0, 4
    	addi $t1, $t1, 1
    	j checkDirect
    	
    endcheck:
    	move $s6, $sp #save original stack address
    	addi $sp, $sp, -4
    	sw $s1, 0($sp)
    	
    DFSLoop:
    	beq $sp, $s6, errorD
    	lw $t1, 0($sp)
    	li $t2, 0 #counter
    	move $t0, $s4 #set t0 to beginning of set edges
    	li $s7, 1
    	li $t9, 888
    	loopEdges:
    	    beq $t2, $s3, backTrack
    	    lw $t4, 0($t0)
    	    addi $t0, $t0, 4
    	    lw $t5, 0($t0)
    	    addi $t0, $t0, 4
    	    lw $t6, 0($t0)
    	    
    	    checkIsFriend:
    	    bne $t6, $s7, nextEdge
    	    
    	    bne $t4, $t1, checkSecondName
    	    beq $t5, $s2, foundD
    	    j markVisited1
    	    
    	    checkSecondName:
    	    bne $t5, $t1, nextEdge
    	    beq $t4, $s2, foundD
    	    j markVisited2
    	    
    	    
    	    nextEdge:
    	    addi $t0, $t0, 4
    	    addi $t2, $t2, 1
    	    j loopEdges
    	    
    	    markVisited1:
    	    sw $t9, 0($t0)
    	    addi $sp, $sp, -4
    	    sw $t5, 0($sp)
    	    j DFSLoop
    	    
    	    markVisited2:
    	    sw $t9, 0($t0)
    	    addi $sp, $sp, -4
    	    sw $t4, 0($sp)
    	    j DFSLoop
    	    
    	    backTrack:
    	    addi $sp, $sp, 4
    	    j DFSLoop
    	    
    foundD:
    	move $t0, $s4
    	li $t1, 1
    	li $t2, 888
    	li $t3, 0 #counter
    	loopFound:
    	    beq $t3, $s3, endLoopFound
    	    addi $t0, $t0, 8
  	    lw $t4, 0($t0)
  	    bne $t4, $t2, skip11
    	    sw $t1, 0($t0)
    	    skip11:
    	    addi $t3, $t3, 1
    	    addi $t0, $t0, 4
	    j loopFound

    	endLoopFound:
    	li $v0, 1
    	jr $ra
    	
    errorD:
    	move $t0, $s4
    	li $t1, 1
    	li $t2, 888
    	li $t3, 0 #counter
    	loopError:
    	    beq $t3, $s3, endLoopError
    	    addi $t0, $t0, 8
  	    lw $t4, 0($t0)
  	    bne $t4, $t2, skip22
    	    sw $t1, 0($t0)
    	    skip22:
    	    addi $t3, $t3, 1
    	    addi $t0, $t0, 4
	    j loopError
	    
	endLoopError:
    	li $v0, 0
    	jr $ra
	   
    notExist:
    	lw $ra, 0($sp)
   	addi $sp, $sp, 4
    	li $v0, -1
    	jr $ra
