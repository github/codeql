/** Provides classes for working with statements. */

import javascript

/** A statement. */
class Stmt extends @stmt, ExprOrStmt, Documentable {
  /** Gets the statement container (toplevel, function or namespace) to which this statement belongs. */
  override StmtContainer getContainer() {
    stmtContainers(this, result)
  }

  /** Holds if this statement has an implicitly inserted semicolon. */
  predicate hasSemicolonInserted() {
    isSubjectToSemicolonInsertion() and
    getLastToken().getValue() != ";"
  }

  /** Holds if automatic semicolon insertion applies to this statement. */
  predicate isSubjectToSemicolonInsertion() {
    none()
  }

  /**
   * Gets the kind of this statement, which is an integer
   * value representing the statement's node type.
   *
   * _Note_: The mapping from node types to integers is considered an implementation detail
   * and may change between versions of the extractor.
   */
  int getKind() {
    stmts(this, result, _, _, _)
  }

  override string toString() {
    stmts(this, _, _, _, result)
  }

  /**
   * Gets the statement that is the parent of this statement in the AST, if any.
   */
  Stmt getParentStmt() {
    this = result.getAChildStmt()
  }

  /**
   * Holds if this statement is lexically nested inside statement `outer`.
   */
  predicate nestedIn(Stmt outer) {
    outer = getParentStmt+() or
    getContainer().(Expr).getEnclosingStmt().nestedIn(outer)
  }

  override predicate isAmbient() {
    hasDeclareKeyword(this) or getParent().isAmbient()
  }
}

/**
 * A control statement, that is, is a loop, an if statement, a switch statement,
 * a with statement, a try statement, or a catch clause.
 */
abstract class ControlStmt extends Stmt {
  /** Gets a statement controlled by this control statement. */
  abstract Stmt getAControlledStmt();
}

/** A loop, that is, is a while loop, a do-while loop, a for loop, or a for-in loop. */
abstract class LoopStmt extends ControlStmt {
  /** Gets the body of this loop. */
  abstract Stmt getBody();

  /** Gets the loop test of this loop. */
  abstract Expr getTest();

  override Stmt getAControlledStmt() {
    result = getBody()
  }
}

/** An empty statement. */
class EmptyStmt extends @emptystmt, Stmt {}

/** A block of statements. */
class BlockStmt extends @blockstmt, Stmt {
  /** Gets the `i`th statement in this block. */
  Stmt getStmt(int i) {
    result = getChildStmt(i)
  }

  /** Gets a statement in this block. */
  Stmt getAStmt() {
    result = getStmt(_)
  }

  /** Gets the number of statements in this block. */
  int getNumStmt() {
    result = count(getAStmt())
  }

  /** Holds if this block is a function body. */
  predicate isFunctionBody() {
    this.getParent() instanceof Function
  }
}

/** An expression statement. */
class ExprStmt extends @exprstmt, Stmt {
  /** Gets the expression of this expression statement. */
  Expr getExpr() {
    result = getChildExpr(0)
  }

  override predicate isSubjectToSemicolonInsertion() {
    not isDoubleColonMethod(_, _, _)
  }

  /**
   * Holds if this expression statement is a JScript-style double colon method declaration.
   */
  predicate isDoubleColonMethod(Identifier interface, Identifier id, Function f) {
    // the parser converts double colon method declarations into assignments, but we
    // can consult token-level information to identify them
    exists (Assignment assgn, DotExpr dot, Token tk |
      assgn = getExpr() and
      dot = assgn.getLhs() and
      interface = dot.getBase() and
      // check if the interface name is followed by two colons
      tk = interface.getLastToken().getNextToken() and
      (tk.getValue() = ":" and  tk.getNextToken().getValue() = ":" or
       tk.getValue() = "::") and
      id = dot.getProperty() and
      f = assgn.getRhs()
    )
  }
}

/**
 * An expression statement wrapping a string literal (which may
 * be a directive).
 */
