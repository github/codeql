private import codeql.ruby.AST
private import codeql.ruby.CFG
private import internal.AST
private import internal.TreeSitter
private import internal.Variable
private import codeql.ruby.controlflow.internal.ControlFlowGraphImpl

/**
 * A statement.
 *
 * This is the root QL class for all statements.
 */
class Stmt extends AstNode, TStmt {
  /** Gets a control-flow node for this statement, if any. */
  CfgNodes::AstCfgNode getAControlFlowNode() { result.getNode() = this }

  /** Gets a control-flow entry node for this statement, if any */
  AstNode getAControlFlowEntryNode() { result = getAControlFlowEntryNode(this) }

  /** Gets the control-flow scope of this statement, if any. */
  CfgScope getCfgScope() { result = getCfgScope(this) }

  /** Gets the enclosing callable, if any. */
  Callable getEnclosingCallable() { result = this.getCfgScope() }
}

/**
 * An empty statement (`;`).
 */
class EmptyStmt extends Stmt, TEmptyStmt {
  final override string getAPrimaryQlClass() { result = "EmptyStmt" }

  final override string toString() { result = ";" }
}

/**
 * A `begin` statement.
 * ```rb
 * begin
 *  puts "hello world"
 * end
 * ```
 */
class BeginExpr extends BodyStmt, TBeginExpr {
  final override string getAPrimaryQlClass() { result = "BeginExpr" }

  final override string toString() { result = "begin ... " }
}

/**
 * A `BEGIN` block.
 * ```rb
 * BEGIN { puts "starting ..." }
 * ```
 */
class BeginBlock extends StmtSequence, TBeginBlock {
  private Ruby::BeginBlock g;

  BeginBlock() { this = TBeginBlock(g) }

  final override string getAPrimaryQlClass() { result = "BeginBlock" }

  final override string toString() { result = "BEGIN { ... }" }

  final override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }
}

/**
 * An `END` block.
 * ```rb
 * END { puts "shutting down" }
 * ```
 */
class EndBlock extends StmtSequence, TEndBlock {
  private Ruby::EndBlock g;

  EndBlock() { this = TEndBlock(g) }

  final override string getAPrimaryQlClass() { result = "EndBlock" }

  final override string toString() { result = "END { ... }" }

  final override Stmt getStmt(int n) { toGenerated(result) = g.getChild(n) }
}

/**
 * An `undef` statement. For example:
 * ```rb
 * - undef method_name
 * - undef &&, :method_name
 * - undef :"method_#{ name }"
 * ```
 */
class UndefStmt extends Stmt, TUndefStmt {
  private Ruby::Undef g;

  UndefStmt() { this = TUndefStmt(g) }

  /** Gets the `n`th method name to undefine. */
  final MethodName getMethodName(int n) { toGenerated(result) = g.getChild(n) }

  /** Gets a method name to undefine. */
  final MethodName getAMethodName() { result = this.getMethodName(_) }

  final override string getAPrimaryQlClass() { result = "UndefStmt" }

  final override string toString() { result = "undef ..." }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getMethodName" and result = this.getMethodName(_)
  }
}

/**
 * An `alias` statement. For example:
 * ```rb
 * - alias alias_name method_name
 * - alias foo :method_name
 * - alias bar :"method_#{ name }"
 * ```
 */
class AliasStmt extends Stmt, TAliasStmt {
  private Ruby::Alias g;

  AliasStmt() { this = TAliasStmt(g) }

  /** Gets the new method name. */
  final MethodName getNewName() { toGenerated(result) = g.getName() }

  /** Gets the original method name. */
  final MethodName getOldName() { toGenerated(result) = g.getAlias() }

  final override string getAPrimaryQlClass() { result = "AliasStmt" }

  final override string toString() { result = "alias ..." }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getNewName" and result = this.getNewName()
    or
    pred = "getOldName" and result = this.getOldName()
  }
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
class ReturningStmt extends Stmt, TReturningStmt {
  private Ruby::ArgumentList getArgumentList() {
    result = any(Ruby::Return g | this = TReturnStmt(g)).getChild()
    or
    result = any(Ruby::Break g | this = TBreakStmt(g)).getChild()
    or
    result = any(Ruby::Next g | this = TNextStmt(g)).getChild()
  }

  /** Gets the returned value, if any. */
  final Expr getValue() {
    toGenerated(result) =
      any(Ruby::AstNode res |
        exists(Ruby::ArgumentList a, int c |
          a = this.getArgumentList() and c = count(a.getChild(_))
        |
          res = a.getChild(0) and c = 1
          or
          res = a and c > 1
        )
      )
  }

  final override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = "getValue" and result = this.getValue()
  }
}

/**
 * A `return` statement.
 * ```rb
 * return
 * return value
 * ```
 */
class ReturnStmt extends ReturningStmt, TReturnStmt {
  final override string getAPrimaryQlClass() { result = "ReturnStmt" }

  final override string toString() { result = "return" }
}

/**
 * A `break` statement.
 * ```rb
 * break
 * break value
 * ```
 */
class BreakStmt extends ReturningStmt, TBreakStmt {
  final override string getAPrimaryQlClass() { result = "BreakStmt" }

  final override string toString() { result = "break" }
}

/**
 * A `next` statement.
 * ```rb
 * next
 * next value
 * ```
 */
class NextStmt extends ReturningStmt, TNextStmt {
  final override string getAPrimaryQlClass() { result = "NextStmt" }

  final override string toString() { result = "next" }
}

/**
 * A `redo` statement.
 * ```rb
 * redo
 * ```
 */
class RedoStmt extends Stmt, TRedoStmt {
  final override string getAPrimaryQlClass() { result = "RedoStmt" }

  final override string toString() { result = "redo" }
}

/**
 * A `retry` statement.
 * ```rb
 * retry
 * ```
 */
class RetryStmt extends Stmt, TRetryStmt {
  final override string getAPrimaryQlClass() { result = "RetryStmt" }

  final override string toString() { result = "retry" }
}
