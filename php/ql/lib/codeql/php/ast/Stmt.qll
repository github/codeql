/**
 * Provides classes for working with PHP statements.
 *
 * This module builds on top of the auto-generated TreeSitter classes
 * to provide a more convenient API for statement analysis.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.Locations as L

/**
 * A statement in PHP.
 */
class Stmt extends TS::PHP::Statement {
  /** Gets the location of this statement. */
  L::Location getLocation() { result = super.getLocation() }
}

/**
 * A compound statement (block of statements in braces).
 */
class BlockStmt extends TS::PHP::CompoundStatement {
  /** Gets the i-th statement in this block. */
  Stmt getStmt(int i) { result = this.getChild(i) }

  /** Gets any statement in this block. */
  Stmt getAStmt() { result = this.getChild(_) }

  /** Gets the number of statements in this block. */
  int getNumStmts() { result = count(this.getAStmt()) }
}

/**
 * An expression statement (expression followed by semicolon).
 */
class ExprStmt extends TS::PHP::ExpressionStatement {
  /** Gets the expression. */
  TS::PHP::Expression getExpr() { result = this.getChild() }
}

/**
 * A return statement.
 */
class ReturnStmt extends TS::PHP::ReturnStatement {
  /** Gets the returned expression, if any. */
  TS::PHP::Expression getExpr() { result = this.getChild() }

  /** Holds if this return statement has an expression. */
  predicate hasExpr() { exists(this.getChild()) }
}

/**
 * An echo statement.
 */
class EchoStmt extends TS::PHP::EchoStatement {
  /** Gets the expression being echoed. */
  TS::PHP::AstNode getExpr() { result = this.getChild() }
}

/**
 * An if statement.
 */
class IfStmt extends TS::PHP::IfStatement {
  /** Gets the condition (wrapped in parentheses). */
  TS::PHP::ParenthesizedExpression getConditionNode() { result = this.getCondition() }

  /** Gets the condition expression. */
  TS::PHP::Expression getConditionExpr() { result = this.getConditionNode().getChild() }

  /** Gets the 'then' branch. */
  TS::PHP::AstNode getThenBranch() { result = this.getBody() }

  /** Gets the i-th elseif clause. */
  TS::PHP::ElseIfClause getElseIfClause(int i) { result = this.getAlternative(i) }

  /** Gets the else clause, if any. */
  TS::PHP::ElseClause getElseClause() { result = this.getAlternative(_) }

  /** Holds if this if statement has an else clause. */
  predicate hasElse() { exists(this.getElseClause()) }
}

/**
 * An else-if clause.
 */
class ElseIfClause extends TS::PHP::ElseIfClause {
  /** Gets the condition (wrapped in parentheses). */
  TS::PHP::ParenthesizedExpression getConditionNode() { result = this.getCondition() }

  /** Gets the condition expression. */
  TS::PHP::Expression getConditionExpr() { result = this.getConditionNode().getChild() }

  /** Gets the body. */
  TS::PHP::AstNode getBodyNode() { result = this.getBody() }
}

/**
 * An else clause.
 */
class ElseClause extends TS::PHP::ElseClause {
  /** Gets the body. */
  TS::PHP::AstNode getBodyNode() { result = this.getBody() }
}

/**
 * A while statement.
 */
class WhileStmt extends TS::PHP::WhileStatement {
  /** Gets the condition (wrapped in parentheses). */
  TS::PHP::ParenthesizedExpression getConditionNode() { result = this.getCondition() }

  /** Gets the condition expression. */
  TS::PHP::Expression getConditionExpr() { result = this.getConditionNode().getChild() }

  /** Gets the loop body. */
  TS::PHP::AstNode getBodyNode() { result = this.getBody() }
}

/**
 * A do-while statement.
 */
class DoWhileStmt extends TS::PHP::DoStatement {
  /** Gets the condition (wrapped in parentheses). */
  TS::PHP::ParenthesizedExpression getConditionNode() { result = this.getCondition() }

  /** Gets the condition expression. */
  TS::PHP::Expression getConditionExpr() { result = this.getConditionNode().getChild() }

  /** Gets the loop body. */
  TS::PHP::Statement getBodyStmt() { result = this.getBody() }
}

/**
 * A for statement.
 */
class ForStmt extends TS::PHP::ForStatement {
  /** Gets the initialization expression. */
  TS::PHP::AstNode getInit() { result = this.getInitialize() }

  /** Gets the condition expression. */
  TS::PHP::AstNode getConditionExpr() { result = super.getCondition() }

  /** Gets the update expression. */
  TS::PHP::AstNode getUpdateExpr() { result = super.getUpdate() }

  /** Gets the i-th body statement. */
  TS::PHP::Statement getBodyStmt(int i) { result = this.getBody(i) }

  /** Gets any body statement. */
  TS::PHP::Statement getABodyStmt() { result = this.getBody(_) }
}

/**
 * A foreach statement.
 */
class ForeachStmt extends TS::PHP::ForeachStatement {
  /** Gets the array/iterable expression. */
  TS::PHP::AstNode getIterableExpr() { result = this.getChild(0) }

  /** Gets the value variable (or list pattern). */
  TS::PHP::AstNode getValueVar() { result = this.getChild(1) }

  /** Gets the key variable, if any (for foreach($arr as $k => $v)). */
  TS::PHP::AstNode getKeyVar() {
    exists(TS::PHP::Pair p | p = this.getChild(1) | result = p.getChild(0))
  }

  /** Gets the loop body. */
  TS::PHP::AstNode getBodyNode() { result = this.getBody() }
}

