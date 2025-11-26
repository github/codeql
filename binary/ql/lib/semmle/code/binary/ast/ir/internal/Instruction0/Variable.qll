private import TranslatedElement
private import semmle.code.binary.ast.Location
private import semmle.code.binary.ast.ir.internal.InstructionTag as Tags
private import semmle.code.binary.ast.instructions as Raw
private import Operand

newtype TVariable =
  TTempVariable(TranslatedElement te, Tags::VariableTag tag) { hasTempVariable(te, tag) } or
  TStackPointer() or
  TFramePointer() or
  TRegisterVariableReal(Raw::X86Register r) {
    not r instanceof Raw::RbpRegister and // Handled by FramePointer
    not r instanceof Raw::RspRegister // Handled by StackPointer
  } or
  TRegisterVariableSynth(Tags::SynthRegisterTag tag) { hasSynthVariable(tag) }

abstract class Variable extends TVariable {
  abstract string toString();

  Location getLocation() { result instanceof EmptyLocation }

  Operand getAnAccess() { result.getVariable() = this }
}

class TempVariable extends Variable, TTempVariable {
  TranslatedElement te;
  Tags::VariableTag tag;

  TempVariable() { this = TTempVariable(te, tag) }

  override string toString() { result = te.getDumpId() + "." + Tags::stringOfVariableTag(tag) }
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

  Tags::SynthRegisterTag getRegisterTag() { none() }
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
  Tags::SynthRegisterTag tag;

  RegisterVariableSynth() { this = TRegisterVariableSynth(tag) }

  override string toString() { result = Tags::stringOfSynthRegisterTag(tag) }

  override Tags::SynthRegisterTag getRegisterTag() { result = tag }
}

RegisterVariableSynth getTranslatedVariableSynth(Tags::SynthRegisterTag tag) {
  result.getRegisterTag() = tag
}

class VariableTag = Tags::VariableTag;
