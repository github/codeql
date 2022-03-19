import csharp
import experimental.ir.implementation.raw.IR
private import experimental.ir.implementation.internal.OperandTag
private import experimental.ir.implementation.internal.IRFunctionBase
private import experimental.ir.implementation.internal.TInstruction
private import experimental.ir.internal.CSharpType
private import experimental.ir.internal.Overlap
private import experimental.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedCondition
private import TranslatedElement
private import TranslatedExpr
private import TranslatedStmt
private import desugar.Foreach
private import TranslatedFunction
private import experimental.ir.Util
private import experimental.ir.internal.IRCSharpLanguage as Language

TranslatedElement getInstructionTranslatedElement(Instruction instruction) {
  instruction = TRawInstruction(result, _)
}

InstructionTag getInstructionTag(Instruction instruction) {
  instruction = TRawInstruction(_, result)
}

pragma[noinline]
private predicate instructionOrigin(
  Instruction instruction, TranslatedElement element, InstructionTag tag
) {
  element = getInstructionTranslatedElement(instruction) and
  tag = getInstructionTag(instruction)
}

class TStageInstruction = TRawInstruction;

/**
 * Provides the portion of the parameterized IR interface that is used to construct the initial
 * "raw" stage of the IR. The other stages of the IR do not expose these predicates.
 */
cached
module Raw {
  class InstructionTag1 = TranslatedElement;

  class InstructionTag2 = InstructionTag;

  cached
  predicate functionHasIR(Callable callable) { exists(getTranslatedFunction(callable)) }

  cached
  predicate hasInstruction(TranslatedElement element, InstructionTag tag) {
    element.hasInstruction(_, tag, _)
  }

  cached
  predicate hasUserVariable(Callable callable, Variable var, CSharpType type) {
    getTranslatedFunction(callable).hasUserVariable(var, type)
  }

  cached
  predicate hasTempVariable(
    Callable callable, Language::AST ast, TempVariableTag tag, CSharpType type
  ) {
    exists(TranslatedElement element |
      element.getAst() = ast and
      callable = element.getFunction() and
      element.hasTempVariable(tag, type)
    )
  }

  cached
  predicate hasStringLiteral(
    Callable callable, Language::AST ast, CSharpType type, StringLiteral literal
  ) {
    literal = ast and
    literal.getEnclosingCallable() = callable and
    getTypeForPRValue(literal.getType()) = type
  }

  cached
  predicate hasDynamicInitializationFlag(Callable callable, Language::Variable var, CSharpType type) {
    none()
  }

  cached
  Expr getInstructionConvertedResultExpression(Instruction instruction) {
    exists(TranslatedExpr translatedExpr |
      translatedExpr = getTranslatedExpr(result) and
      instruction = translatedExpr.getResult()
    )
  }

  cached
  Expr getInstructionUnconvertedResultExpression(Instruction instruction) {
    exists(Expr converted, TranslatedExpr translatedExpr | result = converted.stripCasts() |
      translatedExpr = getTranslatedExpr(converted) and
      instruction = translatedExpr.getResult()
    )
  }

  cached
  IRVariable getInstructionVariable(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      element = getInstructionTranslatedElement(instruction) and
      tag = getInstructionTag(instruction) and
      (
        result = element.getInstructionVariable(tag) or
        result.(IRStringLiteral).getAst() = element.getInstructionStringLiteral(tag)
      )
    )
  }

  cached
  Field getInstructionField(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getInstructionField(tag)
    )
  }

  cached
  int getInstructionIndex(Instruction instruction) { none() }

  cached
  Callable getInstructionFunction(Instruction instruction) {
    result =
      getInstructionTranslatedElement(instruction)
          .getInstructionFunction(getInstructionTag(instruction))
  }

  cached
  string getInstructionConstantValue(Instruction instruction) {
    result =
      getInstructionTranslatedElement(instruction)
          .getInstructionConstantValue(getInstructionTag(instruction))
  }

  cached
  CSharpType getInstructionExceptionType(Instruction instruction) {
    result =
      getInstructionTranslatedElement(instruction)
          .getInstructionExceptionType(getInstructionTag(instruction))
  }

  cached
  predicate getInstructionInheritance(Instruction instruction, Class baseClass, Class derivedClass) {
    getInstructionTranslatedElement(instruction)
        .getInstructionInheritance(getInstructionTag(instruction), baseClass, derivedClass)
  }

  cached
  int getInstructionElementSize(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getInstructionElementSize(tag)
    )
  }

  cached
  Language::BuiltInOperation getInstructionBuiltInOperation(Instruction instr) { none() }
}

import Cached

