/**
 * Provides all statement classes.
 *
 * All statements have the common base class `Stmt`.
 */

import Element
import Location
import Member
import exprs.Expr
private import semmle.code.csharp.Enclosing::Internal
private import semmle.code.csharp.frameworks.System
private import TypeRef

/**
 * A statement.
 *
 * Either a block statement (`BlockStmt`), an expression statement (`ExprStmt`),
 * a selection statement (`SelectionStmt`), a labeled statement (`LabeledStmt`),
 * a loop statement (`LoopStmt`), a jump statement (`JumpStmt`), a `try` statement
 * (`TryStmt`), a `catch` clause (`CatchClause`), a `checked` statement
 * (`CheckedStmt`), an `unchecked` statement (`UncheckedStmt`), a `lock`
 * statement (`LockStmt`), a `using` statement (`UsingStmt`), a local
 * variable declaration statement (`LocalVariableDeclStmt`), an empty statement
 * (`EmptyStmt`), an `unsafe` statement (`UnsafeStmt`), or a `fixed` statement
 * (`FixedStmt`).
 */
class Stmt extends ControlFlowElement, @stmt {
  /** Gets the enclosing callable of this statement. */
  override Callable getEnclosingCallable() { enclosingCallable(this, result) }

  override string toString() { result = "Statement" }

  override Location getALocation() { stmt_location(this, result) }

  /**
   * Gets the singleton statement contained in this statement, by removing
   * enclosing block statements.
   *
   * For example converts `{ { return x; } }` to `return x;`.
   */
  Stmt stripSingletonBlocks() { result = this }
}

/**
 * A block statement, for example
 *
 * ```csharp
 * {
 *   ...
 * }
 * ```
 */
class BlockStmt extends Stmt, @block_stmt {
  /** Gets a statement in this block, if any. */
  Stmt getAStmt() { result.getParent() = this }

  /** Gets the `n`th statement in this block. */
  Stmt getStmt(int n) { result = this.getChild(n) }

  /** Gets the number of statements in this block. */
  int getNumberOfStmts() { result = count(this.getAStmt()) }

  /** Gets the first statement in this block, if any. */
  Stmt getFirstStmt() { result = getStmt(0) }

  /** Gets the last statement in this block, if any. */
  Stmt getLastStmt() { result = getStmt(getNumberOfStmts() - 1) }

  /** Holds if this block is an empty block with no statements. */
  predicate isEmpty() { not exists(this.getAStmt()) }

  override Stmt stripSingletonBlocks() {
    if getNumberOfStmts() = 1
    then result = getAChildStmt().stripSingletonBlocks()
    else result = this
  }

  override string toString() { result = "{...}" }

  override string getAPrimaryQlClass() { result = "BlockStmt" }
}

/**
 * An expression statement, for example `M1()` on line 5
 *
 * ```csharp
 * class C {
 *   int M1() { ... }
 *
 *   void M2() {
 *     M1();
 *   }
 * }
 * ```
 */
class ExprStmt extends Stmt, @expr_stmt {
  /** Gets the expression in this expression statement. */
  Expr getExpr() { result.getParent() = this }

  override string toString() { result = "...;" }

  override string getAPrimaryQlClass() { result = "ExprStmt" }
}

/**
 * A conditional statement.
 *
 * Either an `if` statement (`IfStmt`) or a `switch` statement (`SwitchStmt`).
 */
class SelectionStmt extends Stmt, @cond_stmt {
  /** Gets the condition of this selection statement. */
  Expr getCondition() { none() }
}

/**
 * An `if` statement, for example
 *
 * ```csharp
 * if (x==0) {
 *   ...
 * } else {
 *   ...
 * }
 * ```
 *
 * The `else` part is optional.
 */
class IfStmt extends SelectionStmt, @if_stmt {
  override Expr getCondition() { result = this.getChild(0) }

  /** Gets the `then` (true) branch of this `if` statement. */
  Stmt getThen() { result = this.getChild(1) }

  /** Gets the `else` (false) branch of this `if` statement, if any. */
  Stmt getElse() { result = this.getChild(2) }

  override string toString() { result = "if (...) ..." }

  override string getAPrimaryQlClass() { result = "IfStmt" }
}

/**
 * A `switch` statement, for example
 *
 * ```csharp
 * switch (instruction) {
 *   ...
 * }
 * ```
 */
class SwitchStmt extends SelectionStmt, Switch, @switch_stmt {
  override Expr getExpr() { result = this.getChild(0) }

  override Expr getCondition() { result = this.getExpr() }

  /**
   * Gets the `i`th `case` statement in the body of this `switch` statement.
   *
   * Example:
   *
   * ```csharp
   * switch (x) {
   *   case "abc":              // i = 0
   *     return 0;
   *   case int i when i > 0:   // i = 1
   *     return 1;
   *   case string s:           // i = 2
   *     Console.WriteLine(s);
   *     return 2;
   *   default:                 // i = 3
   *     return 3;
   * }
   * ```
   * Note that this reorders the `default` case to always be at the end.
   */
  override CaseStmt getCase(int i) { result = SwithStmtInternal::getCase(this, i) }

