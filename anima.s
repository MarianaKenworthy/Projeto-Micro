.global ANIMA

ANIMA:
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

    # Carrega o valor atual da animação dos LEDs
    movia r18, LED_ANIM            # Endereço da variável LED_ANIM
    ldw r19, 0(r18)                # r19 = valor atual dos LEDs animados

    # Lê o estado da chave SW0 para definir a direção
    movia r10, 0x10000040          # Endereço base dos switches
    ldw r9, 0(r10)                 # Lê switches
    andi r9, r9, 0x1               # Isola apenas o SW0

    movia r10, DIR_FLAG            # Endereço da flag de direção
    stw r9, 0(r10)                 # Salva direção (0 = esquerda, 1 = direita)

    beq r9, r0, DIR_ESQ            # Se SW0 == 0, vai para DIR_ESQ (esquerda)
    br ESQ_DIR                     # Caso contrário, vai para ESQ_DIR (direita)

DIR_ESQ:
    slli r19, r19, 1               # Desloca LEDs para a esquerda
    movi r21, 0b1000000000000000000 # Valor limite (um bit a mais do que o LED mais à esquerda)
    bge r19, r21, RESET_DIR_ESQ    # Se passou do limite, reseta
    br DONE                        # Caso contrário, termina

ESQ_DIR:
    srli r19, r19, 1               # Desloca LEDs para a direita
    ble r19, r0, RESET_ESQ_DIR     # Se chegou ao limite direito, reseta
    br DONE                        # Caso contrário, termina

RESET_DIR_ESQ:
    movia r19, 0x1                 # Reinicia no LED mais à esquerda (bit 0)
    br DONE

RESET_ESQ_DIR:
    movia r19, 0b100000000000000000 # Reinicia no LED mais à direita (bit 8)
    br DONE

DONE:
    movia r20, LEDR                # Endereço dos LEDs físicos
    stwio r19, 0(r20)              # Atualiza LEDs físicos
    movia r21, LED_ANIM            # Endereço da variável LED_ANIM
    stw r19, 0(r21)                # Atualiza valor da animação

    # Restaura todos os registradores salvos
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

    ret