private class MaybeDirective extends ExprStmt {
  MaybeDirective() {
    getExpr() instanceof StringLiteral
  }

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
    exists (string text | text = getExpr().(StringLiteral).getRawValue() |
      result = text.substring(1, text.length()-1)
    )
  }
}

/** A directive: string literal expression statement in the beginning of a statement container. */
class Directive extends MaybeDirective {
  Directive() {
    exists (StmtContainer sc, ASTNode body, int i |
      // directives must be toplevel statements in their container
      body = sc.getBody() and this = body.getChildStmt(i) and
      // and all preceding statements must be directives as well
      forall (Stmt pred | pred = body.getChildStmt([0..i-1]) | pred instanceof MaybeDirective)
    )
  }
}

/** A known directive, such as a strict mode declaration. */
abstract class KnownDirective extends Directive {

}

/** A strict mode declaration. */
class StrictModeDecl extends KnownDirective {
  StrictModeDecl() { getDirectiveText() = "use strict" }
}

/** An asm.js directive. */
class ASMJSDirective extends KnownDirective {
  ASMJSDirective() { getDirectiveText() = "use asm" }
}

/** A Babel directive. */
class BabelDirective extends KnownDirective {
  BabelDirective() { getDirectiveText() = "use babel" }
}

/** A legacy 6to5 directive. */
class SixToFiveDirective extends KnownDirective {
  SixToFiveDirective() { getDirectiveText() = "use 6to5" }
}

/** A SystemJS `format` directive. */
class SystemJSFormatDirective extends KnownDirective {
  SystemJSFormatDirective() {
    getDirectiveText().regexpMatch("format (cjs|esm|global|register)")
  }
}

/** A SystemJS `format register` directive. */
class FormatRegisterDirective extends SystemJSFormatDirective {
  FormatRegisterDirective() { getDirectiveText() = "format register" }
}

/** A `ngInject` or `ngNoInject` directive. */
class NgInjectDirective extends KnownDirective {
  NgInjectDirective() { getDirectiveText().regexpMatch("ng(No)?Inject") }
}


/** A SystemJS `deps` directive. */
class SystemJSDepsDirective extends KnownDirective {
  SystemJSDepsDirective() {
    getDirectiveText().regexpMatch("deps [^ ]+")
  }
}

/** A `bundle` directive. */
class BundleDirective extends KnownDirective {
  BundleDirective() { getDirectiveText() = "bundle" }
}

/** An `if` statement. */
class IfStmt extends @ifstmt, ControlStmt {
  /** Gets the condition of this `if` statement. */
  Expr getCondition() {
    result = getChildExpr(0)
  }

  /** Gets the "then" branch of this `if` statement. */
  Stmt getThen() {
    result = getChildStmt(1)
  }

  /** Gets the "else" branch of this `if` statement, if any. */
  Stmt getElse() {
    result = getChildStmt(2)
  }

  /** Gets the `if` token of this `if` statement. */
  KeywordToken getIfToken() {
    result = getFirstToken()
  }

  /** Gets the `else` token of this `if` statement, if any. */
  KeywordToken getElseToken() {
    result = getThen().getLastToken().getNextToken() and
    result.getIndex() < getLastToken().getIndex()
  }

  override Stmt getAControlledStmt() {
    result = getThen() or
    result = getElse()
  }

  /** Holds if this `if` statement is an `else if` of an outer `if` statement. */
  predicate isElseIf() {
    exists(IfStmt outer | outer.getElse() = this)
  }
}

/** A labeled statement. */
class LabeledStmt extends @labeledstmt, Stmt {
  /** Gets the label of this statement. */
  string getLabel() {
    result = getChildExpr(0).(Identifier).getName()
  }

  /** Gets the labeled statement of this statement. */
  Stmt getStmt() {
    result = getChildStmt(1)
  }
}

/**
 * A statement that disrupts structured control flow, that is, a
 * `continue` statement, a `break` statement,
 * a `throw` statement, or a `return` statement.
 */