  /** Gets a case of this `switch` statement. */
  override CaseStmt getACase() { result = this.getCase(_) }

  /** Gets a constant value case of this `switch` statement, if any. */
  ConstCase getAConstCase() { result = this.getACase() }

  /** Gets the default case of this `switch` statement, if any. */
  DefaultCase getDefaultCase() { result = this.getACase() }

  override string toString() { result = "switch (...) {...}" }

  override string getAPrimaryQlClass() { result = "SwitchStmt" }

  /**
   * Gets the `i`th statement in the body of this `switch` statement.
   *
   * Example:
   *
   * ```csharp
   * switch (x) {
   *   case "abc":              // i = 0
   *     return 0;
   *   case int i when i > 0:   // i = 1
   *     return 1;
   *   case string s:           // i = 2
   *     Console.WriteLine(s);
   *     return 2;              // i = 3
   *   default:                 // i = 4
   *     return 3;              // i = 5
   * }
   * ```
   *
   * Note that each non-`default` case is a labeled statement, so the statement
   * that follows is a child of the labeled statement, and not the `switch` block.
   */
  Stmt getStmt(int i) { result = SwithStmtInternal::getStmt(this, i) }

  /** Gets a statement in the body of this `switch` statement. */
  Stmt getAStmt() { result = this.getStmt(_) }
}

cached
private module SwithStmtInternal {
  cached
  CaseStmt getCase(SwitchStmt ss, int i) {
    exists(int index, int rankIndex |
      caseIndex(ss, result, index) and
      rankIndex = i + 1 and
      index = rank[rankIndex](int j, CaseStmt cs | caseIndex(ss, cs, j) | j)
    )
  }

  /** Implicitly reorder case statements to put the default case last if needed. */
  private predicate caseIndex(SwitchStmt ss, CaseStmt case, int index) {
    exists(int i | case = ss.getChildStmt(i) |
      if case instanceof DefaultCase
      then index = max(int j | exists(ss.getChildStmt(j))) + 1
      else index = i
    )
  }

  cached
  Stmt getStmt(SwitchStmt ss, int i) {
    exists(int index, int rankIndex |
      result = ss.getChildStmt(index) and
      rankIndex = i + 1 and
      index =
        rank[rankIndex](int j, Stmt s |
          // `getChild` includes both labeled statements and the targeted
          // statements of labeled statement as separate children, but we
          // only want the labeled statement
          s = getLabeledStmt(ss, j)
        |
          j
        )
    )
  }

  private Stmt getLabeledStmt(SwitchStmt ss, int i) {
    result = ss.getChildStmt(i) and
    not result = any(CaseStmt cs).getBody()
  }
}

/** A `case` statement. */
class CaseStmt extends Case, @case_stmt {
  override Expr getExpr() { result = any(SwitchStmt ss | ss.getACase() = this).getExpr() }

  override PatternExpr getPattern() { result = this.getChild(0) }

  override Stmt getBody() {
    exists(int i |
      this = this.getParent().getChild(i) and
      result = this.getParent().getChild(i + 1)
    )
  }

  /**
   * Gets the condition on this case, if any. For example, the type case on line 3
   * has no condition, and the type case on line 4 has condition `s.Length > 0`, in
   *
   * ```csharp
   * switch(p)
   * {
   *     case int i:
   *     case string s when s.Length > 0:
   *         break;
   *     ...
   * }
   * ```
   */
  override Expr getCondition() { result = this.getChild(1) }

  /** Gets the `switch` statement that this `case` statement belongs to. */
  SwitchStmt getSwitchStmt() { result.getACase() = this }

  override string toString() { result = "case ...:" }

  override string getAPrimaryQlClass() { result = "CaseStmt" }
}

/**
 * A constant case of a `switch` statement, for example `case OpCode.Nop:`
 * on line 2 in
 *
 * ```csharp
 * switch (instruction) {
 *   case OpCode.Nop: ...
 *   default: ...
 * }
 * ```
 */
class ConstCase extends CaseStmt, LabeledStmt {
  private ConstantPatternExpr p;

  ConstCase() { p = this.getPattern() }

  override string getLabel() { result = p.getValue() }

  override string toString() { result = CaseStmt.super.toString() }

  override string getAPrimaryQlClass() { result = "ConstCase" }
}

/**
 * A default case of a `switch` statement, for example `default:` on
 * line 3 in
 *
 * ```csharp
 * switch (instruction) {
 *   case OpCode.Nop: ...
 *   default: ...
 * }
 * ```
 */
class DefaultCase extends CaseStmt, LabeledStmt {
  DefaultCase() { not exists(Expr e | e.getParent() = this) }

  override string getLabel() { result = "default" }

  override string toString() { result = "default:" }

