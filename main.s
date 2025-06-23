.global _start

.org 0x20
RTI:
    subi sp, sp, 40                # Salva espaço na pilha para preservar registradores
    stw ra, 0(sp)                  # Salva o registrador de retorno
    stw r5, 4(sp)
    stw r7, 8(sp)
    stw r8, 12(sp)
    stw r10, 16(sp)
    stw r11, 20(sp)
    stw r12, 24(sp)
    stw r13, 28(sp)
    stw r14, 32(sp)
    stw r15, 36(sp)

    rdctl et, ipending             # Lê registrador de interrupções pendentes
    beq et, r0, END_RTI            # Se não há interrupção, encerra RTI

    subi ea, ea, 4                 # Corrige endereço de retorno

    # --- IRQ 0: Timer (animação e cronômetro) ---
    andi r21, et, 0x1              # Verifica se interrupção do timer está ativa
    beq r21, r0, CHECK_KEY1        # Se não, vai checar KEY1

    # Reseta bit TO do timer
    movia r10, TIMER               # Endereço do timer
    movi r11, 0x1                  # Valor para resetar
    stwio r11, 0(r10)              # Reseta o timer

    # Verifica se FLAG_ANIMACAO está ativa
    movia r16, FLAG_ANIMACAO
    ldw r17, 0(r16)
    beq r17, r0, SKIP_ANIM         # Se não ativa, pula animação
    call ANIMA                     # Chama rotina de animação

SKIP_ANIM:
    movi r17, 5                    # Valor para dividir a frequência do cronômetro
    addi r22, r22, 1               # Incrementa contador auxiliar
    blt r22, r17, END_RTI          # Só executa cronômetro a cada 5 ticks

    movi r22, 0                    # Reseta contador auxiliar

    # Verifica se FLAG_CRONOMETRO está ativa e não pausado
    movia r16, FLAG_CRONOMETRO
    ldw r17, 0(r16)
    beq r17, r0, END_RTI           # Se não ativa, encerra RTI
    movia r16, CRONO_PAUSA
    ldw r17, 0(r16)
    bne r17, r0, END_RTI           # Se pausado, encerra RTI
    call CRONOMETRA                # Atualiza contagem do cronômetro

CHECK_KEY1:

    andi r21, et, 0x2              # Verifica se interrupção do botão KEY1 está ativa
    beq r21, r0, END_RTI           # Se não, encerra RTI

    # Limpa a interrupção do botão
    movia r21, 0x1000005C          # Endereço para limpar interrupção do botão
    stwio r0, (r21)

    movia r16, CRONO_PAUSA         # Endereço da flag de pausa
    ldw r17, 0(r16)
    bne r17, r0, DESPAUSA          # Se já está pausado, despausa

    movi r17, 1
    stw r17, 0(r16)                # Pausa cronômetro
    br END_RTI

DESPAUSA:
    stw r0, 0(r16)                 # Despausa cronômetro

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
    addi sp, sp, 40                # Libera espaço da pilha
    eret                           # Retorna da interrupção

.global LEDR
.equ LEDR, 0x10000000
.global SLIDER
.equ SLIDER, 0x10000040
.global PUSHBUTTON
.equ PUSHBUTTON, 0x10000050

.equ UART, 0x10001000 

.global TIMER
.equ TIMER, 0x10002000

.global DISPLAY
.equ DISPLAY, 0x10000020

_start:
    movia r6, 0x10001000           # JTAG UART endereço base
    
    movia r22, 0                   # Inicializa contador auxiliar

    movia sp, 0x100000             # Inicializa stack pointer
    
    # Configura timer (200 ms)
    movia r10, TIMER
    movia r11, 10000000            # Parte baixa (10.000.000)
    stw r11, 8(r10)                # PeriodLow
    srli r11, r11, 16              # r11 tem os 16 bits superiores do periodo de contagem
    stw r11, 12(r10)               # PeriodHigh

    # Habilita interrupções, modo contínuo, start
    movi r13, 0x7                  # Start | Continuous | ITO --> 0x7 = 0b111
    stw r13, 4(r10)                # Control

    # Habilita interrupções globais (IRQ 0 e IRQ 1)
    movi r14, 0x3                  # 0b11 --> IRQ 0 e 1
    wrctl ienable, r14
    movi r15, 0x1                  # Global enable
    wrctl status, r15

    movia r8, 0x10000050           # Endereço dos botões
    movi  r9, 0x2                  # Máscara para KEY1
    stwio r9, 8(r8)                # Habilita interrupção para KEY1
    
