<<<<<<< HEAD
.global _start

.org 0x20
RTI:
/* Exception handler */
    rdctl et, ipending              /* Check if external interrupt occurred */
    beq et, r0, END_RTI    /* If zero, check exceptions */
    subi ea, ea, 4                  /* Hardware interrupt, decrement ea to execute the interrupted */ ##trocar numero
                                    /* instruction upon return to main program */
    andi r21, et, 2                 /* Check if irq 1 asserted */ ##trocar numero
    beq r21, r0, END_RTI   /*If not, check other external interrupts */
    call PUSHBUTTON                   /* If yes, go to IRQ1 service routine */ ##trocar rotina
END_RTI: 
    eret  

## interrupção (KEY 1) = para cronometro
.global LEDR
.equ LEDR, 0x10000000
.equ SLIDER, 0x10000040
.equ PUSHBUTTON, 0x10000050
.equ UART, 0x10001000 
.equ TIMER, 0x10002000


## r8 -> text_string
## r5 -> mensagem em text_string
## r6 -> UART base adress
## r4 -> controlador uart



_start:
    movia r6, 0x10001000 /* JTAG UART base address */

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
    call ANIMACAO

    br LOOP_INFINITO

    /* Checa CRONOMETRO */
CHECA_CRONOMETRO:
    movi r8, 0x32
    bne r5, r8, LOOP_INFINITO
    call CRONOMETRO

    br LOOP_INFINITO


COMMAND:
.skip 100

.data
TEXT_STRING:
.asciz "\nEntre com o comando:\n"

END:
  br END
=======
.global _start

.org 0x20
RTI:
/* Exception handler */
    rdctl et, ipending              /* Check if external interrupt occurred */
    beq et, r0, END_RTI    /* If zero, check exceptions */
    subi ea, ea, 4                  /* Hardware interrupt, decrement ea to execute the interrupted */ ##trocar numero
                                    /* instruction upon return to main program */
    andi r21, et, 2                 /* Check if irq 1 asserted */ ##trocar numero
    beq r21, r0, END_RTI   /*If not, check other external interrupts */
    call PUSHBUTTON                   /* If yes, go to IRQ1 service routine */ ##trocar rotina
END_RTI: 
    eret  

## interrupção (KEY 1) = para cronometro
.equ LEDR, 0x10000000
.equ SLIDER, 0x10000040
.equ PUSHBUTTON, 0x10000050
.equ UART, 0x10001000 
.equ TIMER, 0x10002000


## r8 -> text_string
## r5 -> mensagem em text_string
## r6 -> UART base adress
## r4 -> controlador uart



_start:
    movia r6, 0x10001000 /* JTAG UART base address */
RETYPE_MESSAGE:
    movia r8, TEXT_STRING
    
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
        movi r10, 0b00001010
        beq r5, r10, RETYPE_MESSAGE
        br GET_JTAG
    

TERMINOU_STRING:

LOOP_INFINITO:
    ##UART -> command

/*
    char <= le UART
    enquanto char for invalido voltar pra POLLING_UART
    se char == ENTER, sai
    *comm_ptr = char
    avança comm_ptr
    volta POLLING_UART
 */


    ## beq command[0], 0, LED
    ## beq command[0], 1, ANIMACAO
    ## beq command[0], 2, CRONOMETRO

    br LOOP_INFINITO


COMMAND:
.skip 100

.data
TEXT_STRING:
.asciz "Entre com o comando:\n"

END:
  br END
>>>>>>> 94f703269a6d4175748a7d366d737440b2a02f54
.end