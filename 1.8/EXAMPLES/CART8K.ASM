; Example for standard 8k cartridge
;   compiles rom file for $A000-$BFFF

ZP_TEMP1 equ $80

DOSVEC   equ $0A
CH       equ $2FC

IOCB0    equ $340

CIOV     equ $E456

ICCOM    equ $02
ICBLL    equ $08
ICBLH    equ $09

C8K_STRT equ $A000
C8K_CONF equ $BFFA

; cartridge code
         blk none C8K_STRT

start    jsr print
         dta b($9B)
         dta c'Hello World!',b($9B)
         dta c'<press any key>',b($9B)
         dta b($00)
; check for key
         lda #$FF
         cmp CH
         beq *-3
         sta CH
; back to DOS
         jmp (DOSVEC)

; cartridge initialization code
;   no initilization for now
init     rts

; print string to console
print    pla
         sta ZP_TEMP1
         pla
         sta ZP_TEMP1+1
prnt_lp  inc ZP_TEMP1
         bne prnt_lda
         inc ZP_TEMP1+1
prnt_lda ldy #$00
         lda (ZP_TEMP1),Y
         beq prnt_end
         jsr putc
         jmp prnt_lp
prnt_end lda ZP_TEMP1+1
         pha
         lda ZP_TEMP1
         pha
         rts
; put char to console
putc     tay
         lda #$00
         tax
         sta IOCB0+ICBLL,X
         sta IOCB0+ICBLH,X
         lda #$0B
         sta IOCB0+ICCOM,X
         tya
         jmp CIOV

; cartdrige config register
         blk padding C8K_CONF $FF
CARTCS   dta a(start) ; start address
CART     dta b($00)   ; 0 for cartridge
CARTFG   dta b($01)   ; boot on (Bit0=1)
CARTAD   dta a(init)  ; init address

         end
