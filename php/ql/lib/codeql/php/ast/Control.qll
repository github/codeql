/**
 * Provides classes for control flow analysis in PHP.
 *
 * This module provides abstractions for statements that affect control flow.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Stmt

/**
 * A statement that affects control flow.
 */
class ControlFlowStmt extends TS::PHP::AstNode {
  ControlFlowStmt() {
    this instanceof TS::PHP::IfStatement or
    this instanceof TS::PHP::WhileStatement or
    this instanceof TS::PHP::DoStatement or
    this instanceof TS::PHP::ForStatement or
    this instanceof TS::PHP::ForeachStatement or
    this instanceof TS::PHP::SwitchStatement or
    this instanceof TS::PHP::TryStatement or
    this instanceof TS::PHP::ReturnStatement or
    this instanceof TS::PHP::ThrowExpression or
    this instanceof TS::PHP::BreakStatement or
    this instanceof TS::PHP::ContinueStatement or
    this instanceof TS::PHP::GotoStatement
  }
}

/**
 * A conditional statement (if, while, for, foreach, switch).
 */
class ConditionalStmt extends ControlFlowStmt {
  ConditionalStmt() {
    this instanceof TS::PHP::IfStatement or
    this instanceof TS::PHP::WhileStatement or
    this instanceof TS::PHP::DoStatement or
    this instanceof TS::PHP::ForStatement or
    this instanceof TS::PHP::ForeachStatement or
    this instanceof TS::PHP::SwitchStatement
  }
}

/**
 * A loop statement (while, do-while, for, foreach).
 */
class LoopStmt extends ConditionalStmt {
  LoopStmt() {
    this instanceof TS::PHP::WhileStatement or
    this instanceof TS::PHP::DoStatement or
    this instanceof TS::PHP::ForStatement or
    this instanceof TS::PHP::ForeachStatement
  }

  /** Gets the loop body. */
  TS::PHP::AstNode getLoopBody() {
    result = this.(TS::PHP::WhileStatement).getBody() or
    result = this.(TS::PHP::DoStatement).getBody() or
    result = this.(TS::PHP::ForStatement).getBody(_) or
    result = this.(TS::PHP::ForeachStatement).getBody()
  }
}

/**
 * A jump statement (return, break, continue, goto).
 */
class JumpStmt extends ControlFlowStmt {
  JumpStmt() {
    this instanceof TS::PHP::ReturnStatement or
    this instanceof TS::PHP::BreakStatement or
    this instanceof TS::PHP::ContinueStatement or
    this instanceof TS::PHP::GotoStatement
  }
}

/**
 * A loop exit statement (break, continue).
 */
class LoopExitStmt extends JumpStmt {
  LoopExitStmt() {
    this instanceof TS::PHP::BreakStatement or
    this instanceof TS::PHP::ContinueStatement
  }

  /** Gets the break/continue level, if specified. */
  TS::PHP::Expression getLevel() {
    result = this.(TS::PHP::BreakStatement).getChild() or
    result = this.(TS::PHP::ContinueStatement).getChild()
  }
}

/**
 * An exception handling statement (try-catch-finally).
 */
class ExceptionHandlingStmt extends ControlFlowStmt {
  ExceptionHandlingStmt() { this instanceof TS::PHP::TryStatement }

  /** Gets the try block. */
  TS::PHP::CompoundStatement getTryBlock() { result = this.(TS::PHP::TryStatement).getBody() }

  /** Gets a catch clause. */
  TS::PHP::CatchClause getACatchClause() { result = this.(TS::PHP::TryStatement).getChild(_) }

  /** Gets the finally clause, if any. */
  TS::PHP::FinallyClause getFinallyClause() { result = this.(TS::PHP::TryStatement).getChild(_) }
}
