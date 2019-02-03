# AvahiClient

A Swift wrapper for [libavahi-client](https://www.avahi.org/).

This exists mainly to demonstrate a bug in LLDB.

## Building
### On Ubuntu 18.04
Assuming that you have Swift and `libavahi-client-dev` installed, all the normal SPM `swift build`/ `swift test` should just work.

## Debug
### Prerequisite: update ~/.lldbinit
Add this line to your `~/.lldbinit`:
```
log enable f /tmp/lldbtypes-log.txt lldb types
```

### Run the debugger
Make sure to run with `LLDB_SWIFT_DUMP_DIAGS=1` enabled. Start the debugger and set a breakpoint. Note the error to find `Clibavahiclient`.
```
LLDB_SWIFT_DUMP_DIAGS=1 lldb ./.build/x86_64-unknown-linux/debug/AvahiClientPackageTests.xctest
<unknown>:0: error: missing required module 'Clibavahiclient'
Breakpoint 1: where = AvahiClientPackageTests.xctest`AvahiClientTests.AvahiClientTests.testNewAvahiClient() -> () + 135 at AvahiClientTests.swift:12, address = 0x0000000000004a07
```

Try to run and print anyway:
```
(lldb) r
Process 10360 launched: './.build/x86_64-unknown-linux/debug/AvahiClientPackageTests.xctest' (x86_64)
Test Suite 'All tests' started at 2019-02-03 03:39:22.738
Test Suite 'debug.xctest' started at 2019-02-03 03:39:22.738
Test Suite 'AvahiClientTests' started at 2019-02-03 03:39:22.738
Test Case 'AvahiClientTests.testNewAvahiClient' started at 2019-02-03 03:39:22.738
Process 10360 stopped
* thread #1, name = 'AvahiClientPack', stop reason = breakpoint 1.1
    frame #0: 0x0000555555558a07 AvahiClientPackageTests.xctest`AvahiClientTests.testNewAvahiClient(self=<unavailable>) at AvahiClientTests.swift:12
   9   	    func testNewAvahiClient() {
   10  	        do {
   11  	            let c = try AvahiClient()
-> 12  	            print(c)
   13  	        } catch {
   14  	            XCTFail("\(error)")
   15  	        }
Target 0: (AvahiClientPackageTests.xctest) stopped.
(lldb) print c
<unknown>:0: error: missing required module 'Clibavahiclient'
error: in auto-import:
failed to get module 'AvahiClientTests' from AST context:
error: missing required module 'Clibavahiclient'
```

You can see that lldb is telling the truth. It does not know about Clibavahiclient:
```
(lldb) target modules list
[  0] E21ECC95-0000-0000-0000-000000000000                    ./.build/x86_64-unknown-linux/debug/AvahiClientPackageTests.xctest
```

## Further digging
If we go poking around, we do see some stuff under `.build/` with `Clibavahiclient` in the name:
```
$ find . -name Clibavahiclient*
./.build/checkouts/Clibavahiclient.git--4733535768090925471
./.build/x86_64-unknown-linux/debug/ModuleCache/33J8DIMD7H8ZB/Clibavahiclient-2J8WBHG3Q43SC.pcm
./.build/repositories/Clibavahiclient.git--4733535768090925471
```

`Clibavahiclient-2J8WBHG3Q43SC.pcm` sounds promising, let's try a `readelf`:
```
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              REL (Relocatable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x0
  Start of program headers:          0 (bytes into file)
  Start of section headers:          151568 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           0 (bytes)
  Number of program headers:         0
  Size of section headers:           64 (bytes)
  Number of section headers:         18
  Section header string table index: 1

Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  [ 1] .strtab           STRTAB           0000000000000000  00024f38
       00000000000000d5  0000000000000000           0     0     1
  [ 2] .text             PROGBITS         0000000000000000  00000040
       0000000000000000  0000000000000000  AX       0     0     4
  [ 3] __clangast        PROGBITS         0000000000000000  00000040
       0000000000021120  0000000000000000   A       0     0     8
  [ 4] .debug_str        PROGBITS         0000000000000000  00021160
       0000000000001250  0000000000000001  MS       0     0     1
  [ 5] .debug_abbrev     PROGBITS         0000000000000000  000223b0
       0000000000000126  0000000000000000           0     0     1
  [ 6] .debug_info       PROGBITS         0000000000000000  000224d6
       0000000000000ba5  0000000000000000           0     0     1
  [ 7] .rela.debug_info  RELA             0000000000000000  00023480
       0000000000001a58  0000000000000018          17     6     8
  [ 8] .debug_ranges     PROGBITS         0000000000000000  0002307b
       0000000000000000  0000000000000000           0     0     1
  [ 9] .debug_macinfo    PROGBITS         0000000000000000  0002307b
       0000000000000001  0000000000000000           0     0     1
  [10] .debug_pubnames   PROGBITS         0000000000000000  0002307c
       00000000000000ab  0000000000000000           0     0     1
  [11] .rela.debug_pubna RELA             0000000000000000  00024ed8
       0000000000000030  0000000000000018          17    10     8
  [12] .debug_pubtypes   PROGBITS         0000000000000000  00023127
       0000000000000081  0000000000000000           0     0     1
  [13] .rela.debug_pubty RELA             0000000000000000  00024f08
       0000000000000030  0000000000000018          17    12     8
  [14] .comment          PROGBITS         0000000000000000  000231a8
       00000000000000b4  0000000000000001  MS       0     0     1
  [15] .note.GNU-stack   PROGBITS         0000000000000000  0002325c
       0000000000000000  0000000000000000           0     0     1
  [16] .debug_line       PROGBITS         0000000000000000  0002325c
       000000000000017b  0000000000000000           0     0     1
  [17] .symtab           SYMTAB           0000000000000000  000233d8
       00000000000000a8  0000000000000018           1     7     8
...
```
You can read the whole readelf dump [here](./readelf.txt), but it does look like an ELF binary with some debug information in it. Let's try an `llvm-dwarfdump`:

```
./.build/x86_64-unknown-linux/debug/ModuleCache/33J8DIMD7H8ZB/Clibavahiclient-2J8WBHG3Q43SC.pcm:	file format ELF64-x86-64

.debug_abbrev contents:
Abbrev table for offset: 0x00000000
[1] DW_TAG_compile_unit	DW_CHILDREN_yes
	DW_AT_producer	DW_FORM_strp
	DW_AT_language	DW_FORM_data2
	DW_AT_name	DW_FORM_strp
	DW_AT_stmt_list	DW_FORM_sec_offset
	DW_AT_comp_dir	DW_FORM_strp
	DW_AT_GNU_pubnames	DW_FORM_flag_present
	DW_AT_GNU_dwo_id	DW_FORM_data8
...
.debug_info contents:
0x00000000: Compile Unit: length = 0x00000b77 version = 0x0004 abbr_offset = 0x0000 addr_size = 0x08 (next unit at 0x00000b7b)

0x0000000b: DW_TAG_compile_unit
              DW_AT_producer	("clang version 6.0.0 (git@github.com:apple/swift-clang.git 78aa734eee0a481cb13743f74a4b66a340e207fa) (git@github.com:apple/swift-llvm.git 4ba03d9389a3a5a6afccb2d6b202b7b6fa745f77)")
              DW_AT_language	(DW_LANG_C99)
              DW_AT_name	("Clibavahiclient")
              DW_AT_stmt_list	(0x00000000)
              DW_AT_comp_dir	("/work/AvahiClient")
              DW_AT_GNU_pubnames	(true)
              DW_AT_GNU_dwo_id	(0x73912bbb5b3343f8)

0x00000026:   DW_TAG_module
                DW_AT_name	("Clibavahiclient")
                DW_AT_LLVM_config_macros	("\"-D__swift__=40150\"")
                DW_AT_LLVM_include_path	("/work/AvahiClient/.build/checkouts/Clibavahiclient.git--4733535768090925471")
                DW_AT_LLVM_isysroot	("/")
...
```

You can read the whole llvm-dwarfdump dump [here](./llvm-dwarfdump.txt), but it looks suspiciosly like it has the debug sysmbols we need? I haven't figured out how to get them imported into lldb.