abstract class JumpStmt extends Stmt {
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
  abstract ASTNode getTarget();
}

/** A break or continue statement. */
abstract class BreakOrContinueStmt extends JumpStmt {
  /** Gets the label this statement refers to, if any. */
  string getTargetLabel() {
    result = ((Identifier)getChildExpr(0)).getName()
  }

  /** Holds if this statement has an explicit target label. */
  predicate hasTargetLabel() {
    exists(getTargetLabel())
  }

  /** Gets the statement this statement breaks out of or continues with. */
  override Stmt getTarget() {
    jumpTargets(this, result)
  }

  override predicate isSubjectToSemicolonInsertion() {
    any()
  }
}

/** A `break` statement. */
class BreakStmt extends @breakstmt, BreakOrContinueStmt {}

/** A `continue` statement. */
class ContinueStmt extends @continuestmt, BreakOrContinueStmt {}

/** A `with` statement. */
class WithStmt extends @withstmt, ControlStmt {
  /** Gets the controlling expression of this `with` statement. */
  Expr getExpr() {
    result = getChildExpr(0)
  }

  /** Gets the body of this `with` statement. */
  Stmt getBody() {
    result = getChildStmt(1)
  }

  /**
   * Holds if `acc` could refer to a property of the scope object
   * introduced by this `with` statement.
   */
  predicate mayAffect(VarAccess acc) {
    acc.getEnclosingStmt().nestedIn(getBody()) and
    exists (Variable v | v = acc.getVariable() |
      v instanceof GlobalVariable or
      exists (ASTNode scopeElt | scopeElt = v.getScope().getScopeElement() |
        scopeElt = getParent+()
      )
    )
  }

  override Stmt getAControlledStmt() {
    result = getBody()
  }
}

/** A `switch` statement. */
class SwitchStmt extends @switchstmt, ControlStmt {
  /** Gets the controlling expression of this `switch` statement. */
  Expr getExpr() {
    result = getChildExpr(-1)
  }

  /** Gets the `i`th `case` clause of this `switch` statement. */
  Case getCase(int i) {
    result = getChildStmt(i)
  }

  /** Gets a `case` clause of this `switch` statement. */
  Case getACase() {
    result = getCase(_)
  }

  /** Gets the number of `case` clauses of this `switch` statement. */
  int getNumCase() {
    result = count(getACase())
  }

  override Case getAControlledStmt() {
    result = getACase()
  }
}

/** A `return` statement. */
class ReturnStmt extends @returnstmt, JumpStmt {
  /** Gets the expression specifying the returned value, if any. */
  Expr getExpr() {
    result = getChildExpr(0)
  }

  /** Gets the target of this `return` statement, which is the enclosing statement container. */
  override Function getTarget() {
    result = getContainer()
  }

  override ControlFlowNode getFirstControlFlowNode() {
    if exists(getExpr()) then
      result = getExpr().getFirstControlFlowNode()
    else
      result = this
  }

  override predicate isSubjectToSemicolonInsertion() {
    any()
  }
}

/** A `throw` statement. */
class ThrowStmt extends @throwstmt, JumpStmt {
  /** Gets the expression specifying the value to throw. */
  Expr getExpr() {
    result = getChildExpr(0)
  }

  /**
   * Gets the target of this `throw` statement, which is the closest surrounding
   * `try` statement in whose body the throw statement occurs. If there is no such
   * `try` statement, the target defaults to the enclosing statement container.
   */
  override ASTNode getTarget() {
    if exists (TryStmt ts | getParentStmt+() = ts.getBody()) then
      (getParentStmt+() = ((TryStmt)result).getBody() and
       not exists (TryStmt mid | getParentStmt+() = mid.getBody() and mid.getParentStmt+() = result))
    else
      result = getContainer()
  }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getExpr().getFirstControlFlowNode()
  }

  override predicate isSubjectToSemicolonInsertion() {
    any()
  }
}

