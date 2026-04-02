private import cpp
private import semmle.code.cpp.ir.internal.IRUtilities
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.CppType
private import semmle.code.cpp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedElement
private import TranslatedStmt
private import TranslatedFunction

/**
 * Holds if `s` is a statement that may be an expanded assertion in a
 * release build.
 */
pragma[nomagic]
private predicate stmtCandidate(Stmt s) {
  not s.isFromUninstantiatedTemplate(_) and
  (
    // The expansion of `__analysis_assume(x != 0);` when `__analysis_assume` is
    // empty is the empty statement.
    s instanceof EmptyStmt
    or
    // The expansion of `assert(x != 0)` when `assert` is `((void)0)` is a zero literal
    // with a void type.
    exists(Expr e |
      e = s.(ExprStmt).getExpr() and
      e.getValue() = "0" and
      e.getActualType() instanceof VoidType
    )
  )
}

pragma[nomagic]
private predicate macroInvocationLocation(int startline, Function f, MacroInvocation mi) {
  mi.getMacroName() = ["assert", "__analysis_assume"] and
  mi.getNumberOfArguments() = 1 and
  mi.getLocation().hasLocationInfo(_, startline, _, _, _) and
  f.getEntryPoint().isAffectedByMacro(mi)
}

pragma[nomagic]
private predicate stmtParentLocation(int startline, Function f, StmtParent p) {
  p.getEnclosingFunction() = f and
  p.getLocation().hasLocationInfo(_, startline, _, _, _)
}

/**
 * Holds if `mi` is a macro invocation with a name that is known
 * to correspond to an assertion macro, and the macro invocation
 * is the only thing on the line.
 */
pragma[nomagic]
private predicate assertion0(MacroInvocation mi, Stmt s, string arg) {
  stmtCandidate(s) and
  s =
    unique(StmtParent p, int startline, Function f |
      macroInvocationLocation(startline, f, mi) and
      stmtParentLocation(startline, f, p) and
      // Also do not count the elements from the expanded macro, i.e., when checking
      // if `assert(x)` is the only thing on the line we do not count the
      // generated `((void)0)` expression.
      not p = mi.getAnExpandedElement()
    |
      p
    ) and
  arg = mi.getUnexpandedArgument(0)
}

private Function getEnclosingFunctionForMacroInvocation(MacroInvocation mi) {
  exists(Stmt s |
    assertion0(mi, s, _) and
    result = s.getEnclosingFunction()
  )
}

/**
 * Holds if `arg` has two components and the `i`'th component of the string
 * `arg` is `s`, and the components are separated by an operation with
 * opcode `opcode`.
 */
bindingset[arg]
pragma[inline_late]
private predicate parseArgument(string arg, string s, int i, Opcode opcode) {
  s =
    arg.regexpCapture("([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)\\s?<=\\s?([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)",
      i + 1) and
  opcode instanceof Opcode::CompareLE
  or
  s =
    arg.regexpCapture("([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)\\s?>=\\s?([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)",
      i + 1) and
  opcode instanceof Opcode::CompareGE
  or
  s =
    arg.regexpCapture("([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)\\s?<\\s?([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)",
      i + 1) and
  opcode instanceof Opcode::CompareLT
  or
  s =
    arg.regexpCapture("([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)\\s?>\\s?([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)",
      i + 1) and
  opcode instanceof Opcode::CompareGT
  or
  s =
    arg.regexpCapture("([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)\\s?!=\\s?([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)",
      i + 1) and
  opcode instanceof Opcode::CompareNE
  or
  s =
    arg.regexpCapture("([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)\\s?==\\s?([a-zA-Z_][a-zA-Z_0-9]*|[0-9]+)",
      i + 1) and
  opcode instanceof Opcode::CompareEQ
}

private Element getAChildScope(Element scope) { result.getParentScope() = scope }

private predicate hasAVariable(MacroInvocation mi, Stmt s, Element scope) {
  assertion0(mi, s, _) and
  s.getParent() = scope
  or
  hasAVariable(mi, s, getAChildScope(scope))
}

