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

  abstract int getOrder();
}

class TempVariable extends Variable, TTempVariable {
  TranslatedElement te;
  TempVariableTag tag;

  TempVariable() { this = TTempVariable(te, tag) }

  override string toString() { result = te.getDumpId() + "." + tag.toString() }

  override int getOrder() { none() }
}

class StackPointer extends LocalVariable {
  StackPointer() { this.getTag() = X86RegisterTag(any(Raw::RspRegister sp)) }
}

class FramePointer extends LocalVariable {
  FramePointer() { this.getTag() = X86RegisterTag(any(Raw::RbpRegister fp)) }
}

class LocalVariable extends Variable, TLocalVariable {
  TranslatedFunction tf;
  LocalVariableTag tag;

  LocalVariable() { this = TLocalVariable(tf, tag) }

  override string toString() { result = stringOfLocalVariableTag(tag) }

  LocalVariableTag getTag() { result = tag }

  Function getEnclosingFunction() { result = TMkFunction(tf) }

  final override int getOrder() { tf.hasOrdering(tag, result) }

  predicate isStackAllocated() { none() }
}

predicate variableHasOrdering(Variable v, int ordering) { v.getOrder() = ordering }
