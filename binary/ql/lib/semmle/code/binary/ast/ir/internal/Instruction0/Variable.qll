private import TranslatedElement
private import semmle.code.binary.ast.Location
private import semmle.code.binary.ast.instructions as Raw
private import VariableTag
private import semmle.code.binary.ast.ir.internal.Tags
private import Operand

newtype TVariable =
  TTempVariable(TranslatedElement te, VariableTag tag) { hasTempVariable(te, tag) } or
  TStackPointer() or
  TFramePointer() or
  TRegisterVariableReal(Raw::X86Register r) {
    not r instanceof Raw::RbpRegister and // Handled by FramePointer
    not r instanceof Raw::RspRegister // Handled by StackPointer
  } or
  TRegisterVariableSynth(SynthRegisterTag tag) { hasSynthVariable(tag) }

abstract class Variable extends TVariable {
  abstract string toString();

  Location getLocation() { result instanceof EmptyLocation }

  Operand getAnAccess() { result.getVariable() = this }
}

class TempVariable extends Variable, TTempVariable {
  TranslatedElement te;
  VariableTag tag;

  TempVariable() { this = TTempVariable(te, tag) }

  override string toString() { result = te.getDumpId() + "." + tag.toString() }
}

class StackPointer extends Variable, TStackPointer {
  override string toString() { result = "sp" }
}

Variable getStackPointer() { result instanceof StackPointer }

class FramePointer extends Variable, TFramePointer {
  override string toString() { result = "fp" }
}

Variable getFramePointer() { result instanceof FramePointer }

class TRegisterVariable = TRegisterVariableReal or TRegisterVariableSynth;

class RegisterVariable extends Variable, TRegisterVariable {
  override string toString() { none() }

  Raw::X86Register getRegister() { none() }

  SynthRegisterTag getRegisterTag() { none() }
}

private class RegisterVariableReal extends RegisterVariable, TRegisterVariableReal {
  Raw::X86Register r;

  RegisterVariableReal() { this = TRegisterVariableReal(r) }

  override string toString() { result = r.toString() }

  override Raw::X86Register getRegister() { result = r }
}

Variable getTranslatedVariableReal(Raw::X86Register r) {
  result.(RegisterVariable).getRegister() = r
  or
  r instanceof Raw::RspRegister and result instanceof StackPointer
  or
  r instanceof Raw::RbpRegister and result instanceof FramePointer
}

private class RegisterVariableSynth extends RegisterVariable, TRegisterVariableSynth {
  SynthRegisterTag tag;

  RegisterVariableSynth() { this = TRegisterVariableSynth(tag) }

  override string toString() { result = stringOfSynthRegisterTag(tag) }

  override SynthRegisterTag getRegisterTag() { result = tag }
}

RegisterVariableSynth getTranslatedVariableSynth(SynthRegisterTag tag) {
  result.getRegisterTag() = tag
}

