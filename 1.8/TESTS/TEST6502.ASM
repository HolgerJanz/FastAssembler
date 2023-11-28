;  Test all 6502 operations
* with * and ; comments

BLK DOS $3000
label  RTS

; ADC (ADd with Carry)

;     SYNTAX     HEX LEN   MODE        
 ADC #$44       :$69  2  Immediate    
 ADC $44        :$65  2  Zero Page    
 ADC $44,X      :$75  2  Zero Page,X  
 ADC $4400      :$6D  3  Absolute     
 ADC $4400,X    :$7D  3  Absolute,X   
 ADC $4400,Y    :$79  3  Absolute,Y   
 ADC ($44,X)    :$61  2  Indirect,X   
 ADC ($44),Y    :$71  2  Indirect,Y   

; AND (bitwise AND with accumulator) 

;   SYNTAX       HEX LEN  MODE
 AND #$44       :$29  2  Immediate
 AND $44        :$25  2  Zero Page
 AND $44,X      :$35  2  Zero Page,X
 AND $4400      :$2D  3  Absolute
 AND $4400,X    :$3D  3  Absolute,X
 AND $4400,Y    :$39  3  Absolute,Y
 AND ($44,X)    :$21  2  Indirect,X
 AND ($44),Y    :$31  2  Indirect,Y

; ASL (Arithmetic Shift Left) 

;   SYNTAX       HEX LEN  MODE        
 ASL @          :$0A  1  Accumulator (Implied)
 ASL $44        :$06  2  Zero Page    
 ASL $44,X      :$16  2  Zero Page,X  
 ASL $4400      :$0E  3  Absolute     
 ASL $4400,X    :$1E  3  Absolute,X   

; BIT (test BITs) 

;    SYNTAX      HEX LEN  MODE        
 BIT $44        :$24  2  Zero Page    
 BIT $4400      :$2C  3  Absolute     

* Branch Instructions

* MNEMONIC   HEX
 BPL label  :$10 (Branch on PLus)          
 BMI label  :$30 (Branch on MInus)         
 BVC label  :$50 (Branch on oVerflow Clear)
 BVS label  :$70 (Branch on oVerflow Set)  
 BCC label  :$90 (Branch on Carry Clear)   
 BCS label  :$B0 (Branch on Carry Set)     
 BNE label  :$D0 (Branch on Not Equal)     
 BEQ label  :$F0 (Branch on EQual)         

; BRK (BReaK) 
;   SYNTAX       HEX LEN  MODE         
 BRK            :$00  1  Implied      

; CMP (CoMPare accumulator) 

;   SYNTAX       HEX LEN MODE         
 CMP #$44      :$C9  2   Immediate    
 CMP $44       :$C5  2   Zero Page    
 CMP $44,X     :$D5  2   Zero Page,X  
 CMP $4400     :$CD  3   Absolute     
 CMP $4400,X   :$DD  3   Absolute,X   
 CMP $4400,Y   :$D9  3   Absolute,Y   
 CMP ($44,X)   :$C1  2   Indirect,X   
 CMP ($44),Y   :$D1  2   Indirect,Y   

; CPX (ComPare X register) 

;   SYNTAX      HEX LEN MODE         
 CPX #$44      :$E0  2  Immediate    
 CPX $44       :$E4  2  Zero Page    
 CPX $4400     :$EC  3  Absolute     

; CPY (ComPare Y register) 

;   SYNTAX      HEX LEN MODE         
 CPY #$44      :$C0  2  Immediate    
 CPY $44       :$C4  2  Zero Page    
 CPY $4400     :$CC  3  Absolute     

; DEC (DECrement memory) 

;   SYNTAX      HEX LEN MODE         
 DEC $44       :$C6  2  Zero Page    
 DEC $44,X     :$D6  2  Zero Page,X  
 DEC $4400     :$CE  3  Absolute     
 DEC $4400,X   :$DE  3  Absolute,X   

; EOR (bitwise Exclusive OR) 

;   SYNTAX      HEX LEN MODE         
 EOR #$44      :$49  2  Immediate    
 EOR $44       :$45  2  Zero Page    
 EOR $44,X     :$55  2  Zero Page,X  
 EOR $4400     :$4D  3  Absolute     
 EOR $4400,X   :$5D  3  Absolute,X   
 EOR $4400,Y   :$59  3  Absolute,Y   
 EOR ($44,X)   :$41  2  Indirect,X   
 EOR ($44),Y   :$51  2  Indirect,Y   

; Flag (Processor Status) Instructions

;  MNEMONIC             HEX
 CLC :(CLear Carry)     $18
 SEC :(SEt Carry)       $38
 CLI :(CLear Interrupt) $58
 SEI :(SEt Interrupt)   $78
 CLV :(CLear oVerflow)  $B8
 CLD :(CLear Decimal)   $D8
 SED :(SEt Decimal)     $F8

* INC (INCrement memory) 

*   SYNTAX      HEX LEN MODE         
 INC $44       :$E6  2  Zero Page    
 INC $44,X     :$F6  2  Zero Page,X  
 INC $4400     :$EE  3  Absolute     
 INC $4400,X   :$FE  3  Absolute,X   

* JMP (JuMP) 

*   SYNTAX      HEX LEN MODE         
 JMP $5597     :$4C  3  Absolute     
 JMP ($5597)   :$6C  3  Indirect     

* JSR (Jump to SubRoutine) 

*   SYNTAX      HEX LEN MODE         
 JSR $5597     :$20  3  Absolute     

* LDA (LoaD Accumulator) 

