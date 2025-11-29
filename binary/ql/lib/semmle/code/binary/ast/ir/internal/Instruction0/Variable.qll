private import TranslatedElement
private import semmle.code.binary.ast.Location
private import semmle.code.binary.ast.instructions as Raw
private import TempVariableTag
private import semmle.code.binary.ast.ir.internal.Tags
private import Operand
private import TranslatedFunction
private import Function

newtype TVariable =
  TTempVariable(TranslatedElement te, TempVariableTag tag) { hasTempVariable(te, tag) } or
  TLocalVariable(TranslatedFunction tf, LocalVariableTag tag) { hasLocalVariable(tf, tag) }

abstract class Variable extends TVariable {
  abstract string toString();

  Location getLocation() { result instanceof EmptyLocation }

  Operand getAnAccess() { result.getVariable() = this }
}

class TempVariable extends Variable, TTempVariable {
  TranslatedElement te;
  TempVariableTag tag;

  TempVariable() { this = TTempVariable(te, tag) }

  override string toString() { result = te.getDumpId() + "." + tag.toString() }
}

class StackPointer extends LocalVariable {
  StackPointer() { this.getTag() = X86RegisterTag(any(Raw::RspRegister sp)) }
}

Variable getStackPointer() { result instanceof StackPointer }

class FramePointer extends LocalVariable {
  FramePointer() { this.getTag() = X86RegisterTag(any(Raw::RbpRegister fp)) }
}

Variable getFramePointer() { result instanceof FramePointer }

class LocalVariable extends Variable, TLocalVariable {
  TranslatedFunction tf;
  LocalVariableTag tag;

  LocalVariable() { this = TLocalVariable(tf, tag) }

  override string toString() { result = stringOfLocalVariableTag(tag) }

  LocalVariableTag getTag() { result = tag }

  Function getEnclosingFunction() { result = TMkFunction(tf) }
}
