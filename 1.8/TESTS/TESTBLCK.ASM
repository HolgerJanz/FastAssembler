* Test Blocks

         blk dos $2000
         rts

         blk sparta $3000
         rts

         blk reloc main
test1    rts

         blk reloc ext
         rts

* breaks the binary format, is OK
         blk none $3500
         rts

         blk empty $200 main

         blk empty $300 ext

         blk reloc main

         blk reloc ext

         blk update symbols
         blk update addrs
         blk update new test1 '@TEST'
