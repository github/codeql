/**
 * Provides various helper classes for AST nodes. The definitions in this file
 * will likely be part of the hand-written user-facing AST layer.
 */

private import codeql_ruby.ast.internal.TreeSitter::Generated
private import codeql_ruby.controlflow.internal.Completion

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

private class If_or_elisif =
  @if or @elsif or @conditional or @if_modifier or @unless or @unless_modifier;

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

private class ConditionalAstNode extends IfElsifAstNode, Conditional {
  override AstNode getConditionNode() { result = this.getCondition() }

  override AstNode getConsequenceNode() { result = this.getConsequence() }

  override AstNode getAlternativeNode() { result = this.getAlternative() }
}

private class IfModifierAstNode extends IfElsifAstNode, IfModifier {
  override AstNode getConditionNode() { result = this.getCondition() }

  override AstNode getConsequenceNode() { result = this.getBody() }
}

private class UnlessAstNode extends IfElsifAstNode, Unless {
  override AstNode getConditionNode() { result = this.getCondition() }

  override AstNode getConsequenceNode() { result = this.getAlternative() }

  override AstNode getAlternativeNode() { result = this.getConsequence() }
}

private class UnlessModifierAstNode extends IfElsifAstNode, UnlessModifier {
  override AstNode getConditionNode() { result = this.getCondition() }

  override AstNode getAlternativeNode() { result = this.getBody() }
}

private class CondLoop = @while or @while_modifier or @until or @until_modifier;

class ConditionalLoopAstNode extends AstNode, CondLoop {
  AstNode getConditionNode() { none() }

  AstNode getBodyNode() { none() }

  predicate continueLoop(BooleanCompletion c) { c instanceof TrueCompletion }

  final predicate endLoop(BooleanCompletion c) { continueLoop(c.getDual()) }
}

private class WhileLoop extends ConditionalLoopAstNode, While {
  override UnderscoreStatement getConditionNode() { result = this.getCondition() }

  override Do getBodyNode() { result = this.getBody() }
}

private class WhileModifierLoop extends ConditionalLoopAstNode, WhileModifier {
  override AstNode getConditionNode() { result = this.getCondition() }

  override UnderscoreStatement getBodyNode() { result = this.getBody() }
}

private class UntilLoop extends ConditionalLoopAstNode, Until {
  override UnderscoreStatement getConditionNode() { result = this.getCondition() }

  override Do getBodyNode() { result = this.getBody() }

  override predicate continueLoop(BooleanCompletion c) { c instanceof FalseCompletion }
}

private class UntilModifierLoop extends ConditionalLoopAstNode, UntilModifier {
  override AstNode getConditionNode() { result = this.getCondition() }

  override UnderscoreStatement getBodyNode() { result = this.getBody() }

  override predicate continueLoop(BooleanCompletion c) { c instanceof FalseCompletion }
}

class ParenthesizedStatement extends ParenthesizedStatements {
  ParenthesizedStatement() { strictcount(int i | exists(this.getChild(i))) = 1 }

  AstNode getChild() { result = this.getChild(0) }
}