*   SYNTAX      HEX LEN MODE         
 LDA #$44      :$A9  2  Immediate    
 LDA $44       :$A5  2  Zero Page    
 LDA $44,X     :$B5  2  Zero Page,X  
 LDA $4400     :$AD  3  Absolute     
 LDA $4400,X   :$BD  3  Absolute,X   
 LDA $4400,Y   :$B9  3  Absolute,Y   
 LDA ($44,X)   :$A1  2  Indirect,X   
 LDA ($44),Y   :$B1  2  Indirect,Y   

* LDX (LoaD X register) 

*   SYNTAX      HEX LEN MODE         
 LDX #$44      :$A2  2  Immediate    
 LDX $44       :$A6  2  Zero Page    
 LDX $44,Y     :$B6  2  Zero Page,Y  
 LDX $4400     :$AE  3  Absolute     
 LDX $4400,Y   :$BE  3  Absolute,Y   

* LDY (LoaD Y register) 

*   SYNTAX      HEX LEN MODE         
 LDY #$44      :$A0  2  Immediate    
 LDY $44       :$A4  2  Zero Page    
 LDY $44,X     :$B4  2  Zero Page,X  
 LDY $4400     :$AC  3  Absolute     
 LDY $4400,X   :$BC  3  Absolute,X   

* LSR (Logical Shift Right) 

*   SYNTAX      HEX LEN MODE         
 LSR @         :$4A  1  Accumulator (Implied)
 LSR $44       :$46  2  Zero Page    
 LSR $44,X     :$56  2  Zero Page,X  
 LSR $4400     :$4E  3  Absolute     
 LSR $4400,X   :$5E  3  Absolute,X   

* NOP (No OPeration) 

*   SYNTAX      HEX LEN MODE         
 NOP           :$EA  1  Implied      

* ORA (bitwise OR with Accumulator) 

*   SYNTAX      HEX LEN MODE         
 ORA #$44      :$09  2  Immediate    
 ORA $44       :$05  2  Zero Page    
 ORA $44,X     :$15  2  Zero Page,X  
 ORA $4400     :$0D  3  Absolute     
 ORA $4400,X   :$1D  3  Absolute,X   
 ORA $4400,Y   :$19  3  Absolute,Y   
 ORA ($44,X)   :$01  2  Indirect,X   
 ORA ($44),Y   :$11  2  Indirect,Y   

* Register Instructions 

* MNEMONIC                 HEX
 TAX :(Transfer A to X)    $AA
 TXA :(Transfer X to A)    $8A
 DEX :(DEcrement X)        $CA
 INX :(INcrement X)        $E8
 TAY :(Transfer A to Y)    $A8
 TYA :(Transfer Y to A)    $98
 DEY :(DEcrement Y)        $88
 INY :(INcrement Y)        $C8

* ROL (ROtate Left) 

*   SYNTAX      HEX LEN MODE         
 ROL @         :$2A  1  Accumulator (Implied)
 ROL $44       :$26  2  Zero Page    
 ROL $44,X     :$36  2  Zero Page,X  
 ROL $4400     :$2E  3  Absolute     
 ROL $4400,X   :$3E  3  Absolute,X   

* ROR (ROtate Right) 

*   SYNTAX      HEX LEN MODE         
 ROR @         :$6A  1  Accumulator (Implied)
 ROR $44       :$66  2  Zero Page    
 ROR $44,X     :$76  2  Zero Page,X  
 ROR $4400     :$6E  3  Absolute     
 ROR $4400,X   :$7E  3  Absolute,X   

* RTI (ReTurn from Interrupt) 

*   SYNTAX      HEX LEN MODE         
 RTI           :$40  1  Implied      

* RTS (ReTurn from Subroutine) 

*   SYNTAX      HEX LEN MODE         
 RTS           :$60  1  Implied      

* SBC (SuBtract with Carry)

*   SYNTAX      HEX LEN MODE         
 SBC #$44      :$E9  2  Immediate    
 SBC $44       :$E5  2  Zero Page    
 SBC $44,X     :$F5  2  Zero Page,X  
 SBC $4400     :$ED  3  Absolute     
 SBC $4400,X   :$FD  3  Absolute,X   
 SBC $4400,Y   :$F9  3  Absolute,Y   
 SBC ($44,X)   :$E1  2  Indirect,X   
 SBC ($44),Y   :$F1  2  Indirect,Y   

* STA (STore Accumulator) 

*   SYNTAX      HEX LEN MODE         
 STA $44       :$85  2  Zero Page    
 STA $44,X     :$95  2  Zero Page,X  
 STA $4400     :$8D  3  Absolute     
 STA $4400,X   :$9D  3  Absolute,X   
 STA $4400,Y   :$99  3  Absolute,Y   
 STA ($44,X)   :$81  2  Indirect,X   
 STA ($44),Y   :$91  2  Indirect,Y   

* Stack Instructions
*  MNEMONIC                      HEX 
 TXS :(Transfer X to Stack ptr)   $9A 
 TSX :(Transfer Stack ptr to X)   $BA 
 PHA :(PusH Accumulator)          $48 
 PLA :(PuLl Accumulator)          $68 
 PHP :(PusH Processor status)     $08 
 PLP :(PuLl Processor status)     $28 

* STX (STore X register)

*   SYNTAX      HEX LEN MODE         
 STX $44       :$86  2  * Zero Page    
 STX $44,Y     :$96  2  * Zero Page,Y  
 STX $4400     :$8E  3  * Absolute     

* STY (STore Y register)

*   SYNTAX      HEX LEN MODE         
 STY $44       :$84  2  * Zero Page    
 STY $44,X     :$94  2  * Zero Page,X  
 STY $4400     :$8C  3  * Absolute

