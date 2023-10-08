* Part 5 Pseudo Opcodes

psCode1 dta c'OOEIBLESI'
psCode2 dta c'PRNCLSQMN'
psCode3 dta c'TGDLKTUBS'

psCodeV dta v(optCode)
        dta v(orgCode)
        dta v(endCode)
        dta v(iclCode)
        dta v(blkCode)
        dta v(lstCode)
        dta v(errCode)
        dta v(errCode)
        dta v(insCode)

* parse pseudo codes
prsPseu lda BFCFNAL
        cmp #$03
        beq B1L147B
B1L1479 sec
        rts
B1L147B ldx #$09
B1L147D dex
        bmi B1L1479
        lda bfCFNAM
        cmp psCode1,X
        bne B1L147D
        lda bfCFNAM+1
        cmp psCode2,X
        bne B1L147D
        lda bfCFNAM+2
        cmp psCode3,X
        bne B1L147D
        txa
        asl @
        tax
        lda psCodeV,X
        sta B1L14A7+1
        lda psCodeV+1,X
        sta B1L14A7+2
B1L14A7 jsr $FFFF
        clc
        rts

* opcode LST
lstCode jsr B1L08D8
        bne B1L14B6
B1L14B1 lda #$02
        jmp prErrMs
B1L14B6 ldx #$00
        lda bfCFNAM
        cmp #'N'
        bne B1L14C6
        stx cmdOptL
        rts
B1L14C6 dex
        cmp #'A'
        bne B1L14CF
        stx cmdOptL
        rts
B1L14CF cmp #'B'
        bne B1L14D7
        rts
B1L14D7 lda #$06
        jmp prErrMs

* parse ICL
iclCode ldx CURICLX
        lda CURICLN
        sta arrICLL,X
        lda CURICLN+1
        sta arrICLH,X
        lda CURICLF
        sta arrFILN,X
        inc CURICLX
        jsr iclImpl
        lda filenum
        sta CURICLF
* set new include
        lda #$00
        sta CURICLN
        sta CURICLN+1
        jsr stCRICL
        rts

iclImpl inc fileNum
        lda PASSNUM
        bne B1L14F5
        jsr B1L08D8
        beq B1L14B1
        ldx #$00
        jsr B1L096A
        bcc *+3
        rts
        ldx #$00
        jsr syAFile
B1L14F5 jmp openSRC

* parse END
endCode jsr endImpl
        ldx CURICLX
        beq *+3
        dex
        stx CURICLX
        lda arrICLL,X
        sta CURICLN
        lda arrICLH,X
        sta CURICLN+1
        lda arrFILN,X
        sta CURICLF
        ldx #$00
        jsr syGetFA
        jsr stCRICL
        rts

endImpl lda curFilX
        cmp #$02
        bcs B1L1503
        dec flagEnd
        rts
B1L1503 dec flagCls
        jmp closSRC

errCode lda #$09
        jmp prErrMs

B1L150B dta b($00)

* parse INS
insCode jsr iclCode
        lda PASSNUM
        bne insCpyF
* pass 0 just get length and inc PC
        jsr FILELENG
        lda FAUX3
        beq *+6
        sec
        php
        bcs insChkC
        clc
        lda FAUX1
        adc PROGCNT
        sta PROGCNT
        lda FAUX2
        adc PROGCNT+1
        sta PROGCNT+1
        php
insChkC jsr endCode
        plp
        bcc *+7
        lda #$13
        jsr prErrMs
        rts
insCpyF jsr insLoop
        jsr endCode
        rts

insLoop lda bufReaV
        sta FAUX1
        lda bufReaV+1
        sta FAUX2
        lda <bufReaS
        sta FAUX4
        lda >bufReaS
        sta FAUX5
        lda #$00
        sta SYSCALL
        jsr FREAD
        php
        jsr insCopy
        plp
        bpl insLoop
        rts

* copy read buffer to output
insCopy lda bufReaV
        sta ZTEMP1
        lda bufReaV+1
        sta ZTEMP1+1
        lda FAUX4
        sta ZTEMP2
        lda FAUX5
        sta ZTEMP2+1
        ldy #$00
insCpyL lda ZTEMP2
        ora ZTEMP2+1
        beq insCpyE
        dec ZTEMP2
        lda ZTEMP2
        cmp #$FF
        bne *+4
        dec ZTEMP2+1
        lda (ZTEMP1),Y
        jsr outByte
        iny
        bne insCpyL
        inc ZTEMP1+1
        bne insCpyL
