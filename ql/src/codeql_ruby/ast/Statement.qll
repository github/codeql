private import codeql_ruby.AST
private import codeql_ruby.CFG
private import internal.Expr
private import internal.Statement
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
 * A `begin` statement.
 * ```rb
 * begin
 *  puts "hello world"
 * end
 * ```
 */
class BeginExpr extends BodyStatement, @begin {
  final override Begin::Range range;

  final override string getAPrimaryQlClass() { result = "BeginExpr" }
}

/**
 * A `BEGIN` block.
 * ```rb
 * BEGIN { puts "starting ..." }
 * ```
 */
class BeginBlock extends StmtSequence, @begin_block {
  final override BeginBlock::Range range;

  final override string getAPrimaryQlClass() { result = "BeginBlock" }
}

/**
 * An `END` block.
 * ```rb
 * END { puts "shutting down" }
 * ```
 */
class EndBlock extends StmtSequence, @end_block {
  final override EndBlock::Range range;

  final override string getAPrimaryQlClass() { result = "EndBlock" }
}

/**
 * An `undef` statement. For example:
 * ```rb
 * - undef method_name
 * - undef &&, :method_name
 * - undef :"method_#{ name }"
 * ```
 */
class UndefStmt extends Stmt, @undef {
  final override UndefStmt::Range range;

  /** Gets the `n`th method name to undefine. */
  final MethodName getMethodName(int n) { result = range.getMethodName(n) }

  /** Gets a method name to undefine. */
  final MethodName getAMethodName() { result = getMethodName(_) }

  final override string getAPrimaryQlClass() { result = "UndefStmt" }
}

/**
 * An `alias` statement. For example:
 * ```rb
 * - alias alias_name method_name
 * - alias foo :method_name
 * - alias bar :"method_#{ name }"
 * ```
 */
class AliasStmt extends Stmt, @alias {
  final override AliasStmt::Range range;

  /** Gets the new method name. */
  final MethodName getNewName() { result = range.getNewName() }

  /** Gets the original method name. */
  final MethodName getOldName() { result = range.getOldName() }

  final override string getAPrimaryQlClass() { result = "AliasStmt" }
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
