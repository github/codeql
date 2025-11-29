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

newtype TOperandTag =
  LeftTag() or
  RightTag() or
  UnaryTag() or
  StoreValueTag() or
  StoreAddressTag() or
  CallTargetTag() or
  CondTag() or
  CondJumpTargetTag() or
  JumpTargetTag()

class OperandTag extends TOperandTag {
  int getIndex() {
    this = LeftTag() and
    result = 0
    or
    this = RightTag() and
    result = 1
    or
    this = UnaryTag() and
    result = 0
    or
    this = StoreValueTag() and
    result = 1
    or
    this = StoreAddressTag() and
    result = 0
    or
    this = CallTargetTag() and
    result = 0
    or
    this = CondJumpTargetTag() and
    result = 0
    or
    this = CondTag() and
    result = 1
    or
    this = JumpTargetTag() and
    result = 0
  }

  OperandTag getSuccessorTag() {
    this = LeftTag() and
    result = RightTag()
    or
    this = StoreAddressTag() and
    result = StoreValueTag()
    or
    this = CondJumpTargetTag() and
    result = CondTag()
  }

  OperandTag getPredecessorTag() { this = result.getSuccessorTag() }

  string toString() {
    this = LeftTag() and
    result = "Left"
    or
    this = RightTag() and
    result = "Right"
    or
    this = UnaryTag() and
    result = "Unary"
    or
    this = StoreValueTag() and
    result = "StoreValue"
    or
    this = StoreAddressTag() and
    result = "StoreDest"
    or
    this = CallTargetTag() and
    result = "CallTarget"
    or
    this = CondJumpTargetTag() and
    result = "CondJumpTarget"
    or
    this = CondTag() and
    result = "CondJump"
    or
    this = JumpTargetTag() and
    result = "JumpTarget"
  }
}
