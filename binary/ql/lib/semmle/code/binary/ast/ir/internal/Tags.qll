private import Opcode
private import codeql.util.Boolean
private import semmle.code.binary.ast.internal.CilInstructions
private import semmle.code.binary.ast.internal.instructions

newtype LocalVariableTag =
  CmpRegisterTag() or
  X86RegisterTag(X86Register r) or
  StlocVarTag(int index) { any(CilStoreLocal stloc).getLocalVariableIndex() = index }

string stringOfLocalVariableTag(LocalVariableTag tag) {
  tag = CmpRegisterTag() and
  result = "cmp_r"
  or
  exists(int index |
    tag = StlocVarTag(index) and
    result = "stloc_" + index.toString()
  )
  or
  exists(X86Register r |
    tag = X86RegisterTag(r) and
    result = r.toString()
  )
}
