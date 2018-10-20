.section .init
.global _start
.global get_impid
.extern main
.extern _stacktop

_start:
la sp,_stacktop // set SP to end of RAM
jal main


get_impid:
csrr a0,mimpid
ret

