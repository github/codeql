private import semmle.code.binary.ast.Location
private import semmle.code.binary.ast.instructions as Raw
private import TranslatedElement
private import codeql.util.Option
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import Variable
private import Instruction
private import TranslatedInstruction
private import TranslatedFunction
private import semmle.code.binary.ast.ir.internal.Tags
private import InstructionTag
private import codeql.controlflow.SuccessorType

abstract class TranslatedType extends TranslatedElement {
  final override predicate producesResult() { none() }

  final override Variable getResultVariable() { none() }

  final override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  final FunEntryInstruction getEntry() { none() }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    none()
  }

  final override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) { none() }

  abstract string getName();

  abstract string getNamespace();

  abstract TranslatedFunction getAFunction();

  final override string toString() { result = "Translation of " + this.getName() }

  final override TranslatedFunction getEnclosingFunction() { none() }

  final override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    none()
  }

  final override string getDumpId() { result = this.getName() }
}

class TranslatedCiLType extends TranslatedType, TTranslatedCilType {
  Raw::CilType type;

  TranslatedCiLType() { this = TTranslatedCilType(type) }

  final override Raw::Element getRawElement() { result = type }

  final override string getName() { result = type.getName() }

  final override string getNamespace() { result = type.getNamespace() }

  final override TranslatedCilMethod getAFunction() {
    result = getTranslatedFunction(type.getAMethod())
  }

  final override Location getLocation() { result = type.getLocation() }
}

class TranslatedJvmType extends TranslatedType, TTranslatedJvmType {
  Raw::JvmType type;

  TranslatedJvmType() { this = TTranslatedJvmType(type) }

  final override Raw::Element getRawElement() { result = type }

  final override string getName() { result = type.getName() }

  final override string getNamespace() { result = type.getPackage() }

  final override TranslatedJvmMethod getAFunction() {
    result = getTranslatedFunction(type.getAMethod())
  }

  final override Location getLocation() { result = type.getLocation() }
}

TranslatedType getTranslatedType(Raw::Element raw) { result.getRawElement() = raw }
