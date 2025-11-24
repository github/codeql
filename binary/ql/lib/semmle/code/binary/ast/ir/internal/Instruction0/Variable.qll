private import TranslatedElement
private import semmle.code.binary.ast.Location
private import semmle.code.binary.ast.ir.internal.InstructionTag as Tags
private import semmle.code.binary.ast.instructions as Raw
private import Operand

newtype TVariable =
  TTempVariable(TranslatedElement te, Tags::VariableTag tag) { hasTempVariable(te, tag) } or
  TRegisterVariableReal(Raw::Register r) or
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

class TRegisterVariable = TRegisterVariableReal or TRegisterVariableSynth;

class RegisterVariable extends Variable, TRegisterVariable {
  override string toString() { none() }

  Raw::Register getRegister() { none() }

  Tags::SynthRegisterTag getRegisterTag() { none() }
}

private class RegisterVariableReal extends RegisterVariable, TRegisterVariableReal {
  Raw::Register r;

  RegisterVariableReal() { this = TRegisterVariableReal(r) }

  override string toString() { result = r.toString() }

  override Raw::Register getRegister() { result = r }
}

RegisterVariable getTranslatedVariableReal(Raw::Register r) { result.getRegister() = r }

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
