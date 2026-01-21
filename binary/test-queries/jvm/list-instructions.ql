/**
 * @name List all instructions in a method
 * @description Lists all instructions with their offsets and mnemonics
 * @kind table
 * @id jvm/list-instructions
 */

import semmle.code.binary.ast.internal.JvmInstructions

from JvmInstruction instr
where instr.getEnclosingMethod().getName() = "simpleMethod"
select instr.getOffset() as offset, instr.getMnemonic() as mnemonic,
  instr.getEnclosingMethod().getFullyQualifiedName() as method order by offset
