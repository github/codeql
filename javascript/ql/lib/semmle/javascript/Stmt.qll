/** Provides classes for working with statements. */

import javascript

/**
 * A statement.
 *
 * Examples:
 *
 * ```
 * x = 0;
 *
 * if (typeof console !== "undefined") {
 *   log = console.log;
 * } else {
 *   log = alert;
 * }
 * ```
 */
class Stmt extends @stmt, ExprOrStmt, Documentable {
  /** Holds if this statement has an implicitly inserted semicolon. */
  predicate hasSemicolonInserted() {
    this.isSubjectToSemicolonInsertion() and
    this.getLastToken().getValue() != ";"
  }

  /** Holds if automatic semicolon insertion applies to this statement. */
  predicate isSubjectToSemicolonInsertion() { none() }

  /**
   * Gets the kind of this statement, which is an integer
   * value representing the statement's node type.
   *
   * _Note_: The mapping from node types to integers is considered an implementation detail
   * and may change between versions of the extractor.
   */
  int getKind() { stmts(this, result, _, _, _) }

  override string toString() { stmts(this, _, _, _, result) }

  /**
   * Gets the statement that is the parent of this statement in the AST, if any.
   */
  Stmt getParentStmt() { this = result.getAChildStmt() }

  /**
   * Holds if this statement is lexically nested inside statement `outer`.
   */
  predicate nestedIn(Stmt outer) {
    outer = this.getParentStmt+() or
    this.getContainer().(Expr).getEnclosingStmt().nestedIn(outer)
  }

  /**
   * Gets the `try` statement with a catch block containing this statement without
   * crossing function boundaries or other `try ` statements with catch blocks.
   */
  TryStmt getEnclosingTryCatchStmt() {
    this.getParentStmt+() = result.getBody() and
    exists(result.getACatchClause()) and
    not exists(TryStmt mid | exists(mid.getACatchClause()) |
      this.getParentStmt+() = mid.getBody() and mid.getParentStmt+() = result.getBody()
    )
  }
}

private class TControlStmt =
  TLoopStmt or @if_stmt or @with_stmt or @switch_stmt or @try_stmt or @catch_clause;

private class TLoopStmt = TEnhancedForLoop or @while_stmt or @do_while_stmt or @for_stmt;

private class TEnhancedForLoop = @for_in_stmt or @for_each_stmt or @for_of_stmt;

/**
 * A control statement, that is, is a loop, an if statement, a switch statement,
 * a with statement, a try statement, or a catch clause.
 *
 * Examples:
 *
 * ```
 * if (typeof console !== "undefined") {
 *   log = console.log;
 * } else {
 *   log = alert;
 * }
 *
 * while(hasNext()) {
 *   handle(getNext());
 * }
 * ```
 */
class ControlStmt extends TControlStmt, Stmt {
  /** Gets a statement controlled by this control statement. */
  abstract Stmt getAControlledStmt();
}

/**
 * A loop, that is, a while loop, a do-while loop, a for loop, or a for-in loop.
 *
 * Examples:
 *
 * ```
 * while(hasNext()) {
 *   handle(getNext());
 * }
 *
 * do {
 *   handle(lines[i]);
 * } while(++i < lines.length);
 * ```
 */
class LoopStmt extends TLoopStmt, ControlStmt {
  /** Gets the body of this loop. */
  abstract Stmt getBody();

  /** Gets the loop test of this loop. */
  abstract Expr getTest();

  override Stmt getAControlledStmt() { result = this.getBody() }
}

/**
 * An empty statement.
 *
 * Example:
 *
 * ```
 * ;
 * ```
 */
class EmptyStmt extends @empty_stmt, Stmt {
  override string getAPrimaryQlClass() { result = "EmptyStmt" }
}

/**
 * A block of statements.
 *
 * Example:
 *
 * ```
 * {
 *   console.log(msg);
 * }
 * ```
 */
class BlockStmt extends @block_stmt, Stmt {
  /** Gets the `i`th statement in this block. */
  Stmt getStmt(int i) { result = this.getChildStmt(i) }

  /** Gets a statement in this block. */
  Stmt getAStmt() { result = this.getStmt(_) }

  /** Gets the number of statements in this block. */
  int getNumStmt() { result = count(this.getAStmt()) }

