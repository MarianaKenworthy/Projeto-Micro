.global ANIMA

ANIMA:
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

    ## movia r16, ANIM_DIR
    ## ldw r17, 0(r16)

    movia r18, LED_ANIM
    ldw r19, 0(r18)

    movia r10, 0x10000040     # SW base
    ldw r9, 0(r10)
    andi r9, r9, 0x1         # SW0 apenas

    movia r10, DIR_FLAG
    stw r9, 0(r10)           # Guarda direção

    beq r9, r0, DIR_ESQ
    br ESQ_DIR

DIR_ESQ:
    slli r19, r19, 1
    movi r21, 0b1000000000000000000
    bge r19, r21, RESET_DIR_ESQ
    br DONE 

ESQ_DIR:
    srli r19, r19, 1
    ble r19, r0, RESET_ESQ_DIR
    br DONE

RESET_DIR_ESQ:
    movia r19, 0x1      # LED mais à esquerda (bit 9)
    br DONE

RESET_ESQ_DIR:
    movia r19, 0b100000000000000000
    br DONE

DONE:

    movia r20, LEDR
    stwio r19, 0(r20)
    movia r21, LED_ANIM
    stw r19, 0(r21)

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