/**
 * A switch statement.
 */
class SwitchStmt extends TS::PHP::SwitchStatement {
  /** Gets the condition (wrapped in parentheses). */
  TS::PHP::ParenthesizedExpression getConditionNode() { result = this.getCondition() }

  /** Gets the condition expression. */
  TS::PHP::Expression getConditionExpr() { result = this.getConditionNode().getChild() }

  /** Gets the switch block containing cases. */
  TS::PHP::SwitchBlock getSwitchBlock() { result = this.getBody() }
}

/**
 * A case statement in a switch.
 */
class CaseStmt extends TS::PHP::CaseStatement {
  /** Gets the case value expression. */
  TS::PHP::Expression getCaseValue() { result = this.getValue() }

  /** Gets the i-th statement in this case. */
  Stmt getStmt(int i) { result = this.getChild(i) }

  /** Gets any statement in this case. */
  Stmt getAStmt() { result = this.getChild(_) }
}

/**
 * A default statement in a switch.
 */
class DefaultStmt extends TS::PHP::DefaultStatement {
  /** Gets the i-th statement in this default case. */
  Stmt getStmt(int i) { result = this.getChild(i) }

  /** Gets any statement in this default case. */
  Stmt getAStmt() { result = this.getChild(_) }
}

/**
 * A try statement.
 */
class TryStmt extends TS::PHP::TryStatement {
  /** Gets the try block body. */
  TS::PHP::CompoundStatement getTryBlock() { result = this.getBody() }

  /** Gets a catch clause. */
  TS::PHP::CatchClause getACatchClause() { result = this.getChild(_) }

  /** Gets the finally clause, if any. */
  TS::PHP::FinallyClause getFinallyClause() { result = this.getChild(_) }

  /** Holds if this try has a finally clause. */
  predicate hasFinally() { exists(this.getFinallyClause()) }
}

/**
 * A catch clause.
 */
class CatchClause extends TS::PHP::CatchClause {
  /** Gets the exception type list. */
  TS::PHP::TypeList getExceptionTypes() { result = this.getType() }

  /** Gets the exception variable, if any. */
  TS::PHP::VariableName getExceptionVar() { result = this.getName() }

  /** Gets the catch block body. */
  TS::PHP::CompoundStatement getCatchBlock() { result = this.getBody() }
}

/**
 * A finally clause.
 */
class FinallyClause extends TS::PHP::FinallyClause {
  /** Gets the finally block body. */
  TS::PHP::CompoundStatement getFinallyBlock() { result = this.getBody() }
}

/**
 * A break statement.
 */
class BreakStmt extends TS::PHP::BreakStatement {
  /** Gets the break level expression, if any. */
  TS::PHP::Expression getLevel() { result = this.getChild() }

  /** Holds if this has a break level. */
  predicate hasLevel() { exists(this.getChild()) }
}

/**
 * A continue statement.
 */
class ContinueStmt extends TS::PHP::ContinueStatement {
  /** Gets the continue level expression, if any. */
  TS::PHP::Expression getLevel() { result = this.getChild() }

  /** Holds if this has a continue level. */
  predicate hasLevel() { exists(this.getChild()) }
}

/**
 * A goto statement.
 */
class GotoStmt extends TS::PHP::GotoStatement {
  /** Gets the target label name. */
  TS::PHP::Name getLabelName() { result = this.getChild() }

  /** Gets the label name as a string. */
  string getLabel() { result = this.getLabelName().getValue() }
}

/**
 * A named label statement.
 */
class LabelStmt extends TS::PHP::NamedLabelStatement {
  /** Gets the label name. */
  TS::PHP::Name getLabelName() { result = this.getChild() }

  /** Gets the label name as a string. */
  string getLabel() { result = this.getLabelName().getValue() }
}

/**
 * A global declaration statement.
 */
class GlobalStmt extends TS::PHP::GlobalDeclaration {
  /** Gets the i-th variable. */
  TS::PHP::AstNode getVariable(int i) { result = this.getChild(i) }

  /** Gets any variable in this declaration. */
  TS::PHP::AstNode getAVariable() { result = this.getChild(_) }
}

/**
 * A function static variable declaration.
 */
class FunctionStaticStmt extends TS::PHP::FunctionStaticDeclaration {
  /** Gets the i-th static variable declaration. */
  TS::PHP::StaticVariableDeclaration getDeclaration(int i) { result = this.getChild(i) }

  /** Gets any static variable declaration. */
  TS::PHP::StaticVariableDeclaration getADeclaration() { result = this.getChild(_) }
}

/**
 * An unset statement.
 */
class UnsetStmt extends TS::PHP::UnsetStatement {
  /** Gets the i-th variable being unset. */
  TS::PHP::AstNode getVariable(int i) { result = this.getChild(i) }

  /** Gets any variable being unset. */
  TS::PHP::AstNode getAVariable() { result = this.getChild(_) }
}

/**
 * A declare statement.
 */
class DeclareStmt extends TS::PHP::DeclareStatement {
  /** Gets the i-th child (directive or body). */
  TS::PHP::AstNode getChildNode(int i) { result = this.getChild(i) }
}

/**
 * An exit/die statement.
 */
class ExitStmt extends TS::PHP::ExitStatement {
  /** Gets the exit code/message expression, if any. */
  TS::PHP::Expression getExpr() { result = this.getChild() }

  /** Holds if this has an exit expression. */
  predicate hasExpr() { exists(this.getChild()) }
}

/**
 * An empty statement (just a semicolon).
 */
class EmptyStmt extends TS::PHP::EmptyStatement {
}
