; Key in the basic program "10 SYS 4096"
; which invokes whatever machine code at addr 4096
*=$0801
        byte $0c, $08, $0a, $00, $9e, $20
        byte $34, $30, $39, $36, $00, $00
        byte $00

; my ball sprite data
*=$0900
 BYTE $00,$3F,$00,$00,$FF,$C0
 BYTE $03,$FF,$F0,$07,$C3,$F8
 BYTE $0F,$87,$FC,$1F,$0F,$FC
 BYTE $1E,$1F,$FE,$3E,$3F,$FE
 BYTE $3C,$7F,$FE,$7C,$FF,$FE
 BYTE $7C,$FF,$FE,$7F,$FF,$FE
 BYTE $7F,$FF,$FE,$7F,$FF,$1C
 BYTE $3F,$FF,$1C,$3F,$FF,$18
 BYTE $3F,$FF,$F0,$1F,$FF,$E0
 BYTE $1F,$FF,$C0,$07,$FF,$80
 BYTE $00,$7C,$00



; Put the machine code at address $1000 = 4096 dec
*=$1000

showball
        ; set the address of the data for sprite 0
        lda #$24        ; the address of the sprite data (0x24 * 0x40 = 0x0900)
        ldx #$00
        sta $07F8,x     ; pointer for the data for sprite 0

         ; enable sprite 0
        lda #$FF
        ldx #$15
        sta $D000,x
        
        ; sprite 0 color
        lda #$07        ; yellow
        ldx #$00
        sta $D027,x


        lda #$A0        ; some coordinates

        ldx #$00   
        sta $D000,x    ; X

        ldx #$01
        sta $D000,x    ; Y
 
        rts