# Projeto Microprocessador

Este projeto implementa funcionalidades de controle de LEDs, animação visual e um cronômetro em um sistema embarcado utilizando um processador Nios II. A interação com o sistema ocorre via JTAG UART.

## Funcionalidades

O projeto oferece as seguintes funcionalidades principais:

* **Controle de LEDs**: Permite acender ou apagar LEDs individuais através de comandos enviados pela JTAG UART.
* **Animação de LEDs**: Habilita e desabilita uma animação visual nos LEDs. A direção da animação pode ser controlada por uma chave (SW0).
* **Cronômetro**: Inicia, pausa e zera um cronômetro que exibe a contagem em um display de 7 segmentos. O cronômetro é pausado e despausado pelo botão KEY1.

## Estrutura do Projeto

O projeto é composto pelos seguintes arquivos assembly:

* `main.s`: Contém o ponto de entrada do programa (`_start`), a rotina de tratamento de interrupções (RTI), a lógica principal de polling da JTAG UART e o roteamento dos comandos para as respectivas funcionalidades.
* `led.s`: Implementa a lógica para acender ou apagar LEDs específicos com base nos comandos recebidos.
* `anima.s`: Contém a rotina para a animação dos LEDs, incluindo a leitura da chave deslizante para determinar a direção.
* `animacao.s`: Handler para iniciar e parar a animação dos LEDs, ativando ou desativando uma flag de controle.
* `cronometra.s`: Lógica para atualizar a contagem do cronômetro e exibir os valores no display de 7 segmentos.
* `cronometro.s`: Handler para iniciar, parar e resetar o cronômetro, manipulando flags de controle e zerando o display.
* `put_jtag.s`: Rotina para enviar um caractere para a JTAG UART.

## Cronograma de Desenvolvimento

O projeto seguiu o seguinte cronograma:

| Data | Tarefa|
|-------|-------|
| 26/05 | Planejamento e main|
| 02/06 | UART e LED |
| 09/06 | Animação |
| 16/06 | Cronômetro |

## Comandos UART

Para interagir com o sistema, envie os seguintes comandos via JTAG UART:

* **Controle de LED**:
    * `0<ação><led_dezena><led_unidade>`: `ação` é '0' para acender ou '1' para apagar. `led_dezena` e `led_unidade` são os dígitos do número do LED vermelho (ex: `0010` para acender o LED 10, `0110` para apagar o LED 10).
* **Animação de LEDs**:
    * `10`: Inicia a animação dos LEDs.
    * `11`: Para a animação dos LEDs.
* **Cronômetro**:
    * `20`: Inicia o cronômetro.
    * `21`: Para o cronômetro e zera o display.

## Interrupções

O sistema utiliza interrupções para as seguintes finalidades:

* **IRQ 0 (Timer)**: Usada para controlar a frequência de atualização da animação dos LEDs e a contagem do cronômetro.
* **IRQ 1 (Botão KEY1)**: Utilizada para pausar e despausar o cronômetro.