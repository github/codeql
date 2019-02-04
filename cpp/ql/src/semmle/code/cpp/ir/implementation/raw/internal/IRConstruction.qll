import cpp
import semmle.code.cpp.ir.implementation.raw.IR
private import semmle.code.cpp.ir.internal.OperandTag
private import semmle.code.cpp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedStmt
private import TranslatedFunction

class InstructionTagType extends TInstructionTag {
  final string toString() {
    result = "Tag"
  }
}

private TranslatedElement getInstructionTranslatedElement(
    Instruction instruction) {
  instruction = result.getInstruction(_)
}

private TranslatedElement getInstructionTranslatedElementAndTag(
    Instruction instruction, InstructionTag tag) {
  instruction = result.getInstruction(tag)
}

import Cached
cached private module Cached {
  cached predicate functionHasIR(Function func) {
    exists(getTranslatedFunction(func))
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

  cached Expr getInstructionConvertedResultExpression(Instruction instruction) {
    exists(TranslatedExpr translatedExpr |
      translatedExpr = getTranslatedExpr(result) and
      instruction = translatedExpr.getResult()
    )
  }

  cached Expr getInstructionUnconvertedResultExpression(Instruction instruction) {
    exists(Expr converted, TranslatedExpr translatedExpr |
      result = converted.(Conversion).getExpr+()
      or
      result = converted
      |
      not result instanceof Conversion and
      translatedExpr = getTranslatedExpr(converted) and
      instruction = translatedExpr.getResult()
    )
  }
  
  cached Instruction getInstructionOperandDefinition(Instruction instruction, OperandTag tag) {
    result = getInstructionTranslatedElement(instruction).getInstructionOperand(
      instruction.getTag(), tag)
  }

  cached Instruction getPhiInstructionOperandDefinition(Instruction instruction,
      IRBlock predecessorBlock) {
    none()
  }

  cached Instruction getPhiInstructionBlockStart(PhiInstruction instr) {
    none()
  }

  cached Instruction getInstructionSuccessor(Instruction instruction, EdgeKind kind) {
    result = getInstructionTranslatedElement(instruction).getInstructionSuccessor(
      instruction.getTag(), kind)
  }

  // This predicate has pragma[noopt] because otherwise the `getAChild*` calls
  // get joined too early. The join order for the loop cases goes like this:
  // - Find all loops of that type (tens of thousands).
  // - Find all edges into the start of the loop (x 2).
  // - Restrict to edges that originate within the loop (/ 2).
  pragma[noopt]
  cached Instruction getInstructionBackEdgeSuccessor(Instruction instruction, EdgeKind kind) {
    // While loop:
    // Any edge from within the body of the loop to the condition of the loop
    // is a back edge. This includes edges from `continue` and the fall-through
    // edge(s) after the last instruction(s) in the body.
    exists(TranslatedWhileStmt s |
      s instanceof TranslatedWhileStmt and
      result = s.getFirstConditionInstruction() and
      exists(TranslatedElement inBody, InstructionTag tag |
        result = inBody.getInstructionSuccessor(tag, kind) and
        exists(TranslatedElement body | body = s.getBody() | inBody = body.getAChild*()) and
        instruction = inBody.getInstruction(tag)
      )
    )
    or
    // Do-while loop:
    // The back edge should be the edge(s) from the condition to the
    // body. This ensures that it's the back edge that will be pruned in a `do
    // { ... } while (0)` statement. Note that all `continue` statements in a
    // do-while loop produce forward edges.
    exists(TranslatedDoStmt s |
      s instanceof TranslatedDoStmt and
      exists(TranslatedStmt body | body = s.getBody() | result = body.getFirstInstruction()) and
      exists(TranslatedElement inCondition, InstructionTag tag |
        result = inCondition.getInstructionSuccessor(tag, kind) and
        exists(TranslatedElement condition | condition = s.getCondition() |
          inCondition = condition.getAChild*()
        ) and
        instruction = inCondition.getInstruction(tag)
      )
    )
    or
    // For loop:
    // Any edge from within the body or update of the loop to the condition of
    // the loop is a back edge. When there is no loop update expression, this
    // includes edges from `continue` and the fall-through edge(s) after the
    // last instruction(s) in the body. A for loop may not have a condition, in
    // which case `getFirstConditionInstruction` returns the body instead.
    exists(TranslatedForStmt s |
      s instanceof TranslatedForStmt and
      result = s.getFirstConditionInstruction() and
      exists(TranslatedElement inLoop, InstructionTag tag |
        result = inLoop.getInstructionSuccessor(tag, kind) and
        exists(TranslatedElement bodyOrUpdate |
          bodyOrUpdate = s.getBody()
          or
          bodyOrUpdate = s.getUpdate()
        |
          inLoop = bodyOrUpdate.getAChild*()
        ) and
        instruction = inLoop.getInstruction(tag)
      )
    )
    or
    // Goto statement:
    // As a conservative approximation, any edge out of `goto` is a back edge
    // unless it goes strictly forward in the program text. A `goto` whose
    // source and target are both inside a macro will be seen as having the
    // same location for source and target, so we conservatively assume that
    // such a `goto` creates a back edge.
    exists(TranslatedElement s, GotoStmt goto |
      goto instanceof GotoStmt and
      not isStrictlyForwardGoto(goto) and
      goto = s.getAST() and
      exists(InstructionTag tag |
        result = s.getInstructionSuccessor(tag, kind) and
        instruction = s.getInstruction(tag)
      )
    )
  }

  /** Holds if `goto` jumps strictly forward in the program text. */
  private predicate isStrictlyForwardGoto(GotoStmt goto) {
    goto.getLocation().isBefore(goto.getTarget().getLocation())
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

  cached Instruction getPrimaryInstructionForSideEffect(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getPrimaryInstructionForSideEffect(tag)
    )
  }
}

import CachedForDebugging
cached private module CachedForDebugging {
  cached string getTempVariableUniqueId(IRTempVariable var) {
    exists(TranslatedElement element |
      var = element.getTempVariable(_) and
      result = element.getId() + ":" + getTempVariableTagId(var.getTag())
    )
  }

  cached string getInstructionUniqueId(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction).getId() + ":" +
      getInstructionTagId(instruction.getTag())
  }
}
