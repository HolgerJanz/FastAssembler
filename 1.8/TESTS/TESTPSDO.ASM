* Test Pseudo Operations

         opt %01010101

         lst none
         lst bad
         lst all
* test list all
         lst none
         lst bad

         org $2000
         rts
         lda #'A'
         lda #"A"
         icl 'INCLPSDO.ASM'
