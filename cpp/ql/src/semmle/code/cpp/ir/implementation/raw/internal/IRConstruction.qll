private import cpp
import semmle.code.cpp.ir.implementation.raw.IR
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.CppType
private import semmle.code.cpp.ir.internal.Overlap
private import semmle.code.cpp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedCondition
private import TranslatedElement
private import TranslatedExpr
private import TranslatedStmt
private import TranslatedFunction

TranslatedElement getInstructionTranslatedElement(Instruction instruction) {
  instruction = MkInstruction(result, _)
}

InstructionTag getInstructionTag(Instruction instruction) { instruction = MkInstruction(_, result) }

import Cached

cached
private module Cached {
  cached
  predicate functionHasIR(Function func) { exists(getTranslatedFunction(func)) }

  cached
  newtype TInstruction =
    MkInstruction(TranslatedElement element, InstructionTag tag) {
      element.hasInstruction(_, tag, _)
    }

  cached
  predicate hasUserVariable(Function func, Variable var, CppType type) {
    getTranslatedFunction(func).hasUserVariable(var, type)
  }

  cached
  predicate hasTempVariable(Function func, Locatable ast, TempVariableTag tag, CppType type) {
    exists(TranslatedElement element |
      element.getAST() = ast and
      func = element.getFunction() and
      element.hasTempVariable(tag, type)
    )
  }

  cached
  predicate hasModeledMemoryResult(Instruction instruction) { none() }

  cached
  Expr getInstructionConvertedResultExpression(Instruction instruction) {
    exists(TranslatedExpr translatedExpr |
      translatedExpr = getTranslatedExpr(result) and
      instruction = translatedExpr.getResult()
    )
  }

  cached
  Expr getInstructionUnconvertedResultExpression(Instruction instruction) {
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

  cached
  Instruction getRegisterOperandDefinition(Instruction instruction, RegisterOperandTag tag) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionOperand(getInstructionTag(instruction), tag)
  }

  cached
  Instruction getMemoryOperandDefinition(
    Instruction instruction, MemoryOperandTag tag, Overlap overlap
  ) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionOperand(getInstructionTag(instruction), tag) and
    overlap instanceof MustTotallyOverlap
  }

  cached
  CppType getInstructionOperandType(Instruction instruction, TypedOperandTag tag) {
    // For all `LoadInstruction`s, the operand type of the `LoadOperand` is the same as
    // the result type of the load.
    result = instruction.(LoadInstruction).getResultLanguageType()
    or
    not instruction instanceof LoadInstruction and
    result = getInstructionTranslatedElement(instruction)
          .getInstructionOperandType(getInstructionTag(instruction), tag)
  }

  cached
  Instruction getPhiOperandDefinition(
    PhiInstruction instruction, IRBlock predecessorBlock, Overlap overlap
  ) {
    none()
  }

  cached
  Instruction getPhiInstructionBlockStart(PhiInstruction instr) { none() }

  cached
  Instruction getInstructionSuccessor(Instruction instruction, EdgeKind kind) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionSuccessor(getInstructionTag(instruction), kind)
  }

  // This predicate has pragma[noopt] because otherwise the `getAChild*` calls
  // get joined too early. The join order for the loop cases goes like this:
  // - Find all loops of that type (tens of thousands).
  // - Find all edges into the start of the loop (x 2).
  // - Restrict to edges that originate within the loop (/ 2).
  pragma[noopt]
  cached
  Instruction getInstructionBackEdgeSuccessor(Instruction instruction, EdgeKind kind) {
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
    // Range-based for loop:
    // Any edge from within the update of the loop to the condition of
    // the loop is a back edge.
    exists(TranslatedRangeBasedForStmt s, TranslatedCondition condition |
      s instanceof TranslatedRangeBasedForStmt and
      condition = s.getCondition() and
      result = condition.getFirstInstruction() and
      exists(TranslatedElement inUpdate, InstructionTag tag |
        result = inUpdate.getInstructionSuccessor(tag, kind) and
        exists(TranslatedElement update | update = s.getUpdate() | inUpdate = update.getAChild*()) and
        instruction = inUpdate.getInstruction(tag)
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

  cached
  Locatable getInstructionAST(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction).getAST()
  }

  cached
  CppType getInstructionResultType(Instruction instruction) {
    getInstructionTranslatedElement(instruction)
        .hasInstruction(_, getInstructionTag(instruction), result)
  }

  cached
  Opcode getInstructionOpcode(Instruction instruction) {
    getInstructionTranslatedElement(instruction)
        .hasInstruction(result, getInstructionTag(instruction), _)
  }

  cached
  IRFunction getInstructionEnclosingIRFunction(Instruction instruction) {
    result.getFunction() = getInstructionTranslatedElement(instruction).getFunction()
  }

  cached
  IRVariable getInstructionVariable(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionVariable(getInstructionTag(instruction))
  }

  cached
  Field getInstructionField(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getInstructionField(tag)
    )
  }

  cached
  Function getInstructionFunction(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionFunction(getInstructionTag(instruction))
  }

  cached
  string getInstructionConstantValue(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionConstantValue(getInstructionTag(instruction))
  }

  cached
  int getInstructionIndex(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getInstructionIndex(tag)
    )
  }

  cached
  StringLiteral getInstructionStringLiteral(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionStringLiteral(getInstructionTag(instruction))
  }

  cached
  BuiltInOperation getInstructionBuiltInOperation(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionBuiltInOperation(getInstructionTag(instruction))
  }

  cached
  CppType getInstructionExceptionType(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionExceptionType(getInstructionTag(instruction))
  }

  cached
  predicate getInstructionInheritance(Instruction instruction, Class baseClass, Class derivedClass) {
    getInstructionTranslatedElement(instruction)
        .getInstructionInheritance(getInstructionTag(instruction), baseClass, derivedClass)
  }

  pragma[noinline]
  private predicate instructionOrigin(
    Instruction instruction, TranslatedElement element, InstructionTag tag
  ) {
    element = getInstructionTranslatedElement(instruction) and
    tag = getInstructionTag(instruction)
  }

  cached
  int getInstructionElementSize(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getInstructionElementSize(tag)
    )
  }

  cached
  predicate needsUnknownOpaqueType(int byteSize) {
    exists(TranslatedElement element |
      element.needsUnknownOpaqueType(byteSize)
    )
  }

  cached
  int getInstructionResultSize(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getInstructionResultSize(tag)
    )
  }

  cached
  Instruction getPrimaryInstructionForSideEffect(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getPrimaryInstructionForSideEffect(tag)
    )
  }
}

import CachedForDebugging

cached
private module CachedForDebugging {
  cached
  string getTempVariableUniqueId(IRTempVariable var) {
    exists(TranslatedElement element |
      var = element.getTempVariable(_) and
      result = element.getId() + ":" + getTempVariableTagId(var.getTag())
    )
  }

  cached
  string getInstructionUniqueId(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction).getId() + ":" +
        getInstructionTagId(getInstructionTag(instruction))
  }
}
