.global PUT_JTAG

PUT_JTAG:
    # Save any modified registers
    subi sp, sp, 4          # Reserve space on the stack
    stw r4, 0(sp)           # Save register
    ldwio r4, 4(r6)         # Read the JTAG UART Control register
    andhi r4, r4, 0xffff    # Check for write space
    beq r4, r0, END_PUT     # If no space, ignore the character
    stwio r5, 0(r6)         # Send the character
    
END_PUT:
    # Restore registers
    ldw r4, 0(sp)
    addi sp, sp, 4
ret