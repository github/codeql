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
  predicate hasStringLiteral(Function func, Locatable ast, CppType type, StringLiteral literal) {
    literal = ast and
    literal.getEnclosingFunction() = func and
    getTypeForPRValue(literal.getType()) = type
  }

  cached
  predicate hasDynamicInitializationFlag(Function func, StaticLocalVariable var, CppType type) {
    var.getFunction() = func and
    var.hasDynamicInitialization() and
    type = getBoolType()
  }

  cached
  predicate hasModeledMemoryResult(Instruction instruction) { none() }

  cached
  predicate hasConflatedMemoryResult(Instruction instruction) {
    instruction instanceof UnmodeledDefinitionInstruction
    or
    instruction instanceof AliasedDefinitionInstruction
    or
    instruction.getOpcode() instanceof Opcode::InitializeNonLocal
  }

  cached
  Expr getInstructionConvertedResultExpression(Instruction instruction) {
    exists(TranslatedExpr translatedExpr |
      translatedExpr = getTranslatedExpr(result) and
      instruction = translatedExpr.getResult() and
      // Only associate `instruction` with this expression if the translated
      // expression actually produced the instruction; not if it merely
      // forwarded the result of another translated expression.
      instruction = translatedExpr.getInstruction(_)
    )
  }

  cached
  Expr getInstructionUnconvertedResultExpression(Instruction instruction) {
    result = getInstructionConvertedResultExpression(instruction).getUnconverted()
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
    result =
      getInstructionTranslatedElement(instruction)
          .getInstructionOperand(getInstructionTag(instruction), tag) and
    overlap instanceof MustTotallyOverlap
  }

  /** Gets a non-phi instruction that defines an operand of `instr`. */
  private Instruction getNonPhiOperandDef(Instruction instr) {
    result = getRegisterOperandDefinition(instr, _)
    or
    result = getMemoryOperandDefinition(instr, _, _)
  }

  /**
   * Gets a non-phi instruction that defines an operand of `instr` but only if
   * both `instr` and the result have neighbor on the other side of the edge
   * between them. This is a necessary condition for being in a cycle, and it
   * removes about two thirds of the tuples that would otherwise be in this
   * predicate.
   */
  private Instruction getNonPhiOperandDefOfIntermediate(Instruction instr) {
    result = getNonPhiOperandDef(instr) and
    exists(getNonPhiOperandDef(result)) and
    instr = getNonPhiOperandDef(_)
  }

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
    getNonPhiOperandDefOfIntermediate+(instr) = instr
  }

  cached
  CppType getInstructionOperandType(Instruction instruction, TypedOperandTag tag) {
    // For all `LoadInstruction`s, the operand type of the `LoadOperand` is the same as
    // the result type of the load.
    result = instruction.(LoadInstruction).getResultLanguageType()
    or
    not instruction instanceof LoadInstruction and
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

  /**
   * Holds if the CFG edge (`sourceElement`, `sourceTag`) ---`kind`-->
   * `targetInstruction` is a back edge under the condition that
   * `requiredAncestor` is an ancestor of `sourceElement`.
   */
  private predicate backEdgeCandidate(
    TranslatedElement sourceElement, InstructionTag sourceTag, TranslatedElement requiredAncestor,
    Instruction targetInstruction, EdgeKind kind
  ) {
    // While loop:
    // Any edge from within the body of the loop to the condition of the loop
    // is a back edge. This includes edges from `continue` and the fall-through
    // edge(s) after the last instruction(s) in the body.
    exists(TranslatedWhileStmt s |
      targetInstruction = s.getFirstConditionInstruction() and
      targetInstruction = sourceElement.getInstructionSuccessor(sourceTag, kind) and
      requiredAncestor = s.getBody()
    )
    or
    // Do-while loop:
    // The back edge should be the edge(s) from the condition to the
    // body. This ensures that it's the back edge that will be pruned in a `do
    // { ... } while (0)` statement. Note that all `continue` statements in a
    // do-while loop produce forward edges.
    exists(TranslatedDoStmt s |
      targetInstruction = s.getBody().getFirstInstruction() and
      targetInstruction = sourceElement.getInstructionSuccessor(sourceTag, kind) and
      requiredAncestor = s.getCondition()
    )
    or
    // For loop:
    // Any edge from within the body or update of the loop to the condition of
    // the loop is a back edge. When there is no loop update expression, this
    // includes edges from `continue` and the fall-through edge(s) after the
    // last instruction(s) in the body. A for loop may not have a condition, in
    // which case `getFirstConditionInstruction` returns the body instead.
    exists(TranslatedForStmt s |
      targetInstruction = s.getFirstConditionInstruction() and
      targetInstruction = sourceElement.getInstructionSuccessor(sourceTag, kind) and
      (
        requiredAncestor = s.getUpdate()
        or
        not exists(s.getUpdate()) and
        requiredAncestor = s.getBody()
      )
    )
    or
    // Range-based for loop:
    // Any edge from within the update of the loop to the condition of
    // the loop is a back edge.
    exists(TranslatedRangeBasedForStmt s |
      targetInstruction = s.getCondition().getFirstInstruction() and
      targetInstruction = sourceElement.getInstructionSuccessor(sourceTag, kind) and
      requiredAncestor = s.getUpdate()
    )
  }

  private predicate jumpSourceHasAncestor(TranslatedElement jumpSource, TranslatedElement ancestor) {
    backEdgeCandidate(jumpSource, _, _, _, _) and
    ancestor = jumpSource
    or
    // For performance, we don't want a fastTC here
    jumpSourceHasAncestor(jumpSource, ancestor.getAChild())
  }

  cached
  Instruction getInstructionBackEdgeSuccessor(Instruction instruction, EdgeKind kind) {
    exists(
      TranslatedElement sourceElement, InstructionTag sourceTag, TranslatedElement requiredAncestor
    |
      backEdgeCandidate(sourceElement, sourceTag, requiredAncestor, result, kind) and
      jumpSourceHasAncestor(sourceElement, requiredAncestor) and
      instruction = sourceElement.getInstruction(sourceTag)
    )
    or
    // Goto statement:
    // As a conservative approximation, any edge out of `goto` is a back edge
    // unless it goes strictly forward in the program text. A `goto` whose
    // source and target are both inside a macro will be seen as having the
    // same location for source and target, so we conservatively assume that
    // such a `goto` creates a back edge.
    exists(TranslatedElement s, GotoStmt goto |
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
    exists(TranslatedElement element, InstructionTag tag |
      element = getInstructionTranslatedElement(instruction) and
      tag = getInstructionTag(instruction) and
      (
        result = element.getInstructionVariable(tag) or
        result.(IRStringLiteral).getAST() = element.getInstructionStringLiteral(tag)
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
  Function getInstructionFunction(Instruction instruction) {
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
  int getInstructionIndex(Instruction instruction) {
    exists(TranslatedElement element, InstructionTag tag |
      instructionOrigin(instruction, element, tag) and
      result = element.getInstructionIndex(tag)
    )
  }

  cached
  BuiltInOperation getInstructionBuiltInOperation(Instruction instruction) {
    result =
      getInstructionTranslatedElement(instruction)
          .getInstructionBuiltInOperation(getInstructionTag(instruction))
  }

  cached
  CppType getInstructionExceptionType(Instruction instruction) {
    result =
      getInstructionTranslatedElement(instruction)
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
    exists(TranslatedElement element | element.needsUnknownOpaqueType(byteSize))
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
    result =
      getInstructionTranslatedElement(instruction).getId() + ":" +
        getInstructionTagId(getInstructionTag(instruction))
  }
}
