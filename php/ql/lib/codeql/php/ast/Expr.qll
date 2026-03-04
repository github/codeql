/**
 * Provides classes for PHP expressions.
 */

private import codeql.php.AST
private import internal.TreeSitter

/** An expression. */
class Expr extends AstNode, @php_expression {
  override string getAPrimaryQlClass() { result = "Expr" }
}

/** An assignment expression (`$x = expr`). */
class AssignExpr extends Expr, @php_assignment_expression {
  override string getAPrimaryQlClass() { result = "AssignExpr" }

  /** Gets the left-hand side (target) of the assignment. */
  AstNode getLeftOperand() { php_assignment_expression_def(this, result, _) }

  /** Gets the right-hand side (value) of the assignment. */
  Expr getRightOperand() { php_assignment_expression_def(this, _, result) }

  override string toString() { result = "... = ..." }
}

/** A reference assignment expression (`$x =& expr`). */
class RefAssignExpr extends Expr, @php_reference_assignment_expression {
  override string getAPrimaryQlClass() { result = "RefAssignExpr" }

  Expr getLeftOperand() { php_reference_assignment_expression_def(this, result, _) }

  Expr getRightOperand() { php_reference_assignment_expression_def(this, _, result) }

  override string toString() { result = "... =& ..." }
}

/** An augmented assignment expression (`$x += expr`, `$x .= expr`, etc.). */
class AugmentedAssignExpr extends Expr, @php_augmented_assignment_expression {
  override string getAPrimaryQlClass() { result = "AugmentedAssignExpr" }

  AstNode getLeftOperand() { php_augmented_assignment_expression_def(this, result, _, _) }

  string getOperator() { result = this.(Php::AugmentedAssignmentExpression).getOperator() }

  Expr getRightOperand() { php_augmented_assignment_expression_def(this, _, _, result) }

  override string toString() { result = "... " + this.getOperator() + " ..." }
}

/** A binary expression (`$x + $y`, `$x . $y`, etc.). */
class BinaryExpr extends Expr, @php_binary_expression {
  override string getAPrimaryQlClass() { result = "BinaryExpr" }

  Expr getLeftOperand() { php_binary_expression_def(this, result, _, _) }

  string getOperator() { result = this.(Php::BinaryExpression).getOperator() }

  Expr getRightOperand() { php_binary_expression_def(this, _, _, result) }

  override string toString() { result = "... " + this.getOperator() + " ..." }
}

/** A unary expression (`!$x`, `-$x`, `~$x`). */
class UnaryExpr extends Expr, @php_unary_op_expression {
  override string getAPrimaryQlClass() { result = "UnaryExpr" }

  string getOperator() {
    exists(AstNode op |
      php_unary_op_expression_operator(this, op) and
      php_tokeninfo(op, _, result)
    )
  }

  Expr getOperand() { php_unary_op_expression_argument(this, result) }

  override string toString() { result = this.getOperator() + "..." }
}

/** An update expression (`$x++`, `$x--`, `++$x`, `--$x`). */
class UpdateExpr extends Expr, @php_update_expression {
  override string getAPrimaryQlClass() { result = "UpdateExpr" }

  AstNode getArgument() { php_update_expression_def(this, result, _) }

  string getOperator() { result = this.(Php::UpdateExpression).getOperator() }

  predicate isPrefix() { this.(Php::UpdateExpression).toString() = this.(Php::UpdateExpression).toString() }

  override string toString() { result = this.getOperator() + "..." }
}

/** A conditional (ternary) expression (`$x ? $y : $z`). */
class ConditionalExpr extends Expr, @php_conditional_expression {
  override string getAPrimaryQlClass() { result = "ConditionalExpr" }

  Expr getCondition() { php_conditional_expression_def(this, _, result) }

  Expr getConsequence() { php_conditional_expression_body(this, result) }

  Expr getAlternative() { php_conditional_expression_def(this, result, _) }

  override string toString() { result = "... ? ... : ..." }
}

/** A cast expression (`(int)$x`, `(string)$x`, etc.). */
class CastExpr extends Expr, @php_cast_expression {
  override string getAPrimaryQlClass() { result = "CastExpr" }

