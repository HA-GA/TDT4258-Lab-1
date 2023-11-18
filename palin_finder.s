.global _start

_start:
	ldr r0, =input		//load input memory into two registers, because the address is changed
	ldr r1, =input		//before it is used in check_palindrom
	mov r2, #-1			//r2 starts at 1, because the string is 1-indexed, and counter is 0-indexed
	bl check_input		//saves the address to lr

	add r5, r2, r0		//end of word, for later

	b check_palindrom

check_input:			//find length of word
	
	ldrb r3, [r1], #1
	cmp r3, #0
	bxeq lr				//branch and exchange, branches up tp add on line 9
	add r2, r2, #1
	b check_input


check_palindrom://first and last char of word into own register, increments/dercrements 1
	
	ldrb r3, [r0], #1
	ldrb r4, [r5], #-1

	cmp r3, #32				//if space jump to next char
	ldreqb r3, [r0], #1
	cmp r4, #32
	ldreqb r4, [r5], #-1

	cmp r3, #96				//if small letter change into capitilized
	subgt r3, r3, #32
	cmp r4, #96
	subgt r4, r4, #32

	cmp r3, r4				
	bne is_no_palindrom

	cmp r0, r5				//if r0>r5 we have crossed the middle of the word, and every char so far is equal, meaning we have a palindrome
	bge is_palindrom

	b check_palindrom		//loop

is_palindrom:

	MOV R10, #0x3E0			//Move value into R0, 5 Leftmost LEDs
	LDR R11, =0xFF200000		//Load memory address
	STR R10, [R11] 				

	ldr r4, =0xFF201000     	
	ldr r0, =output_string1 

	b print_loop
	
is_no_palindrom:

	MOV R10, #0x1f				//Move value into R0, 5 Rightmost LEDs
	LDR R11, =0xFF200000		//Load memory address
	STR R10, [R11] 				

	ldr r4, =0xFF201000     	//address of jtag
	ldr r0, =output_string

print_loop:
    
    ldrb r1, [r0], #1 	
    cmp r1, #0    	 	//0 means end of string
   
   	beq _exit
	
    str r1, [r4]  		
   
    b print_loop	
	
_exit:
	// Branch here for exit
	b .
	
.data

output_string:   .asciz "Not a palindrom"
output_string1:   .asciz "Palindrom detected!"



.align
	// This is the input you are supposed to check for a palindrom
	// You can modify the string during development, however you
	// are not allowed to change the name 'input'!
	input: .asciz "Varg den ned grav"
.end	