  override string getAPrimaryQlClass() { result = "DefaultCase" }
}

/**
 * A loop statement.
 *
 * Either a `while` statement (`WhileStmt`), a `do`-`while` statement
 * (`DoStmt`), a `for` statement (`ForStmt`), or a `foreach` statement
 * (`ForeachStmt`).
 */
class LoopStmt extends Stmt, @loop_stmt {
  /** Gets the body of this loop statement. */
  Stmt getBody() { result.getParent() = this }

  /** Gets the condition of this loop statement, if any. */
  Expr getCondition() { none() }
}

/**
 * A `while` statement, for example
 *
 * ```csharp
 * while (remaining > 0) {
 *   ...
 * }
 * ```
 */
class WhileStmt extends LoopStmt, @while_stmt {
  override Expr getCondition() { result.getParent() = this }

  override string toString() { result = "while (...) ..." }

  override string getAPrimaryQlClass() { result = "WhileStmt" }
}

/**
 * A `do`-`while` statement, for example
 *
 * ```csharp
 * do {
 *   ...
 * }
 * while (remaining > 0);
 * ```
 */
class DoStmt extends LoopStmt, @do_stmt {
  override Expr getCondition() { result.getParent() = this }

  override string toString() { result = "do ... while (...);" }

  override string getAPrimaryQlClass() { result = "DoStmt" }
}

/**
 * A `for` loop, for example
 *
 * ```csharp
 * for (int i = 0; i < 10; i++) {
 *   ...
 * }
 * ```
 */
class ForStmt extends LoopStmt, @for_stmt {
  /**
   * Gets an initializer expression of this `for` loop, if any.
   *
   * For example, `i = 0` in
   *
   * ```csharp
   * for (int i = 0; i < 10; i++) {
   *   ...
   * }
   * ```
   */
  Expr getAnInitializer() { result = getInitializer(_) }

  /**
   * Gets the `n`th initializer expression of this `for` loop
   * (starting at index 0).
   *
   * For example, the second (`n = 1`) initializer is `j = 10` in
   *
   * ```csharp
   * for (int i = 0, j = 10; i < j; i++) {
   *   ...
   * }
   * ```
   */
  Expr getInitializer(int n) {
    exists(int i | result = this.getChild(i) and n = -1 - i and i <= -1)
  }

  override Expr getCondition() { result = this.getChild(0) }

  /**
   * Gets an update expression of this `for` loop, if any.
   *
   * For example, `i++` in
   *
   * ```csharp
   * for (int i = 0; i < 10; i++) {
   *   ...
   * }
   * ```
   */
  Expr getAnUpdate() { result = getUpdate(_) }

  /**
   * Gets the `n`th update expression of this `for` loop (starting at index 0).
   *
   * For example, the second (`n = 1`) update expression is `j--` in
   *
   * ```csharp
   * for (int i = 0, j = 10; i < j; i++, j--) {
   *   ...
   * }
   * ```
   */
  Expr getUpdate(int n) { exists(int i | result = this.getChild(i) and n = i - 1 and i >= 1) }

  override string toString() { result = "for (...;...;...) ..." }

  override string getAPrimaryQlClass() { result = "ForStmt" }
}

/**
 * A `foreach` loop, for example
 *
 * ```csharp
 * foreach (var item in items) {
 *   ...
 * }
 * ```
 */
class ForeachStmt extends LoopStmt, @foreach_stmt {
  /**
   * Gets the local variable of this `foreach` loop, if any.
   *
   * For example, `item` in
   *
   * ```csharp
   * foreach (var item in items) {
   *   ...
   * }
   * ```
   */
  LocalVariable getVariable() { result = this.getVariableDeclExpr().getVariable() }

  /**
   * Gets the local variable declaration of this `foreach` loop, if any.
   *
   * For example, `var item` in
   *
   * ```csharp
   * foreach (var item in items) {
   *   ...
   * }
   * ```
   */
  LocalVariableDeclExpr getVariableDeclExpr() { result = this.getChild(0) }

  /**
   * Gets the `i`th local variable declaration of this `foreach` loop.
   *
   * For example, `int a` is the 0th local variable declaration in
   *
   * ```csharp
   * foreach ((int a, int b) in items) {
   *   ...
   * }
   * ```
   */
  LocalVariableDeclExpr getVariableDeclExpr(int i) {
    result = getVariableDeclTuple().getArgument(i)
    or
    i = 0 and result = this.getChild(0)
  }

  /**
   * Gets the local variable declaration tuple of this `foreach` loop, if any.
   * For example, `(int a, int b)` in
   *
   * ```csharp
   * foreach ((int a, int b) in items) {
   *   ...
   * }
   * ```
   */
  TupleExpr getVariableDeclTuple() { result = this.getChild(0) }

  /**
   * Gets the `i`th local variable of this `foreach` loop.
   *
   * For example, `a` is the 0th local variable in
   *
   * ```csharp
   * foreach ((int a, int b) in items) {
   *   ...
   * }
   * ```
   */
  LocalVariable getVariable(int i) { result = getVariableDeclExpr(i).getVariable() }