private LocalScopeVariable getVariable(MacroInvocation mi, int i) {
  exists(string operand, string arg, Stmt s |
    assertion0(mi, s, arg) and
    parseArgument(arg, operand, i, _) and
    result =
      unique(Variable v |
        v.getLocation().getStartLine() < s.getLocation().getStartLine() and
        hasAVariable(mi, s, v.getParentScope()) and
        v.hasName(operand)
      |
        v
      )
  )
}

/**
 * Holds if the `i`'th component of the macro invocation `mi` with opcode
 * `opcode` is a reference to `var`.
 */
private predicate hasVarAccessMacroArgument(MacroInvocation mi, Variable var, int i, Opcode opcode) {
  exists(string arg, string s, Function f |
    arg = mi.getUnexpandedArgument(0) and
    f = getEnclosingFunctionForMacroInvocation(mi) and
    parseArgument(arg, s, i, opcode) and
    var = getVariable(mi, i)
  )
}

/**
 * Holds if the `i`'th component of the macro invocation `mi` with opcode
 * `opcode` is a constant with the value `k`.
 */
private predicate hasConstMacroArgument(MacroInvocation mi, int k, int i, Opcode opcode) {
  exists(string arg, string s |
    assertion0(mi, _, arg) and
    s.toInt() = k and
    parseArgument(arg, s, i, opcode)
  )
}

predicate hasAssertionOperand(MacroInvocation mi, int i) {
  hasVarAccessMacroArgument(mi, _, i, _)
  or
  hasConstMacroArgument(mi, _, i, _)
}

private predicate hasAssertionOpcode(MacroInvocation mi, Opcode opcode) {
  hasVarAccessMacroArgument(mi, _, _, opcode)
  or
  hasConstMacroArgument(mi, _, _, opcode)
}

/**
 * Holds if `mi` is a macro invocation that is an assertion that should be generated
 * in the control-flow graph at `s`.
 */
predicate assertion(MacroInvocation mi, Stmt s) {
  assertion0(mi, s, _) and
  hasAssertionOperand(mi, 0) and
  hasAssertionOperand(mi, 1)
}

/** The translation of an operand of an assertion. */
abstract private class TranslatedAssertionOperand extends TranslatedElement,
  TTranslatedAssertionOperand
{
  MacroInvocation mi;
  int index;

  TranslatedAssertionOperand() { this = TTranslatedAssertionOperand(mi, index) }

  MacroInvocation getMacroInvocation() { result = mi }

  /**
   * Gets the statement that is being replaced by the assertion that uses this
   * operand.
   */
  Stmt getStmt() { assertion(mi, result) }

  final override Locatable getAst() { result = this.getStmt() }

  final override TranslatedElement getChild(int id) { none() }

  final override Declaration getFunction() { result = this.getStmt().getEnclosingFunction() }

  /** Gets the instruction which holds the result of this operand. */
  abstract Instruction getResult();

  final override string toString() { result = "Operand of assertion: " + mi }

  /** Gets the index of this operand (i.e., `0` or `1`). */
  final int getIndex() { result = index }
}

/** An operand of an assertion that is a variable access. */
class TranslatedAssertionVarAccess extends TranslatedAssertionOperand {
  TranslatedAssertionVarAccess() { hasVarAccessMacroArgument(mi, _, index, _) }

  Variable getVariable() { hasVarAccessMacroArgument(mi, result, index, _) }

  final override IRUserVariable getInstructionVariable(InstructionTag tag) {
    tag = AssertionVarAddressTag() and
    result.getVariable() = this.getVariable()
  }

