/**
 * Provides classes for modeling control flow in PHP.
 *
 * This module enables control flow analysis by modeling the program's possible
 * execution paths through if statements, loops, exception handlers, etc.
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A scope that contains statements (function, method, or global scope).
 */
class Scope extends TS::PHP::AstNode {
  Scope() {
    this instanceof TS::PHP::FunctionDefinition or
    this instanceof TS::PHP::MethodDeclaration or
    this instanceof TS::PHP::AnonymousFunction or
    this instanceof TS::PHP::ArrowFunction or
    this instanceof TS::PHP::Program
  }

  /** Gets the body of this scope. */
  TS::PHP::AstNode getBody() {
    result = this.(TS::PHP::FunctionDefinition).getBody() or
    result = this.(TS::PHP::MethodDeclaration).getBody() or
    result = this.(TS::PHP::AnonymousFunction).getBody() or
    result = this.(TS::PHP::ArrowFunction).getBody() or
    result = this.(TS::PHP::Program).getChild(_)
  }

  /** Gets the name of this scope, if it has one. */
  string getName() {
    result = this.(TS::PHP::FunctionDefinition).getName().getValue() or
    result = this.(TS::PHP::MethodDeclaration).getName().getValue() or
    result = "anonymous" and this instanceof TS::PHP::AnonymousFunction or
    result = "arrow" and this instanceof TS::PHP::ArrowFunction or
    result = "global" and this instanceof TS::PHP::Program
  }
}

/**
 * A basic block of statements that execute sequentially.
 */
class BasicBlock extends TS::PHP::CompoundStatement {
  /** Gets the i-th statement in this block. */
  TS::PHP::Statement getStatement(int i) { result = this.getChild(i) }

  /** Gets any statement in this block. */
  TS::PHP::Statement getAStatement() { result = this.getChild(_) }

  /** Gets the number of statements. */
  int getNumStatements() { result = count(this.getAStatement()) }

  /** Gets the first statement. */
  TS::PHP::Statement getFirstStatement() { result = this.getStatement(0) }

  /** Gets the last statement. */
  TS::PHP::Statement getLastStatement() {
    result = this.getStatement(this.getNumStatements() - 1)
  }
}

/**
 * A branching point in control flow.
 */
class BranchingPoint extends TS::PHP::AstNode {
  BranchingPoint() {
    this instanceof TS::PHP::IfStatement or
    this instanceof TS::PHP::SwitchStatement or
    this instanceof TS::PHP::ConditionalExpression or
    this instanceof TS::PHP::MatchExpression
  }

  /** Gets the condition expression. */
  TS::PHP::AstNode getCondition() {
    result = this.(TS::PHP::IfStatement).getCondition() or
    result = this.(TS::PHP::SwitchStatement).getCondition() or
    result = this.(TS::PHP::ConditionalExpression).getCondition() or
    result = this.(TS::PHP::MatchExpression).getCondition()
  }
}

/**
 * A loop construct.
 */
class LoopStmt extends TS::PHP::AstNode {
  LoopStmt() {
    this instanceof TS::PHP::WhileStatement or
    this instanceof TS::PHP::DoStatement or
    this instanceof TS::PHP::ForStatement or
    this instanceof TS::PHP::ForeachStatement
  }

  /** Gets the loop body. */
  TS::PHP::AstNode getBody() {
    result = this.(TS::PHP::WhileStatement).getBody() or
    result = this.(TS::PHP::DoStatement).getBody() or
    result = this.(TS::PHP::ForStatement).getBody(_) or
    result = this.(TS::PHP::ForeachStatement).getBody()
  }

  /** Gets the loop condition, if any. */
  TS::PHP::AstNode getCondition() {
    result = this.(TS::PHP::WhileStatement).getCondition() or
    result = this.(TS::PHP::DoStatement).getCondition() or
    result = this.(TS::PHP::ForStatement).getCondition()
  }
}

/**
 * A return point - where control flow exits a function.
 */
class ReturnPoint extends TS::PHP::AstNode {
  ReturnPoint() {
    this instanceof TS::PHP::ReturnStatement or
    this instanceof TS::PHP::ThrowExpression
  }

  /** Gets the returned/thrown expression, if any. */
  TS::PHP::AstNode getExpr() {
    result = this.(TS::PHP::ReturnStatement).getChild() or
    result = this.(TS::PHP::ThrowExpression).getChild()
  }

  /** Holds if this is a normal return. */
  predicate isReturn() { this instanceof TS::PHP::ReturnStatement }

  /** Holds if this is a throw. */
  predicate isThrow() { this instanceof TS::PHP::ThrowExpression }
}

/**
 * An exception handler (try-catch-finally).
 */
class ExceptionHandler extends TS::PHP::TryStatement {
  /** Gets the try block. */
  TS::PHP::CompoundStatement getTryBlock() { result = this.getBody() }

  /** Gets a catch clause. */
  TS::PHP::CatchClause getACatchClause() { result = this.getChild(_) }

  /** Gets the finally clause, if any. */
  TS::PHP::FinallyClause getFinallyClause() { result = this.getChild(_) }

  /** Gets the number of catch clauses. */
  int getNumCatchClauses() { result = count(this.getACatchClause()) }

  /** Holds if this has a finally clause. */
  predicate hasFinally() { exists(this.getFinallyClause()) }
}

/**
 * A statement that can terminate a loop early (break/continue).
 */
class LoopTerminator extends TS::PHP::AstNode {
  LoopTerminator() {
    this instanceof TS::PHP::BreakStatement or
    this instanceof TS::PHP::ContinueStatement
  }

  /** Holds if this is a break statement. */
  predicate isBreak() { this instanceof TS::PHP::BreakStatement }

  /** Holds if this is a continue statement. */
  predicate isContinue() { this instanceof TS::PHP::ContinueStatement }

  /** Gets the nesting level to break/continue from, if specified. */
  TS::PHP::Expression getLevel() {
    result = this.(TS::PHP::BreakStatement).getChild() or
    result = this.(TS::PHP::ContinueStatement).getChild()
  }
}