  /**
   * Gets a local variable of this `foreach` loop.
   *
   * For example, `a` and `b` in
   *
   * ```csharp
   * foreach ((int a, int b) in items) {
   *   ...
   * }
   * ```
   */
  LocalVariable getAVariable() { result = getVariable(_) }

  /**
   * Gets a local variable declaration of this `foreach` loop.
   *
   * For example, `int a` and `int b` in
   *
   * ```csharp
   * foreach ((int a, int b) in items) {
   *   ...
   * }
   * ```
   */
  LocalVariableDeclExpr getAVariableDeclExpr() { result = getVariableDeclExpr(_) }

  override Expr getCondition() { none() }

  /**
   * Gets the expression that this `foreach` loop iterates over.
   *
   * For example, `items` in
   *
   * ```csharp
   * foreach (var item in items) {
   *   ...
   * }
   * ```
   */
  Expr getIterableExpr() { result = this.getChild(1) }

  override string toString() { result = "foreach (... ... in ...) ..." }

  override string getAPrimaryQlClass() { result = "ForeachStmt" }
}

/**
 * A statement that changes the control flow and jumps to another statement.
 *
 * Either a `break` statement (`BreakStmt`), a `continue` statement (`ContinueStmt`),
 * a `goto` statement (`GotoStmt`), a `throw` statement (`ThrowStmt`), a `return` statement
 * (`ReturnStmt`), or a `yield` statement (`YieldStmt`).
 */
class JumpStmt extends Stmt, @jump_stmt { }

/**
 * A `break` statement, for example line 4 in
 *
 * ```csharp
 * while (true) {
 *   ...
 *   if (done)
 *     break;
 * }
 * ```
 */
class BreakStmt extends JumpStmt, @break_stmt {
  override string toString() { result = "break;" }

  override string getAPrimaryQlClass() { result = "BreakStmt" }
}

/**
 * A `continue` statement, for example line 4 in
 *
 * ```csharp
 * while (true) {
 *   ...
 *   if (!done)
 *     continue;
 *   ...
 * }
 * ```
 */
class ContinueStmt extends JumpStmt, @continue_stmt {
  override string toString() { result = "continue;" }

  override string getAPrimaryQlClass() { result = "ContinueStmt" }
}

/**
 * A `goto` statement.
 *
 * Either a `goto` label (`GotoLabelStmt`), a `goto case` (`GotoCaseStmt`), or
 * a `goto default` (`GotoDefaultStmt`).
 */
class GotoStmt extends JumpStmt, @goto_any_stmt {
  /** Gets the label that this `goto` statement jumps to. */
  string getLabel() { none() }
}

/**
 * A `goto` statement that jumps to a labeled statement, for example line 4 in
 *
 * ```csharp
 * while (true) {
 *   ...
 *   if (done)
 *     goto exit;
 * }
 * exit: ...
 * ```
 */
class GotoLabelStmt extends GotoStmt, @goto_stmt {
  override string getLabel() { exprorstmt_name(this, result) }

  override string toString() { result = "goto ...;" }

  /** Gets the target statement that this `goto` statement jumps to. */
  LabeledStmt getTarget() {
    result.getEnclosingCallable() = getEnclosingCallable() and
    result.getLabel() = getLabel()
  }

  override string getAPrimaryQlClass() { result = "GotoLabelStmt" }
}

/**
 * A `goto case` statement that jumps to a `switch` case.
 *
 * For example, line 5 in
 *
 * ```csharp
 * switch (x) {
 *   case 0 :
 *     return 1;
 *   case 1 :
 *     goto case 0;
 *   default :
 *     return -1;
 * }
 * ```
 */
class GotoCaseStmt extends GotoStmt, @goto_case_stmt {
  /** Gets the constant expression that this `goto case` statement jumps to. */
  Expr getExpr() { result = this.getChild(0) }

  override string getLabel() { result = getExpr().getValue() }

  override string toString() { result = "goto case ...;" }

  override string getAPrimaryQlClass() { result = "GotoCaseStmt" }
}

/**
 * A `goto default` statement that jumps to the `default` case.
 *
 * For example, line 5 in
 *
 * ```csharp
 * switch (x) {
 *   case 0 :
 *     return 1;
 *   case 1 :
 *     goto default;
 *   default :
 *     return -1;
 * }
 * ```
 */
class GotoDefaultStmt extends GotoStmt, @goto_default_stmt {
  override string toString() { result = "goto default;" }

  override string getLabel() { result = "default" }

  override string getAPrimaryQlClass() { result = "GotoDefaultStmt" }
}

/**
 * A `throw` statement, for example line 3 in
 *
 * ```csharp
 * void M(string s) {
 *   if (s == null)
 *     throw new ArgumentNullException(nameof(s));
 * }
 * ```
 */
