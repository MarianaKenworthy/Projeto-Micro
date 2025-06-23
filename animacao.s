.global ANIMACAO_HANDLER

ANIMACAO_HANDLER:
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

    ldb r5, 1(r7)                  # Lê o comando de ação (command[1])

    movi r8, 0x30                  # ASCII '0'
    beq r5, r8, INICIA_ANIMACAO    # Se comando for '0', inicia animação

    movi r8, 0x31                  # ASCII '1'
    beq r5, r8, PARA_ANIMACAO      # Se comando for '1', para animação

    br DONE                        # Se não for nenhum dos dois, termina

INICIA_ANIMACAO:
    # Ativa a flag de animação
    movi r11, 1                    # Valor para ativar
    movia r12, FLAG_ANIMACAO       # Endereço da flag de animação
    stw r11, 0(r12)                # Ativa a flag
    br DONE

PARA_ANIMACAO:
    movia r10, FLAG_ANIMACAO       # Endereço da flag de animação
    movi r9, 0                     # Valor para desativar
    stw r9, 0(r10)                 # Desativa animação
    movia r20, LEDR                # Endereço dos LEDs
    stwio r0, 0(r20)               # Apaga todos os LEDs

DONE:
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