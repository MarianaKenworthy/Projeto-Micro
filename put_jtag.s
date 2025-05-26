.global PUT_JTAG

PUT_JTAG:
/* save any modified registers */
    subi sp, sp, 4 /* reserve space on the stack */
    stw r4, 0(sp) /* save register */
    ldwio r4, 4(r6) /* read the JTAG UART Control register */
    andhi r4, r4, 0xffff /* check for write space */
    beq r4, r0, END_PUT /* if no space, ignore the character */
    stwio r5, 0(r6) /* send the character */
    
END_PUT:
/* restore registers */
    ldw r4, 0(sp)
    addi sp, sp, 4
ret

