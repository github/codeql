/**
 * Provides a hierarchy of classes for modeling C/C++ statements.
 */

import semmle.code.cpp.Element
private import semmle.code.cpp.Enclosing
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ statement.
 */
class Stmt extends StmtParent, @stmt {
  /** Gets the `n`th child of this statement. */
  Element getChild(int n) {
    stmtparents(unresolveElement(result), n, underlyingElement(this)) or
    exprparents(unresolveElement(result), n, underlyingElement(this))
  }

  /** Holds if `e` is the `n`th child of this statement. */
  predicate hasChild(Element e, int n) { this.getChild(n) = e }

  /** Gets the enclosing function of this statement, if any. */
  Function getEnclosingFunction() { result = stmtEnclosingElement(this) }

  /**
   * Gets the nearest enclosing block of this statement in the source, if any.
   */
  BlockStmt getEnclosingBlock() {
    if
      this.getParentStmt() instanceof BlockStmt and
      not this.getParentStmt().(BlockStmt).getLocation() instanceof UnknownLocation
    then result = this.getParentStmt()
    else result = this.getParentStmt().getEnclosingBlock()
  }

  /** Gets a child of this statement. */
  Element getAChild() { result = this.getChild(_) }

  /** Gets the parent of this statement, if any. */
  StmtParent getParent() { stmtparents(underlyingElement(this), _, unresolveElement(result)) }

  /** Gets the parent statement of this statement, if any. */
  Stmt getParentStmt() { stmtparents(underlyingElement(this), _, unresolveElement(result)) }

  /** Gets a child statement of this statement. */
  Stmt getChildStmt() { result.getParentStmt() = this }

  /**
   * Gets the statement following this statement in the same block, if any.
   *
   * Note that this is not widely useful, because this doesn't have a result for
   * the last statement of a block.  Consider using the `ControlFlowNode` class
   * to trace the flow of control instead.
   */
  Stmt getFollowingStmt() {
    exists(BlockStmt b, int i |
      this = b.getStmt(i) and
      result = b.getStmt(i + 1)
    )
  }

  /**
   * Gets the `n`th compiler-generated destructor call that is performed after this statement, in
   * order of destruction.
   *
   * For instance, in the following code, `getImplicitDestructorCall(0)` for the block will be the
   * destructor call for `c2`:
   * ```cpp
   * {
   *      MyClass c1;
   *      MyClass c2;
   * }
   * ```
   */
  DestructorCall getImplicitDestructorCall(int n) {
    synthetic_destructor_call(this, max(int i | synthetic_destructor_call(this, i, _)) - n, result)
  }

  /**
   * Gets a compiler-generated destructor call that is performed after this statement.
   */
  DestructorCall getAnImplicitDestructorCall() { synthetic_destructor_call(this, _, result) }

  override Location getLocation() { stmts(underlyingElement(this), _, result) }

  override string toString() { none() }

  override Function getControlFlowScope() { result = this.getEnclosingFunction() }

  override Stmt getEnclosingStmt() { result = this }

  /**
   * Holds if this statement is side-effect free (a conservative
   * approximation; that is, it may be side-effect free even if this
   * predicate doesn't hold).
   *
   * This predicate cannot be overridden; override `mayBeImpure()`
   * instead.
   *
   * Note that this predicate only considers whether the statement has
   * any side-effects, such as writing to a file. Even if it holds, the
   * statement may be impure in the sense that its behavior is affected
   * by external factors, such as the contents of global variables.
   */
  final predicate isPure() { not this.mayBeImpure() }

  /**
   * Holds if it is possible that this statement is impure. If we are not
   * sure, then it holds.
   */
  predicate mayBeImpure() { any() }

  /**
   * Holds if it is possible that this statement is globally impure.
   *
   * Similar to `mayBeImpure()`, except that `mayBeGloballyImpure()`
   * does not consider modifications to temporary local variables to be
   * impure. That is, if you call a function in which
   * `mayBeGloballyImpure()` doesn't hold for any statement, then the
   * function as a whole will have no side-effects, even if it mutates
   * its own fresh stack variables.
   */
  predicate mayBeGloballyImpure() { any() }