class ThrowStmt extends JumpStmt, ThrowElement, @throw_stmt {
  override string toString() { result = "throw ...;" }

  override ExceptionClass getThrownExceptionType() {
    result = ThrowElement.super.getThrownExceptionType()
    or
    result = getRethrowParent().(CatchClause).getCaughtExceptionType()
  }

  private ControlFlowElement getRethrowParent() {
    result = this and not exists(getExpr())
    or
    exists(ControlFlowElement mid |
      mid = getRethrowParent() and
      not mid instanceof CatchClause and
      result = mid.getParent()
    )
  }

  override string getAPrimaryQlClass() { result = "ThrowStmt" }
}

/**
 * A class that derives from `System.Exception`,
 * and may be thrown as an exception.
 */
class ExceptionClass extends Class {
  ExceptionClass() { getBaseClass*() instanceof SystemExceptionClass }
}

/**
 * A `return` statement, for example line 2 in
 *
 * ```csharp
 * int M() {
 *   return 0;
 * }
 * ```
 */
class ReturnStmt extends JumpStmt, @return_stmt {
  /** Gets the expression being returned, if any. */
  Expr getExpr() { result.getParent() = this }

  override string toString() { result = "return ...;" }

  override string getAPrimaryQlClass() { result = "ReturnStmt" }
}

/**
 * A `yield` statement.
 *
 * Either a `yield return` statement (`YieldReturnStmt`) or a
 * `yield break` statement (`YieldBreakStmt`).
 */
class YieldStmt extends JumpStmt, @yield_stmt {
  /** Gets the expression being yielded, if any. */
  Expr getExpr() { result.getParent() = this }
}

/**
 * A `yield break` statement, for example line 6 in
 *
 * ```csharp
 * IEnumerable<int> DownFrom(int i) {
 *   while (true) {
 *     if (i > 0)
 *       yield return i--;
 *     else
 *       yield break;
 *   }
 * }
 * ```
 */
class YieldBreakStmt extends YieldStmt {
  YieldBreakStmt() { not exists(this.getExpr()) }

  override string toString() { result = "yield break;" }

  override string getAPrimaryQlClass() { result = "YieldBreakStmt" }
}

/**
 * A `yield return` statement, for example line 4 in
 *
 * ```csharp
 * IEnumerable<int> DownFrom(int i) {
 *   while (true) {
 *     if (i > 0)
 *       yield return i--;
 *     else
 *       yield break;
 *   }
 * }
 * ```
 */
class YieldReturnStmt extends YieldStmt {
  YieldReturnStmt() { exists(this.getExpr()) }

  override string toString() { result = "yield return ...;" }

  override string getAPrimaryQlClass() { result = "YieldReturnStmt" }
}

/**
 * A `try` statement, for example
 *
 * ```csharp
 * try {
 *   ...
 * }
 * catch (Exception e) {
 *   ...
 * }
 * finally {
 *   ...
 * }
 * ```
 */
class TryStmt extends Stmt, @try_stmt {
  /** Gets the block of this `try` statement. */
  BlockStmt getBlock() { result = this.getChild(0) }

  /** Gets a `catch` clause of this `try` statement, if any. */
  CatchClause getACatchClause() { result = this.getAChild() }

  /** Gets the `n`th catch clause of this `try` statement. */
  CatchClause getCatchClause(int n) { exists(int i | result = this.getChild(i) and n = i - 1) }

  /** Gets the `finally` block of this `try` statement, if any. */
  BlockStmt getFinally() { result = this.getChild(-1) }

  /** Holds if this `try` statement has a `finally` block. */
  predicate hasFinally() { exists(this.getFinally()) }

  override string toString() { result = "try {...} ..." }

  override string getAPrimaryQlClass() { result = "TryStmt" }

  /** Gets the `catch` clause that handles an exception of type `ex`, if any. */
  CatchClause getAnExceptionHandler(ExceptionClass ex) { result = clauseHandlesException(ex, 0) }

  /**
   * Holds if catch clause `cc` definitely handles exceptions of type `ex`.
   */
  predicate definitelyHandles(ExceptionClass ex, CatchClause cc) {
    cc = getACatchClause() and
    not exists(cc.getFilterClause()) and
    (
      cc.getCaughtExceptionType() = ex.getBaseClass*()
      or
      cc instanceof GeneralCatchClause
    )
  }

  private predicate maybeHandles(ExceptionClass ex, CatchClause cc) {
    cc = getACatchClause() and
    cc.getCaughtExceptionType().getBaseClass*() = ex
  }

  private CatchClause clauseHandlesException(ExceptionClass ex, int n) {
    exists(CatchClause clause | clause = getCatchClause(n) |
      if definitelyHandles(ex, clause)
      then result = clause
      else
        if maybeHandles(ex, clause)
        then
          result = clause or
          result = clauseHandlesException(ex, n + 1)
        else
          // Does not handle
          result = clauseHandlesException(ex, n + 1)
    )
  }

