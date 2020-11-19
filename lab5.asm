.globl __start

.text
__start:
  lw x1, 0(x0)
  add x2, x2, x1
  lw x1, 4(x0)
  add x2, x2, x1
  lw x1, 8(x0)
  add x2, x2, x1
  lw x1, 12(x0)
  add x2, x2, x1
  lw x1, 16(x0)
  add x2, x2, x1
  lw x1, 20(x0)
  add x2, x2, x1
  lw x1, 24(x0)
  add x2, x2, x1
  lw x1, 28(x0)
  add x2, x2, x1
  lw x1, 32(x0)
  add x2, x2, x1
  lw x1, 36(x0)
  add x2, x2, x1
  lw x1, 40(x0)
  add x2, x2, x1
  lw x1, 44(x0)
  add x2, x2, x1
  lw x1, 48(x0)
  add x2, x2, x1
  lw x1, 52(x0)
  add x2, x2, x1
  lw x1, 56(x0)
  add x2, x2, x1
  lw x1, 60(x0)
  add x2, x2, x1
  addi x2, x2, 8
  srli x2, x2, 4