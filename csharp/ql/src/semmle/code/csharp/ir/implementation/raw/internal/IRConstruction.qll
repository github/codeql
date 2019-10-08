import csharp
import semmle.code.csharp.ir.implementation.raw.IR
private import semmle.code.csharp.ir.implementation.internal.OperandTag
private import semmle.code.csharp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedCondition
private import TranslatedElement
private import TranslatedExpr
private import TranslatedStmt
private import desugar.Foreach
private import TranslatedFunction
private import semmle.code.csharp.ir.Util
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

TranslatedElement getInstructionTranslatedElement(Instruction instruction) {
  instruction = MkInstruction(result, _)
}

InstructionTag getInstructionTag(Instruction instruction) { instruction = MkInstruction(_, result) }

import Cached

cached
private module Cached {
  cached
  predicate functionHasIR(Callable callable) {
    exists(getTranslatedFunction(callable)) and
    callable.fromSource()
  }

  cached
  newtype TInstruction =
    MkInstruction(TranslatedElement element, InstructionTag tag) {
      element.hasInstruction(_, tag, _, _)
    }

  cached
  predicate hasUserVariable(Callable callable, Variable var, Type type) {
    getTranslatedFunction(callable).hasUserVariable(var, type)
  }

  cached
  predicate hasTempVariable(Callable callable, Language::AST ast, TempVariableTag tag, Type type) {
    exists(TranslatedElement element |
      element.getAST() = ast and
      callable = element.getFunction() and
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
    exists(Expr converted, TranslatedExpr translatedExpr | result = converted.stripCasts() |
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
    overlap instanceof MustTotallyOverlap and
    result = getInstructionTranslatedElement(instruction)
          .getInstructionOperand(getInstructionTag(instruction), tag)
  }

  cached
  Type getInstructionOperandType(Instruction instruction, TypedOperandTag tag) {
    // For all `LoadInstruction`s, the operand type of the `LoadOperand` is the same as
    // the result type of the load.
    if instruction instanceof LoadInstruction
    then result = instruction.(LoadInstruction).getResultType()
    else
      result = getInstructionTranslatedElement(instruction)
            .getInstructionOperandType(getInstructionTag(instruction), tag)
  }

  cached
  int getInstructionOperandSize(Instruction instruction, SideEffectOperandTag tag) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionOperandSize(getInstructionTag(instruction), tag)
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
      goto = s.getAST() and
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
  Language::AST getInstructionAST(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction).getAST()
  }

  cached
  predicate instructionHasType(Instruction instruction, Type type, boolean isLValue) {
    getInstructionTranslatedElement(instruction)
        .hasInstruction(_, getInstructionTag(instruction), type, isLValue)
  }

  cached
  Opcode getInstructionOpcode(Instruction instruction) {
    getInstructionTranslatedElement(instruction)
        .hasInstruction(result, getInstructionTag(instruction), _, _)
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
  ArrayAccess getInstructionArrayAccess(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionArrayAccess(getInstructionTag(instruction))
  }

  cached
  int getInstructionIndex(Instruction instruction) { none() }

  cached
  Callable getInstructionFunction(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionFunction(getInstructionTag(instruction))
  }

  cached
  string getInstructionConstantValue(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionConstantValue(getInstructionTag(instruction))
  }

  cached
  StringLiteral getInstructionStringLiteral(Instruction instruction) {
    result = getInstructionTranslatedElement(instruction)
          .getInstructionStringLiteral(getInstructionTag(instruction))
  }

  cached
  Type getInstructionExceptionType(Instruction instruction) {
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

  cached
  Language::BuiltInOperation getInstructionBuiltInOperation(Instruction instr) { none() }
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
