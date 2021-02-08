private import codeql_ruby.AST
private import codeql_ruby.CFG
private import internal.Statement
private import codeql_ruby.controlflow.internal.ControlFlowGraphImpl
private import codeql_ruby.ast.internal.TreeSitter

/**
 * A statement.
 *
 * This is the root QL class for all statements.
 */
class Statement extends AstNode {
  Statement::Range range;

  Statement() { this = range }

  /** Gets a control-flow node for this statement, if any. */
  CfgNodes::AstCfgNode getAControlFlowNode() { result.getNode() = this }

  /** Gets the control-flow scope of this statement, if any. */
  CfgScope getCfgScope() { result = getCfgScope(this) }

  /** Gets the enclosing callable, if any. */
  Callable getEnclosingCallable() { result = this.getCfgScope() }
}

/**
 * A statement that may return a value: `return`, `break` and `next`.
 *
 * ```rb
 * return
 * return value
 * break
 * break value
 * next
 * next value
 * ```
 */
class ReturningStatement extends Statement {
  override ReturningStatement::Range range;

  final override string toString() {
    not exists(getValue()) and result = range.getStatementName()
    or
    result = range.getStatementName() + " " + getValue().toString()
  }

  /** Gets the returned value, if any. */
  final Expr getValue() {
    exists(Generated::ArgumentList a, int c |
      a = range.getArgumentList() and c = count(a.getChild(_))
    |
      result = a.getChild(0) and c = 1
      or
      result = a and c > 1
    )
  }
}

/**
 * A `return` statement.
 * ```rb
 * return
 * return value
 * ```
 */
class ReturnStmt extends ReturningStatement, @return {
  final override ReturnStmt::Range range;

  final override string getAPrimaryQlClass() { result = "ReturnStmt" }
}

/**
 * A `break` statement.
 * ```rb
 * break
 * break value
 * ```
 */
class BreakStmt extends ReturningStatement, @break {
  final override BreakStmt::Range range;

  final override string getAPrimaryQlClass() { result = "BreakStmt" }
}

/**
 * A `next` statement.
 * ```rb
 * next
 * next value
 * ```
 */
class NextStmt extends ReturningStatement, @next {
  final override NextStmt::Range range;

  final override string getAPrimaryQlClass() { result = "NextStmt" }
}