LOOP_INFINITO:
    movia r8, TEXT_STRING          # Ponteiro para mensagem inicial
    movia r7, COMMAND              # Ponteiro para buffer de comando
    
    # Escreve na UART a mensagem "\nEntre com o comando:\n"
    LOOP:
        ldb r5, 0(r8)              # Lê caractere da mensagem

        beq r5, zero, GET_JTAG     # Se chegou ao fim da string, vai para GET_JTAG
        call PUT_JTAG              # Envia caractere para UART
        addi r8, r8, 1             # Avança ponteiro
        br LOOP                    # Repete até fim da string

    GET_JTAG:
        ldwio r4, 0(r6)            # Lê o registrador de dados da UART
        andi r8, r4, 0x8000        # Verifica se há novo dado
        beq r8, r0, GET_JTAG       # Se não há dado, espera

        andi r5, r4, 0x00ff        # Extrai o byte recebido
        
        movi r9, 0b00001010
        beq r5, r9, TERMINOU_STRING # Se ENTER, termina leitura

        # Trata BACKSPACE
        movi r9, 0x7F              # ASCII DEL (Simulador trata BACKSPACE como DEL, não 0x08)
        beq r5, r9, BACKSPACE

        # Checar se é menor que '0' (0x30 em ASCII)
        movi r9, 0x30
        blt r5, r9, GET_JTAG       # Se r5 < '0', ignora

        # Checar se é maior que '9' (0x39 em ASCII)
        movi r9, 0x39
        bgt r5, r9, GET_JTAG       # Se r5 > '9', ignora

        # Se chegou aqui, r5 contém um número
        stb r5, 0(r7)              # Armazena caractere no buffer
        addi r7, r7, 1             # Avança ponteiro

        call PUT_JTAG              # Ecoa caractere
        br GET_JTAG                # Continua lendo

        BACKSPACE:
            movia r9, COMMAND      # Carrega endereço base do buffer COMMAND
            beq r7, r9, GET_JTAG   # Se já está no início, ignora backspace

            subi r7, r7, 1         # Decrementa ponteiro
            movi r9, 0x20          # ASCII Espaço
            stb r9, 0(r7)          # Limpa caractere no buffer

            # Ecoa Backspace, Espaço, Backspace para apagar visualmente no terminal
            movi r5, 0x08          # Backspace
            call PUT_JTAG
            movi r5, 0x20          # Espaço
            call PUT_JTAG
            movi r5, 0x08          # Backspace novamente
            call PUT_JTAG

            br GET_JTAG
    

TERMINOU_STRING:
    movia r7, COMMAND              # Ponteiro para início do comando
    
    ldb r5, 0(r7)                  # Lê primeiro caractere do comando
    call PUT_JTAG                  # Ecoa comando
    
    # Checa LED
    movi r8, 0x30
    bne r5, r8, CHECA_ANIMACAO     # Se não for comando de LED, checa animação
    call LED                       # Chama rotina de LED

    br LOOP_INFINITO               # Volta para o início

CHECA_ANIMACAO:
    movi r8, 0x31
    bne r5, r8, CHECA_CRONOMETRO   # Se não for comando de animação, checa cronômetro
    call ANIMACAO_HANDLER          # Chama rotina de animação

    br LOOP_INFINITO               # Volta para o início

CHECA_CRONOMETRO:
    movi r8, 0x32
    bne r5, r8, LOOP_INFINITO      # Se não for comando de cronômetro, volta ao início
    call CRONOMETRO_HANDLER        # Chama rotina do cronômetro

    br LOOP_INFINITO               # Volta para o início

COMMAND:
.skip 100


.org 0x500
.global NUMBERS
NUMBERS:
.word 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

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

.global DIR_FLAG
DIR_FLAG:
.word 0

TEXT_STRING:
.asciz "\nEntre com o comando:\n"

.end