  /**
   * Gets a control flow element that is tried by this `try` statement.
   *
   * That is, a child element that is not tried by another nested
   * `try` statement.
   */
  ControlFlowElement getATriedElement() {
    result = getBlock()
    or
    exists(ControlFlowElement mid |
      mid = getATriedElement() and
      not mid instanceof TryStmt and
      result = getAChild(mid, mid.getEnclosingCallable())
    )
  }
}

pragma[noinline]
private ControlFlowElement getAChild(ControlFlowElement cfe, Callable c) {
  result = cfe.getAChild() and
  c = result.getEnclosingCallable()
}

/**
 * A `catch` clause within a `try` statement.
 *
 * Either a specific `catch` clause (`SpecificCatchClause`) or a
 * general `catch` clause (`GeneralCatchClause`).
 */
class CatchClause extends Stmt, @catch {
  /** Gets the `try` statement that this `catch` clause belongs to. */
  TryStmt getTryStmt() { result.getACatchClause() = this }

  /** Gets the block of this `catch` clause. */
  BlockStmt getBlock() { result.getParent() = this }

  /**
   * Gets the type of the exception caught. For example, the type of the exception
   * caught on line 4 is `System.IO.IOException` in
   *
   * ```csharp
   * try {
   *   ...
   * }
   * catch (System.IO.IOException ex) {
   *   ...
   * }
   * ```
   */
  ExceptionClass getCaughtExceptionType() { catch_type(this, getTypeRef(result), _) }

  /**
   * Gets the `catch` filter clause, if any. For example, the filter expression
   * of the catch clause on line 4 is `ex.HResult == 1` in
   *
   * ```csharp
   * try {
   *   ...
   * }
   * catch (System.IO.IOException ex) when (ex.HResult == 1) {
   *   ...
   * }
   * ```
   */
  Expr getFilterClause() { result = getChild(2) }

  /** Holds if this `catch` clause has a filter. */
  predicate hasFilterClause() { exists(getFilterClause()) }

  /** Holds if this is the last `catch` clause in the `try` statement that it belongs to. */
  predicate isLast() {
    exists(TryStmt ts, int last |
      ts = this.getTryStmt() and
      last = max(int i | exists(ts.getCatchClause(i))) and
      this = ts.getCatchClause(last)
    )
  }
}

/**
 * A `catch` clause that catches a specific exception.
 *
 * For example, the `catch` clause on line 4 in
 *
 * ```csharp
 * try {
 *   ...
 * }
 * catch (System.IO.IOException ex) {
 *   ...
 * }
 * ```
 *
 * The exception variable (`ex`) is optional.
 */
class SpecificCatchClause extends CatchClause {
  SpecificCatchClause() { catch_type(this, _, 1) }

  /** Gets the local variable of this catch clause, if any. */
  LocalVariable getVariable() { result = this.getVariableDeclExpr().getVariable() }

  /** Gets the local variable declaration of this catch clause, if any. */
  LocalVariableDeclExpr getVariableDeclExpr() { result.getParent() = this }

  override string toString() { result = "catch (...) {...}" }

  override string getAPrimaryQlClass() { result = "SpecificCatchClause" }
}

/**
 * A general `catch` clause that does not specify the exception being caught.
 *
 * For example, the `catch` clause on line 4 in
 *
 * ```csharp
 * try {
 *   ...
 * }
 * catch {
 *   ...
 * }
 * ```
 */
class GeneralCatchClause extends CatchClause {
  GeneralCatchClause() { catch_type(this, _, 2) }

  override string toString() { result = "catch {...}" }

  override string getAPrimaryQlClass() { result = "GeneralCatchClause" }
}

/**
 * A `checked` statement, for example
 *
 * ```csharp
 * checked {
 *   int i = 2147483647;
 *   i++;
 * }
 * ```
 */
class CheckedStmt extends Stmt, @checked_stmt {
  /** Gets the block of this `checked` statement. */
  BlockStmt getBlock() { result.getParent() = this }

  override string toString() { result = "checked {...}" }

  override string getAPrimaryQlClass() { result = "CheckedStmt" }
}

/**
 * An `unchecked` statement, for example
 *
 * ```csharp
 * unchecked {
 *   int i = 2147483647;
 *   i++;
 * }
 * ```
 */
class UncheckedStmt extends Stmt, @unchecked_stmt {
  /** Gets the block of this unchecked statement. */
  BlockStmt getBlock() { result.getParent() = this }

  override string toString() { result = "unchecked {...}" }

  override string getAPrimaryQlClass() { result = "UncheckedStmt" }
}

/**
 * A `lock` statement, for example
 *
 * ```csharp
 * lock (mutex) {
 *   ...
 * }
 * ```
 */
class LockStmt extends Stmt, @lock_stmt {
  /** Gets the expression being locked. */
  Expr getExpr() { result.getParent() = this }

  /** Gets the body of this `lock` statement. */
  Stmt getBlock() { result.getParent() = this }

  override string toString() { result = "lock (...) {...}" }

