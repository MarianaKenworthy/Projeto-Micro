.global CRONOMETRA

CRONOMETRA:
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

    ldw r11, 0(r23) # Unidade
    ldw r12, 4(r23) # Dezena
    ldw r13, 8(r23) # Centena
    ldw r14, 12(r23) # Milhar
    movi r7, 9

    bne r11, r7, SOMA # r7 = 9
        movi r11, 0
        addi r12, r12, 1

    blt r12, r7, DONE
        movi r12, 0
        addi r13, r13, 1

    blt r13, r7, DONE
        movi r13, 0
        addi r14, r14, 1
        br DONE

SOMA:
    addi r11, r11, 1
DONE:
    ## Salvar no r23 a contagem atual para a próxima iteração
    stw r11, 0(r23)
    stw r12, 4(r23)
    stw r13, 8(r23)
    stw r14, 12(r23)

    muli r11, r11, 4
    muli r12, r12, 4
    muli r13, r13, 4
    muli r14, r14, 4

    addi r11, r11, NUMBERS # 503
    addi r12, r12, NUMBERS # 500
    addi r13, r13, NUMBERS # 500
    addi r14, r14, NUMBERS # 500

    ldw r11, (r11)
    ldw r12, (r12)
    ldw r13, (r13)
    ldw r14, (r14)

    slli r12, r12, 8
    slli r13, r13, 16
    slli r14, r14, 24

    or r11, r11, r12
    or r11, r11, r13
    or r11, r11, r14

    movia r5, DISPLAY
    stwio r11, (r5)

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