  final override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(AssertionVarAddressTag()) and kind instanceof GotoEdge
  }

  final override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = AssertionVarAddressTag() and
    kind instanceof GotoEdge and
    result = this.getInstruction(AssertionVarLoadTag())
    or
    tag = AssertionVarLoadTag() and
    result = getTranslatedAssertionMacroInvocation(mi).getChildSuccessor(this, kind)
  }

  final override Instruction getALastInstructionInternal() {
    result = this.getInstruction(AssertionVarLoadTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    exists(Variable v | v = this.getVariable() |
      opcode instanceof Opcode::VariableAddress and
      tag = AssertionVarAddressTag() and
      resultType = getTypeForGLValue(v.getType())
      or
      opcode instanceof Opcode::Load and
      tag = AssertionVarLoadTag() and
      resultType = getTypeForPRValue(v.getType())
    )
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = AssertionVarLoadTag() and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(AssertionVarAddressTag())
  }

  final override Instruction getResult() { result = this.getInstruction(AssertionVarLoadTag()) }
}

/** An operand of an assertion that is a constant access. */
private class TranslatedAssertionConst extends TranslatedAssertionOperand {
  TranslatedAssertionConst() { hasConstMacroArgument(mi, _, index, _) }

  int getConst() { hasConstMacroArgument(mi, result, index, _) }

  final override string getInstructionConstantValue(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = this.getConst().toString()
  }

  final override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(OnlyInstructionTag()) and
    kind instanceof GotoEdge
  }

  final override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    result = getTranslatedAssertionMacroInvocation(mi).getChildSuccessor(this, kind)
  }

  final override Instruction getALastInstructionInternal() {
    result = this.getInstruction(OnlyInstructionTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    opcode instanceof Opcode::Constant and
    tag = OnlyInstructionTag() and
    resultType = getIntType()
  }

  final override Instruction getResult() { result = this.getInstruction(OnlyInstructionTag()) }
}

/**
 * Gets the `TranslatedAssertionMacroInvocation` corresponding to the macro
 * invocation `mi`.
 */
TranslatedAssertionMacroInvocation getTranslatedAssertionMacroInvocation(MacroInvocation mi) {
  result.getMacroInvocation() = mi
}

/**
 * A synthesized assertion which would have otherwise been invisible because the
 * database represents a release build where assertions are disabled.
 */
private class TranslatedAssertionMacroInvocation extends TranslatedStmt {
  MacroInvocation mi;

  TranslatedAssertionMacroInvocation() { assertion(mi, stmt) }

  final override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getLeft().getFirstInstruction(kind)
  }

  TranslatedAssertionOperand getLeft() {
    result.getMacroInvocation() = mi and
    result.getIndex() = 0
  }

  TranslatedAssertionOperand getRight() {
    result.getMacroInvocation() = mi and
    result.getIndex() = 1
  }

  final override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    tag = AssertionOpTag() and
    kind instanceof GotoEdge and
    result = this.getInstruction(AssertionBranchTag())
    or
    tag = AssertionBranchTag() and
    kind instanceof TrueEdge and
    result = this.getParent().getChildSuccessor(this, _)
  }

  final override TranslatedElement getChildInternal(int id) {
    id = 0 and result = this.getLeft()
    or
    id = 1 and result = this.getRight()
  }

  final override Instruction getALastInstructionInternal() {
    result = this.getInstruction(AssertionBranchTag())
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = AssertionOpTag() and
    resultType = getBoolType() and
    hasAssertionOpcode(mi, opcode)
    or
    tag = AssertionBranchTag() and
    resultType = getVoidType() and
    opcode instanceof Opcode::ConditionalBranch
  }

  final override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getLeft() and
    result = this.getRight().getFirstInstruction(kind)
    or
    child = this.getRight() and
    kind instanceof GotoEdge and
    result = this.getInstruction(AssertionOpTag())
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = AssertionOpTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getLeft().getResult()
      or
      operandTag instanceof RightOperandTag and
      result = this.getRight().getResult()
    )
    or
    tag = AssertionBranchTag() and
    operandTag instanceof ConditionOperandTag and
    result = this.getInstruction(AssertionOpTag())
  }

  MacroInvocation getMacroInvocation() { result = mi }
}
