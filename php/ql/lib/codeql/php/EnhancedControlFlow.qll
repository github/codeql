/**
 * @name Enhanced Control Flow Analysis
 * @description Provides advanced control flow analysis for PHP with support for complex branching,
 *              loops, exception handling, and data-dependent control flow.
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ControlFlow

/**
 * A control flow node in the program.
 */
class CfgNode extends TS::PHP::AstNode {
  /** Gets the AST node this CFG node represents */
  TS::PHP::AstNode getAstNode() { result = this }
}

/**
 * A branch node represents a point where execution can take multiple paths.
 */
class BranchNode extends CfgNode {
  BranchNode() {
    this instanceof TS::PHP::IfStatement or
    this instanceof TS::PHP::SwitchStatement or
    this instanceof TS::PHP::WhileStatement or
    this instanceof TS::PHP::ForStatement or
    this instanceof TS::PHP::ForeachStatement or
    this instanceof TS::PHP::TryStatement
  }
}

/**
 * Represents an if/elseif/else chain as a single branching construct.
 */
class ConditionalChain extends BranchNode {
  ConditionalChain() {
    this instanceof TS::PHP::IfStatement
  }

  /** Gets the condition expression */
  TS::PHP::ParenthesizedExpression getCondition() {
    result = this.(TS::PHP::IfStatement).getCondition()
  }

  /** Gets the body of the if statement */
  TS::PHP::AstNode getIfBody() {
    result = this.(TS::PHP::IfStatement).getBody()
  }

  /** Gets an else-if clause */
  TS::PHP::ElseIfClause getAnElseIfClause() {
    result = this.(TS::PHP::IfStatement).getAlternative(_)
  }

  /** Gets the else clause if present */
  TS::PHP::ElseClause getElseClause() {
    result = this.(TS::PHP::IfStatement).getAlternative(_)
  }

  /** Checks if this has an else clause */
  predicate hasElse() {
    exists(this.getElseClause())
  }
}

/**
 * Represents a loop construct (while, for, foreach, do-while).
 */
class EnhancedLoopNode extends BranchNode {
  EnhancedLoopNode() {
    this instanceof TS::PHP::WhileStatement or
    this instanceof TS::PHP::DoStatement or
    this instanceof TS::PHP::ForStatement or
    this instanceof TS::PHP::ForeachStatement
  }

  /** Gets the loop condition if present */
  TS::PHP::AstNode getLoopCondition() {
    result = this.(TS::PHP::WhileStatement).getCondition() or
    result = this.(TS::PHP::DoStatement).getCondition() or
    result = this.(TS::PHP::ForStatement).getCondition()
  }

  /** Gets the loop body */
  TS::PHP::AstNode getLoopBody() {
    result = this.(TS::PHP::WhileStatement).getBody() or
    result = this.(TS::PHP::DoStatement).getBody() or
    result = this.(TS::PHP::ForStatement).getBody(_) or
    result = this.(TS::PHP::ForeachStatement).getBody()
  }

  /** Checks if this is a do-while loop */
  predicate isDoWhile() {
    this instanceof TS::PHP::DoStatement
  }
}

/**
 * Represents a switch statement with multiple cases.
 */
class SwitchNode extends BranchNode {
  SwitchNode() {
    this instanceof TS::PHP::SwitchStatement
  }

  /** Gets the switch condition */
  TS::PHP::ParenthesizedExpression getSwitchCondition() {
    result = this.(TS::PHP::SwitchStatement).getCondition()
  }

  /** Gets the switch body */
  TS::PHP::SwitchBlock getSwitchBody() {
    result = this.(TS::PHP::SwitchStatement).getBody()
  }
}

/**
 * Represents exception handling with try/catch/finally.
 */
class TryNode extends BranchNode {
  TryNode() {
    this instanceof TS::PHP::TryStatement
  }

  /** Gets the try block */
  TS::PHP::CompoundStatement getTryBlock() {
    result = this.(TS::PHP::TryStatement).getBody()
  }

  /** Gets a catch clause */
  TS::PHP::CatchClause getACatchClause() {
    result = this.(TS::PHP::TryStatement).getChild(_)
  }

  /** Gets the finally clause if present */
  TS::PHP::FinallyClause getFinallyClause() {
    result = this.(TS::PHP::TryStatement).getChild(_)
  }

  /** Checks if this has a finally clause */
  predicate hasFinally() {
    exists(this.getFinallyClause())
  }

  /** Gets the number of catch clauses */
  int getNumCatches() {
    result = count(this.getACatchClause())
  }
}

/**
 * Represents control flow statements that alter normal execution.
 */
class LoopControlNode extends CfgNode {
  LoopControlNode() {
    this instanceof TS::PHP::BreakStatement or
    this instanceof TS::PHP::ContinueStatement
  }

  /** Checks if this is a break statement */
  predicate isBreak() { this instanceof TS::PHP::BreakStatement }

  /** Checks if this is a continue statement */
  predicate isContinue() { this instanceof TS::PHP::ContinueStatement }
}

/**
 * A return point - where control flow exits a function.
 */
class ReturnNode extends CfgNode {
  ReturnNode() {
    this instanceof TS::PHP::ReturnStatement or
    this instanceof TS::PHP::ThrowExpression
  }

  /** Gets the returned/thrown expression if any */
  TS::PHP::AstNode getExpr() {
    result = this.(TS::PHP::ReturnStatement).getChild() or
    result = this.(TS::PHP::ThrowExpression).getChild()
  }

  /** Checks if this is a return (not throw) */
  predicate isReturn() { this instanceof TS::PHP::ReturnStatement }

  /** Checks if this is a throw */
  predicate isThrow() { this instanceof TS::PHP::ThrowExpression }
}

/**
 * Identifies complex branching patterns.
 */
class ComplexBranching extends CfgNode {
  ComplexBranching() {
    // Nested conditionals
    exists(TS::PHP::IfStatement outer, TS::PHP::IfStatement inner |
      this = outer and
      inner.getParent+() = outer
    )
    or
    // Nested loops
    exists(EnhancedLoopNode outer, EnhancedLoopNode inner |
      this = outer and
      inner.getParent+() = outer
    )
  }
}

/**
 * Determines if statement B is a potential successor to statement A.
 */
predicate isStatementSuccessor(TS::PHP::Statement successor, TS::PHP::Statement predecessor) {
  // Sequential statements in a compound statement
  exists(TS::PHP::CompoundStatement block, int i |
    block.getChild(i) = predecessor and
    block.getChild(i + 1) = successor
  )
}

/**
 * Determines if a statement always completes (returns or throws).
 */
predicate alwaysCompletes(TS::PHP::AstNode node) {
  node instanceof TS::PHP::ReturnStatement or
  node instanceof TS::PHP::ThrowExpression
}
