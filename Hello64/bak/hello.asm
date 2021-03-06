; Key in the basic program "10 SYS 4096"
; which invokes whatever machine code at addr 4096
*=$0801
        byte $0c, $08, $0a, $00, $9e, $20
        byte $34, $30, $39, $36, $00, $00
        byte $00

; Put the machine code at address $1000 = 4096 dec
*=$1000

; the addresses from $0400 to $07E7 correspond to the screen
; the addresses from $d800 to $d8E7 correspond to the Color RAM
; the address $00D6 corresponds to the cursor line

        ; clear the screen
clear   ldx #$00
        lda #$20 ; the space character
loop1   sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $06E8,x ; to make sure we stay within $07E7
        inx
        bne loop1

        ; Print the hello world string
        ldx #$00
loop2   lda message,x
        and #$3f        ; keep only the charcters (should not be necessary)
        sta $0436,x 
        inx
        cpx #$0c        ; $0c = length of the string to display
        bne loop2

        ; change the color of the letters
        lda #$00
        ldx #$00
loop3   adc #1
        inx
        sta $d836,x
        cmp #$0c
        bne loop3

        ; move cursor to line 4
        lda #$03   
        sta $00D6  

        rts
message
        text 'Hello world!'
