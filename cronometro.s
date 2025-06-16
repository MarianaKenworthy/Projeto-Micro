.global CRONOMETRO_HANDLER

CRONOMETRO_HANDLER:
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

    movi r8, 0x30 ## 0, INICIA CRONÔMETRO
    beq r5, r8, INICIA_CRONOMETRO

    ##beq command[1], 1, CANCELA
    movi r8, 0x31
    beq r5, r8, PARA_CRONOMETRO

INICIA_CRONOMETRO:
    movi r11, 1
    movia r12, FLAG_CRONOMETRO
    stw r11, 0(r12)      

    br DONE

PARA_CRONOMETRO:
    movia r10, FLAG_CRONOMETRO
    movi r9, 0
    stw r0, 0(r23)
    stw r0, 4(r23)
    stw r0, 8(r23)
    stw r0, 12(r23)
    stw r9, 0(r10)            # Desativa cronômetro
    movia r20, DISPLAY
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