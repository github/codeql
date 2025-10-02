private import TranslatedElement
private import InstructionTag
private import semmle.code.binary.ast.registers

newtype TVariable =
  TTempVariable(TranslatedElement te, VariableTag tag) { hasTempVariable(te, tag) } or
  TRegisterVariableReal(Register r) or
  TRegisterVariableSynth(SynthRegisterTag tag) { hasSynthVariable(tag) }

abstract class Variable extends TVariable {
  abstract string toString();
}

class TempVariable extends Variable, TTempVariable {
  TranslatedElement te;
  VariableTag tag;

  TempVariable() { this = TTempVariable(te, tag) }

  override string toString() { result = te.getDumpId() + "_" + stringOfVariableTag(tag) }
}

class TRegisterVariable = TRegisterVariableReal or TRegisterVariableSynth;

class RegisterVariable extends Variable, TRegisterVariable {
  override string toString() { none() }

  Register getRegister() { none() }

  SynthRegisterTag getRegisterTag() { none() }
}

private class RegisterVariableReal extends RegisterVariable, TRegisterVariableReal {
  Register r;

  RegisterVariableReal() { this = TRegisterVariableReal(r) }

  override string toString() { result = r.toString() }

  override Register getRegister() { result = r }
}

RegisterVariable getTranslatedVariableReal(Register r) { result.getRegister() = r }

private class RegisterVariableSynth extends RegisterVariable, TRegisterVariableSynth {
  SynthRegisterTag tag;

  RegisterVariableSynth() { this = TRegisterVariableSynth(tag) }

  override string toString() { result = stringOfSynthRegisterTag(tag) }

  override SynthRegisterTag getRegisterTag() { result = tag }
}

RegisterVariableSynth getTranslatedVariableSynth(SynthRegisterTag tag) {
  result.getRegisterTag() = tag
}