  /** Holds if this block is a function body. */
  predicate isFunctionBody() { this.getParent() instanceof Function }

  override string getAPrimaryQlClass() { result = "BlockStmt" }
}

/**
 * An expression statement.
 *
 * Examples:
 *
 * ```
 * x = 0;
 * console.log("Restart.");
 * ```
 */
class ExprStmt extends @expr_stmt, Stmt {
  /** Gets the expression of this expression statement. */
  Expr getExpr() { result = this.getChildExpr(0) }

  override predicate isSubjectToSemicolonInsertion() { not this.isDoubleColonMethod(_, _, _) }

  /**
   * Holds if this expression statement is a JScript-style double colon method declaration.
   */
  predicate isDoubleColonMethod(Identifier interface, Identifier id, Function f) {
    // the parser converts double colon method declarations into assignments, but we
    // can consult token-level information to identify them
    exists(Assignment assgn, DotExpr dot, Token tk |
      assgn = this.getExpr() and
      dot = assgn.getLhs() and
      interface = dot.getBase() and
      // check if the interface name is followed by two colons
      tk = interface.getLastToken().getNextToken() and
      (
        tk.getValue() = ":" and tk.getNextToken().getValue() = ":"
        or
        tk.getValue() = "::"
      ) and
      id = dot.getProperty() and
      f = assgn.getRhs()
    )
  }

  override string getAPrimaryQlClass() { result = "ExprStmt" }
}

/**
 * An expression statement wrapping a string literal (which may
 * be a directive).
 */
private class MaybeDirective extends ExprStmt {
  MaybeDirective() { this.getExpr() instanceof StringLiteral }

  /**
   * Gets the raw text of the string literal wrapped by this statement.
   *
   * The surrounding quotes are removed, but escape sequences are not
   * interpreted. For example, the text of the directive
   *
   * ```
   * 'use strict';
   * ```
   *
   * is `use strict`, while the text of the directive
   *
   * ```
   * "use\x20strict";
   * ```
   *
   * is `use\x20strict`. (Note in particular that the latter is not
   * a valid strict mode declaration, even though the value of the
   * string literal is the same as in the former case.)
   */
  string getDirectiveText() {
    exists(string text | text = this.getExpr().(StringLiteral).getRawValue() |
      result = text.substring(1, text.length() - 1)
    )
  }
}

/**
 * A directive: string literal expression statement in the beginning of a statement container.
 *
 * Examples:
 *
 * ```
 * function f() {
 *   "use strict";
 *   "a custom directive";
 * }
 * ```
 */
class Directive extends MaybeDirective {
  Directive() {
    exists(StmtContainer sc, AstNode body, int i |
      // directives must be toplevel statements in their container
      body = sc.getBody() and
      this = body.getChildStmt(i) and
      // and all preceding statements must be directives as well
      forall(Stmt pred | pred = body.getChildStmt([0 .. i - 1]) | pred instanceof MaybeDirective)
    )
  }
}

/**
 * A known directive, such as a strict mode declaration.
 *
 * Example:
 *
 * ```
 * "use strict";
 * ```
 */
abstract class KnownDirective extends Directive { }

/**
 * A strict mode declaration.
 *
 * Example:
 *
 * ```
 * "use strict";
 * ```
 */
class StrictModeDecl extends KnownDirective {
  StrictModeDecl() { this.getDirectiveText() = "use strict" }
}

/**
 * An asm.js directive.
 *
 * Example:
 *
 * ```
 * "use asm";
 * ```
 */
class ASMJSDirective extends KnownDirective {
  ASMJSDirective() { this.getDirectiveText() = "use asm" }
}

/**
 * A Babel directive.
 *
 * Example:
 *
 * ```
 * "use babel";
 * ```
 */
class BabelDirective extends KnownDirective {
  BabelDirective() { this.getDirectiveText() = "use babel" }
}

/**
 * A legacy 6to5 directive.
 *
 * Example:
 *
 * ```
 * "use 6to5";
 * ```
 */
class SixToFiveDirective extends KnownDirective {
  SixToFiveDirective() { this.getDirectiveText() = "use 6to5" }
}