  /**
   * Gets an attribute of this statement, for example
   * `[[clang::fallthrough]]`.
   */
  Attribute getAnAttribute() { stmtattributes(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets a macro invocation that generates this entire statement.
   *
   * For example, given
   * ```
   * #define SOMEFUN a()
   * #define FOO do { SOMEFUN; b(); } while (0)
   * void f(void) {
   *     FOO;
   * }
   * ```
   * this predicate would have results of `SOMEFUN` and `FOO` for the
   * function call `a()`, and just `FOO` for the function call `b()`,
   * the block within the 'do' statement, and the entire 'do' statement.
   *
   * Note that, unlike `isInMacroExpansion()` it is not necessary for
   * the macro to generate the terminating semi-colon.
   */
  MacroInvocation getGeneratingMacro() { result.getAnExpandedElement() = this }

  /** Holds if this statement was generated by the compiler. */
  predicate isCompilerGenerated() { compgenerated(underlyingElement(this)) }
}

private class TStmtParent = @stmt or @expr;

/**
 * An element that is the parent of a statement in the C/C++ AST.
 *
 * This is normally a statement, but may be a `StmtExpr`.
 */
class StmtParent extends ControlFlowNode, TStmtParent { }

/**
 * A C/C++ 'expression' statement.
 *
 * For example,
 * ```
 * x = 1;
 * ```
 * is an assignment expression inside an 'expression' statement.
 */
class ExprStmt extends Stmt, @stmt_expr {
  override string getAPrimaryQlClass() { result = "ExprStmt" }

  /**
   * Gets the expression of this 'expression' statement.
   *
   * For example, for
   * ```
   * x = 1;
   * ```
   * the result would be an `AssignExpr`.
   */
  Expr getExpr() { result = this.getChild(0) }

  override string toString() { result = "ExprStmt" }

  override predicate mayBeImpure() { this.getExpr().mayBeImpure() }

  override predicate mayBeGloballyImpure() { this.getExpr().mayBeGloballyImpure() }

  override MacroInvocation getGeneratingMacro() {
    // We only need the expression to be in the macro, not the semicolon.
    result.getAnExpandedElement() = this.getExpr()
  }
}

private class TControlStructure = TConditionalStmt or TLoop;

/**
 * A C/C++ control structure, that is, either a conditional statement or
 * a loop.
 */
class ControlStructure extends Stmt, TControlStructure {
  /**
   * Gets the controlling expression of this control structure.
   *
   * This is the condition of 'if' statements and loops, and the
   * switched expression for 'switch' statements.
   */
  Expr getControllingExpr() { none() } // overridden by subclasses

  /** Gets a child declaration of this scope. */
  Declaration getADeclaration() { none() }
}

private class TConditionalStmt = @stmt_if or @stmt_constexpr_if or @stmt_switch;

/**
 * A C/C++ conditional statement, that is, either an 'if' statement or a
 * 'switch' statement.
 */
class ConditionalStmt extends ControlStructure, TConditionalStmt { }

/**
 * A C/C++ 'if' statement. For example, the `if` statement in the following
 * code:
 * ```
 * if (x == 1) {
 *   ...
 * }
 * ```
 */
class IfStmt extends ConditionalStmt, @stmt_if {
  override string getAPrimaryQlClass() { result = "IfStmt" }

  /**
   * Gets the initialization statement of this 'if' statement, if any.
   *
   * For example, for
   * ```
   * if (int x = y; b) { f(); }
   * ```
   * the result is `int x = y;`.
   *
   * Does not hold if the initialization statement is missing or an empty statement, as in
   * ```
   * if (b) { f(); }
   * ```
   * or
   * ```
   * if (; b) { f(); }
   * ```
   */
  Stmt getInitialization() { if_initialization(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets the condition expression of this 'if' statement.
   *
   * For example, for
   * ```
   * if (b) { x = 1; }
   * ```
   * the result is `b`.
   */
  Expr getCondition() { result = this.getChild(1) }

  override Expr getControllingExpr() { result = this.getCondition() }

  /**
   * Gets the 'then' statement of this 'if' statement.
   *
   * For example, for
   * ```
   * if (b) { x = 1; }
   * ```
   * the result is the `BlockStmt` `{ x = 1; }`.
   */
  Stmt getThen() { if_then(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets the 'else' statement of this 'if' statement, if any.
   *
   * For example, for
   * ```
   * if (b) { x = 1; } else { x = 2; }
   * ```
   * the result is the `BlockStmt` `{ x = 2; }`, and for
   * ```
   * if (b) { x = 1; }
   * ```
   * there is no result.
   */
  Stmt getElse() { if_else(underlyingElement(this), unresolveElement(result)) }

  /**
   * Holds if this 'if' statement has an 'else' statement.
   *
   * For example, this holds for
   * ```
   * if (b) { x = 1; } else { x = 2; }
   * ```
   * but not for
   * ```
   * if (b) { x = 1; }
   * ```
   */
  predicate hasElse() { exists(this.getElse()) }

  override string toString() { result = "if (...) ... " }

  override predicate mayBeImpure() {
    this.getCondition().mayBeImpure() or
    this.getThen().mayBeImpure() or
    this.getElse().mayBeImpure()
  }

  override predicate mayBeGloballyImpure() {
    this.getCondition().mayBeGloballyImpure() or
    this.getThen().mayBeGloballyImpure() or
    this.getElse().mayBeGloballyImpure()
  }

  override MacroInvocation getGeneratingMacro() {
    result.getAnExpandedElement() = this.getCondition() and
    this.getThen().getGeneratingMacro() = result and
    (this.hasElse() implies this.getElse().getGeneratingMacro() = result)
  }
}

/**
 * A C/C++ 'constexpr if' statement. For example, the `if constexpr` statement
 * in the following code:
 * ```
 * if constexpr (x) {
 *   ...
 * }
 * ```
 */
class ConstexprIfStmt extends ConditionalStmt, @stmt_constexpr_if {
  override string getAPrimaryQlClass() { result = "ConstexprIfStmt" }

  /**
   * Gets the initialization statement of this 'constexpr if' statement, if any.
   *
   * For example, for
   * ```
   * if constexpr (int x = y; b) { f(); }
   * ```
   * the result is `int x = y;`.
   *
   * Does not hold if the initialization statement is missing or an empty statement, as in
   * ```
   * if constexpr (b) { f(); }
   * ```
   * or
   * ```
   * if constexpr (; b) { f(); }
   * ```
   */
  Stmt getInitialization() {
    constexpr_if_initialization(underlyingElement(this), unresolveElement(result))
  }

  /**
   * Gets the condition expression of this 'constexpr if' statement.
   *
   * For example, for
   * ```
   * if constexpr (b) { x = 1; }
   * ```
   * the result is `b`.
   */
  Expr getCondition() { result = this.getChild(1) }

  override Expr getControllingExpr() { result = this.getCondition() }

  /**
   * Gets the 'then' statement of this 'constexpr if' statement.
   *
   * For example, for
   * ```
   * if constexpr (b) { x = 1; }
   * ```
   * the result is the `BlockStmt` `{ x = 1; }`.
   */
  Stmt getThen() { constexpr_if_then(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets the 'else' statement of this 'constexpr if' statement, if any.
   *
   * For example, for
   * ```
   * if constexpr (b) { x = 1; } else { x = 2; }
   * ```
   * the result is the `BlockStmt` `{ x = 2; }`, and for
   * ```
   * if constexpr (b) { x = 1; }
   * ```
   * there is no result.
   */
  Stmt getElse() { constexpr_if_else(underlyingElement(this), unresolveElement(result)) }

  /**
   * Holds if this 'constexpr if' statement has an 'else' statement.
   *
   * For example, this holds for
   * ```
   * if constexpr (b) { x = 1; } else { x = 2; }
   * ```
   * but not for
   * ```
   * if constexpr (b) { x = 1; }
   * ```
   */
  predicate hasElse() { exists(this.getElse()) }

  override string toString() { result = "if constexpr (...) ... " }

  override predicate mayBeImpure() {
    this.getCondition().mayBeImpure() or
    this.getThen().mayBeImpure() or
    this.getElse().mayBeImpure()
  }

  override predicate mayBeGloballyImpure() {
    this.getCondition().mayBeGloballyImpure() or
    this.getThen().mayBeGloballyImpure() or
    this.getElse().mayBeGloballyImpure()
  }

  override MacroInvocation getGeneratingMacro() {
    result.getAnExpandedElement() = this.getCondition() and
    this.getThen().getGeneratingMacro() = result and
    (this.hasElse() implies this.getElse().getGeneratingMacro() = result)
  }
}

/**
 * A C/C++ '(not) consteval if'. For example, the `if consteval` statement
 * in the following code:
 * ```cpp
 * if consteval {
 *   ...
 * }
 * ```
 */
class ConstevalIfStmt extends Stmt, @stmt_consteval_or_not_consteval_if {
  override string getAPrimaryQlClass() { result = "ConstevalIfStmt" }

  override string toString() {
    if this.isNot() then result = "if ! consteval ..." else result = "if consteval ..."
  }

  /**
   * Holds if this is a 'not consteval if' statement.
   *
   * For example, this holds for
   * ```cpp
   * if ! consteval { return true; }
   * ```
   * but not for
   * ```cpp
   * if consteval { return true; }
   * ```
   */
  predicate isNot() { this instanceof @stmt_not_consteval_if }

  /**
   * Gets the 'then' statement of this '(not) consteval if' statement.
   *
   * For example, for
   * ```cpp
   * if consteval { return true; }
   * ```
   * the result is the `BlockStmt` `{ return true; }`.
   */
  Stmt getThen() { consteval_if_then(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets the 'else' statement of this '(not) constexpr if' statement, if any.
   *
   * For example, for
   * ```cpp
   * if consteval { return true; } else { return false; }
   * ```
   * the result is the `BlockStmt` `{ return false; }`, and for
   * ```cpp
   * if consteval { return true; }
   * ```
   * there is no result.
   */
  Stmt getElse() { consteval_if_else(underlyingElement(this), unresolveElement(result)) }

  /**
   * Holds if this '(not) constexpr if' statement has an 'else' statement.
   *
   * For example, this holds for
   * ```cpp
   * if consteval { return true; } else { return false; }
   * ```
   * but not for
   * ```cpp
   * if consteval { return true; }
   * ```
   */
  predicate hasElse() { exists(this.getElse()) }

  override predicate mayBeImpure() {
    this.getThen().mayBeImpure() or
    this.getElse().mayBeImpure()
  }

  override predicate mayBeGloballyImpure() {
    this.getThen().mayBeGloballyImpure() or
    this.getElse().mayBeGloballyImpure()
  }

  override MacroInvocation getGeneratingMacro() {
    this.getThen().getGeneratingMacro() = result and
    (this.hasElse() implies this.getElse().getGeneratingMacro() = result)
  }

  /**
   * Gets the statement of this '(not) consteval if' statement evaluated during compile time, if any.
   *
   * For example, for
   * ```cpp
   * if ! consteval { return true; } else { return false; }
   * ```
   * the result is the `BlockStmt` `{ return false; }`, and for
   * ```cpp
   * if ! consteval { return true; }
   * ```
   * there is no result.
   */
  Stmt getCompileTimeEvaluatedBranch() {
    if this.isNot() then result = this.getElse() else result = this.getThen()
  }

  /**
   * Holds if this '(not) constexpr if' statement has a compile time evaluated statement.
   *
   * For example, this holds for
   * ```cpp
   * if ! consteval { return true; } else { return false; }
   * ```
   * but not for
   * ```cpp
   * if ! consteval { return true; }
   * ```
   */
  predicate hasCompileTimeEvaluatedBranch() { exists(this.getCompileTimeEvaluatedBranch()) }

  /**
   * Gets the statement of this '(not) consteval if' statement evaluated during runtime, if any.
   *
   * For example, for
   * ```cpp
   * if consteval { return true; } else { return false; }
   * ```
   * the result is the `BlockStmt` `{ return false; }`, and for
   * ```cpp
   * if consteval { return true; }
   * ```
   * there is no result.
   */
  Stmt getRuntimeEvaluatedBranch() {
    if this.isNot() then result = this.getThen() else result = this.getElse()
  }

  /**
   * Holds if this '(not) constexpr if' statement has a runtime evaluated statement.
   *
   * For example, this holds for
   * ```cpp
   * if consteval { return true; } else { return false; }
   * ```
   * but not for
   * ```cpp
   * if consteval { return true; }
   * ```
   */
  predicate hasRuntimeEvaluatedBranch() { exists(this.getRuntimeEvaluatedBranch()) }
}

private class TLoop = @stmt_while or @stmt_end_test_while or @stmt_range_based_for or @stmt_for;

/**
 * A C/C++ loop, that is, either a 'while' loop, a 'for' loop, or a
 * 'do' loop.
 */
class Loop extends ControlStructure, TLoop {
  /** Gets the condition expression of this loop. */
  Expr getCondition() { none() } // overridden in subclasses

  /** Gets the body statement of this loop. */
  Stmt getStmt() { none() } // overridden in subclasses
}

/**
 * A C/C++ 'while' statement.
 *
 * For example, the `while` statement in the following code:
 * ```
 * while (b) {
 *   f();
 * }
 * ```
 */
class WhileStmt extends Loop, @stmt_while {
  override string getAPrimaryQlClass() { result = "WhileStmt" }

  override Expr getCondition() { result = this.getChild(0) }

  override Expr getControllingExpr() { result = this.getCondition() }

  override Stmt getStmt() { while_body(underlyingElement(this), unresolveElement(result)) }

  override string toString() { result = "while (...) ..." }

  override predicate mayBeImpure() {
    this.getCondition().mayBeImpure() or
    this.getStmt().mayBeImpure()
  }

  override predicate mayBeGloballyImpure() {
    this.getCondition().mayBeGloballyImpure() or
    this.getStmt().mayBeGloballyImpure()
  }

  override MacroInvocation getGeneratingMacro() {
    result.getAnExpandedElement() = this.getCondition() and
    this.getStmt().getGeneratingMacro() = result
  }

  /**
   * Holds if the loop condition is provably `true`.
   *
   * For example, this holds for
   * ```
   * while(1) { ...; if(b) break; ...; }
   * ```
   */
  predicate conditionAlwaysTrue() { conditionAlwaysTrue(this.getCondition()) }

  /**
   * Holds if the loop condition is provably `false`.
   *
   * For example, this holds for
   * ```
   * while(0) { ...; }
   * ```
   */
  predicate conditionAlwaysFalse() { conditionAlwaysFalse(this.getCondition()) }

  /**
   * Holds if the loop condition is provably `true` upon entry,
   * that is, at least one iteration of the loop is guaranteed.
   *
   * For example, with
   * ```
   * bool done = false;
   * while (!done) { ... done = true; ... }
   * ```
   * the condition `!done` always evaluates to `true` upon entry since
   * `done = false`, but the condition may evaluate to `false` after
   * some iterations.
   */
  predicate conditionAlwaysTrueUponEntry() { loopConditionAlwaysTrueUponEntry(this, _) }
}

/**
 * A C/C++ jump statement.
 */
class JumpStmt extends Stmt, @jump {
  override string getAPrimaryQlClass() { result = "JumpStmt" }

  /** Gets the target of this jump statement. */
  Stmt getTarget() { jumpinfo(underlyingElement(this), _, unresolveElement(result)) }
}

/**
 * A C/C++ 'goto' statement which jumps to a label.
 *
 * For example, the `goto` statement in the following code:
 * ```
 * goto someLabel;
 * ...
 * somelabel:
 * ```
 */
class GotoStmt extends JumpStmt, @stmt_goto {
  override string getAPrimaryQlClass() { result = "GotoStmt" }

  /**
   * Gets the name of the label this 'goto' statement refers to.
   *
   * For example, for
   * ```
   * goto someLabel;
   * ```
   * the result is `"someLabel"`.
   */
  string getName() { jumpinfo(underlyingElement(this), result, _) and result != "" }

  /** Holds if this 'goto' statement refers to a label. */
  predicate hasName() { exists(string s | jumpinfo(underlyingElement(this), s, _) and s != "") }

  override string toString() { result = "goto ..." }

  /**
   * Holds if this 'goto' statement breaks out of two or more nested
   * loops.
   *
   * For example, for
   * ```
   * while(b) {
   *     while(b) {
   *         if(b) goto middle;
   *         if(b) goto end;
   *     }
   *     if(b) goto end;
   * middle:
   * }
   * end:
   * ```
   * this holds for the second `goto`, but not the first or third.
   */
  predicate breaksFromNestedLoops() {
    exists(Loop l1, Loop l2 |
      this.getParentStmt+() = l1 and
      l1.getParentStmt+() = l2 and
      l2.getParentStmt+() = this.getASuccessor().(Stmt).getParentStmt()
    )
  }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }
}

/**
 * A 'goto' statement whose target is computed by a non-constant
 * expression (a non-standard extension to C/C++).
 *
 * For example, the `goto` statement in the following code:
 * ```
 * goto *ptr;
 * ```
 */
class ComputedGotoStmt extends Stmt, @stmt_assigned_goto {
  /**
   * Gets the expression used to compute the target of this 'goto'
   * statement.
   *
   * For example, for
   * ```
   * goto *ptr;
   * ```
   * the result is `ptr`.
   */
  Expr getExpr() { result = this.getChild(0) }

  override string toString() { result = "computed goto ..." }

  override predicate mayBeImpure() { this.getExpr().mayBeImpure() }

  override predicate mayBeGloballyImpure() { this.getExpr().mayBeGloballyImpure() }

  override MacroInvocation getGeneratingMacro() {
    // We only need the expression to be in the macro, not the semicolon.
    result.getAnExpandedElement() = this.getExpr()
  }
}

/**
 * A C/C++ 'continue' statement.
 *
 * For example, the `continue` statement in the following code:
 * ```
 * while (x) {
 *   if (arr[x] < 0) continue;
 *   ...
 * }
 * ```
 */
class ContinueStmt extends JumpStmt, @stmt_continue {
  override string getAPrimaryQlClass() { result = "ContinueStmt" }

  override string toString() { result = "continue;" }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }

  /**
   * Gets the loop that this continue statement will jump to the beginning of.
   */
  Stmt getContinuable() { result = getEnclosingContinuable(this) }
}

private Stmt getEnclosingContinuable(Stmt s) {
  if s.getParent().getEnclosingStmt() instanceof Loop
  then result = s.getParent().getEnclosingStmt()
  else result = getEnclosingContinuable(s.getParent().getEnclosingStmt())
}

/**
 * A C/C++ 'break' statement.
 *
 * For example, the `break` statement in the following code:
 * ```
 * while (x) {
 *   if (arr[x] == 0) break;
 *   ...
 * }
 * ```
 */
class BreakStmt extends JumpStmt, @stmt_break {
  override string getAPrimaryQlClass() { result = "BreakStmt" }

  override string toString() { result = "break;" }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }

  /**
   * Gets the loop or switch statement that this break statement will exit.
   */
  Stmt getBreakable() { result = getEnclosingBreakable(this) }
}

private Stmt getEnclosingBreakable(Stmt s) {
  if
    s.getParent().getEnclosingStmt() instanceof Loop or
    s.getParent().getEnclosingStmt() instanceof SwitchStmt
  then result = s.getParent().getEnclosingStmt()
  else result = getEnclosingBreakable(s.getParent().getEnclosingStmt())
}

/**
 * A Microsoft C/C++ `__leave` statement.
 *
 * For example, the `__leave` statement in the following code:
 * ```
 * __try {
 *   if (err) __leave;
 *   ...
 * }
 * __finally {
 *
 * }
 * ```
 */
class LeaveStmt extends JumpStmt, @stmt_leave {
  override string getAPrimaryQlClass() { result = "LeaveStmt" }

  override string toString() { result = "__leave;" }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }

  /**
   * Gets the `__try` statement that this `__leave` exits.
   */
  MicrosoftTryStmt getEnclosingTry() { result = getEnclosingTry(this) }
}

private MicrosoftTryStmt getEnclosingTry(Stmt s) {
  if s.getParent().getEnclosingStmt() instanceof MicrosoftTryStmt
  then result = s.getParent().getEnclosingStmt()
  else result = getEnclosingTry(s.getParent().getEnclosingStmt())
}

/**
 * A C/C++ 'label' statement.
 *
 * For example, the `somelabel:` statement in the following code:
 * ```
 * goto someLabel;
 * ...
 * somelabel:
 * ```
 */
class LabelStmt extends Stmt, @stmt_label {
  override string getAPrimaryQlClass() { result = "LabelStmt" }

  /** Gets the name of this 'label' statement. */
  string getName() { jumpinfo(underlyingElement(this), result, _) and result != "" }

  /** Holds if this 'label' statement is named. */
  predicate isNamed() { exists(this.getName()) }

  override string toString() { result = "label ...:" }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }
}

/**
 * A C/C++ `co_return` statement.
 *
 * For example:
 * ```
 * co_return 1+2;
 * ```
 * or
 * ```
 * co_return;
 * ```
 */
class CoReturnStmt extends Stmt, @stmt_co_return {
  override string getAPrimaryQlClass() { result = "CoReturnStmt" }

  /**
   * Gets the operand of this `co_return` statement.
   *
   * For example, for
   * ```
   * co_return 1+2;
   * ```
   * the operand is a function call `return_value(1+2)`, and for
   * ```
   * co_return;
   * ```
   * the operand is a function call `return_void()`.
   */
  FunctionCall getOperand() { result = this.getChild(0) }

  /**
   * Gets the expression of this `co_return` statement, if any.
   *
   * For example, for
   * ```
   * co_return 1+2;
   * ```
   * the result is `1+2`, and there is no result for
   * ```
   * co_return;
   * ```
   */
  Expr getExpr() { result = this.getOperand().getArgument(0) }

  /**
   * Holds if this `co_return` statement has an expression.
   *
   * For example, this holds for
   * ```
   * co_return 1+2;
   * ```
   * but not for
   * ```
   * co_return;
   * ```
   */
  predicate hasExpr() { exists(this.getExpr()) }

  override string toString() { result = "co_return ..." }
}

/**
 * A C/C++ 'return' statement.
 *
 * For example:
 * ```
 * return 1+2;
 * ```
 * or
 * ```
 * return;
 * ```
 */
class ReturnStmt extends Stmt, @stmt_return {
  override string getAPrimaryQlClass() { result = "ReturnStmt" }

  /**
   * Gets the expression of this 'return' statement.
   *
   * For example, for
   * ```
   * return 1+2;
   * ```
   * the result is `1+2`, and there is no result for
   * ```
   * return;
   * ```
   */
  Expr getExpr() { result = this.getChild(0) }

  /**
   * Holds if this 'return' statement has an expression.
   *
   * For example, this holds for
   * ```
   * return 1+2;
   * ```
   * but not for
   * ```
   * return;
   * ```
   */
  predicate hasExpr() { exists(this.getExpr()) }

  override string toString() { result = "return ..." }

  override predicate mayBeImpure() { this.getExpr().mayBeImpure() }

  override predicate mayBeGloballyImpure() { this.getExpr().mayBeGloballyImpure() }
}

/**
 * A C/C++ 'do' statement.
 *
 * For example, the `do` ... `while` in the following code:
 * ```
 * do {
 *     x = x + 1;
 * } while (x < 10);
 * ```
 */
class DoStmt extends Loop, @stmt_end_test_while {
  override string getAPrimaryQlClass() { result = "DoStmt" }

  override Expr getCondition() { result = this.getChild(0) }

  override Expr getControllingExpr() { result = this.getCondition() }

  override Stmt getStmt() { do_body(underlyingElement(this), unresolveElement(result)) }

  override string toString() { result = "do (...) ..." }

  override predicate mayBeImpure() {
    this.getCondition().mayBeImpure() or
    this.getStmt().mayBeImpure()
  }

  override predicate mayBeGloballyImpure() {
    this.getCondition().mayBeGloballyImpure() or
    this.getStmt().mayBeGloballyImpure()
  }

  override MacroInvocation getGeneratingMacro() {
    result.getAnExpandedElement() = this.getCondition() and
    this.getStmt().getGeneratingMacro() = result
  }
}

/**
 * A C++11 range-based 'for' statement.
 *
 * For example,
 * ```
 * for (int x : xs) { y += x; }
 * ```
 *
 * This example would be desugared to
 * ```
 * {
 *     auto &amp;&amp; __range = xs;
 *     for (auto __begin = begin_expr, __end = end_expr;
 *          __begin != __end;
 *          ++__begin) {
 *         int x = *__begin;
 *         y += x;
 *     }
 * }
 * ```
 * where `begin_expr` and `end_expr` depend on the type of `xs`.
 */
class RangeBasedForStmt extends Loop, @stmt_range_based_for {
  override string getAPrimaryQlClass() { result = "RangeBasedForStmt" }

  /**
   * Gets the initialization statement of this 'for' statement, if any.
   *
   * For example, for
   * ```
   * for (int x = y; auto z : ... ) { }
   * ```
   * the result is `int x = y;`.
   *
   * Does not hold if the initialization statement is missing or an empty statement, as in
   * ```
   * for (auto z : ...) { }
   * ```
   * or
   * ```
   * for (; auto z : ) { }
   * ```
   */
  Stmt getInitialization() { for_initialization(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets the 'body' statement of this range-based 'for' statement.
   *
   * For example, for
   * ```
   * for (int x : xs) { y += x; }
   * ```
   * the result is the `BlockStmt` `{ y += x; }`.
   */
  override Stmt getStmt() { result = this.getChild(6) }

  override string toString() { result = "for(...:...) ..." }

  /**
   * Gets the variable introduced by the for-range-declaration.
   *
   * For example, for
   * ```
   * for (int x : xs) { y += x; }
   * ```
   * the result is `int x`.
   */
  LocalVariable getVariable() { result = this.getChild(5).(DeclStmt).getADeclaration() }

  /**
   * Gets the expression giving the range to iterate over.
   *
   * For example, for
   * ```
   * for (int x : xs) { y += x; }
   * ```
   * the result is `xs`.
   */
  Expr getRange() { result = this.getRangeVariable().getInitializer().getExpr() }

  /** Gets the compiler-generated `__range` variable after desugaring. */
  LocalVariable getRangeVariable() { result = this.getChild(1).(DeclStmt).getADeclaration() }

  /**
   * Gets the compiler-generated `__begin != __end` which is the
   * condition expression of this for statement after desugaring.
   * It will be either an `NEExpr` or a call to a user-defined
   * `operator!=`.
   */
  override Expr getCondition() { result = this.getChild(3) }

  override Expr getControllingExpr() { result = this.getCondition() }

  /**
   * Gets a declaration statement that declares first `__begin` and then
   * `__end`, initializing them to the values they have before entering the
   * desugared loop.
   */
  DeclStmt getBeginEndDeclaration() { result = this.getChild(2) }

  /** Gets the compiler-generated `__begin` variable after desugaring. */
  LocalVariable getBeginVariable() { result = this.getBeginEndDeclaration().getDeclaration(0) }

  /** Gets the compiler-generated `__end` variable after desugaring. */
  LocalVariable getEndVariable() { result = this.getBeginEndDeclaration().getDeclaration(1) }

  /**
   * Gets the compiler-generated `++__begin` which is the update
   * expression of this for statement after desugaring. It will
   * be either a `PrefixIncrExpr` or a call to a user-defined
   * `operator++`.
   */
  Expr getUpdate() { result = this.getChild(4) }

  /** Gets the compiler-generated `__begin` variable after desugaring. */
  LocalVariable getAnIterationVariable() { result = this.getBeginVariable() }
}

/**
 * A C/C++ 'for' statement.
 *
 * This only represents "traditional" 'for' statements and not C++11
 * range-based 'for' statements or Objective C 'for-in' statements.
 *
 * For example, the `for` statement in:
 * ```
 * for (i = 0; i < 10; i++) { j++; }
 * ```
 */
class ForStmt extends Loop, @stmt_for {
  override string getAPrimaryQlClass() { result = "ForStmt" }

  /**
   * Gets the initialization statement of this 'for' statement.
   *
   * For example, for
   * ```
   * for (i = 0; i < 10; i++) { j++; }
   * ```
   * the result is `i = 0;`.
   *
   * Does not hold if the initialization statement is an empty statement, as in
   * ```
   * for (; i < 10; i++) { j++; }
   * ```
   */
  Stmt getInitialization() { for_initialization(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets the condition expression of this 'for' statement.
   *
   * For example, for
   * ```
   * for (i = 0; i < 10; i++) { j++; }
   * ```
   * the result is `i < 10`.
   *
   * Does not hold if the condition expression is omitted, as in
   * ```
   * for (i = 0;; i++) { if (i >= 10) break; }
   * ```
   */
  override Expr getCondition() { for_condition(underlyingElement(this), unresolveElement(result)) }

  override Expr getControllingExpr() { result = this.getCondition() }

  /**
   * Gets the update expression of this 'for' statement.
   *
   * For example, for
   * ```
   * for (i = 0; i < 10; i++) { j++; }
   * ```
   * the result is `i++`.
   *
   * Does not hold if the update expression is omitted, as in
   * ```
   * for (i = 0; i < 10;) { i++; }
   * ```
   */
  Expr getUpdate() { for_update(underlyingElement(this), unresolveElement(result)) }

  override Stmt getStmt() { for_body(underlyingElement(this), unresolveElement(result)) }

  override string toString() { result = "for(...;...;...) ..." }

  /**
   * Gets a variable that is used as an iteration variable. That is, a
   * variables that is defined, updated or tested in the head of this
   * for statement.
   *
   * This only has results that are quite certainly loop variables: for
   * complex iterations, it may not return anything.
   *
   * For example, for
   * ```
   * for (i = 0; i < 10; i++) { j++; }
   * ```
   * the result is `i`.
   */
  pragma[noopt]
  Variable getAnIterationVariable() {
    this instanceof ForStmt and
    // check that it is assigned to, incremented or decremented in the update
    exists(Expr updateOpRoot, Expr updateOp |
      updateOpRoot = this.getUpdate() and
      inForUpdate(updateOpRoot, updateOp)
    |
      exists(CrementOperation op, VariableAccess va |
        op = updateOp and
        op instanceof CrementOperation and
        op.getOperand() = va and
        va = result.getAnAccess()
      )
      or
      updateOp = result.getAnAssignedValue()
    ) and
    result instanceof Variable and
    // checked or used in the condition
    exists(Expr e, VariableAccess va |
      va = result.getAnAccess() and
      inForCondition(e, va) and
      e = this.getCondition()
    )
  }

  /**
   * Gets a declaration from the initialization statement of this 'for'
   * statement.
   *
   * For example, for
   * ```
   * for(int x = 0, y = 10; x != y; ++x) { sum += x; }
   * ```
   * the results are `x` and `y`, while for
   * ```
   * for (i = 0; i < 10; i++) { j++; }
   * ```
   * there are no results.
   */
  override Declaration getADeclaration() {
    result = this.getInitialization().(DeclStmt).getADeclaration()
  }

  override predicate mayBeImpure() {
    this.getInitialization().mayBeImpure() or
    this.getCondition().mayBeImpure() or
    this.getUpdate().mayBeImpure() or
    this.getStmt().mayBeImpure()
  }

  override predicate mayBeGloballyImpure() {
    this.getInitialization().mayBeGloballyImpure() or
    this.getCondition().mayBeGloballyImpure() or
    this.getUpdate().mayBeGloballyImpure() or
    this.getStmt().mayBeGloballyImpure()
  }

  override MacroInvocation getGeneratingMacro() {
    (
      exists(this.getInitialization())
      implies
      result = this.getInitialization().getGeneratingMacro()
    ) and
    (exists(this.getCondition()) implies this.getCondition() = result.getAnExpandedElement()) and
    (exists(this.getUpdate()) implies this.getUpdate() = result.getAnExpandedElement()) and
    this.getStmt().getGeneratingMacro() = result
  }

  /**
   * Holds if the loop condition is provably `true`.
   *
   * For example, this holds for
   * ```
   * for(x = 0; 1; ++x) { sum += x; }
   * ```
   */
  predicate conditionAlwaysTrue() { conditionAlwaysTrue(this.getCondition()) }

  /**
   * Holds if the loop condition is provably `false`.
   *
   * For example, this holds for
   * ```
   * for(x = 0; 0; ++x) { sum += x; }
   * ```
   */
  predicate conditionAlwaysFalse() { conditionAlwaysFalse(this.getCondition()) }

  /**
   * Holds if the loop condition is provably `true` upon entry,
   * that is, at least one iteration of the loop is guaranteed.
   *
   * For example, with
   * ```
   * for (int i = 0; i < 10; i++) { ... }
   * ```
   * the condition `i < 10` always evaluates to `true` upon entry since
   * `i = 0`, but the condition will evaluate to `false` after 10
   * iterations.
   */
  predicate conditionAlwaysTrueUponEntry() { loopConditionAlwaysTrueUponEntry(this, _) }
}

/**
 * Holds if `child` is in the condition `forCondition` of a 'for'
 * statement.
 *
 * For example, if a program includes
 * ```
 * for (i = 0; i < 10; i++) { j++; }
 * ```
 * then this predicate will hold with `forCondition` as `i < 10`,
 * and `child` as any of `i`, `10` and `i < 10`.
 */
pragma[noopt]
private predicate inForCondition(Expr forCondition, Expr child) {
  exists(ForStmt for |
    forCondition = for.getCondition() and
    child = forCondition and
    for instanceof ForStmt
  )
  or
  exists(Expr mid |
    inForCondition(forCondition, mid) and
    child.getParent() = mid
  )
}

/**
 * Holds if `child` is in the update `forUpdate` of a 'for' statement.
 *
 * For example, if a program includes
 * ```
 * for (i = 0; i < 10; i += 1) { j++; }
 * ```
 * then this predicate will hold with `forUpdate` as `i += 1`,
 * and `child` as any of `i`, `1` and `i += 1`.
 */
pragma[noopt]
private predicate inForUpdate(Expr forUpdate, Expr child) {
  exists(ForStmt for | forUpdate = for.getUpdate() and child = forUpdate)
  or
  exists(Expr mid | inForUpdate(forUpdate, mid) and child.getParent() = mid)
}

/** Gets the `rnk`'th `case` statement in `b`. */
private int indexOfSwitchCaseRank(BlockStmt b, int rnk) {
  result = rank[rnk](int i | b.getStmt(i) instanceof SwitchCase)
}

/**
 * A C/C++ 'switch case' statement.
 *
 * For example, the `case` and `default` statements in:
 * ```
 * switch (i)
 * {
 * case 5:
 *   ...
 * default:
 *   ...
 * }
 * ```
 */
class SwitchCase extends Stmt, @stmt_switch_case {
  override string getAPrimaryQlClass() { result = "SwitchCase" }

  /**
   * Gets the expression of this 'switch case' statement (or the start of
   * the range if there is a GNU case range). Does not exist for a
   * `DefaultCase`.
   *
   * For example, for
   * ```
   * case 5:
   * ```
   * the result is `5`, for
   * ```
   * case 6 ... 7:
   * ```
   * the result is 6, and there is no result for
   * ```
   * default:
   * ```
   */
  Expr getExpr() { result = this.getChild(0) }

  /**
   * Gets the end of the range, if this is a GNU case range. Otherwise
   * has no result.
   *
   * For example, for
   * ```
   * case 6 ... 7:
   * ```
   * the result is `7`, while for
   * ```
   * case 5:
   * ```
   * and
   * ```
   * default:
   * ```
   * there is no result.
   */
  Expr getEndExpr() { result = this.getChild(1) }

  /**
   * Gets the 'switch' statement of this 'switch case' statement.
   *
   * For example, with
   * ```
   * switch(i) {
   * case 5:
   *     x = 1;
   * }
   * ```
   * the result of this predicate on `case 5:` is the whole
   * `switch(i) { ... }` statement.
   */
  SwitchStmt getSwitchStmt() { result.getASwitchCase() = this }

  /**
   * Gets the 0-based index of this 'switch case' statement within its
   * 'switch' statement.
   *
   * For example, for
   * ```
   * switch(i) {
   * case 5:
   * case 6:
   * default:
   * }
   * ```
   * the `case 5:` has result 0, `case 6:` has result 1, and `default:`
   * has result 2.
   */
  int getChildNum() { switch_case(_, result, underlyingElement(this)) }

  /**
   * Gets the next `SwitchCase` belonging to the same 'switch'
   * statement, if any.
   *
   * For example, for
   * ```
   * switch (i) {
   * case 5:
   *     x = 1;
   *     break;
   * case 6:
   * case 7:
   *     { x = 2; break; }
   * default:
   *     { x = 3; }
   *     x = 4;
   *     break;
   * }
   * ```
   * the `case 5:` has result `case 6:`, which has result `case 7:`,
   * which has result `default:`, which has no result.
   */
  SwitchCase getNextSwitchCase() {
    result.getSwitchStmt() = this.getSwitchStmt() and
    result.getChildNum() = this.getChildNum() + 1
  }

  /**
   * Gets the previous `SwitchCase` belonging to the same 'switch'
   * statement, if any.
   *
   * For example, for
   * ```
   * switch (i) {
   * case 5:
   *     x = 1;
   *     break;
   * case 6:
   * case 7:
   *     { x = 2; break; }
   * default:
   *     { x = 3; }
   *     x = 4;
   *     break;
   * }
   * ```
   * the `default:` has result `case 7:`, which has result `case 6:`,
   * which has result `case 5:`, which has no result.
   */
  SwitchCase getPreviousSwitchCase() { result.getNextSwitchCase() = this }

  /**
   * Gets a statement belonging under this 'switch case' statement.
   *
   * For example, for
   * ```
   * switch (i) {
   * case 5:
   *     x = 1;
   *     break;
   * case 6:
   * case 7:
   *     { x = 2; break; }
   * default:
   *     { x = 3; }
   *     x = 4;
   *     break;
   * }
   * ```
   * the `case 5:` has results `x = 1;` and `break;`, `case 6:` has no
   * results, `case 7:` has a single result `{ x = 2; break; }`, and
   * `default:` has results `{ x = 3; }, `x = 4;` and `break;`.
   */
  Stmt getAStmt() {
    exists(BlockStmt b, int rnk, int i |
      b.getStmt(i) = this and
      i = indexOfSwitchCaseRank(b, rnk)
    |
      pragma[only_bind_into](b).getStmt([i + 1 .. indexOfSwitchCaseRank(b, rnk + 1) - 1]) = result
      or
      not exists(indexOfSwitchCaseRank(b, rnk + 1)) and
      b.getStmt([i + 1 .. b.getNumStmt() + 1]) = result
    )
  }

  /**
   * Gets the last statement under this 'switch case' statement. If the
   * last statement is wrapped in one or more blocks then the result is
   * the last statement in those blocks instead.
   *
   * For example, for
   * ```
   * switch (i) {
   * case 5:
   *     x = 1;
   *     break;
   * case 6:
   * case 7:
   *     { x = 2; break; }
   * default:
   *     { x = 3; { x = 4; break; } }
   * }
   * ```
   * the `case 5:` has result `break;`, the `case 6:` has no result,
   * the `case 7:` has results `break;`, and the `default:` has result
   * `break;`.
   */
  Stmt getLastStmt() {
    exists(Stmt lastStmt |
      lastStmt = this.getAStmt() and
      not lastStmt.getFollowingStmt() = this.getAStmt() and
      if lastStmt instanceof BlockStmt
      then result = lastStmt.(BlockStmt).getLastStmtIn()
      else result = lastStmt
    )
  }

  /**
   * Holds if the last statement, as determined by `getLastStmt`, under
   * this 'switch case' statement is a 'break' statement.
   *
   * For example, for
   * ```
   * switch (i) {
   * case 5:
   *     x = 1;
   *     break;
   * case 6:
   * case 7:
   *     { x = 2; break; }
   * default:
   *     { x = 3; { x = 4; break; } }
   * }
   * ```
   * this holds for `case 5:`, `case 7:` and `default:`, but not for `case 6:`.
   */
  predicate terminatesInBreakStmt() { this.getLastStmt() instanceof BreakStmt }

  /**
   * Holds if the last statement, as determined by `getLastStmt`, under
   * this 'switch case' statement is a 'return' statement.
   *
   * For example, for
   * ```
   * switch (i) {
   * case 5:
   *     x = 1;
   *     return;
   * case 6:
   * case 7:
   *     { x = 2; return; }
   * default:
   *     { x = 3; { x = 4; return; } }
   * }
   * ```
   * this holds for `case 5:`, `case 7:` and `default:`, but not for `case 6:`.
   */
  predicate terminatesInReturnStmt() { this.getLastStmt() instanceof ReturnStmt }

  /**
   * Holds if the last statement, as determined by `getLastStmt`, under
   * this 'switch case' statement is a 'throw' statement.
   *
   * For example, for
   * ```
   * switch (i) {
   * case 5:
   *     x = 1;
   *     throw 1;
   * case 6:
   * case 7:
   *     { x = 2; throw 2; }
   * default:
   *     { x = 3; { x = 4; throw 3; } }
   * }
   * ```
   * this holds for `case 5:`, `case 7:` and `default:`, but not for `case 6:`.
   */
  predicate terminatesInThrowStmt() {
    exists(ThrowExpr t | t.getEnclosingStmt() = this.getLastStmt())
  }

  /**
   * Holds if this 'switch case' statement is a 'default' statement.
   *
   * For example, for
   * ```
   * switch (i) {
   * case 5:
   * case 6:
   * case 7:
   * default:
   * }
   * ```
   * this holds for `default:`, but not for `case 5:`, `case 6:`,
   * or `case 7:`.
   */
  predicate isDefault() { this instanceof DefaultCase }

  override string toString() { result = "case ...:" }

  override predicate mayBeImpure() { this.getExpr().mayBeImpure() }

  override predicate mayBeGloballyImpure() { this.getExpr().mayBeGloballyImpure() }
}

/**
 * A C/C++ 'default case' statement.
 *
 * For example, the `default` statement in:
 * ```
 * switch (i)
 * {
 * case 5:
 *   ...
 * default:
 *   ...
 * }
 * ```
 */
class DefaultCase extends SwitchCase {
  DefaultCase() { not exists(this.getExpr()) }

  override string toString() { result = "default: " }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }
}

/**
 * A C/C++ 'switch' statement.
 *
 * For example, the `switch` statement in:
 * ```
 * switch (i)
 * {
 * case 5:
 *   ...
 * default:
 *   ...
 * }
 * ```
 */
class SwitchStmt extends ConditionalStmt, @stmt_switch {
  override string getAPrimaryQlClass() { result = "SwitchStmt" }

  /**
   * Gets the initialization statement of this 'switch' statement, if any.
   *
   * For example, for
   * ```
   * switch (int x = y; b) { }
   * ```
   * the result is `int x = y;`.
   *
   * Does not hold if the initialization statement is missing or an empty statement, as in
   * ```
   * switch (b) { }
   * ```
   * or
   * ```
   * switch (; b) { }
   * ```
   */
  Stmt getInitialization() {
    switch_initialization(underlyingElement(this), unresolveElement(result))
  }

  /**
   * Gets the expression that this 'switch' statement switches on.
   *
   * For example, for
   * ```
   * switch(i) {
   *     case 1:
   *     case 2:
   *     break;
   *     default:
   *     break;
   * }
   * ```
   * the result is `i`.
   */
  Expr getExpr() { result = this.getChild(1) }

  override Expr getControllingExpr() { result = this.getExpr() }

  /**
   * Gets the body statement of this 'switch' statement.
   *
   * In almost all cases the result will be a `BlockStmt`, but there are
   * other syntactically valid constructions.
   *
   * For example, for
   * ```
   * switch(i) {
   *     case 1:
   *     case 2:
   *     break;
   *     default:
   *     break;
   * }
   * ```
   * the result is
   * ```
   * {
   *     case 1:
   *     case 2:
   *     break;
   *     default:
   *     break;
   * }
   * ```
   */
  Stmt getStmt() { switch_body(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets a 'switch case' statement of this 'switch' statement.
   *
   * For example, for
   * ```
   * switch(i) {
   *     case 1:
   *     case 2:
   *     break;
   *     default:
   *     break;
   * }
   * ```
   * the results are `case 1:`, `case 2:` and `default:`.
   */
  SwitchCase getASwitchCase() { switch_case(underlyingElement(this), _, unresolveElement(result)) }

  /**
   * Gets the 'default case' statement of this 'switch' statement,
   * if any.
   *
   * For example, for
   * ```
   * switch(i) {
   *     case 1:
   *     case 2:
   *     break;
   *     default:
   *     break;
   * }
   * ```
   * the result is `default:`, but there is no result for
   * ```
   * switch(i) {
   *     case 1:
   *     case 2:
   *     break;
   * }
   * ```
   */
  DefaultCase getDefaultCase() { result = this.getASwitchCase() }

  /**
   * Holds if this 'switch' statement has a 'default case' statement.
   *
   * For example, this holds for
   * ```
   * switch(i) {
   *     case 1:
   *     case 2:
   *     break;
   *     default:
   *     break;
   * }
   * ```
   * but not for
   * ```
   * switch(i) {
   *     case 1:
   *     case 2:
   *     break;
   * }
   * ```
   */
  predicate hasDefaultCase() { exists(this.getDefaultCase()) }

  override string toString() { result = "switch (...) ... " }

  override predicate mayBeImpure() {
    this.getExpr().mayBeImpure() or
    this.getStmt().mayBeImpure()
  }

  override predicate mayBeGloballyImpure() {
    this.getExpr().mayBeGloballyImpure() or
    this.getStmt().mayBeGloballyImpure()
  }

  override MacroInvocation getGeneratingMacro() {
    result.getAnExpandedElement() = this.getExpr() and
    forall(SwitchCase c | c = this.getASwitchCase() | exists(c.getGeneratingMacro()))
  }
}

/**
 * A C/C++ 'switch' statement where the controlling expression has an
 * enum type.
 *
 * For example, given
 * ```
 * enum color { RED, GREEN, BLUE };
 * enum color c;
 * ```
 * the `switch` statement in:
 * ```
 * switch (c) {
 * case RED:
 *     return 1;
 * default:
 *     return 2;
 * }
 * ```
 */
class EnumSwitch extends SwitchStmt {
  EnumSwitch() { this.getExpr().getType().getUnderlyingType() instanceof Enum }

  /**
   * Gets a constant from the enum type that does not have a case in this
   * 'switch' statement.
   *
   * For example, with
   * ```
   * enum color { RED, GREEN, BLUE };
   * enum color c;
   * switch (c) {
   * case RED:
   *     return 1;
   * default:
   *     return 2;
   * }
   * ```
   * there are results `GREEN` and `BLUE`.
   */
  EnumConstant getAMissingCase() {
    exists(Enum et |
      et = this.getExpr().getUnderlyingType() and
      result = et.getAnEnumConstant() and
      not this.matchesValue(result.getInitializer().getExpr().getValue())
    )
  }

  pragma[noinline]
  private predicate matchesValue(string value) {
    value = this.getASwitchCase().getExpr().getValue()
  }
}

/**
 * A handler for a 'try' statement.
 *
 * This corresponds to a 'catch block' in the source. If the exception
 * is of a type that can be handled by this 'catch block', then
 * execution continues with the associated `CatchBlock`. Otherwise,
 * execution continues with the next `Handler`.
 *
 * This has no concrete representation in the source, but makes the
 * control flow graph easier to use.  For example in the following code:
 * ```
 * try
 * {
 *   f();
 * } catch (std::exception &e) {
 *   g();
 * }
 * ```
 * there is a handler that's associated with the `catch` block and controls
 * entry to it.
 */
class Handler extends Stmt, @stmt_handler {
  override string toString() { result = "<handler>" }

  override string getAPrimaryQlClass() { result = "Handler" }

  /**
   * Gets the block containing the implementation of this handler.
   */
  CatchBlock getBlock() { result = this.getChild(0) }

  /** Gets the 'try' statement corresponding to this 'catch block'. */
  TryStmt getTryStmt() { result = this.getParent() }

  /**
   * Gets the parameter introduced by this 'catch block', if any.
   *
   * For example, `catch(std::exception&amp; e)` introduces a
   * parameter `e`, whereas `catch(...)` does not introduce a parameter.
   */
  Parameter getParameter() { result = this.getBlock().getParameter() }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }
}

/**
 * A C/C++ 'try' statement.
 *
 * For example, the `try` statement in the following code:
 * ```
 * try {
 *   f();
 * } catch(std::exception &e) {
 *   g();
 * }
 * ```
 */
class TryStmt extends Stmt, @stmt_try_block {
  override string getAPrimaryQlClass() { result = "TryStmt" }

  override string toString() { result = "try { ... }" }

  /**
   * Gets the 'body' statement of this 'try' statement.
   *
   * For example, for
   * ```
   * try { f(); } catch (...) { g(); }
   * ```
   * the result is `{ f(); }`.
   */
  Stmt getStmt() { result = this.getChild(0) }

  /**
   * Gets the `n`th 'catch block' of this 'try' statement.
   *
   * For example, for
   * ```
   * try { f(); } catch (...) { g(); }
   * ```
   * the result of `getCatchClause(0)` is `{ g(); }`.
   */
  CatchBlock getCatchClause(int n) { result = this.getChild(n + 1).(Handler).getBlock() }

  /**
   * Gets a 'catch block' of this 'try' statement.
   *
   * For example, for
   * ```
   * try { f(); } catch (...) { g(); }
   * ```
   * the result is `{ g(); }`.
   */
  CatchBlock getACatchClause() { result = this.getCatchClause(_) }

  /**
   * Gets the number of 'catch block's of this 'try' statement.
   *
   * For example, for
   * ```
   * try { f(); } catch (...) { g(); }
   * ```
   * the result is 1.
   */
  int getNumberOfCatchClauses() { result = count(this.getACatchClause()) }

  override predicate mayBeImpure() {
    this.getStmt().mayBeImpure() or
    this.getACatchClause().mayBeImpure()
  }

  override predicate mayBeGloballyImpure() {
    this.getStmt().mayBeGloballyImpure() or
    this.getACatchClause().mayBeGloballyImpure()
  }
}

/**
 * A C++ 'function try' statement.
 *
 * This is a 'try' statement wrapped around an entire function body,
 * for example the `try` statement in the following code:
 * ```
 * void foo() try {
 *   f();
 * } catch(...) {
 *   g();
 * }
 * ```
 */
class FunctionTryStmt extends TryStmt {
  FunctionTryStmt() { not exists(this.getEnclosingBlock()) }

  override string getAPrimaryQlClass() { result = "FunctionTryStmt" }
}

/**
 * A 'catch block', for example the second and third blocks in the following
 * code:
 * ```
 * try {
 *   f();
 * } catch(std::exception &e) {
 *   g();
 * } catch(...) {
 *   h();
 * }
 * ```
 */
class CatchBlock extends BlockStmt {
  override string getAPrimaryQlClass() { result = "CatchBlock" }

  CatchBlock() { ishandler(underlyingElement(this)) }

  /**
   * Gets the parameter introduced by this 'catch block', if any.
   *
   * For example, `catch(std::exception&amp; e)` introduces a parameter
   * `e`, whereas `catch(...)` does not introduce a parameter.
   */
  Parameter getParameter() { result.getCatchBlock() = this }

  /** Gets the try statement corresponding to this 'catch block'. */
  TryStmt getTryStmt() { result.getACatchClause() = this }
}

/**
 * A C++ 'catch-any block', for example the third block in the following code:
 * ```
 * try {
 *   f();
 * } catch(std::exception &e) {
 *   g();
 * } catch(...) {
 *   h();
 * }
 * ```
 */
class CatchAnyBlock extends CatchBlock {
  CatchAnyBlock() { not exists(this.getParameter()) }

  override string getAPrimaryQlClass() { result = "CatchAnyBlock" }
}

/**
 * A structured exception handling 'try' statement, that is, a
 * `__try __except` or `__try __finally` statement. This is a Microsoft
 * C/C++ extension.
 */
class MicrosoftTryStmt extends Stmt, @stmt_microsoft_try {
  /** Gets the body statement of this __try statement. */
  Stmt getStmt() { result = this.getChild(0) }
}

/**
 * A structured exception handling 'try except' statement, for example the
 * `__try` statement in the following code:
 * ```
 * __try
 * {
 *   f();
 * } __except(myExceptionFilter()) {
 *   g()
 * }
 * ```
 * This is a Microsoft C/C++ extension.
 */
class MicrosoftTryExceptStmt extends MicrosoftTryStmt {
  MicrosoftTryExceptStmt() { this.getChild(1) instanceof Expr }

  override string toString() { result = "__try { ... } __except( ... ) { ... }" }

  /** Gets the expression guarding the `__except` statement. */
  Expr getCondition() { result = this.getChild(1) }

  /** Gets the `__except` statement (usually a `BlockStmt`). */
  Stmt getExcept() { result = this.getChild(2) }

  override string getAPrimaryQlClass() { result = "MicrosoftTryExceptStmt" }
}

/**
 * A structured exception handling 'try finally' statement, for example the
 * `__try` statement in the following code:
 * ```
 * __try
 * {
 *   f();
 * } __finally {
 *   g()
 * }
 * ```
 * This is a Microsoft C/C++ extension.
 */
class MicrosoftTryFinallyStmt extends MicrosoftTryStmt {
  MicrosoftTryFinallyStmt() { not this.getChild(1) instanceof Expr }

  override string toString() { result = "__try { ... } __finally { ... }" }

  /** Gets the `__finally` statement (usually a `BlockStmt`). */
  Stmt getFinally() { result = this.getChild(1) }

  override string getAPrimaryQlClass() { result = "MicrosoftTryFinallyStmt" }
}

/**
 * A C/C++ 'declaration' statement.
 *
 * For example, the following statement is a declaration statement:
 * ```
 * int i, j;
 * ```
 */
class DeclStmt extends Stmt, @stmt_decl {
  override string getAPrimaryQlClass() { result = "DeclStmt" }

  /**
   * Gets the `i`th declaration entry declared by this 'declaration' statement.
   *
   * For example, for
   * ```
   * int i, j;
   * ```
   * the result of `getDeclarationEntry(0)` is `i`.
   */
  DeclarationEntry getDeclarationEntry(int i) {
    stmt_decl_entry_bind(underlyingElement(this), i, unresolveElement(result))
  }

  /**
   * Gets a declaration entry declared by this 'declaration' statement.
   *
   * For example, for
   * ```
   * int i, j;
   * ```
   * the results are `i` and `j`.
   */
  DeclarationEntry getADeclarationEntry() { result = this.getDeclarationEntry(_) }

  /**
   * Gets the number of declarations declared by this 'declaration' statement.
   *
   * For example, for
   * ```
   * int i, j;
   * ```
   * the result of `getNumDeclarations()` is `2`.
   */
  int getNumDeclarations() { result = count(this.getADeclaration()) }

  /**
   * Gets the `i`th declaration declared by this 'declaration' statement.
   *
   * For example, for
   * ```
   * int i, j;
   * ```
   * the result of `getDeclaration(0)` is `i`.
   */
  Declaration getDeclaration(int i) {
    stmt_decl_bind(underlyingElement(this), i, unresolveElement(result))
  }

  /**
   * Gets a declaration declared by this 'declaration' statement.
   *
   * For example, for
   * ```
   * int i, j;
   * ```
   * the results are `i` and `j`.
   */
  Declaration getADeclaration() { result = this.getDeclaration(_) }

  override string toString() { result = "declaration" }

  override predicate mayBeImpure() {
    this.getADeclaration().(LocalVariable).getInitializer().getExpr().mayBeImpure()
  }

  override predicate mayBeGloballyImpure() {
    this.getADeclaration().(LocalVariable).getInitializer().getExpr().mayBeGloballyImpure()
  }
}

/**
 * A C/C++ 'empty' statement.
 *
 * For example, the following statement is an empty statement:
 * ```
 * ;
 * ```
 */
class EmptyStmt extends Stmt, @stmt_empty {
  override string getAPrimaryQlClass() { result = "EmptyStmt" }

  override string toString() { result = ";" }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }
}

/**
 * A C/C++ 'asm' statement.
 *
 * For example, the `__asm__` statement in the following code:
 * ```
 * __asm__("movb %bh (%eax)");
 * ```
 */
class AsmStmt extends Stmt, @stmt_asm {
  override string toString() { result = "asm statement" }

  override string getAPrimaryQlClass() { result = "AsmStmt" }
}

/**
 * A C99 statement which computes the size of a single dimension of a
 * variable length array. For example the variable length array dimension
 * (`x`) in the following code:
 * ```
 * int myArray[x];
 * ```
 *
 * Each `VlaDeclStmt` is preceded by one `VlaDimensionStmt` for each
 * variable length dimension of the array.
 */
class VlaDimensionStmt extends Stmt, @stmt_set_vla_size {
  override string toString() { result = "VLA dimension size" }

  override string getAPrimaryQlClass() { result = "VlaDimensionStmt" }

  /** Gets the expression which gives the size. */
  Expr getDimensionExpr() { result = this.getChild(0) }
}

/**
 * A C99 statement which declares a variable length array. For example
 * the variable length array declaration in the following code:
 * ```
 * int myArray[x];
 * ```
 *
 * Each `VlaDeclStmt` is preceded by one `VlaDimensionStmt` for each
 * variable length dimension of the array.
 */
class VlaDeclStmt extends Stmt, @stmt_vla_decl {
  override string toString() { result = "VLA declaration" }

  override string getAPrimaryQlClass() { result = "VlaDeclStmt" }

  /**
   * Gets the number of VLA dimension statements in this VLA
   * declaration statement.
   */
  int getNumberOfVlaDimensionStmts() {
    exists(BlockStmt b, int j |
      this = b.getStmt(j) and
      result =
        j - 1 -
          max(int i |
            i in [0 .. j - 1] and
            not b.getStmt(i) instanceof VlaDimensionStmt
          )
    )
  }

  /**
   * Gets the `i`th VLA dimension statement in this VLA
   * declaration statement.
   */
  VlaDimensionStmt getVlaDimensionStmt(int i) {
    i in [0 .. this.getNumberOfVlaDimensionStmts() - 1] and
    exists(BlockStmt b, int j |
      this = b.getStmt(j) and
      result = b.getStmt(j - this.getNumberOfVlaDimensionStmts() + i)
    )
  }

  /**
   * Gets the type that this VLA declaration statement relates to,
   * if any.
   */
  Type getType() { type_vla(unresolveElement(result), underlyingElement(this)) }

  /**
   * Gets the variable that this VLA declaration statement relates to,
   * if any.
   */
  Variable getVariable() { variable_vla(unresolveElement(result), underlyingElement(this)) }
}
