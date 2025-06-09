.global _start

.org 0x20
RTI:
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

    movia r10, TIMER
    movi r11, 0x1
    stw r11, 0(r10)

    rdctl et, ipending
    beq et, r0, END_RTI

    subi ea, ea, 4

    # --- IRQ 0: Timer (animação e cronômetro) ---
    andi r21, et, 0x1
    beq r21, r0, CHECK_KEY1

    # Verifica se FLAG_ANIMACAO está ativa
    movia r16, FLAG_ANIMACAO
    ldw r17, 0(r16)
    beq r17, r0, SKIP_ANIM
    call ANIMA
SKIP_ANIM:

    # Verifica se FLAG_CRONOMETRO está ativa e não pausado
    movia r16, FLAG_CRONOMETRO
    ldw r17, 0(r16)
    beq r17, r0, CHECK_KEY1
    movia r16, CRONO_PAUSA
    ldw r17, 0(r16)
    bne r17, r0, CHECK_KEY1
    call CRONOMETRA     # atualiza contagem a cada 1s

CHECK_KEY1:
    # --- IRQ 1: Botão KEY1 ---
    andi r21, et, 0x2
    beq r21, r0, END_RTI
    call CRONOMETRA

END_RTI:
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
    eret

## interrupção (KEY 1) = para cronometro
.global LEDR
.equ LEDR, 0x10000000
.global SLIDER
.equ SLIDER, 0x10000040
.global PUSHBUTTON
.equ PUSHBUTTON, 0x10000050

.equ UART, 0x10001000 

.global TIMER
.equ TIMER, 0x10002000


## r4 -> controlador uart
## r5 -> mensagem em text_string
## r6 -> UART base address
## r7 -> COMMAND
## r8 -> text_string

_start:
    movia r6, 0x10001000 /* JTAG UART base address */

    # Inicializar o stack-pointer
    movia sp, 0x100000
    
    # ---------------------------
    # Configura Timer (200 ms)
    # ---------------------------
    movia r10, TIMER
    movia r11, 10000000     # Parte baixa (10.000.000)
    stw r11, 8(r10)         # PeriodLow
    srli r11, r11, 16       # r11 tem os 16 bits superiores do periodo de contagem
    stw r11, 12(r10)        # PeriodHigh

    # Habilita interrupções, modo contínuo, start
    movi r13, 0x7           # Start | Continuous | ITO
    stw r13, 4(r10)         # Control

    # Habilita interrupções globais (IRQ 0 e IRQ 1)
    movi r14, 0x3       # 0b11 → IRQ 0 e 1
    wrctl ienable, r14
    movi r15, 0x1       # Global enable
    wrctl status, r15
    
LOOP_INFINITO:
    movia r8, TEXT_STRING
    movia r7, COMMAND
    
    LOOP:
        ldb r5, 0(r8)

        beq r5, zero, GET_JTAG /* string is null-terminated */
        call PUT_JTAG
        addi r8, r8, 1
        br LOOP

    GET_JTAG:
        ldwio r4, 0(r6) /* read the JTAG UART Data register */
        andi r8, r4, 0x8000 /* check if there is new data */
        beq r8, r0, GET_JTAG /* if no data, wait */

        andi r5, r4, 0x00ff /* the data is in the least significant byte */
        call PUT_JTAG /* echo character */
        /* depois ver de pegar só caracter valido */
        movi r9, 0b00001010
        beq r5, r9, TERMINOU_STRING
        stb r5, 0(r7)
        addi r7, r7, 1

        br GET_JTAG
    

TERMINOU_STRING:

    movia r7, COMMAND

    ##UART -> command

/*
    char <= le UART
    enquanto char for invalido voltar pra POLLING_UART
    se char == ENTER, sai
    *comm_ptr = char
    avança comm_ptr
    volta POLLING_UART
 */
    
    ldb r5, 0(r7)
    call PUT_JTAG
    
    /* Checa LED */
    movi r8, 0x30
    bne r5, r8, CHECA_ANIMACAO
    call LED

    br LOOP_INFINITO

    /* Checa ANIMACAO */
CHECA_ANIMACAO:
    movi r8, 0x31
    bne r5, r8, CHECA_CRONOMETRO
    call ANIMACAO_HANDLER

    br LOOP_INFINITO

    /* Checa CRONOMETRO */
CHECA_CRONOMETRO:
    movi r8, 0x32
    bne r5, r8, LOOP_INFINITO
    call CRONOMETRO_HANDLER

    br LOOP_INFINITO


COMMAND:
.skip 100


.org 0x500

.align
.global FLAG_ANIMACAO
FLAG_ANIMACAO:
.word 0

.global FLAG_CRONOMETRO
FLAG_CRONOMETRO:
.word 0

.global CRONO_PAUSA
CRONO_PAUSA:
.word 0

.global LED_ANIM
LED_ANIM:
.word 1

.global ANIM_DIR
ANIM_DIR:
.word 0

.global DIR_FLAG
DIR_FLAG:
.word 0

TEXT_STRING:
.asciz "\nEntre com o comando:\n"


.end