insCpyE rts

* parse OPT
optCode jsr B1L0B18
        bcs B1L1547
        lda B1L09AD
        and #$7C
        beq B1L151D
        lda #$0C
        jmp prErrMs
B1L151D lda B1L09AE
        and #$03
        bne B1L152A
        sta cmdOptL
B1L152A ldx #$FF
        cmp #$01
        bne B1L1535
        beq B1L1538
B1L1535 stx cmdOptL
B1L1538 ldx #$01
        lda B1L09AE
        and #$60
        cmp #$60
        bne B1L1544
        dex
B1L1544 stx B1L150B
B1L1547 rts

orgCode jsr B1L15AE
        ldx B1L150B
        jmp B1L1582

blkKind dta c'NDSREU'

blkKndV dta v(blkNone)
        dta v(blkADOS)
        dta v(blkSpar)
        dta v(blkRelo)
        dta v(blkEmpt)
        dta v(blkUpdt)

* parse BLK
blkCode jsr B1L08D8
        bne B1L156D
        lda #$02
        jmp prErrMs
B1L156D jsr B1L15AE
        lda bfCFNAM
        ldx #$05
        cmp blkKind,X
        beq B1L1582
        dex
        bpl *-6
        lda #$06
        jmp prErrMs
B1L1582 stx B1L1D6A
        inc B1L1D63
        bne B1L158F
        lda #$0B
        jmp prErrMs
B1L158F txa
        asl @
        tax
        lda blkKndV,X
        sta B1L15AA+1
        lda blkKndV+1,X
        sta B1L15AA+2
        jsr B1L08D8
        bne B1L15A8
        lda #$02
        jmp prErrMs
B1L15A8 lda PASSNUM
B1L15AA jmp $FFFF

B1L15AD dta b($00)

B1L15AE lda B1L1D63
        beq B1L15F5
        lda B1L1D6A
        sta B1L1D6B
        jsr B1L1D6C
        lda PASSNUM
        bne B1L15F5
        ldy #$07
        lda PROGCNT
        sta ($84),Y
        iny
        lda PROGCNT+1
        sta ($84),Y
        lda B1L1D65
        and #$70
        bne B1L15F5
        ldx B1L1D64
        cpx B1L15AD
        beq B1L15F5
        stx B1L15AD
        lda BLKPCNT
        sta bfL210C,X
        lda BLKPCNT+1
        sta bfL2114,X
        lda PROGCNT
        sta BLKPCNT
        sta bfL211C,X
        lda PROGCNT+1
        sta BLKPCNT+1
        sta bfL2124,X
B1L15F5 rts

B1L15F6 ldx #$07
B1L15F8 lda B1L09AE
        cmp bfL211C,X
        lda B1L09AF
        sbc bfL2124,X
        bcs B1L1617
        lda B1L09AE
        cmp bfL210C,X
        lda B1L09AF
        sbc bfL2114,X
        bcs B1L1619
        dex
        bne B1L15F8
B1L1617 sec
        dta b(BIT_zp)
B1L1619 clc
        rts

initDat ldx #$07
        lda #$00
        sta bfL210C,X
        sta bfL211C,X
        lda #$A0
        sta bfL2114,X
        sta bfL2124,X
        dex
        bne *-17
        rts

B1L1631 lda B1L1D66
        cmp B1L1D68
        lda B1L1D67
        sbc B1L1D69
        bcc B1L1645
        lda B1L1D6B
        sta B1L1D6A
B1L1645 rts

blkNone bne B1L1671
B1L1648 lda #$FF
B1L164A sta B1L1D65
        jsr B1L0B22
        bcs B1L167E
        lda B1L09AD
        and #$5C
        beq B1L165E
        lda #$0C
        jmp prErrMs
B1L165E lda B1L09AE
        sta PROGCNT
        sta B1L1D66
        lda B1L09AF
        sta PROGCNT+1
        sta B1L1D67
        jmp B1L1D91
B1L1671 jsr B1L1D6C
        lda B1L1D66
        sta PROGCNT
        lda B1L1D67
        sta PROGCNT+1
B1L167E rts

blkADOS beq B1L1648
        jsr B1L1671
        jsr B1L1631
        bcs B1L167E
        lda B1L1D6B
        cmp #$01
        beq B1L1698
        lda #$FF
        jsr B1L089F
        jsr B1L089F
