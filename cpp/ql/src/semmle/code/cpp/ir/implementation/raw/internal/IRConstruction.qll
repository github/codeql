import cpp
import semmle.code.cpp.ir.implementation.raw.IR
import IRBlockConstruction as BlockConstruction
private import semmle.code.cpp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedFunction

class InstructionTagType extends TInstructionTag {
  final string toString() {
    result = "Tag"
  }
}

private TranslatedElement getInstructionTranslatedElement(
    Instruction instruction) {
  result = getInstructionTranslatedElementAndTag(instruction, _)
}

private TranslatedElement getInstructionTranslatedElementAndTag(
    Instruction instruction, InstructionTag tag) {
  result.getAST() = instruction.getAST() and
  tag = instruction.getTag() and
  result.hasInstruction(_, tag, _, _)
}

private TranslatedElement getTempVariableTranslatedElement(
  IRTempVariable var) {
  result.getAST() = var.getAST() and
  result.hasTempVariable(var.getTag(), _)
}

import Cached
cached private module Cached {
  cached predicate functionHasIR(Function func) {
    exists(getTranslatedFunction(func))
  }

  cached int getMaxCallArgIndex() {
    result = max(int argIndex |
      exists(FunctionCall call |
        exists(call.getArgument(argIndex))
      )
    )
  }

  cached newtype TInstruction =
    MkInstruction(FunctionIR funcIR, Opcode opcode, Locatable ast,
        InstructionTag tag, Type resultType, boolean isGLValue) {
      hasInstruction(funcIR.getFunction(), opcode, ast, tag,
        resultType, isGLValue)
    }

  private predicate hasInstruction(Function func, Opcode opcode, Locatable ast,
      InstructionTag tag, Type resultType, boolean isGLValue) {
    exists(TranslatedElement element |
      element.getAST() = ast and
      func = element.getFunction() and
      element.hasInstruction(opcode, tag, resultType, isGLValue)
    )
  }

  cached predicate hasTempVariable(Function func, Locatable ast, TempVariableTag tag,
    Type type) {
    exists(TranslatedElement element |
      element.getAST() = ast and
      func = element.getFunction() and
      element.hasTempVariable(tag, type)
    )
  }

  cached predicate hasModeledMemoryResult(Instruction instruction) {
    none()
  }

  cached Expr getInstructionResultExpression(Instruction instruction) {
    exists(TranslatedExpr translatedExpr |
      translatedExpr = getTranslatedExpr(result) and
      instruction = translatedExpr.getResult()
    )
  }

  cached Instruction getInstructionOperand(Instruction instruction, OperandTag tag) {
    result = getInstructionTranslatedElement(instruction).getInstructionOperand(
      instruction.getTag(), tag)
  }

  cached Instruction getPhiInstructionBlockStart(PhiInstruction instr) {
    none()
  }

  cached Instruction getInstructionSuccessor(Instruction instruction, EdgeKind kind) {
    result = getInstructionTranslatedElement(instruction).getInstructionSuccessor(
      instruction.getTag(), kind)
  }

  cached IRVariable getInstructionVariable(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction).getInstructionVariable(
      instruction.getTag())
  }

  cached Field getInstructionField(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getInstructionField(tag)
    )
  }

  cached Function getInstructionFunction(Instruction instruction) {
    exists(InstructionTag tag |
      result = getInstructionTranslatedElementAndTag(instruction, tag)
              .getInstructionFunction(tag)
    )
  }

  cached string getInstructionConstantValue(Instruction instruction) {
    result =
      getInstructionTranslatedElement(instruction).getInstructionConstantValue(
        instruction.getTag())
  }

  cached StringLiteral getInstructionStringLiteral(Instruction instruction) {
    result =
      getInstructionTranslatedElement(instruction).getInstructionStringLiteral(
        instruction.getTag())
  }

  cached Type getInstructionExceptionType(Instruction instruction) {
    result =
      getInstructionTranslatedElement(instruction).getInstructionExceptionType(
        instruction.getTag())
  }

  cached predicate getInstructionInheritance(Instruction instruction,
      Class baseClass, Class derivedClass) {
    getInstructionTranslatedElement(instruction).getInstructionInheritance(
      instruction.getTag(), baseClass, derivedClass)
  }

  pragma[noinline]
  private predicate instructionOrigin(Instruction instruction, 
      TranslatedElement element, InstructionTag tag) {
    element = getInstructionTranslatedElement(instruction) and
    tag = instruction.getTag()
  }

  cached int getInstructionElementSize(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getInstructionElementSize(tag)
    )
  }

  cached int getInstructionResultSize(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getInstructionResultSize(tag)
    )
  }
}

import CachedForDebugging
cached private module CachedForDebugging {
  cached string getTempVariableUniqueId(IRTempVariable var) {
    result = getTempVariableTranslatedElement(var).getId() + ":" +
      getTempVariableTagId(var.getTag())
  }

  cached string getInstructionUniqueId(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction).getId() + ":" +
      getInstructionTagId(instruction.getTag())
  }
}
