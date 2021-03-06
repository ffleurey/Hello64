; Key in the basic program "10 SYS 4096"
; which invokes whatever machine code at addr 4096
*=$0801

; jmp $1000
!BYTE $0c, $08, $0a, $00, $9e, $20
!BYTE $34, $30, $39, $36, $00, $00
!BYTE $00

; my ball sprite data
*=$0900

!BYTE $00,$3F,$00,$00,$FF,$C0
!BYTE $03,$FF,$F0,$07,$C3,$F8
!BYTE $0F,$0F,$FC,$1E,$3F,$FC
!BYTE $1C,$7F,$FE,$38,$FF,$FE
!BYTE $39,$FF,$FE,$73,$FF,$FE
!BYTE $73,$FF,$FE,$77,$FF,$FE
!BYTE $7F,$FF,$FE,$7F,$FF,$FC
!BYTE $3F,$FF,$FC,$3F,$FF,$F8
!BYTE $3F,$FF,$F0,$1F,$FF,$E0
!BYTE $1F,$FF,$C0,$07,$FF,$80
!BYTE $00,$7C,$00

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
        sta $D027

        ; initialize the position of sprite 0 to A0 x A0
        lda #$50        ; some coordinates
        ldx #$00   
        sta $D000,x    ; X

        lda #$33        ; some coordinates
        ldx #$01
        sta $D000,x    ; Y

updatex  ; update the sprite coordinates
        lda $D000
        clc
        adc dx
        sta $D000
        bcs xover       ; over 255
        lda dx
        bmi goingleft
        jmp leftorright

xover   
        lda dx
        bmi goingleft

flipbit9
        lda $D010       ; the 9th bit for the x coordinates for all sprites
        eor #$01
        sta $D010     
        jmp leftorright

goingleft
        lda #$00
        sec
        sbc dx
        clc
        adc $D000
        bcs flipbit9  

leftorright
        lda $D010
        and #$01
        bne right
left
        lda $D000
        cmp #$15
        beq bouncex
        jmp updatey
right
        lda $D000
        cmp #$40
        beq bouncex

        jmp updatey
bouncex
        lda #$00
        sec
        sbc dx
        sta dx
        ; increment the color
        inc $D027     
        inc $D020

updatey
        lda $D001
        clc
        adc dy
        sta $D001

        cmp #$E5
        beq bouncey
        cmp #$30
        beq bouncey

        jmp waitfornextline
bouncey
        lda #$00
        sec
        sbc dy
        sta dy
        inc $D027
        inc $D020

waitfornextline
        ; wait for the next line to be traced (to make sure that the next time we see line $FB we will be on the next frame)
        lda $d012
loop0   cmp $d012
        beq loop0 ; loop as long as we are on the same line
        
        ; wait for the tracing of the #FB line (which is off screen)
loop1   lda $D012
        cmp #$FB
        bne loop1 ; loop as long as we have not reached line $FB
        
        jmp updatex  
        
        rts

dx      !BYTE $01
dy      !BYTE $01