B1L1698 sec
        lda B1L1D68
        sbc #$01   
        sta B1L1D68
        bcs B1L16A6
        dec B1L1D69
B1L16A6 ldx #$00
B1L16A8 lda B1L1D66,X
        jsr B1L089F
        inx
        cpx #$04
        bcc B1L16A8
        jmp B1L1D6C

blkSpar bne B1L16BD
        lda #$FE
        jmp B1L164A
B1L16BD jsr B1L1671
        jsr B1L1631
        bcs B1L167E
        lda #$FA
        jsr B1L089F
        lda #$FF
        jsr B1L089F
        jmp B1L1698

blkRelo bne B1L1715
        lda BLKPCNT
        sta B1L1D66
        sta PROGCNT
        lda BLKPCNT+1
        sta B1L1D67
        sta PROGCNT+1
        ldx #$00
        stx B1L1D65
B1L16E7 ldx #$00
        lda bfCFNAM
        cmp #'M'
        beq B1L16F6
        cmp #'E'
        bne B1L170F
        inx
        inx
B1L16F6 txa
        ora B1L1D65
        sta B1L1D65
        inc B1L1D64
        lda B1L1D64
        cmp #$08
        bcc B1L170C
        lda #$0B
        jmp prErrMs
B1L170C jmp B1L1D91
* ERROR: Illegal symbol
B1L170F lda #$06
        jmp prErrMs
B1L1714 rts
B1L1715 jsr B1L1671
B1L1718 jsr B1L1631
        bcs B1L1714
        lda #$FE
        jsr B1L089F
        lda #$FF   
        jsr B1L089F
        sec
        lda B1L1D68
        sbc B1L1D66
        sta B1L1D68
        lda B1L1D69
        sbc B1L1D67
        sta B1L1D69
        sec
        lda B1L1D67
        sbc #$10
        sta B1L1D67
        ldx #$00
B1L1745 lda B1L1D64,X
        jsr B1L089F
        inx
        cpx #$06
        bcc B1L1745
        jmp B1L1D6C

blkEmpt bne B1L178D
        jsr B1L0B22
        bcs B1L1714
        lda B1L09AD
        and #$5C
        beq B1L1766
        lda #$0C
        jmp prErrMs
B1L1766 clc
        lda BLKPCNT
        sta B1L1D66
        adc B1L09AE
        sta PROGCNT
        lda BLKPCNT+1
        sta B1L1D67
        adc B1L09AF
        sta PROGCNT+1
        lda #$80
        sta B1L1D65
        jsr B1L08D8
        beq B1L1788
        jmp B1L16E7
B1L1788 lda #$02
        jmp prErrMs
B1L178D jsr B1L1671
        jmp B1L1718

blkUpdt dec B1L1D63
        lda B1L1D63
        bne B1L17A0
        lda #$0D
        jmp prErrMs
B1L17A0 lda bfCFNAM
        cmp #$4E
        bne B1L17AA
        jmp B1L197B
B1L17AA cmp #$53
        bne B1L17B1
        jmp B1L18A1
B1L17B1 cmp #$41
        bne B1L17B8
        jmp B1L17BE
B1L17B8 lda #$06
        jmp prErrMs

B1L17BD dta b($00)

B1L17BE lda PASSNUM
        bne B1L17C3
B1L17C2 rts
B1L17C3 lda unResLa
        ora unResLa+1
        bne B1L17C2
        lda B1L1D64
        sta B1L17BD
        inc B1L17BD
B1L17D4 dec B1L17BD
        bne B1L17DC
        jmp B1L1CD9
B1L17DC jsr B1L1CE8
        bmi B1L17D4
B1L17E1 cmp B1L17BD
        beq B1L17ED
        jsr B1L1CF5
        bpl B1L17E1
        bmi B1L17D4
B1L17ED sta B1L1863
        lda #$FD
        jsr B1L089F
        lda #$FF
        jsr B1L089F
        lda B1L1863
        jsr B1L089F
        lda #$00
        jsr B1L089F
        jsr B1L089F
        sta B1L1863
B1L180B ldy #$00
        lda ($92),Y
        cmp B1L17BD
        bne B1L184B
        iny
        lda ($92),Y
        bpl B1L182D
        lda #$FD   
        jsr B1L089F
        iny
        lda ($92),Y
        jsr B1L089F
        iny
        lda ($92),Y
        jsr B1L089F
        jmp B1L184B
