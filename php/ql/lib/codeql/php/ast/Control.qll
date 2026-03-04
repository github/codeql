/**
 * Provides classes for PHP control flow statements.
 */

private import codeql.php.AST
private import internal.TreeSitter

/** An if statement. */
class IfStmt extends Stmt, @php_if_statement {
  override string getAPrimaryQlClass() { result = "IfStmt" }

  /** Gets the condition (a parenthesized expression). */
  AstNode getCondition() { php_if_statement_def(this, _, result) }

  /** Gets the then branch. */
  AstNode getThen() { php_if_statement_def(this, result, _) }

  /** Gets the `i`th alternative (elseif or else clause). */
  AstNode getAlternative(int i) { php_if_statement_alternative(this, i, result) }

  /** Gets an alternative clause. */
  AstNode getAnAlternative() { result = this.getAlternative(_) }

  override string toString() { result = "if (...) ..." }
}

/** An elseif clause. */
class ElseIfClause extends AstNode, @php_else_if_clause {
  override string getAPrimaryQlClass() { result = "ElseIfClause" }

  AstNode getCondition() { php_else_if_clause_def(this, _, result) }

  AstNode getBody() { php_else_if_clause_def(this, result, _) }

  override string toString() { result = "elseif (...) ..." }
}

/** A switch statement. */
class SwitchStmt extends Stmt, @php_switch_statement {
  override string getAPrimaryQlClass() { result = "SwitchStmt" }

  AstNode getCondition() { php_switch_statement_def(this, _, result) }

  override string toString() { result = "switch (...) ..." }
}

/** A case statement within a switch. */
class CaseStmt extends AstNode, @php_case_statement {
  override string getAPrimaryQlClass() { result = "CaseStmt" }

  Expr getValue() { php_case_statement_def(this, result) }

  Stmt getStatement(int i) { php_case_statement_child(this, i, result) }

  Stmt getAStatement() { result = this.getStatement(_) }

  override string toString() { result = "case ...:" }
}

/** A default statement within a switch. */
class DefaultStmt extends AstNode, @php_default_statement {
  override string getAPrimaryQlClass() { result = "DefaultStmt" }

  Stmt getStatement(int i) { php_default_statement_child(this, i, result) }

  Stmt getAStatement() { result = this.getStatement(_) }

  override string toString() { result = "default:" }
}

/** A while statement. */
class WhileStmt extends Stmt, @php_while_statement {
  override string getAPrimaryQlClass() { result = "WhileStmt" }

  AstNode getCondition() { php_while_statement_def(this, _, result) }

  AstNode getBody() { php_while_statement_def(this, result, _) }

  override string toString() { result = "while (...) ..." }
}

/** A do-while statement. */
class DoWhileStmt extends Stmt, @php_do_statement {
  override string getAPrimaryQlClass() { result = "DoWhileStmt" }

  Stmt getBody() { php_do_statement_def(this, result, _) }

  AstNode getCondition() { php_do_statement_def(this, _, result) }

  override string toString() { result = "do ... while (...)" }
}

/** A for statement. */
class ForStmt extends Stmt, @php_for_statement {
  override string getAPrimaryQlClass() { result = "ForStmt" }

  AstNode getInitialize() { php_for_statement_initialize(this, result) }

  AstNode getCondition() { php_for_statement_condition(this, result) }

  AstNode getUpdate() { php_for_statement_update(this, result) }

  Stmt getBodyStmt(int i) { php_for_statement_body(this, i, result) }

  Stmt getABodyStmt() { result = this.getBodyStmt(_) }

  override string toString() { result = "for (...) ..." }
}

/** A foreach statement. */
class ForeachStmt extends Stmt, @php_foreach_statement {
  override string getAPrimaryQlClass() { result = "ForeachStmt" }

  override AstNode getChild(int i) { php_foreach_statement_child(this, i, result) }

  AstNode getBody() { php_foreach_statement_body(this, result) }

  override string toString() { result = "foreach (...) ..." }
}

/** A try statement. */
class TryStmt extends Stmt, @php_try_statement {
  override string getAPrimaryQlClass() { result = "TryStmt" }

  CompoundStmt getBody() { php_try_statement_def(this, result) }

  override AstNode getChild(int i) { php_try_statement_child(this, i, result) }

  CatchClause getCatch(int i) { php_try_statement_child(this, i, result) }

  CatchClause getACatch() { result = this.getCatch(_) }

  FinallyClause getFinally() { php_try_statement_child(this, _, result) }

  predicate hasFinally() { exists(this.getFinally()) }

  override string toString() { result = "try { ... }" }
}

/** A catch clause. */
class CatchClause extends AstNode, @php_catch_clause {
  override string getAPrimaryQlClass() { result = "CatchClause" }

  CompoundStmt getBody() { php_catch_clause_def(this, result, _) }

  VariableName getVariable() { php_catch_clause_name(this, result) }

  override string toString() { result = "catch (...) { ... }" }
}

/** A finally clause. */
class FinallyClause extends AstNode, @php_finally_clause {
  override string getAPrimaryQlClass() { result = "FinallyClause" }

  CompoundStmt getBody() { php_finally_clause_def(this, result) }

  override string toString() { result = "finally { ... }" }
}