/**
 * A SystemJS `format` directive.
 *
 * Example:
 *
 * ```
 * "format global";
 * ```
 */
class SystemJSFormatDirective extends KnownDirective {
  SystemJSFormatDirective() {
    this.getDirectiveText().regexpMatch("format (cjs|esm|global|register)")
  }
}

/**
 * A SystemJS `format register` directive.
 *
 * Example:
 *
 * ```
 * "format register";
 * ```
 */
class FormatRegisterDirective extends SystemJSFormatDirective {
  FormatRegisterDirective() { this.getDirectiveText() = "format register" }
}

/**
 * A `ngInject` or `ngNoInject` directive.
 *
 * Example:
 *
 * ```
 * "ngInject";
 * ```
 */
class NgInjectDirective extends KnownDirective {
  NgInjectDirective() { this.getDirectiveText().regexpMatch("ng(No)?Inject") }
}

/**
 * A YUI compressor directive.
 *
 * Example:
 *
 * ```
 * "console:nomunge";
 * ```
 */
class YuiDirective extends KnownDirective {
  YuiDirective() {
    this.getDirectiveText().regexpMatch("([a-z0-9_]+:nomunge, ?)*([a-z0-9_]+:nomunge)")
  }
}

/**
 * A SystemJS `deps` directive.
 *
 * Example:
 *
 * ```
 * "deps fs";
 * ```
 */
class SystemJSDepsDirective extends KnownDirective {
  SystemJSDepsDirective() { this.getDirectiveText().regexpMatch("deps [^ ]+") }
}

/**
 * A `bundle` directive.
 *
 * Example:
 *
 * ```
 * "bundle";
 * ```
 */
class BundleDirective extends KnownDirective {
  BundleDirective() { this.getDirectiveText() = "bundle" }
}

/**
 * An `if` statement.
 *
 * Example:
 *
 * ```
 * if (typeof console !== "undefined") {
 *   log = console.log;
 * } else {
 *   log = alert;
 * }
 * ```
 */
class IfStmt extends @if_stmt, ControlStmt {
  /** Gets the condition of this `if` statement. */
  Expr getCondition() { result = this.getChildExpr(0) }

  /** Gets the "then" branch of this `if` statement. */
  Stmt getThen() { result = this.getChildStmt(1) }

  /** Gets the "else" branch of this `if` statement, if any. */
  Stmt getElse() { result = this.getChildStmt(2) }

  /** Gets the `if` token of this `if` statement. */
  KeywordToken getIfToken() { result = this.getFirstToken() }

  /** Gets the `else` token of this `if` statement, if any. */
  KeywordToken getElseToken() {
    result = this.getThen().getLastToken().getNextToken() and
    result.getIndex() < this.getLastToken().getIndex()
  }

  override Stmt getAControlledStmt() {
    result = this.getThen() or
    result = this.getElse()
  }

  /** Holds if this `if` statement is an `else if` of an outer `if` statement. */
  predicate isElseIf() { exists(IfStmt outer | outer.getElse() = this) }

  override string getAPrimaryQlClass() { result = "IfStmt" }
}

/**
 * A labeled statement.
 *
 * Example:
 *
 * ```
 * outer:
 * for(i=0; i<10; ++i) {
 *   for(j=0; j<i; ++j) {
 *     if(h(i, j))
 *       break outer;
 *   }
 * }
 * ```
 */
class LabeledStmt extends @labeled_stmt, Stmt {
  /** Gets the label of this statement. */
  string getLabel() { result = this.getChildExpr(0).(Identifier).getName() }

  /** Gets the labeled statement of this statement. */
  Stmt getStmt() { result = this.getChildStmt(1) }

  override string getAPrimaryQlClass() { result = "LabeledStmt" }
}

private class TJumpStmt = TBreakOrContinueStmt or @return_stmt or @throw_stmt;

private class TBreakOrContinueStmt = @break_stmt or @continue_stmt;

/**
 * A statement that disrupts structured control flow, that is, a `continue` statement,
 * a `break` statement, a `throw` statement, or a `return` statement.
 *
 * Examples:
 *
 * ```
 * continue outer;
 * break;
 * throw new Exception();
 * return -1;
 * ```
 */