/** A `try` statement. */
class TryStmt extends @trystmt, ControlStmt {
  /** Gets the body of this `try` statement. */
  BlockStmt getBody() {
    result = getChildStmt(0)
  }

  override Stmt getAControlledStmt() {
    result = getBody() or
    result = getACatchClause() or
    result = getFinally()
  }

  /** Gets the `i`th `catch` clause of this `try` statement, if any. */
  CatchClause getCatchClause(int i) {
    exists (int idx |
      result = getChildStmt(idx) and
      idx >= 1 and
      i = idx-1
    )
  }

  /** Gets a `catch` clause of this `try` statement. */
  CatchClause getACatchClause() {
    result = getCatchClause(_)
  }

  /** Gets the (unique) unguarded `catch` clause of this `try` statement, if any. */
  CatchClause getCatchClause() {
    result = getACatchClause() and
    not exists(result.getGuard())
  }

  /** Gets the number of `catch` clauses of this `try` statement. */
  int getNumCatchClause() {
    result = count(getACatchClause())
  }

  /** Gets the `finally` block of this `try` statement, if any. */
  BlockStmt getFinally() {
    result = getChildStmt(-1)
  }
}

/** A `while` loop. */
class WhileStmt extends @whilestmt, LoopStmt {
  /** Gets the loop condition of this `while` loop. */
  Expr getExpr() {
    result = getChildExpr(0)
  }

  override Expr getTest() {
    result = getExpr()
  }

  override Stmt getBody() {
    result = getChildStmt(1)
  }
}

/** A `do`-`while` loop. */
class DoWhileStmt extends @dowhilestmt, LoopStmt {
  /** Gets the loop condition of this `do`-`while` loop. */
  Expr getExpr() {
    result = getChildExpr(1)
  }

  override Expr getTest() {
    result = getExpr()
  }

  override Stmt getBody() {
    result = getChildStmt(0)
  }

  override predicate isSubjectToSemicolonInsertion() {
    any()
  }
}

/** An expression or a variable declaration statement. */
class ExprOrVarDecl extends ASTNode {
  ExprOrVarDecl() {
    this instanceof Expr or
    this instanceof DeclStmt
  }
}

/** A `for` loop. */
class ForStmt extends @forstmt, LoopStmt {
  /** Gets the init part of this `for` loop. */
  ExprOrVarDecl getInit() {
    result = getChildExpr(0) or
    result = getChildStmt(0)
  }

  override Expr getTest() {
    result = getChildExpr(1)
  }

  /** Gets the update part of this `for` loop. */
  Expr getUpdate() {
    result = getChildExpr(2)
  }

  override Stmt getBody() {
    result = getChildStmt(3)
  }
}

/** A `for`-`in` or `for`-`of` loop. */
abstract class EnhancedForLoop extends LoopStmt {
  /**
   * Gets the iterator of this `for`-`in` or `for`-`of` loop; this can be either a
   * pattern, a property reference, or a variable declaration statement.
   */
  ExprOrVarDecl getIterator() {
    result = getChildExpr(0) or
    result = getChildStmt(0)
  }

  /**
   * Gets the default value of the loop's iterator, if any.
   */
  Expr getDefault() {
    result = getChildExpr(-1)
  }

  /**
   * Gets the iterator expression of this `for`-`in` or `for`-`of` loop; this can be
   * either a variable access or a variable declarator.
   */
  Expr getIteratorExpr() {
    result = getIterator() or
    result = getIterator().(DeclStmt).getADecl()
  }

  /**
   * Gets an iterator variable of this `for`-`in` or `for`-`of` loop.
   */
  Variable getAnIterationVariable() {
    result = getIterator().(DeclStmt).getADecl().getBindingPattern().getAVariable() or
    result = getIterator().(BindingPattern).getAVariable()
  }

  override Expr getTest() {
    none()
  }

