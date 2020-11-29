.globl __start

.text
__start:
  call func
  end:
  nop  
  jal x18, end
  
  func:
  li x9, 0
  li x10, 60
  
  beginn:  
  blt x10, x9, exit

  lw x2, 0(x9)
  add x17, x17, x2
  addi x9, x9, 4

  jal x11, beginn
  exit:
  addi x17, x17, 8
  srli x17, x17, 4
  sw x17, 0(x0)
  ret
  