class JumpStmt extends TJumpStmt, Stmt {
  /**
   * Gets the target of this jump.
   *
   * For break and continue statements, this predicate returns the statement
   * this statement breaks out of or continues with. For throw statements,
   * it returns the closest surrounding try statement in whose body the
   * throw statement occurs, or otherwise the enclosing statement container.
   * For return statements, this predicate returns the enclosing statement
   * container.
   *
   * Note that this predicate does not take `finally` clauses
   * into account, which may interrupt the jump.
   */
  abstract AstNode getTarget();
}

/**
 * A break or continue statement.
 *
 * Examples:
 *
 * ```
 * continue outer;
 * break;
 * ```
 */
class BreakOrContinueStmt extends TBreakOrContinueStmt, JumpStmt {
  /** Gets the label this statement refers to, if any. */
  string getTargetLabel() { result = this.getChildExpr(0).(Identifier).getName() }

  /** Holds if this statement has an explicit target label. */
  predicate hasTargetLabel() { exists(this.getTargetLabel()) }

  /** Gets the statement this statement breaks out of or continues with. */
  override Stmt getTarget() { jump_targets(this, result) }

  override predicate isSubjectToSemicolonInsertion() { any() }
}

/**
 * A `break` statement.
 *
 * Examples:
 *
 * ```
 * break outer;
 * break;
 * ```
 */
class BreakStmt extends @break_stmt, BreakOrContinueStmt {
  override string getAPrimaryQlClass() { result = "BreakStmt" }
}

/**
 * A `continue` statement.
 *
 * Examples:
 *
 * ```
 * continue outer;
 * continue;
 * ```
 */
class ContinueStmt extends @continue_stmt, BreakOrContinueStmt {
  override string getAPrimaryQlClass() { result = "ContinueStmt" }
}

/**
 * A `with` statement.
 *
 * Example:
 *
 * ```
 * with(ctxt) {
 *   f(x, y);
 * }
 * ```
 */
class WithStmt extends @with_stmt, ControlStmt {
  /** Gets the controlling expression of this `with` statement. */
  Expr getExpr() { result = this.getChildExpr(0) }

  /** Gets the body of this `with` statement. */
  Stmt getBody() { result = this.getChildStmt(1) }

  /**
   * Holds if `acc` could refer to a property of the scope object
   * introduced by this `with` statement.
   */
  predicate mayAffect(VarAccess acc) {
    acc.getEnclosingStmt().nestedIn(this.getBody()) and
    exists(Variable v | v = acc.getVariable() |
      v instanceof GlobalVariable
      or
      exists(AstNode scopeElt | scopeElt = v.getScope().getScopeElement() |
        scopeElt = this.getParent+()
      )
    )
  }

  override Stmt getAControlledStmt() { result = this.getBody() }

  override string getAPrimaryQlClass() { result = "WithStmt" }
}

/**
 * A `switch` statement.
 *
 * Example:
 *
 * ```
 * switch(direction) {
 * case "forward":
 *   increment = 1;
 *   break;
 * case "backward":
 *   increment = -1;
 *   break;
 * default:
 *   throw new Error();
 * }
 * ```
 */
class SwitchStmt extends @switch_stmt, ControlStmt {
  /** Gets the controlling expression of this `switch` statement. */
  Expr getExpr() { result = this.getChildExpr(-1) }

  /** Gets the `i`th `case` clause of this `switch` statement. */
  Case getCase(int i) { result = this.getChildStmt(i) }

  /** Gets a `case` clause of this `switch` statement. */
  Case getACase() { result = this.getCase(_) }

  /** Gets the number of `case` clauses of this `switch` statement. */
  int getNumCase() { result = count(this.getACase()) }

  override Case getAControlledStmt() { result = this.getACase() }

  override string getAPrimaryQlClass() { result = "SwitchStmt" }
}

/**
 * A `return` statement.
 *
 * Examples:
 *
 * ```
 * return -1;
 * return;
 * ```
 */
class ReturnStmt extends @return_stmt, JumpStmt {
  /** Gets the expression specifying the returned value, if any. */
  Expr getExpr() { result = this.getChildExpr(0) }

  /** Gets the target of this `return` statement, which is the enclosing statement container. */
  override Function getTarget() { result = this.getContainer() }

