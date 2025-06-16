.global ANIMACAO_HANDLER

## endereço dos led e tal
## temp = 200 ms

ANIMACAO_HANDLER:

    subi sp, sp, 40
    stw ra, 0(sp)
    stw r5, 4(sp)
    stw r7, 8(sp)
    stw r8, 12(sp)
    stw r10, 16(sp)
    stw r11, 20(sp)
    stw r12, 24(sp)
    stw r13, 28(sp)
    stw r14, 32(sp)
    stw r15, 36(sp)

    ldb r5, 1(r7) ## command[1]

    movi r8, 0x30
    beq r5, r8, INICIA_ANIMACAO

    ##beq command[1], 1, APAGA
    movi r8, 0x31
    beq r5, r8, PARA_ANIMACAO

    br DONE

    ## beq command[1], 0, INICIA_ANIMACAO
    ## beq command[1], 0, PARA_ANIMACAO

INICIA_ANIMACAO:
    ##movia r10, 0x10000040     # SW base
    ##ldw r9, 0(r10)
    ##andi r9, r9, 0x1         # SW0 apenas
##
    ##movia r10, DIR_FLAG
    ##stw r9, 0(r10)           # Guarda direção

    movi r11, 1
    movia r12, FLAG_ANIMACAO
    stw r11, 0(r12)      

    br DONE

PARA_ANIMACAO:
    movia r10, FLAG_ANIMACAO
    movi r9, 0
    stw r9, 0(r10)            # Desativa animação
    movia r20, LEDR
    stwio r0, 0(r20)



DONE:
    ldw ra, 0(sp)
    ldw r5, 4(sp)
    ldw r7, 8(sp)
    ldw r8, 12(sp)
    ldw r10, 16(sp)
    ldw r11, 20(sp)
    ldw r12, 24(sp)
    ldw r13, 28(sp)
    ldw r14, 32(sp)
    ldw r15, 36(sp)
    addi sp, sp, 40

    ret