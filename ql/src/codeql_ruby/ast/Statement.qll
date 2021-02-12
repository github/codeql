private import codeql_ruby.AST
private import codeql_ruby.CFG
private import internal.Statement
private import internal.Variable
private import codeql_ruby.controlflow.internal.ControlFlowGraphImpl

/**
 * A statement.
 *
 * This is the root QL class for all statements.
 */
class Stmt extends AstNode {
  override Stmt::Range range;

  /** Gets a control-flow node for this statement, if any. */
  CfgNodes::AstCfgNode getAControlFlowNode() { result.getNode() = this }

  /** Gets the control-flow scope of this statement, if any. */
  CfgScope getCfgScope() { result = getCfgScope(this) }

  /** Gets the variable scope that this statement belongs to. */
  VariableScope getVariableScope() { result = enclosingScope(this) }

  /** Gets the enclosing callable, if any. */
  Callable getEnclosingCallable() { result = this.getCfgScope() }
}

/**
 * An empty statement (`;`).
 */
class EmptyStmt extends Stmt, @token_empty_statement {
  final override EmptyStmt::Range range;

  final override string getAPrimaryQlClass() { result = "EmptyStmt" }
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
class ReturningStmt extends Stmt {
  override ReturningStmt::Range range;

  /** Gets the returned value, if any. */
  final Expr getValue() { result = range.getValue() }
}

/**
 * A `return` statement.
 * ```rb
 * return
 * return value
 * ```
 */
class ReturnStmt extends ReturningStmt, @return {
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
class BreakStmt extends ReturningStmt, @break {
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
class NextStmt extends ReturningStmt, @next {
  final override NextStmt::Range range;

  final override string getAPrimaryQlClass() { result = "NextStmt" }
}

/**
 * A `redo` statement.
 * ```rb
 * redo
 * ```
 */
class RedoStmt extends Stmt, @redo {
  final override RedoStmt::Range range;

  final override string getAPrimaryQlClass() { result = "RedoStmt" }
}

/**
 * A `retry` statement.
 * ```rb
 * retry
 * ```
 */
class RetryStmt extends Stmt, @retry {
  final override RetryStmt::Range range;

  final override string getAPrimaryQlClass() { result = "RetryStmt" }
}