  override ControlFlowNode getFirstControlFlowNode() {
    if exists(this.getExpr())
    then result = this.getExpr().getFirstControlFlowNode()
    else result = this
  }

  override predicate isSubjectToSemicolonInsertion() { any() }

  override string getAPrimaryQlClass() { result = "ReturnStmt" }
}

/**
 * A `throw` statement.
 *
 * Example:
 *
 * ```
 * throw new Error();
 * ```
 */
class ThrowStmt extends @throw_stmt, JumpStmt {
  /** Gets the expression specifying the value to throw. */
  Expr getExpr() { result = this.getChildExpr(0) }

  /**
   * Gets the target of this `throw` statement, which is the closest surrounding
   * `try` statement in whose body the throw statement occurs. If there is no such
   * `try` statement, the target defaults to the enclosing statement container.
   */
  override AstNode getTarget() {
    if exists(TryStmt ts | this.getParentStmt+() = ts.getBody())
    then
      this.getParentStmt+() = result.(TryStmt).getBody() and
      not exists(TryStmt mid |
        this.getParentStmt+() = mid.getBody() and mid.getParentStmt+() = result
      )
    else result = this.getContainer()
  }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getExpr().getFirstControlFlowNode()
  }

  override predicate isSubjectToSemicolonInsertion() { any() }

  override string getAPrimaryQlClass() { result = "ThrowStmt" }
}

/**
 * A `try` statement.
 *
 * Example:
 *
 * ```
 * try {
 *   var text = readFile(f);
 *   display(text);
 * } catch(e) {
 *   log(e);
 * }
 * ```
 */
class TryStmt extends @try_stmt, ControlStmt {
  /** Gets the body of this `try` statement. */
  BlockStmt getBody() { result = this.getChildStmt(0) }

  override Stmt getAControlledStmt() {
    result = this.getBody() or
    result = this.getACatchClause() or
    result = this.getFinally()
  }

  /** Gets the `i`th `catch` clause of this `try` statement, if any. */
  CatchClause getCatchClause(int i) {
    exists(int idx |
      result = this.getChildStmt(idx) and
      idx >= 1 and
      i = idx - 1
    )
  }

  /** Gets a `catch` clause of this `try` statement. */
  CatchClause getACatchClause() { result = this.getCatchClause(_) }

  /** Gets the (unique) unguarded `catch` clause of this `try` statement, if any. */
  CatchClause getCatchClause() {
    result = this.getACatchClause() and
    not exists(result.getGuard())
  }

  /** Gets the number of `catch` clauses of this `try` statement. */
  int getNumCatchClause() { result = count(this.getACatchClause()) }

  /** Gets the `finally` block of this `try` statement, if any. */
  BlockStmt getFinally() { result = this.getChildStmt(-1) }

  override string getAPrimaryQlClass() { result = "TryStmt" }
}

/**
 * A `while` loop.
 *
 * Example:
 *
 * ```
 * while(hasNext()) {
 *   handle(getNext());
 * }
 * ```
 */
class WhileStmt extends @while_stmt, LoopStmt {
  /** Gets the loop condition of this `while` loop. */
  Expr getExpr() { result = this.getChildExpr(0) }

  override Expr getTest() { result = this.getExpr() }

  override Stmt getBody() { result = this.getChildStmt(1) }

  override string getAPrimaryQlClass() { result = "WhileStmt" }
}

/**
 * A `do`-`while` loop.
 *
 * Example:
 *
 * ```
 * do {
 *   handle(lines[i]);
 * } while(++i < lines.length);
 * ```
 */
class DoWhileStmt extends @do_while_stmt, LoopStmt {
  /** Gets the loop condition of this `do`-`while` loop. */
  Expr getExpr() { result = this.getChildExpr(1) }

  override Expr getTest() { result = this.getExpr() }

  override Stmt getBody() { result = this.getChildStmt(0) }

  override predicate isSubjectToSemicolonInsertion() { any() }

  override string getAPrimaryQlClass() { result = "DoWhileStmt" }
}

/**
 * An expression or a variable declaration statement.
 *
 * Examples:
 *
 * ```
 * i = 0;
 * var i = 1;
 * ```
 */
class ExprOrVarDecl extends AstNode {
  ExprOrVarDecl() {
    this instanceof Expr or
    this instanceof DeclStmt
  }
}