  /** Gets the variable being locked, if any. */
  Variable getLockVariable() { result.getAnAccess() = getExpr() }

  /** Gets a statement in the scope of this `lock` statement. */
  Stmt getALockedStmt() {
    // Do this instead of getParent+, because we don't want to escape
    // delegates and lambdas
    result.getParent() = this
    or
    exists(Stmt mid | mid = getALockedStmt() and result.getParent() = mid)
  }

  /** Holds if this statement is of the form `lock(this) { ... }`. */
  predicate isLockThis() { getExpr() instanceof ThisAccess }

  /** Gets the type `T` if this statement is of the form `lock(typeof(T)) { ... }`. */
  Type getLockTypeObject() { result = getExpr().(TypeofExpr).getTypeAccess().getTarget() }

  override string getAPrimaryQlClass() { result = "LockStmt" }
}

/**
 * A using block or declaration. Either a using declaration (`UsingDeclStmt`) or
 * a using block (`UsingBlockStmt`).
 */
class UsingStmt extends Stmt, @using_stmt {
  /** Gets the `i`th local variable declaration of this `using` statement. */
  LocalVariableDeclExpr getVariableDeclExpr(int i) { none() }

  /** Gets a local variable declaration of this `using` statement. */
  LocalVariableDeclExpr getAVariableDeclExpr() { result = this.getVariableDeclExpr(_) }

  /**
   * Gets an expression that is used in this `using` statement. Either an
   * expression assigned to a variable, for example `File.Open("settings.xml")`
   * in
   *
   * ```csharp
   * using (FileStream f = File.Open("settings.xml")) {
   *   ...
   * }
   * ```
   *
   * or an expression directly used, for example `File.Open("settings.xml")`
   * in
   *
   * ```csharp
   * using (File.Open("settings.xml")) {
   *   ...
   * }
   * ```
   */
  Expr getAnExpr() { none() }
}

/**
 * A `using` block statement, for example
 *
 * ```csharp
 * using (FileStream f = File.Open("settings.xml")) {
 *   ...
 * }
 * ```
 */
class UsingBlockStmt extends UsingStmt, @using_block_stmt {
  /** Gets the `i`th local variable of this `using` statement. */
  LocalVariable getVariable(int i) { result = this.getVariableDeclExpr(i).getVariable() }

  /** Gets a local variable of this `using` statement. */
  LocalVariable getAVariable() { result = this.getVariable(_) }

  /** Gets the `i`th local variable declaration of this `using` statement. */
  override LocalVariableDeclExpr getVariableDeclExpr(int i) { result = this.getChild(-i - 1) }

  /**
   * Gets the expression directly used by this `using` statement, if any. For
   * example, `f` on line 2 in
   *
   * ```csharp
   * var f = File.Open("settings.xml");
   * using (f) {
   *   ...
   * }
   * ```
   */
  Expr getExpr() { result = this.getChild(0) }

  override Expr getAnExpr() {
    result = this.getAVariableDeclExpr().getInitializer()
    or
    result = this.getExpr()
  }

  /** Gets the body of this `using` statement. */
  Stmt getBody() { result.getParent() = this }

  override string toString() { result = "using (...) {...}" }

  override string getAPrimaryQlClass() { result = "UsingBlockStmt" }
}

/**
 * A local declaration statement, for example line 2 in
 *
 * ```csharp
 * void M() {
 *   string x = null, y = "";
 * }
 * ```
 */
class LocalVariableDeclStmt extends Stmt, @decl_stmt {
  /**
   * Gets a local variable declaration, for example `x = null` and
   * `y = ""` in
   *
   * ```csharp
   * void M() {
   *   string x = null, y = "";
   * }
   * ```
   */
  LocalVariableDeclExpr getAVariableDeclExpr() { result.getParent() = this }

  /**
   * Gets the `n`th local variable declaration. For example, the second
   * (`n = 1`) declaration is `y = ""` in
   *
   * ```csharp
   * void M() {
   *   string x = null, y = "";
   * }
   * ```
   */
  LocalVariableDeclExpr getVariableDeclExpr(int n) { result = this.getChild(n) }

  override string toString() { result = "... ...;" }

  override string getAPrimaryQlClass() { result = "LocalVariableDeclStmt" }
}

/**
 * A local constant declaration statement, for example line 2 in
 *
 * ```csharp
 * void M() {
 *   const int x = 1, y = 2;
 * }
 * ```
 */
class LocalConstantDeclStmt extends LocalVariableDeclStmt, @const_decl_stmt {
  /**
   * Gets a local constant declaration, for example `x = 1` and `y = 2` in
   *
   * ```csharp
   * void M() {
   *   const int x = 1, y = 2;
   * }
   * ```
   */
  override LocalConstantDeclExpr getAVariableDeclExpr() { result.getParent() = this }

