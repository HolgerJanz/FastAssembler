# Fast Assembler

Assembler for SpartaDOS X on Atari 8bit

The current version is 1.8 2021-12-01 and it works with all versions of SpartaDOS X. It is part of the [SpartaDOS X Add-ons](http://sdx.atari8.info/index.php?show=en_addons).

All files in ATR image are ATASCII encoded.

## Version 1.8

- fixed parameter parsing issue that prevents Fast Assembler working with SpartaDOS X 4.47 to 4.49d

- fixed multiplication and division issue, because of wrong overflow handling these operations always throw error "Too big number"

- add line number to source output

- condense info output 

- remove option B, always print error line, rename option A to L, and introduce option S for summary, e.g. count of labels and blocks, and memory usage

- introduce option E to set error to 255 if compile fails, for better use in batch

- improve memory management

- reduce number of max passes to 8

- update copyright message

- add XEDIT by FJC (thanx for the permission), now it is a complete development package

- add tutorial with extended examples

## Version 1.7
Last original release by MMMG Soft from 1995

This is the original Fast Assembler package delivered with SpartaDOS X Toolkit Disk up to version 4.49.

It was developed by Marek Goderski from MMMG Soft (Free MG). He was so kind to release Fast Assembler
to Public Domain.

Fast Assembler 1.7 uses undocumented features for parameter parsing. These features have been removed with SpartaDOS X 4.47 and reintroduced with 4.49e. For this, Fast Assembler 1.7 will only work with SpartaDOS X versions below 4.47 or above 4.49d. Furthermore it has some issues (see fixes in version 1.8).

This package is kept for archiving and historical reasons.

## 
holgerjanz@msn.com

