.global CRONOMETRA

CRONOMETRA:
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

    ldw r11, 0(r23)                # Carrega unidade do cronômetro
    ldw r12, 4(r23)                # Carrega dezena do cronômetro
    ldw r13, 8(r23)                # Carrega centena do cronômetro
    ldw r14, 12(r23)               # Carrega milhar do cronômetro
    movi r7, 9                     # Valor limite para cada dígito (0-9)

    bne r11, r7, SOMA              # Se unidade != 9, vai para SOMA
        movi r11, 0                # Zera unidade
        addi r12, r12, 1           # Incrementa dezena

    blt r12, r7, DONE              # Se dezena < 9, vai para DONE
        movi r12, 0                # Zera dezena
        addi r13, r13, 1           # Incrementa centena

    blt r13, r7, DONE              # Se centena < 9, vai para DONE
        movi r13, 0                # Zera centena
        addi r14, r14, 1           # Incrementa milhar
        br DONE                    # Vai para DONE

SOMA:
    addi r11, r11, 1               # Incrementa unidade

DONE:
    # Salva no r23 a contagem atual para a próxima iteração
    stw r11, 0(r23)
    stw r12, 4(r23)
    stw r13, 8(r23)
    stw r14, 12(r23)

    # Por ser word, cada valor ocupa 4 bytes, logo multiplicamos por 4
    muli r11, r11, 4
    muli r12, r12, 4
    muli r13, r13, 4
    muli r14, r14, 4

    # Adiciona o endereço base dos números ao deslocamento calculado
    addi r11, r11, NUMBERS
    addi r12, r12, NUMBERS
    addi r13, r13, NUMBERS
    addi r14, r14, NUMBERS

    # Carrega os valores correspondentes aos dígitos do cronômetro
    ldw r11, (r11)
    ldw r12, (r12)
    ldw r13, (r13)
    ldw r14, (r14)

    # Combina os valores dos dígitos para formar o número completo
    slli r12, r12, 8
    slli r13, r13, 16
    slli r14, r14, 24

    # Combina os valores em r11
    or r11, r11, r12
    or r11, r11, r13
    or r11, r11, r14

    movia r5, DISPLAY              # Endereço do display de 7 segmentos
    stwio r11, (r5)                # Atualiza display com novo valor

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