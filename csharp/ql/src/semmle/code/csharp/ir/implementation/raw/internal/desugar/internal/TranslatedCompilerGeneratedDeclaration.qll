/**
 * Contains an abstract class, which is the super class  of all the classes that represent compiler
 * generated declarations. It extends the Base for declarations by incorporating a `Store` instruction, since
 * we treat the initialization as part of the declaration for compiler generated declarations.
 */

import csharp
private import semmle.code.csharp.ir.implementation.Opcode
private import semmle.code.csharp.ir.implementation.internal.OperandTag
private import semmle.code.csharp.ir.implementation.raw.internal.InstructionTag
private import semmle.code.csharp.ir.implementation.raw.internal.TranslatedElement
private import semmle.code.csharp.ir.implementation.raw.internal.TranslatedFunction
private import semmle.code.csharp.ir.implementation.raw.internal.common.TranslatedDeclarationBase
private import TranslatedCompilerGeneratedElement
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

abstract class TranslatedCompilerGeneratedDeclaration extends LocalVariableDeclarationBase,
  TranslatedCompilerGeneratedElement {
  final override string toString() {
    result = "compiler generated declaration (" + generatedBy.toString() + ")"
  }

  override TranslatedElement getChild(int id) {
    result = LocalVariableDeclarationBase.super.getChild(id)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getInitialization() and result = getInstruction(InitializerStoreTag())
  }

  override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
    LocalVariableDeclarationBase.super.hasInstruction(opcode, tag, resultType, isLValue)
    or
    // we can reuse the initializer store tag
    // since compiler generated declarations
    // do not have the `Uninitialized` instruction
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::Store and
    resultType = getVarType() and
    isLValue = false
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    result = LocalVariableDeclarationBase.super.getInstructionSuccessor(tag, kind)
    or
    tag = InitializerStoreTag() and
    result = getParent().getChildSuccessor(this) and
    kind instanceof GotoEdge
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    result = LocalVariableDeclarationBase.super.getInstructionOperand(tag, operandTag)
    or
    tag = InitializerStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = getInstruction(InitializerVariableAddressTag())
      or
      operandTag instanceof StoreValueOperandTag and
      result = getInitializationResult()
    )
  }

  override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = InitializerVariableAddressTag() and
    result = getIRVariable()
  }

  // A compiler generated declaration does not have an associated `LocalVariable`
  // element
  override LocalVariable getDeclVar() { none() }

  // A compiler generated element always has an explicit
  // initialization
  override predicate isInitializedByElement() { none() }

  override Type getVarType() { result = getIRVariable().getType() }

  /**
   * Gets the IR variable that corresponds to the declaration.
   */
  abstract IRVariable getIRVariable();

  /**
   * Gets result (instruction) of the initialization expression.
   */
  abstract Instruction getInitializationResult();
}
