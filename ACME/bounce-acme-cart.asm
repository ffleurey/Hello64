; bounce in a cart

; Define 2 variables in the RAM area $C000-$CFFF
	dx = $C000
	dy = $C001

*=$8000
 
     !word coldstart            ; coldstart vector
     !word warmstart            ; warmstart vector
     !byte $C3,$C2,$CD,$38,$30  ; "CBM8O". Autostart string

; sprite data
*=$8020

!byte $fa,$54,$5e,$22,$56,$50,$23,$d5
!byte $56,$22,$54,$d2,$22,$54,$5e,$00
!byte $00,$00,$03,$00,$20,$07,$06,$30
!byte $04,$86,$30,$04,$8e,$30,$04,$9c
!byte $60,$0c,$54,$60,$0c,$74,$40,$0c
!byte $64,$c0,$18,$08,$c0,$18,$08,$c0
!byte $30,$09,$c0,$30,$19,$f0,$00,$19
!byte $fc,$00,$10,$1c,$00,$00,$00,$02

*=$8200

coldstart
     sei
     stx $d016
     jsr $fda3 ;Prepare IRQ
     jsr $fd50 ;Init memory. Rewrite this routine to speed up boot process.
     jsr $fd15 ;Init I/O
     jsr $ff5b ;Init video
     cli
     
warmstart

showball

		;Switch to Video Bank 2 (8000 - BFFF)
		; Not a good idea here since it changes all the addr for the VIC II variable
		;LDA $DD00
		;AND #%11111100
		;ORA #%00000001
		;STA $DD00
		
		; initialize variables
		lda #$01
		sta dx
		sta dy
		
		; copy sprite data from $8020 to $0900 (in the VIC II bank)
		ldx #$00
copy_loop
		lda $8020, x
		sta $0900, x
		inx
		cpx #63
		bcc copy_loop

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

;dx      !BYTE $01
;dy      !BYTE $01
 
* = $9fff                     ; fill up to -$9fff (or $bfff if 16K)
     !byte 0