B1L182D jsr B1L1864
        sec
        iny
        lda ($92),Y
        sbc $96
        sta $94
        iny
        lda ($92),Y
        sbc $97
        sta $95
        lda ($92),Y
        sta $97
        dey
        lda ($92),Y
        sta $96
        jsr B1L187A
B1L184B jsr B1L1CF5
        bpl B1L180B
        lda #$FC
        jsr B1L089F
        jmp B1L17D4
B1L1858 lda #$00
        sta $94
        sta $96
        sta $95
        sta $97
B1L1862 rts

B1L1863 dta b($00)

B1L1864 cmp B1L1863
        beq B1L1862
        sta B1L1863
        lda #$FE
        jsr B1L089F
        lda B1L1863
        jsr B1L089F
        jmp B1L1858
B1L187A lda $94
        cmp #$FC
        lda $95
        sbc #$00
        bcc B1L1897
        sec
        lda $94
        sbc #$FA
        sta $94
        bcs B1L188F
        dec $95
B1L188F lda #$FF
        jsr B1L089F
        jmp B1L187A
B1L1897 lda $94
        jmp B1L089F

B1L189C dta b($00)
B1L189D dta b($00)
B1L189E dta b($00)
B1L189F dta b($00)
B1L18A0 dta b($00)

B1L18A1 lda PASSNUM
        bne B1L18A6
B1L18A5 rts
B1L18A6 lda unResLa
        ora unResLa+1
        bne B1L18A5
        lda #$FF
        sta B1L189C
        lda MEMMIN
        sta B1L189E
        lda MEMMIN+1
        sta B1L189F
B1L18BD lda B1L189E
        sta $84
        lda B1L189F
        sta $85
        lda #$FF
        sta B1L189D
        jsr B1L1D43
        php
        lda $98
        sta B1L189E
        lda $99
        sta B1L189F
        plp
        bcc B1L18F1
        lda B1L1D63
        sta B1L18A0
B1L18E3 lda B1L189C
        bne B1L18ED
        lda #$FC
        jsr B1L089F
B1L18ED rts

B1L18EE jsr B1L1C25
B1L18F1 beq B1L18BD
        jsr B1L1CCB
        lda B1L18A0
        cmp B1L1C40
        bcs B1L18EE
        lda B1L1D63
        cmp B1L1C40
        bcs B1L1912
        lda B1L189E
        sta $98
        lda B1L189F
        sta $99
        bne B1L18BD
B1L1912 lda B1L189D
        beq B1L193B
        jsr B1L18E3
        ldx #$FF
        stx B1L1863
        inx
        stx B1L189C
        stx B1L189D
        lda #$FB
        jsr B1L089F
        lda #$FF
        jsr B1L089F
        jsr B1L08C2
        lda #$00
        jsr B1L089F
        jsr B1L089F
B1L193B lda B1L1C42
        and #$70
        beq B1L1956
        lda #$FD
        jsr B1L089F
        lda B1L1C43
        jsr B1L089F
        lda B1L1C44
        jsr B1L089F
        jmp B1L18EE
B1L1956 lda B1L1C41
        jsr B1L1864
        sec
        lda B1L1C43
        sbc $96
        sta $94
        lda B1L1C44
        sbc $97
        sta $95
        lda B1L1C43
        sta $96
        lda B1L1C44
        sta $97
        jsr B1L187A
        jmp B1L18EE
B1L197B jsr B1L0B18
        bcs B1L1992
        lda B1L09AD
        and #$5C
        beq B1L1993
        lda #$0C
        dta b(BIT_abs)
B1L198A lda #$0d
        dta b(BIT_abs)
B1L198D lda #$02
        jmp prErrMs
B1L1992 rts
B1L1993 jsr B1L08D8
        beq B1L198D
        jsr B1L1D21
        bcs B1L1992
        lda PASSNUM
        beq B1L1992
        lda #$FC
        jsr B1L089F
        lda #$FF
        jsr B1L089F
        jsr B1L15F6
        bcs B1L198A
        txa
        jsr B1L089F
        lda B1L09AE
        jsr B1L089F
        sec
        lda B1L09AF
        sbc #$10
        jsr B1L089F
        jmp B1L08C2

        end
