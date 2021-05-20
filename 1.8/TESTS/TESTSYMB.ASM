* Test SDX Symbols

test1  smb 'test1'
test2  smb 'test2'
test3  smb 'test3'
test4  smb 'test4'

       blk reloc main
       rts
       jsr test3
       jsr test1
       jsr test2
       jsr test3
       jsr test3
       jsr test2

       blk update symbols
       blk update addr

       end