  AstNode getCastType() { php_cast_expression_def(this, result, _) }

  AstNode getValue() { php_cast_expression_def(this, _, result) }

  override string toString() { result = "(cast)..." }
}

/** An error suppression expression (`@expr`). */
class ErrorSuppressExpr extends Expr, @php_error_suppression_expression {
  override string getAPrimaryQlClass() { result = "ErrorSuppressExpr" }

  Expr getExpr() { php_error_suppression_expression_def(this, result) }

  override string toString() { result = "@..." }
}

/** A clone expression (`clone $x`). */
class CloneExpr extends Expr, @php_clone_expression {
  override string getAPrimaryQlClass() { result = "CloneExpr" }

  Expr getExpr() { php_clone_expression_def(this, result) }

  override string toString() { result = "clone ..." }
}

/** A throw expression (`throw $x`). */
class ThrowExpr extends Expr, @php_throw_expression {
  override string getAPrimaryQlClass() { result = "ThrowExpr" }

  Expr getExpr() { php_throw_expression_def(this, result) }

  override string toString() { result = "throw ..." }
}

/** A parenthesized expression (`(expr)`). */
class ParenExpr extends Expr, @php_parenthesized_expression {
  override string getAPrimaryQlClass() { result = "ParenExpr" }

  Expr getExpr() { php_parenthesized_expression_def(this, result) }

  override string toString() { result = "(...)" }
}

/** An array creation expression (`[1, 2, 3]` or `array(1, 2, 3)`). */
class ArrayCreationExpr extends Expr, @php_array_creation_expression {
  override string getAPrimaryQlClass() { result = "ArrayCreationExpr" }

  ArrayElementInitializer getElement(int i) {
    php_array_creation_expression_child(this, i, result)
  }

  ArrayElementInitializer getAnElement() { result = this.getElement(_) }

  int getNumberOfElements() {
    result = count(int i | php_array_creation_expression_child(this, i, _))
  }

  override string toString() { result = "array(...)" }
}

/** An array element initializer. */
class ArrayElementInitializer extends AstNode, @php_array_element_initializer {
  override string getAPrimaryQlClass() { result = "ArrayElementInitializer" }

  override AstNode getChild(int i) { php_array_element_initializer_child(this, i, result) }

  override string toString() { result = "... => ..." }
}

/** A subscript (array access) expression (`$x[0]`). */
class SubscriptExpr extends Expr, @php_subscript_expression {
  override string getAPrimaryQlClass() { result = "SubscriptExpr" }

  AstNode getObject() { php_subscript_expression_child(this, 0, result) }

  AstNode getIndexExpr() { php_subscript_expression_child(this, 1, result) }

  override string toString() { result = "...[...]" }
}

/** A member access expression (`$obj->prop`). */
class MemberAccessExpr extends Expr, @php_member_access_expression {
  override string getAPrimaryQlClass() { result = "MemberAccessExpr" }

  AstNode getObject() { php_member_access_expression_def(this, _, result) }

  Name getName() { php_member_access_expression_def(this, result, _) }

  override string toString() { result = "...->..." }
}

/** A nullsafe member access expression (`$obj?->prop`). */
class NullsafeMemberAccessExpr extends Expr, @php_nullsafe_member_access_expression {
  override string getAPrimaryQlClass() { result = "NullsafeMemberAccessExpr" }

  AstNode getObject() { php_nullsafe_member_access_expression_def(this, _, result) }

  Name getName() { php_nullsafe_member_access_expression_def(this, result, _) }

  override string toString() { result = "...?->..." }
}

/** A scoped property access expression (`ClassName::$prop`). */
class ScopedPropertyAccessExpr extends Expr, @php_scoped_property_access_expression {
  override string getAPrimaryQlClass() { result = "ScopedPropertyAccessExpr" }

  AstNode getScope() { php_scoped_property_access_expression_def(this, _, result) }

  VariableName getName() { php_scoped_property_access_expression_def(this, result, _) }

  override string toString() { result = "...::$..." }
}