cached
private module Cached {
  cached
  predicate getInstructionOpcode(Opcode opcode, TRawInstruction instr) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instr, element, tag) and
      element.hasInstruction(opcode, tag, _)
    )
  }

  cached
  IRFunctionBase getInstructionEnclosingIRFunction(TRawInstruction instr) {
    result.getFunction() = getInstructionTranslatedElement(instr).getFunction()
  }

  cached
  predicate hasInstruction(TRawInstruction instr) { any() }

  cached
  predicate hasModeledMemoryResult(Instruction instruction) { none() }

  cached
  predicate hasConflatedMemoryResult(Instruction instruction) {
    instruction instanceof AliasedDefinitionInstruction
    or
    instruction.getOpcode() instanceof Opcode::InitializeNonLocal
  }

  cached
  Instruction getRegisterOperandDefinition(Instruction instruction, RegisterOperandTag tag) {
    result =
      getInstructionTranslatedElement(instruction)
          .getInstructionOperand(getInstructionTag(instruction), tag)
  }

  cached
  Instruction getMemoryOperandDefinition(
    Instruction instruction, MemoryOperandTag tag, Overlap overlap
  ) {
    overlap instanceof MustTotallyOverlap and
    result =
      getInstructionTranslatedElement(instruction)
          .getInstructionOperand(getInstructionTag(instruction), tag)
  }

  /** Gets a non-phi instruction that defines an operand of `instr`. */
  private Instruction getNonPhiOperandDef(Instruction instr) {
    result = getRegisterOperandDefinition(instr, _)
    or
    result = getMemoryOperandDefinition(instr, _, _)
  }

  /**
   * Holds if the partial operand of this `ChiInstruction` updates the bit range
   * `[startBitOffset, endBitOffset)` of the total operand.
   */
  cached
  predicate getIntervalUpdatedByChi(ChiInstruction chi, int startBit, int endBit) { none() }

  /**
   * Holds if the operand totally overlaps with its definition and consumes the
   * bit range `[startBitOffset, endBitOffset)`.
   */
  cached
  predicate getUsedInterval(Operand operand, int startBit, int endBit) { none() }

  cached
  predicate chiOnlyPartiallyUpdatesLocation(ChiInstruction chi) { none() }

  /**
   * Holds if `instr` is part of a cycle in the operand graph that doesn't go
   * through a phi instruction and therefore should be impossible.
   *
   * If such cycles are present, either due to a programming error in the IR
   * generation or due to a malformed database, it can cause infinite loops in
   * analyses that assume a cycle-free graph of non-phi operands. Therefore it's
   * better to remove these operands than to leave cycles in the operand graph.
   */
  pragma[noopt]
  cached
  predicate isInCycle(Instruction instr) {
    instr instanceof Instruction and
    getNonPhiOperandDef+(instr) = instr
  }

  cached
  CSharpType getInstructionOperandType(Instruction instruction, TypedOperandTag tag) {
    // For all `LoadInstruction`s, the operand type of the `LoadOperand` is the same as
    // the result type of the load.
    if instruction instanceof LoadInstruction
    then result = instruction.(LoadInstruction).getResultLanguageType()
    else
      result =
        getInstructionTranslatedElement(instruction)
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
    result =
      getInstructionTranslatedElement(instruction)
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
    // Compiler generated foreach while loop:
    // Same as above
    exists(TranslatedForeachWhile s |
      result = s.getFirstInstruction() and
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
          bodyOrUpdate = s.getUpdate(_)
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
      goto = s.getAst() and
      exists(InstructionTag tag |
        result = s.getInstructionSuccessor(tag, kind) and
        instruction = s.getInstruction(tag)
      )
    )
  }

  /** Holds if `goto` jumps strictly forward in the program text. */
  private predicate isStrictlyForwardGoto(GotoLabelStmt goto) {
    goto.getLocation().getFile() = goto.getTarget().getLocation().getFile() and
    goto.getLocation().getEndLine() < goto.getTarget().getLocation().getStartLine()
  }

  cached
  Language::AST getInstructionAst(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction).getAst()
  }

  /** DEPRECATED: Alias for getInstructionAst */
  cached
  deprecated Language::AST getInstructionAST(Instruction instruction) {
    result = getInstructionAst(instruction)
  }

  cached
  CSharpType getInstructionResultType(Instruction instruction) {
    getInstructionTranslatedElement(instruction)
        .hasInstruction(_, getInstructionTag(instruction), result)
  }

  cached
  ArrayAccess getInstructionArrayAccess(Instruction instruction) {
    result =
      getInstructionTranslatedElement(instruction)
          .getInstructionArrayAccess(getInstructionTag(instruction))
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
      result = element.getId().toString() + ":" + getTempVariableTagId(var.getTag())
    )
  }

  cached
  predicate instructionHasSortKeys(Instruction instruction, int key1, int key2) {
    key1 = getInstructionTranslatedElement(instruction).getId() and
    getInstructionTag(instruction) =
      rank[key2](InstructionTag tag, string tagId |
        tagId = getInstructionTagId(tag)
      |
        tag order by tagId
      )
  }

  cached
  string getInstructionUniqueId(Instruction instruction) {
    result =
      getInstructionTranslatedElement(instruction).getId() + ":" +
        getInstructionTagId(getInstructionTag(instruction))
  }
}
