.global LED

## endereço dos led e tal

LED:
    movia r12, LEDR                  # Carrega o endereço base dos LEDs em r12

    ldb r5, 1(r7)                    # command[1]

    ldb r10, 2(r7)                   # command[2]
    subi r10, r10, 48                # -30 já que o que tem no buffer é o char e não o valor
    muli r11, r10, 10                # command[2] * 10

    ldb r10, 3(r7)                   # command[3]
    subi r10, r10, 48                # -30 já que o que tem no buffer é o char e não o valor

    add r11, r11, r10                # r11 = número do LED (dezena + unidade)

    movi r13, 0b0000000000000001     # Máscara inicial para o LED 0
    mov r14, r0                      # Contador de deslocamento (inicia em 0)

COUNT:
    beq r14, r11, FIM_COUNT          # Se já deslocou até o LED desejado, sai
    slli r13, r13, 1                 # Desloca a máscara para o próximo LED
    addi r14, r14, 1                 # Incrementa o contador
    br COUNT                         # Repete até chegar no LED desejado

FIM_COUNT:

    ldwio r15, 0(r12)                # Lê o estado atual dos LEDs

    movi r8, 0x30                    # ASCII '0' (acender)
    beq r5, r8, ACENDE               # Se comando for '0', acende o LED

    movi r8, 0x31                    # ASCII '1' (apagar)
    beq r5, r8, APAGA                # Se comando for '1', apaga o LED

    br DONE                          # Se não for nenhum dos dois, termina
    

ACENDE:
    or r13, r15, r13                 # Liga o LED desejado (OR com a máscara)
    stwio r13, 0(r12)                # Escreve o novo valor nos LEDs
    br DONE

APAGA:
    nor r13, r13, r13                # Inverte a máscara (para apagar)
    and r13, r15, r13                # Apaga o LED desejado (AND com a máscara invertida)
    stwio r13, 0(r12)                # Escreve o novo valor nos LEDs
    br DONE

DONE:
    ret
