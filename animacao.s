.global ANIMACAO

## endereço dos led e tal
## temp = 200 ms

ANIMACAO:
    ## beq command[1], 0, INICIA_ANIMACAO
    ## beq command[1], 0, PARA_ANIMACAO

INICIA_ANIMACAO:
    ## beq SW[0], 0, DIR_ESQ
    ## beq SW[0], 1, ESQ_DIR

DIR_ESQ:


ESQ_DIR:


PARA_ANIMACAO:


DONE:
    ret