/** A class constant access expression (`ClassName::CONST`). */
class ClassConstantAccessExpr extends Expr, @php_class_constant_access_expression {
  override string getAPrimaryQlClass() { result = "ClassConstantAccessExpr" }

  AstNode getScope() { php_class_constant_access_expression_child(this, 0, result) }

  Name getName() { php_class_constant_access_expression_child(this, 1, result) }

  override string toString() { result = "...::..." }
}

/** An `include` expression. */
class IncludeExpr extends Expr, @php_include_expression {
  override string getAPrimaryQlClass() { result = "IncludeExpr" }

  Expr getArgument() { php_include_expression_def(this, result) }

  override string toString() { result = "include ..." }
}

/** An `include_once` expression. */
class IncludeOnceExpr extends Expr, @php_include_once_expression {
  override string getAPrimaryQlClass() { result = "IncludeOnceExpr" }

  Expr getArgument() { php_include_once_expression_def(this, result) }

  override string toString() { result = "include_once ..." }
}

/** A `require` expression. */
class RequireExpr extends Expr, @php_require_expression {
  override string getAPrimaryQlClass() { result = "RequireExpr" }

  Expr getArgument() { php_require_expression_def(this, result) }

  override string toString() { result = "require ..." }
}

/** A `require_once` expression. */
class RequireOnceExpr extends Expr, @php_require_once_expression {
  override string getAPrimaryQlClass() { result = "RequireOnceExpr" }

  Expr getArgument() { php_require_once_expression_def(this, result) }

  override string toString() { result = "require_once ..." }
}

/** An object creation expression (`new ClassName(...)`). */
class ObjectCreationExpr extends Expr, @php_object_creation_expression {
  override string getAPrimaryQlClass() { result = "ObjectCreationExpr" }

  override AstNode getChild(int i) { php_object_creation_expression_child(this, i, result) }

  override string toString() { result = "new ..." }
}

/** A `yield` expression. */
class YieldExpr extends Expr, @php_yield_expression {
  override string getAPrimaryQlClass() { result = "YieldExpr" }

  AstNode getChild() { php_yield_expression_child(this, result) }

  override string toString() { result = "yield ..." }
}

/** A `print` expression. */
class PrintExpr extends Expr, @php_print_intrinsic {
  override string getAPrimaryQlClass() { result = "PrintExpr" }

  Expr getArgument() { php_print_intrinsic_def(this, result) }

  override string toString() { result = "print ..." }
}

/** A shell command expression (backtick operator). */
class ShellCommandExpr extends Expr, @php_shell_command_expression {
  override string getAPrimaryQlClass() { result = "ShellCommandExpr" }

  /** Gets the i-th child element (interpolated parts). */
  AstNode getElement(int i) { php_shell_command_expression_child(this, i, result) }

  override string toString() { result = "`...`" }
}

/** A dynamic variable name expression (`$$var`). */
class DynamicVariableNameExpr extends Expr, @php_dynamic_variable_name {
  override string getAPrimaryQlClass() { result = "DynamicVariableNameExpr" }

  AstNode getNameExpr() { php_dynamic_variable_name_def(this, result) }

  override string toString() { result = "$$..." }
}

/** A variadic unpacking expression (`...$arr`). */
class VariadicUnpackingExpr extends AstNode, @php_variadic_unpacking {
  override string getAPrimaryQlClass() { result = "VariadicUnpackingExpr" }

  Expr getExpr() { php_variadic_unpacking_def(this, result) }

  override string toString() { result = "...expr" }
}

/** A match expression. */
class MatchExpr extends Expr, @php_match_expression {
  override string getAPrimaryQlClass() { result = "MatchExpr" }

  override string toString() { result = "match ..." }
}

/** An arguments list. */
class Arguments extends AstNode, @php_arguments {
  override string getAPrimaryQlClass() { result = "Arguments" }

  AstNode getArgument(int i) { php_arguments_child(this, i, result) }

  AstNode getAnArgument() { result = this.getArgument(_) }

  int getNumberOfArguments() { result = count(int i | php_arguments_child(this, i, _)) }

  override string toString() { result = "(...)" }
}
