.global CRONOMETRO_HANDLER

CRONOMETRO_HANDLER:
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

    movi r8, 0x30                  # ASCII '0' (inicia cronômetro)
    beq r5, r8, INICIA_CRONOMETRO  # Se comando for '0', inicia cronômetro

    movi r8, 0x31                  # ASCII '1' (para cronômetro)
    beq r5, r8, PARA_CRONOMETRO    # Se comando for '1', para cronômetro

INICIA_CRONOMETRO:
    movi r11, 1                    # Valor para ativar
    movia r12, FLAG_CRONOMETRO     # Endereço da flag do cronômetro
    stw r11, 0(r12)                # Ativa o cronômetro
    br DONE

PARA_CRONOMETRO:
    movia r10, FLAG_CRONOMETRO     # Endereço da flag do cronômetro
    movi r9, 0                     # Valor para desativar
    stw r0, 0(r23)                 # Zera variável do cronômetro (posição 0)
    stw r0, 4(r23)                 # Zera variável do cronômetro (posição 4)
    stw r0, 8(r23)                 # Zera variável do cronômetro (posição 8)
    stw r0, 12(r23)                # Zera variável do cronômetro (posição 12)
    stw r9, 0(r10)                 # Desativa cronômetro
    movia r20, DISPLAY             # Endereço do display de 7 segmentos
    stwio r0, 0(r20)               # Limpa o display
    br DONE

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
    addi sp, sp, 40                # Libera espaço da pilha
    ret