  /**
   * Gets the `n`th local constant declaration. For example, the second
   * (`n = 1`) declaration is `y = 2` in
   *
   * ```csharp
   * void M() {
   *   const int x = 1, y = 2;
   * }
   * ```
   */
  override LocalConstantDeclExpr getVariableDeclExpr(int n) { result = this.getChild(n) }

  override string toString() { result = "const ... ...;" }

  override string getAPrimaryQlClass() { result = "LocalConstantDeclStmt" }
}

/**
 * A `using` declaration statement, for example
 *
 * ```csharp
 * using FileStream f = File.Open("settings.xml");
 * ```
 */
class UsingDeclStmt extends LocalVariableDeclStmt, UsingStmt, @using_decl_stmt {
  override string toString() { result = "using ... ...;" }

  override LocalVariableDeclExpr getAVariableDeclExpr() {
    result = LocalVariableDeclStmt.super.getAVariableDeclExpr()
  }

  override LocalVariableDeclExpr getVariableDeclExpr(int n) {
    result = LocalVariableDeclStmt.super.getVariableDeclExpr(n)
  }

  override Expr getAnExpr() { result = this.getAVariableDeclExpr().getInitializer() }

  override string getAPrimaryQlClass() { result = "UsingDeclStmt" }
}

/**
 * An empty statement, for example line 2 in
 *
 * ```csharp
 * while (true) do {
 *   ;
 * }
 * ```
 */
class EmptyStmt extends Stmt, @empty_stmt {
  override string toString() { result = ";" }

  override string getAPrimaryQlClass() { result = "EmptyStmt" }
}

/**
 * An `unsafe` statement, for example
 *
 * ```csharp
 * unsafe {
 *   var data = new int[10];
 *   fixed (int* p = data) {
 *     ...
 *   }
 * }
 * ```
 */
class UnsafeStmt extends Stmt, @unsafe_stmt {
  /** Gets the block of this unsafe statement. */
  BlockStmt getBlock() { result.getParent() = this }

  override string toString() { result = "unsafe {...}" }

  override string getAPrimaryQlClass() { result = "UnsafeStmt" }
}

/**
 * A `fixed` statement, for example lines 3--5 in
 *
 * ```csharp
 * unsafe {
 *   var data = new int[10];
 *   fixed (int* p = data) {
 *     ...
 *   }
 * }
 * ```
 */
class FixedStmt extends Stmt, @fixed_stmt {
  /** Gets the `i`th local variable of this `fixed` statement. */
  LocalVariable getVariable(int i) { result = this.getVariableDeclExpr(i).getVariable() }

  /** Gets a local variable of this `fixed` statement. */
  LocalVariable getAVariable() { result = this.getVariable(_) }

  /** Gets the `i`th local variable declaration of this `fixed` statement. */
  LocalVariableDeclExpr getVariableDeclExpr(int i) { result = this.getChild(-i - 1) }

  /** Gets a local variable declaration of this `fixed` statement. */
  LocalVariableDeclExpr getAVariableDeclExpr() { result = this.getVariableDeclExpr(_) }

  /** Gets the body of this `fixed` statement. */
  Stmt getBody() { result.getParent() = this }

  override string toString() { result = "fixed(...) { ... }" }

  override string getAPrimaryQlClass() { result = "FixedStmt" }
}

/**
 * A label statement, for example line 7 in
 *
 * ```csharp
 * while (true) {
 *   if (done)
 *     goto exit;
 *   ...
 * }
 *
 * exit: ...
 * ```
 */
class LabelStmt extends LabeledStmt, @label_stmt {
  override string getAPrimaryQlClass() { result = "LabelStmt" }
}

/**
 * A labeled statement.
 *
 * Either a `case` statement (`ConstCase`) or a label statement (`LabelStmt`).
 */
class LabeledStmt extends Stmt, @labeled_stmt {
  /**
   * Gets the next statement after this labeled statement.
   *
   * For example, the `return` statement in
   *
   * ```csharp
   * exit:
   *   return MetadataToken.Zero;
   * ```
   */
  Stmt getStmt() {
    exists(int i |
      this = this.getParent().getChild(i) and
      result = this.getParent().getChild(i + 1)
    )
  }

  /** Gets the label of this statement. */
  string getLabel() { exprorstmt_name(this, result) }

  override string toString() { result = this.getLabel() + ":" }
}

/**
 * A statement defining a local function. For example,
 * the statement on lines 2--4 in
 *
 * ```csharp
 * int Choose(int n, int m) {
 *   int Fac(int x) {
 *     return x > 1 ? x * Fac(x - 1) : 1;
 *   }
 *
 *   return Fac(n) / (Fac(m) * Fac(n - m));
 * }
 * ```
 */
class LocalFunctionStmt extends Stmt, @local_function_stmt {
  /** Gets the local function defined by this statement. */
  LocalFunction getLocalFunction() { local_function_stmts(this, result) }

  override string toString() { result = getLocalFunction().getName() + "(...)" }

  override string getAPrimaryQlClass() { result = "LocalFunctionStmt" }
}
