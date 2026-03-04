/**
 * Provides classes for PHP statements.
 */

private import codeql.php.AST
private import internal.TreeSitter

/** A statement. */
class Stmt extends AstNode, @php_statement {
  override string getAPrimaryQlClass() { result = "Stmt" }
}

/** An expression statement. */
class ExprStmt extends Stmt, @php_expression_statement {
  override string getAPrimaryQlClass() { result = "ExprStmt" }

  /** Gets the expression. */
  Expr getExpr() { php_expression_statement_def(this, result) }

  override string toString() { result = "...;" }
}

/** A compound (block) statement. */
class CompoundStmt extends Stmt, @php_compound_statement {
  override string getAPrimaryQlClass() { result = "CompoundStmt" }

  Stmt getStatement(int i) { php_compound_statement_child(this, i, result) }

  Stmt getAStatement() { result = this.getStatement(_) }

  int getNumberOfStatements() {
    result = count(int i | php_compound_statement_child(this, i, _))
  }

  override string toString() { result = "{ ... }" }
}

/** An empty statement (`;`). */
class EmptyStmt extends Stmt, @php_token_empty_statement {
  override string getAPrimaryQlClass() { result = "EmptyStmt" }

  override string toString() { result = ";" }
}

/** A return statement. */
class ReturnStmt extends Stmt, @php_return_statement {
  override string getAPrimaryQlClass() { result = "ReturnStmt" }

  /** Gets the return value, if any. */
  Expr getValue() { php_return_statement_child(this, result) }

  /** Holds if this return statement has a value. */
  predicate hasValue() { exists(this.getValue()) }

  override string toString() { result = "return ..." }
}

/** A break statement. */
class BreakStmt extends Stmt, @php_break_statement {
  override string getAPrimaryQlClass() { result = "BreakStmt" }

  override string toString() { result = "break" }
}

/** A continue statement. */
class ContinueStmt extends Stmt, @php_continue_statement {
  override string getAPrimaryQlClass() { result = "ContinueStmt" }

  override string toString() { result = "continue" }
}

/** A goto statement. */
class GotoStmt extends Stmt, @php_goto_statement {
  override string getAPrimaryQlClass() { result = "GotoStmt" }

  Name getLabel() { php_goto_statement_def(this, result) }

  override string toString() { result = "goto ..." }
}

/** A named label statement. */
class LabelStmt extends Stmt, @php_named_label_statement {
  override string getAPrimaryQlClass() { result = "LabelStmt" }

  Name getName() { php_named_label_statement_def(this, result) }

  override string toString() { result = "label:" }
}

/** An echo statement. */
class EchoStmt extends Stmt, @php_echo_statement {
  override string getAPrimaryQlClass() { result = "EchoStmt" }

  /** Gets the child expression (may be a sequence_expression for multiple args). */
  AstNode getExpression() { php_echo_statement_def(this, result) }

  /** Gets an output expression of this echo statement. */
  AstNode getAnOutputExpression() {
    // Single expression: echo $x;
    php_echo_statement_def(this, result) and not result instanceof @php_sequence_expression
    or
    // Sequence expression: echo $x, $y;
    exists(@php_sequence_expression seq |
      php_echo_statement_def(this, seq) and
      php_sequence_expression_child(seq, _, result)
    )
  }

  /** Gets an argument expression (alias for getAnOutputExpression). */
  AstNode getAnArgument() { result = this.getAnOutputExpression() }

  override string toString() { result = "echo ..." }
}

/** An unset statement. */
class UnsetStmt extends Stmt, @php_unset_statement {
  override string getAPrimaryQlClass() { result = "UnsetStmt" }

  AstNode getExpression(int i) { php_unset_statement_child(this, i, result) }

  AstNode getAnExpression() { result = this.getExpression(_) }

  override string toString() { result = "unset(...)" }
}

/** A global variable declaration. */
class GlobalDeclaration extends Stmt, @php_global_declaration {
  override string getAPrimaryQlClass() { result = "GlobalDeclaration" }

  AstNode getVariable(int i) { php_global_declaration_child(this, i, result) }

  AstNode getAVariable() { result = this.getVariable(_) }

  override string toString() { result = "global ..." }
}

/** A namespace definition. */
class NamespaceDefinition extends Stmt, @php_namespace_definition {
  override string getAPrimaryQlClass() { result = "NamespaceDefinition" }

  NamespaceName getNamespaceName() { php_namespace_definition_name(this, result) }

  CompoundStmt getBody() { php_namespace_definition_body(this, result) }

  override string toString() { result = "namespace ..." }
}

/** A namespace use declaration (`use ...`). */
class NamespaceUseDeclaration extends Stmt, @php_namespace_use_declaration {
  override string getAPrimaryQlClass() { result = "NamespaceUseDeclaration" }

  override string toString() { result = "use ..." }
}

/** A declare statement. */
class DeclareStmt extends Stmt, @php_declare_statement {
  override string getAPrimaryQlClass() { result = "DeclareStmt" }

  override string toString() { result = "declare(...)" }
}