/**
 * A `for` loop.
 *
 * Example:
 *
 * ```
 * for(var i=0; i<10; ++i) {
 *   sample(i);
 * }
 * ```
 */
class ForStmt extends @for_stmt, LoopStmt {
  /** Gets the init part of this `for` loop. */
  ExprOrVarDecl getInit() {
    result = this.getChildExpr(0) or
    result = this.getChildStmt(0)
  }

  override Expr getTest() { result = this.getChildExpr(1) }

  /** Gets the update part of this `for` loop. */
  Expr getUpdate() { result = this.getChildExpr(2) }

  override Stmt getBody() { result = this.getChildStmt(3) }

  override string getAPrimaryQlClass() { result = "ForStmt" }
}

/**
 * A `for`-`in`, `for`-`of` or `for each`-`in` loop.
 *
 * Examples:
 *
 * ```
 * for(var p in src) {
 *   dest[p] = src[p];
 * }
 *
 * for(var elt of arr) {
 *   sum += elt;
 * }
 * ```
 */
class EnhancedForLoop extends TEnhancedForLoop, LoopStmt {
  /**
   * Gets the iterator of this `for`-`in` or `for`-`of` loop; this can be either a
   * pattern, a property reference, or a variable declaration statement.
   */
  ExprOrVarDecl getIterator() {
    result = this.getChildExpr(0) or
    result = this.getChildStmt(0)
  }

  /**
   * Gets the default value of the loop's iterator, if any.
   */
  Expr getDefault() { result = this.getChildExpr(-1) }

  /**
   * Gets the iterator expression of this `for`-`in` or `for`-`of` loop; this can be
   * either a variable access or a variable declarator.
   */
  Expr getIteratorExpr() {
    result = this.getIterator() or
    result = this.getIterator().(DeclStmt).getADecl()
  }

  /**
   * Gets the property, variable, or destructuring pattern occurring as the iterator
   * expression in this `for`-`in` or `for`-`of` loop.
   */
  Expr getLValue() {
    result = this.getIterator() and
    (result instanceof BindingPattern or result instanceof PropAccess)
    or
    result = this.getIterator().(DeclStmt).getADecl().getBindingPattern()
  }

  /**
   * Gets an iterator variable of this `for`-`in` or `for`-`of` loop.
   */
  Variable getAnIterationVariable() {
    result = this.getIterator().(DeclStmt).getADecl().getBindingPattern().getAVariable() or
    result = this.getIterator().(BindingPattern).getAVariable()
  }

  override Expr getTest() { none() }

  /** Gets the expression this `for`-`in` or `for`-`of` loop iterates over. */
  Expr getIterationDomain() { result = this.getChildExpr(1) }

  override Stmt getBody() { result = this.getChildStmt(2) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getIteratorExpr().getFirstControlFlowNode()
  }
}

/**
 * A `for`-`in` loop.
 *
 * Example:
 *
 * ```
 * for(var p in src) {
 *   dest[p] = src[p];
 * }
 * ```
 */
class ForInStmt extends @for_in_stmt, EnhancedForLoop {
  override string getAPrimaryQlClass() { result = "ForInStmt" }
}

/**
 * A `for`-`of` loop.
 *
 * Example:
 *
 * ```
 * for(var elt of arr) {
 *   sum += elt;
 * }
 * ```
 */
class ForOfStmt extends @for_of_stmt, EnhancedForLoop {
  /**
   * Holds if this is a `for-await-of` statement.
   */
  predicate isAwait() { is_for_await_of(this) }

  override string getAPrimaryQlClass() { result = "ForOfStmt" }
}

/**
 * A `for each`-`in` loop.
 *
 * Example:
 *
 * ```
 * for each(var elt in arr) {
 *   sum += elt;
 * }
 * ```
 */
class ForEachStmt extends @for_each_stmt, EnhancedForLoop {
  override string getAPrimaryQlClass() { result = "ForEachStmt" }
}

/**
 * A `debugger` statement.
 *
 * Example:
 *
 * ```
 * debugger;
 * ```
 */
class DebuggerStmt extends @debugger_stmt, Stmt {
  override predicate isSubjectToSemicolonInsertion() { any() }

