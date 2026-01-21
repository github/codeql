private import Opcode
private import codeql.util.Boolean
private import semmle.code.binary.ast.internal.CilInstructions
private import semmle.code.binary.ast.internal.X86Instructions
private import semmle.code.binary.ast.internal.JvmInstructions

newtype LocalVariableTag =
  CmpRegisterTag() or
  X86RegisterTag(X86Register r) or
  StlocVarTag(int index) { any(CilStoreLocal stloc).getLocalVariableIndex() = index } or
  CilParameterVarTag(int index) { any(CilParameter p).getIndex() = index } or
  JvmLocalVarTag(int index) {
    any(JvmLoadLocal load).getLocalVariableIndex() = index or
    any(JvmStoreLocal store).getLocalVariableIndex() = index
  } or
  JvmParameterVarTag(int index) { any(JvmParameter p).getSlotIndex() = index }

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
  or
  exists(int index |
    tag = CilParameterVarTag(index) and
    result = "param_" + index.toString()
  )
  or
  exists(int index |
    tag = JvmLocalVarTag(index) and
    result = "jvm_local_" + index.toString()
  )
  or
  exists(int index |
    tag = JvmParameterVarTag(index) and
    result = "jvm_param_" + index.toString()
  )
}
