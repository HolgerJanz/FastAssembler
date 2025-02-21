# Fast Assembler

Assembler for SpartaDOS X and BW-DOS (1.4 or higher) on Atari 8bit

The current version is 1.8 24-08-2024 and it works with all versions of SpartaDOS X and with BW-DOS at least version 1.4. It is part of the [SpartaDOS X Add-ons](http://sdx.atari8.info/index.php?show=en_addons).

## Projects Using Fast Assembler

- [BW-DOS](https://github.com/HolgerJanz/BW-DOS) - SpartaDOS 3 compatible DOS
- [FujiNet Tools for SpartaDOS](https://github.com/HolgerJanz/FujiNetToolsSpartaDOS) - FujiNet Command Line Tools for all SpartaDOS 3 compatible DOS versions
- [XL OS](https://github.com/HolgerJanz/FastAssemblerAtariXLOS) - Sources for XL operating system
- [Game VARIUS](https://github.com/HolgerJanz/VARIUS) - small game like 2048
- [Demo Rainbow Family](https://github.com/HolgerJanz/RainbowFamily) - small Demo

## Version 1.8

- fixed parameter parsing issue that prevents Fast Assembler working with SpartaDOS X 4.47 to 4.49d

- fixed multiplication and division issue, because of wrong overflow handling these operations always throw error "Too big number”

- new pseudo command INS to insert binary data

- new block kind „padding“ for better support of compiling ROM files (see BLK PADDING)

- fix END issue, processing of source was not aborted but the source in buffer was further processed

- also the ; character can be used to indicate a comment line (like with character *)

- allow spaces in empty lines before the error "Unexpected end of line" was raised if an empty line contains spaces

- improved position information for error messages

- add line number and program counter to source output

- add option /Y for dump of symbol table

- add option /S for summary, e.g. count of labels and blocks, and memory usage

- add option /E to convert error message to DOS error if compile fails, for better use in batch processing

- add option /Q for quite mode without line progress output, for better use if console output is redirected e.g. file

- remove option /B

- rename option /A to /L

- condense info output

- improve memory management

- improve performance of pass 1 and up

- reduce number of max passes to 8

- update copyright message

- add tutorial with extended examples

- add XEDIT by FJC (thanx for the permission), now it is a complete development package

## Version 1.7
Last original release by MMMG Soft from 1995

This is the original Fast Assembler package delivered with SpartaDOS X Toolkit Disk up to version 4.49.

It was developed by Marek Goderski from MMMG Soft (Free MG). He was so kind to release Fast Assembler
to Public Domain.

Fast Assembler 1.7 uses undocumented features for parameter parsing. These features have been removed with SpartaDOS X 4.47 and reintroduced with 4.49e. For this, Fast Assembler 1.7 will only work with SpartaDOS X versions below 4.47 or above 4.49d. Furthermore it has some issues (see fixes in version 1.8).

This package is kept for archiving and historical reasons.

## 
holgerjanz@abbuc.social

