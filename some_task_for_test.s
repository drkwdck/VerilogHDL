.globl __start

.data

.text
__start:
  lbu x13, 208(x0)
  CalcResultStartAdderss:
  beq x13, x24, EndCalcResultStartAdderss
  addi x15, x15, 64
  addi x24, x24, 1
  jal x28, CalcResultStartAdderss
  EndCalcResultStartAdderss:
  addi x14, x14, 212
  add x15, x15, x14
  call Main
  EndProgram:
  nop
  jal x1, EndProgram
  Main:
  li x9, 0
  li x10, 60
  InteranlLoopBegin:  
  blt x10, x9, InternalLoopEnd
  lw x2, 0(x14)
  add x17, x17, x2
  addi x9, x9, 4
  addi x14, x14, 4
  jal x11, InteranlLoopBegin
  InternalLoopEnd:
  addi x17, x17, 8
  srli x17, x17, 4
  sw x17, 0(x15)
  addi x15, x15, 4
  xor x17, x17, x17
  EXIT:
  addi x29, x29, 1
  beq x29, x13, EXIT_LOOP
  jal x28, Main
  EXIT_LOOP:  
  ret