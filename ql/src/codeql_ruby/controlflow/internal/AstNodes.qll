/**
 * Provides various helper classes for AST nodes. The definitions in this file
 * will likely be part of the hand-written user-facing AST layer.
 */

import codeql_ruby.ast

class LogicalNotAstNode extends Unary {
  AstNode operand;

  LogicalNotAstNode() {
    this.getOperator().toString() in ["!", "not"] and
    operand = this.getOperand()
  }
}

class LogicalAndAstNode extends Binary {
  AstNode left;
  AstNode right;

  LogicalAndAstNode() {
    this.getOperator().toString() in ["&&", "and"] and
    left = this.getLeft() and
    right = this.getRight()
  }

  AstNode getAnOperand() { result in [left, right] }
}

class LogicalOrAstNode extends Binary {
  AstNode left;
  AstNode right;

  LogicalOrAstNode() {
    this.getOperator().toString() in ["||", "or"] and
    left = this.getLeft() and
    right = this.getRight()
  }

  AstNode getAnOperand() { result in [left, right] }
}

private class If_or_elisif = @if or @elsif;

class IfElsifAstNode extends AstNode, If_or_elisif {
  AstNode getConditionNode() { none() }

  AstNode getConsequenceNode() { none() }

  AstNode getAlternativeNode() { none() }
}

private class IfAstNode extends IfElsifAstNode, If {
  override AstNode getConditionNode() { result = this.getCondition() }

  override AstNode getConsequenceNode() { result = this.getConsequence() }

  override AstNode getAlternativeNode() { result = this.getAlternative() }
}

private class ElsifAstNode extends IfElsifAstNode, Elsif {
  override AstNode getConditionNode() { result = this.getCondition() }

  override AstNode getConsequenceNode() { result = this.getConsequence() }

  override AstNode getAlternativeNode() { result = this.getAlternative() }
}

class ParenthesizedStatement extends ParenthesizedStatements {
  ParenthesizedStatement() { strictcount(int i | exists(this.getChild(i))) = 1 }

  AstNode getChild() { result = this.getChild(0) }
}
