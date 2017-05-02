*=$0801

start
        lda #$00
loop    
        ldx dx
        sec
        sbc #1
        sta dx
        jmp loop


dx      byte $01