  /** Gets the expression this `for`-`in` or `for`-`of` loop iterates over. */
  Expr getIterationDomain() {
    result = getChildExpr(1)
  }

  override Stmt getBody() {
    result = getChildStmt(2)
  }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getIteratorExpr().getFirstControlFlowNode()
  }
}

/** A `for`-`in` loop. */
class ForInStmt extends @forinstmt, EnhancedForLoop {}

/** A `for`-`of` loop. */
class ForOfStmt extends @forofstmt, EnhancedForLoop {
  /**
   * Holds if this is a `for-await-of` statement.
   */
  predicate isAwait() {
    isForAwaitOf(this)
  }
}

/** A `for each`-`in` loop. */
class ForEachStmt extends @foreachstmt, EnhancedForLoop {}

/** A `debugger` statement. */
class DebuggerStmt extends @debuggerstmt, Stmt {
  override predicate isSubjectToSemicolonInsertion() {
    any()
  }
}

/** A function declaration statement. */
class FunctionDeclStmt extends @functiondeclstmt, Stmt, Function {
  override Stmt getEnclosingStmt() {
    result = this
  }

  override predicate isAmbient() {
    Function.super.isAmbient()
  }
}

/** A declaration statement, that is, a `var`, `const` or `let` declaration. */
class DeclStmt extends @declstmt, Stmt {
  /** Gets the `i`th declarator in this declaration statement. */
  VariableDeclarator getDecl(int i) {
    result = getChildExpr(i) and i >= 0
  }

  /** Gets a declarator in this declaration statement. */
  VariableDeclarator getADecl() {
    result = getDecl(_)
  }

  override predicate isSubjectToSemicolonInsertion() {
    // exclude variable declarations in the init part of for/for-in/for-of loops
    not exists (LoopStmt for | this = for.getAChildStmt() and this != for.getBody())
  }
}

/** A `var` declaration statement. */
class VarDeclStmt extends @vardeclstmt, DeclStmt {}

/** A `const` declaration statement. */
class ConstDeclStmt extends @constdeclstmt, DeclStmt {}

/** A `let` declaration statement. */
class LetStmt extends @letstmt, DeclStmt {}

/** A legacy `let` statement, that is, a statement of the form `let(vardecls) stmt`. */
class LegacyLetStmt extends @legacy_letstmt, DeclStmt {
  /** Gets the statement this let statement scopes over. */
  Stmt getBody() {
    result = getChildStmt(-1)
  }

  override predicate isSubjectToSemicolonInsertion() { none() }
}

/** A `case` or `default` clause in a `switch` statement. */
class Case extends @case, Stmt {
  /** Gets the test expression of this `case` clause. */
  Expr getExpr() {
    result = getChildExpr(-1)
  }

  /** Holds if this is a `default` clause. */
  predicate isDefault() {
    not exists(getExpr())
  }

  /** Gets the `i`th statement in this `case` clause. */
  Stmt getBodyStmt(int i) {
    result = getChildStmt(i)
  }

  /** Gets a statement in this `case` clause. */
  Stmt getABodyStmt() {
    result = getChildStmt(_)
  }

  /** Gets the number of statements in this `case` clause. */
  int getNumBodyStmt() {
    result = count(getABodyStmt())
  }

  /** Gets the `switch` statement to which this clause belongs. */
  SwitchStmt getSwitch() {
    result = getParent()
  }
}

/** A `catch` clause. */
class CatchClause extends @catchclause, ControlStmt, Parameterized {
  /** Gets the body of this `catch` clause. */
  BlockStmt getBody() {
    result = getChildStmt(1)
  }

  /** Gets the guard expression of this `catch` clause, if any. */
  Expr getGuard() {
    result = getChildExpr(2)
  }

  override Stmt getAControlledStmt() {
    result = getBody()
  }

  /** Gets the scope induced by this `catch` clause. */
  CatchScope getScope() {
    result.getCatchClause() = this
  }
}