  override string getAPrimaryQlClass() { result = "DebuggerStmt" }
}

/**
 * A function declaration statement.
 *
 * Example:
 *
 * ```
 * function abs(x) {
 *   return abs < 0 ? -abs : abs;
 * }
 * ```
 */
class FunctionDeclStmt extends @function_decl_stmt, Stmt, Function {
  override Stmt getEnclosingStmt() { result = this }

  override string getAPrimaryQlClass() { result = "FunctionDeclStmt" }
}

/**
 * A declaration statement, that is, a `var`, `const` or `let` declaration
 * (including legacy 'let' statements).
 *
 * Examples:
 *
 * ```
 * const fs = require('fs');
 * var count = 0;
 * let i = 1, j = i-1;
 * ```
 */
class DeclStmt extends @decl_stmt, Stmt {
  /** Gets the `i`th declarator in this declaration statement. */
  VariableDeclarator getDecl(int i) { result = this.getChildExpr(i) and i >= 0 }

  /** Gets a declarator in this declaration statement. */
  VariableDeclarator getADecl() { result = this.getDecl(_) }

  override predicate isSubjectToSemicolonInsertion() {
    // exclude variable declarations in the init part of for/for-in/for-of loops
    not exists(LoopStmt for | this = for.getAChildStmt() and this != for.getBody())
  }

  override string getAPrimaryQlClass() { result = "DeclStmt" }
}

/**
 * A `var` declaration statement.
 *
 * Example:
 *
 * ```
 * var count = 0;
 * ```
 */
class VarDeclStmt extends @var_decl_stmt, DeclStmt { }

/**
 * A `const` declaration statement.
 *
 * Example:
 *
 * ```
 * const fs = require('fs');
 * ```
 */
class ConstDeclStmt extends @const_decl_stmt, DeclStmt { }

/**
 * A `let` declaration statement.
 *
 * Example:
 *
 * ```
 * let i = 1, j = i-1;
 * ```
 */
class LetStmt extends @let_stmt, DeclStmt { }

/**
 * A legacy `let` statement, that is, a statement of the form `let(vardecls) stmt`.
 *
 * Example:
 *
 * ```
 * let(i = 1) {
 *   console.log(i);
 * }
 * ```
 */
class LegacyLetStmt extends @legacy_let_stmt, DeclStmt {
  /** Gets the statement this let statement scopes over. */
  Stmt getBody() { result = this.getChildStmt(-1) }

  override predicate isSubjectToSemicolonInsertion() { none() }
}

/**
 * A `case` or `default` clause in a `switch` statement.
 *
 * Examples:
 *
 * ```
 * case 1:
 * default:
 * ```
 */
class Case extends @case, Stmt {
  /** Gets the test expression of this `case` clause. */
  Expr getExpr() { result = this.getChildExpr(-1) }

  /** Holds if this is a `default` clause. */
  predicate isDefault() { not exists(this.getExpr()) }

  /** Gets the `i`th statement in this `case` clause. */
  Stmt getBodyStmt(int i) { result = this.getChildStmt(i) }

  /** Gets a statement in this `case` clause. */
  Stmt getABodyStmt() { result = this.getChildStmt(_) }

  /** Gets the number of statements in this `case` clause. */
  int getNumBodyStmt() { result = count(this.getABodyStmt()) }

  /** Gets the `switch` statement to which this clause belongs. */
  SwitchStmt getSwitch() { result = this.getParent() }

  override string getAPrimaryQlClass() { result = "Case" }
}

/**
 * A `catch` clause.
 *
 * Example:
 *
 * ```
 * catch(e) {
 *   log(e);
 * }
 * ```
 */
class CatchClause extends @catch_clause, ControlStmt, Parameterized {
  /** Gets the body of this `catch` clause. */
  BlockStmt getBody() { result = this.getChildStmt(1) }

  /** Gets the guard expression of this `catch` clause, if any. */
  Expr getGuard() { result = this.getChildExpr(2) }

  override Stmt getAControlledStmt() { result = this.getBody() }

  /** Gets the scope induced by this `catch` clause. */
  CatchScope getScope() { result.getCatchClause() = this }

  override string getAPrimaryQlClass() { result = "CatchClause" }
}
