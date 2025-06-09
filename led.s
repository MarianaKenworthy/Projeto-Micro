.global LED

## endereço dos led e tal

## 

LED:
    movia r12, LEDR

    ldb r5, 1(r7) ## command[1]
    
    ldb r10, 2(r7) ## command[2]
    subi r10, r10, 48 ## -30 pq o que tem no buffer é o char e não o valor
    muli r11, r10, 10 ## command[2] * 10

    ldb r10, 3(r7) ##command[3]
    subi r10, r10, 48 ## -30 pq o que tem no buffer é o char e não o valor

    add r11, r11, r10 ## command[2] * 10 + command[3]
    /* subi r11, r11, 1 */

    movi r13, 0b0000000000000001
    mov r14, r0

COUNT:
    beq r14, r11, FIM_COUNT
    slli r13, r13, 1
    addi r14, r14, 1
    br COUNT

FIM_COUNT:

    ldwio r15, 0(r12)

    ##beq command[1], 0, ACENDE
    movi r8, 0x30
    beq r5, r8, ACENDE

    ##beq command[1], 1, APAGA
    movi r8, 0x31
    beq r5, r8, APAGA

    br DONE
    

ACENDE:
    or r13, r15, r13
    stwio r13, 0(r12)

    br DONE
APAGA:
    nor r13, r13, r13
    and r13, r15, r13
    stwio r13, 0(r12)
    br DONE
DONE:
    ret 
