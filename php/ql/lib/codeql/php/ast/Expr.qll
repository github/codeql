/**
 * Provides classes for working with PHP expressions.
 *
 * This module builds on top of the auto-generated TreeSitter classes
 * to provide a more convenient API for expression analysis.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.Locations as L

/**
 * An expression in PHP.
 */
class Expr extends TS::PHP::Expression {
  /** Gets the location of this expression. */
  L::Location getLocation() { result = super.getLocation() }
}

/**
 * A binary operation expression (e.g., $a + $b, $x && $y).
 */
class BinaryOp extends TS::PHP::BinaryExpression {
  /** Gets the left operand. */
  Expr getLeftOperand() { result = this.getLeft() }

  /** Gets the right operand. */
  TS::PHP::AstNode getRightOperand() { result = this.getRight() }

  /** Gets the operator as a string. */
  string getOperatorString() { result = this.getOperator() }
}

/**
 * An arithmetic operation (+, -, *, /, %, **).
 */
class ArithmeticOp extends BinaryOp {
  ArithmeticOp() {
    this.getOperator() in ["+", "-", "*", "/", "%", "**"]
  }
}

/**
 * An addition operation.
 */
class AddOp extends ArithmeticOp {
  AddOp() { this.getOperator() = "+" }
}

/**
 * A subtraction operation.
 */
class SubOp extends ArithmeticOp {
  SubOp() { this.getOperator() = "-" }
}

/**
 * A multiplication operation.
 */
class MulOp extends ArithmeticOp {
  MulOp() { this.getOperator() = "*" }
}

/**
 * A division operation.
 */
class DivOp extends ArithmeticOp {
  DivOp() { this.getOperator() = "/" }
}

/**
 * A modulo operation.
 */
class ModOp extends ArithmeticOp {
  ModOp() { this.getOperator() = "%" }
}

/**
 * An exponentiation operation.
 */
class PowOp extends ArithmeticOp {
  PowOp() { this.getOperator() = "**" }
}

/**
 * A comparison operation (==, !=, ===, !==, <, >, <=, >=, <=>).
 */
class ComparisonOp extends BinaryOp {
  ComparisonOp() {
    this.getOperator() in ["==", "!=", "===", "!==", "<", ">", "<=", ">=", "<=>", "<>"]
  }
}

/**
 * An equality comparison (== or ===).
 */
class EqualityOp extends ComparisonOp {
  EqualityOp() { this.getOperator() in ["==", "==="] }

  /** Holds if this is a strict equality check (===). */
  predicate isStrict() { this.getOperator() = "===" }
}

/**
 * An inequality comparison (!= or !==).
 */
class InequalityOp extends ComparisonOp {
  InequalityOp() { this.getOperator() in ["!=", "!==", "<>"] }

  /** Holds if this is a strict inequality check (!==). */
  predicate isStrict() { this.getOperator() = "!==" }
}

/**
 * A less-than comparison.
 */
class LtOp extends ComparisonOp {
  LtOp() { this.getOperator() = "<" }
}

/**
 * A greater-than comparison.
 */
class GtOp extends ComparisonOp {
  GtOp() { this.getOperator() = ">" }
}

/**
 * A less-than-or-equal comparison.
 */
class LeOp extends ComparisonOp {
  LeOp() { this.getOperator() = "<=" }
}

/**
 * A greater-than-or-equal comparison.
 */
class GeOp extends ComparisonOp {
  GeOp() { this.getOperator() = ">=" }
}

/**
 * A spaceship comparison (<=>).
 */
class SpaceshipOp extends ComparisonOp {
  SpaceshipOp() { this.getOperator() = "<=>" }
}

/**
 * A logical operation (&&, ||, and, or, xor).
 */
class LogicalOp extends BinaryOp {
  LogicalOp() {
    this.getOperator() in ["&&", "||", "and", "or", "xor"]
  }
}

/**
 * A logical AND operation (&& or and).
 */
class LogicalAndOp extends LogicalOp {
  LogicalAndOp() { this.getOperator() in ["&&", "and"] }
}

/**
 * A logical OR operation (|| or or).
 */
class LogicalOrOp extends LogicalOp {
  LogicalOrOp() { this.getOperator() in ["||", "or"] }
}

/**
 * A logical XOR operation.
 */
class LogicalXorOp extends LogicalOp {
  LogicalXorOp() { this.getOperator() = "xor" }
}

/**
 * A bitwise operation (&, |, ^, <<, >>).
 */
class BitwiseOp extends BinaryOp {
  BitwiseOp() {
    this.getOperator() in ["&", "|", "^", "<<", ">>"]
  }
}

/**
 * A bitwise AND operation.
 */
class BitwiseAndOp extends BitwiseOp {
  BitwiseAndOp() { this.getOperator() = "&" }
}

/**
 * A bitwise OR operation.
 */
class BitwiseOrOp extends BitwiseOp {
  BitwiseOrOp() { this.getOperator() = "|" }
}

/**
 * A bitwise XOR operation.
 */
class BitwiseXorOp extends BitwiseOp {
  BitwiseXorOp() { this.getOperator() = "^" }
}

/**
 * A left shift operation.
 */
class LeftShiftOp extends BitwiseOp {
  LeftShiftOp() { this.getOperator() = "<<" }
}

/**
 * A right shift operation.
 */
class RightShiftOp extends BitwiseOp {
  RightShiftOp() { this.getOperator() = ">>" }
}

/**
 * A string concatenation operation (.).
 */
class ConcatOp extends BinaryOp {
  ConcatOp() { this.getOperator() = "." }
}

/**
 * A null coalescing operation (??).
 */
class NullCoalesceOp extends BinaryOp {
  NullCoalesceOp() { this.getOperator() = "??" }
}

/**
 * An instanceof expression.
 */
class InstanceofExpr extends BinaryOp {
  InstanceofExpr() { this.getOperator() = "instanceof" }

  /** Gets the expression being tested. */
  Expr getExpr() { result = this.getLeft() }

  /** Gets the class being tested against. */
  TS::PHP::AstNode getClassExpr() { result = this.getRight() }
}

/**
 * A unary operation expression.
 */
class UnaryOp extends TS::PHP::UnaryOpExpression {
  /** Gets the operand. */
  Expr getOperand() { result = this.getArgument() }

  /** Gets the operator. */
  TS::PHP::AstNode getOperatorNode() { result = super.getOperator() }
}

/**
 * An update expression (++$x, $x++, --$x, $x--).
 */
class UpdateExpr extends TS::PHP::UpdateExpression {
  /** Gets the variable being updated. */
  TS::PHP::AstNode getOperand() { result = this.getArgument() }

  /** Gets the operator (++ or --). */
  string getOperatorString() { result = this.getOperator() }

  /** Holds if this is an increment operation. */
  predicate isIncrement() { this.getOperator() = "++" }

  /** Holds if this is a decrement operation. */
  predicate isDecrement() { this.getOperator() = "--" }
}

/**
 * An assignment expression ($x = value).
 */
class Assignment extends TS::PHP::AssignmentExpression {
  /** Gets the target (left-hand side) of the assignment. */
  TS::PHP::AstNode getTarget() { result = this.getLeft() }

  /** Gets the assigned value (right-hand side). */
  Expr getValue() { result = this.getRight() }
}

/**
 * An augmented assignment expression ($x += 5, $x .= "str", etc.).
 */
class AugmentedAssignment extends TS::PHP::AugmentedAssignmentExpression {
  /** Gets the target (left-hand side) of the assignment. */
  TS::PHP::AstNode getTarget() { result = this.getLeft() }

  /** Gets the value on the right-hand side. */
  Expr getValue() { result = this.getRight() }

  /** Gets the operator (+=, -=, etc.). */
  string getOperatorString() { result = this.getOperator() }
}

/**
 * A reference assignment expression ($x =& $y).
 */
class ReferenceAssignment extends TS::PHP::ReferenceAssignmentExpression {
  /** Gets the target of the assignment. */
  TS::PHP::AstNode getTarget() { result = this.getLeft() }

  /** Gets the source of the reference. */
  Expr getSource() { result = this.getRight() }
}

/**
 * A member access expression ($obj->property).
 */
class MemberAccess extends TS::PHP::MemberAccessExpression {
  /** Gets the object being accessed. */
  TS::PHP::AstNode getObject() { result = super.getObject() }

  /** Gets the member name node. */
  TS::PHP::AstNode getMemberNode() { result = this.getName() }

  /** Gets the member name as a string, if it's a simple name. */
  string getMemberName() { result = this.getName().(TS::PHP::Name).getValue() }
}

/**
 * A nullsafe member access expression ($obj?->property).
 */
class NullsafeMemberAccess extends TS::PHP::NullsafeMemberAccessExpression {
  /** Gets the object being accessed. */
  TS::PHP::AstNode getObject() { result = super.getObject() }

  /** Gets the member name node. */
  TS::PHP::AstNode getMemberNode() { result = this.getName() }

  /** Gets the member name as a string, if it's a simple name. */
  string getMemberName() { result = this.getName().(TS::PHP::Name).getValue() }
}

/**
 * A scoped property access expression (Class::$property).
 */
class ScopedPropertyAccess extends TS::PHP::ScopedPropertyAccessExpression {
  /** Gets the scope (class name or expression). */
  TS::PHP::AstNode getScopeExpr() { result = this.getScope() }

  /** Gets the property name node. */
  TS::PHP::AstNode getPropertyNode() { result = this.getName() }
}

/**
 * A class constant access expression (Class::CONSTANT).
 */
class ClassConstantAccess extends TS::PHP::ClassConstantAccessExpression {
  /** Gets the class name or expression. */
  TS::PHP::AstNode getScopeExpr() { result = this.getChild(0) }

  /** Gets the constant name node. */
  TS::PHP::AstNode getConstantNode() { result = this.getChild(1) }
}

/**
 * A subscript expression ($array[index] or $array{index}).
 */
class SubscriptExpr extends TS::PHP::SubscriptExpression {
  /** Gets the array/string being subscripted. */
  TS::PHP::AstNode getBase() { result = this.getChild(0) }

  /** Gets the index expression, if any. */
  TS::PHP::AstNode getIndex() { result = this.getChild(1) }
}

/**
 * An array literal ([1, 2, 3] or array(1, 2, 3)).
 */
class ArrayLiteral extends TS::PHP::ArrayCreationExpression {
  /** Gets the i-th element initializer. */
  TS::PHP::ArrayElementInitializer getElement(int i) { result = this.getChild(i) }

  /** Gets any element initializer. */
  TS::PHP::ArrayElementInitializer getAnElement() { result = this.getChild(_) }

  /** Gets the number of elements. */
  int getNumElements() { result = count(this.getAnElement()) }
}

/**
 * A function call expression.
 */
class FunctionCall extends TS::PHP::FunctionCallExpression {
  /** Gets the function being called (name or expression). */
  TS::PHP::AstNode getCallee() { result = this.getFunction() }

  /** Gets the function name as a string, if it's a simple name. */
  string getFunctionName() {
    result = this.getFunction().(TS::PHP::Name).getValue() or
    result = this.getFunction().(TS::PHP::QualifiedName).getChild().getValue()
  }

  /** Gets the arguments node. */
  TS::PHP::Arguments getArgumentsNode() { result = this.getArguments() }

  /** Gets the i-th argument. */
  TS::PHP::AstNode getArgument(int i) { result = this.getArguments().getChild(i) }

  /** Gets any argument. */
  TS::PHP::AstNode getAnArgument() { result = this.getArguments().getChild(_) }

  /** Gets the number of arguments. */
  int getNumArguments() { result = count(this.getAnArgument()) }
}

/**
 * A method call expression ($obj->method()).
 */
class MethodCall extends TS::PHP::MemberCallExpression {
  /** Gets the object on which the method is called. */
  TS::PHP::AstNode getObject() { result = super.getObject() }

  /** Gets the method name node. */
  TS::PHP::AstNode getMethodNode() { result = this.getName() }

  /** Gets the method name as a string, if it's a simple name. */
  string getMethodName() { result = this.getName().(TS::PHP::Name).getValue() }

  /** Gets the arguments node. */
  TS::PHP::Arguments getArgumentsNode() { result = this.getArguments() }

  /** Gets the i-th argument. */
  TS::PHP::AstNode getArgument(int i) { result = this.getArguments().getChild(i) }

  /** Gets any argument. */
  TS::PHP::AstNode getAnArgument() { result = this.getArguments().getChild(_) }

  /** Gets the number of arguments. */
  int getNumArguments() { result = count(this.getAnArgument()) }
}

/**
 * A nullsafe method call expression ($obj?->method()).
 */
class NullsafeMethodCall extends TS::PHP::NullsafeMemberCallExpression {
  /** Gets the object on which the method is called. */
  TS::PHP::AstNode getObject() { result = super.getObject() }

  /** Gets the method name node. */
  TS::PHP::AstNode getMethodNode() { result = this.getName() }

  /** Gets the method name as a string, if it's a simple name. */
  string getMethodName() { result = this.getName().(TS::PHP::Name).getValue() }

  /** Gets the arguments node. */
  TS::PHP::Arguments getArgumentsNode() { result = this.getArguments() }

  /** Gets the i-th argument. */
  TS::PHP::AstNode getArgument(int i) { result = this.getArguments().getChild(i) }
}

/**
 * A static method call expression (Class::method()).
 */
class StaticMethodCall extends TS::PHP::ScopedCallExpression {
  /** Gets the class/scope being called on. */
  TS::PHP::AstNode getScopeExpr() { result = this.getScope() }

  /** Gets the class name as a string, if it's a simple name. */
  string getClassName() {
    result = this.getScope().(TS::PHP::Name).getValue() or
    result = this.getScope().(TS::PHP::QualifiedName).getChild().getValue()
  }

  /** Gets the method name node. */
  TS::PHP::AstNode getMethodNode() { result = this.getName() }

  /** Gets the method name as a string, if it's a simple name. */
  string getMethodName() { result = this.getName().(TS::PHP::Name).getValue() }

  /** Gets the arguments node. */
  TS::PHP::Arguments getArgumentsNode() { result = this.getArguments() }

  /** Gets the i-th argument. */
  TS::PHP::AstNode getArgument(int i) { result = this.getArguments().getChild(i) }

  /** Gets any argument. */
  TS::PHP::AstNode getAnArgument() { result = this.getArguments().getChild(_) }

  /** Gets the number of arguments. */
  int getNumArguments() { result = count(this.getAnArgument()) }
}

/**
 * An object creation expression (new ClassName()).
 */
class NewExpr extends TS::PHP::ObjectCreationExpression {
  /** Gets the class being instantiated. */
  TS::PHP::AstNode getClassExpr() { result = this.getChild(0) }

  /** Gets the class name as a string, if it's a simple name. */
  string getClassName() {
    result = this.getChild(0).(TS::PHP::Name).getValue() or
    result = this.getChild(0).(TS::PHP::QualifiedName).getChild().getValue()
  }

  /** Gets the arguments node, if present. */
  TS::PHP::Arguments getArgumentsNode() { result = this.getChild(1) }

  /** Gets the i-th argument, if any. */
  TS::PHP::AstNode getArgument(int i) { result = this.getArgumentsNode().getChild(i) }
}

/**
 * A conditional/ternary expression (cond ? then : else).
 */
class ConditionalExpr extends TS::PHP::ConditionalExpression {
  /** Gets the condition. */
  Expr getCondition() { result = super.getCondition() }

  /** Gets the 'then' branch (may be absent for Elvis operator). */
  Expr getThenBranch() { result = this.getBody() }

  /** Gets the 'else' branch. */
  Expr getElseBranch() { result = this.getAlternative() }

  /** Holds if this is an Elvis operator (cond ?: else). */
  predicate isElvis() { not exists(this.getBody()) }
}

/**
 * A cast expression ((type)$value).
 */
class CastExpr extends TS::PHP::CastExpression {
  /** Gets the expression being cast. */
  TS::PHP::AstNode getCastOperand() { result = this.getValue() }

  /** Gets the cast type token. */
  TS::PHP::CastType getCastTypeToken() { result = this.getType() }

  /** Gets the target type as a string. */
  string getCastType() { result = this.getType().getValue() }
}

/**
 * A clone expression (clone $obj).
 */
class CloneExpr extends TS::PHP::CloneExpression {
  /** Gets the expression being cloned. */
  TS::PHP::PrimaryExpression getClonedExpr() { result = this.getChild() }
}

/**
 * A variable reference.
 */
class Variable extends TS::PHP::VariableName {
  /** Gets the variable name (without the $). */
  string getName() { result = this.getChild().getValue() }
}

/**
 * A dynamic variable name ($$var or ${expr}).
 */
class DynamicVariable extends TS::PHP::DynamicVariableName {
  /** Gets the inner expression. */
  TS::PHP::AstNode getInnerExpr() { result = this.getChild() }
}

/**
 * A string literal.
 */
class StringLiteral extends TS::PHP::String {
  /** Gets the string value (content without quotes). */
  string getValue() {
    result = this.getChild(0).(TS::PHP::StringContent).getValue()
  }
}

/**
 * An encapsed (double-quoted) string with interpolation.
 */
class EncapsedStringLiteral extends TS::PHP::EncapsedString {
  /** Gets the i-th part of the string. */
  TS::PHP::AstNode getPart(int i) { result = this.getChild(i) }

  /** Gets any part of the string. */
  TS::PHP::AstNode getAPart() { result = this.getChild(_) }
}

/**
 * A heredoc string.
 */
class HeredocLiteral extends TS::PHP::Heredoc {
  /** Gets the heredoc body. */
  TS::PHP::HeredocBody getBodyNode() { result = this.getValue() }
}

/**
 * A nowdoc string.
 */
class NowdocLiteral extends TS::PHP::Nowdoc {
  /** Gets the nowdoc body. */
  TS::PHP::NowdocBody getBodyNode() { result = this.getValue() }
}

/**
 * An integer literal.
 */
class IntegerLiteral extends TS::PHP::Integer {
  /** Gets the integer value as a string. */
  string getValueString() { result = this.getValue() }
}

/**
 * A float literal.
 */
class FloatLiteral extends TS::PHP::Float {
  /** Gets the float value as a string. */
  string getValueString() { result = this.getValue() }
}

/**
 * A boolean literal (true or false).
 */
class BooleanLiteral extends TS::PHP::Boolean {
  /** Gets the boolean value as a string. */
  string getValueString() { result = this.getValue() }

  /** Holds if this is the literal true. */
  predicate isTrue() { this.getValue().toLowerCase() = "true" }

  /** Holds if this is the literal false. */
  predicate isFalse() { this.getValue().toLowerCase() = "false" }
}

/**
 * The null literal.
 */
class NullLiteral extends TS::PHP::Null {
}

/**
 * A print expression (print $value).
 */
class PrintExpr extends TS::PHP::PrintIntrinsic {
  /** Gets the expression being printed. */
  Expr getPrintedExpr() { result = this.getChild() }
}

/**
 * A throw expression (PHP 8.0+).
 */
class ThrowExpr extends TS::PHP::ThrowExpression {
  /** Gets the exception being thrown. */
  Expr getException() { result = this.getChild() }
}

/**
 * A yield expression.
 */
class YieldExpr extends TS::PHP::YieldExpression {
  /** Gets the yielded value, if any. */
  TS::PHP::AstNode getYieldedValue() { result = this.getChild() }
}

/**
 * A match expression (PHP 8.0+).
 */
class MatchExpr extends TS::PHP::MatchExpression {
  /** Gets the condition being matched. */
  TS::PHP::ParenthesizedExpression getMatchCondition() { result = this.getCondition() }

  /** Gets the match block. */
  TS::PHP::MatchBlock getMatchBlock() { result = this.getBody() }
}

/**
 * An error suppression expression (@expr).
 */
class ErrorSuppressionExpr extends TS::PHP::ErrorSuppressionExpression {
  /** Gets the suppressed expression. */
  Expr getSuppressedExpr() { result = this.getChild() }
}

/**
 * An include expression.
 */
class IncludeExpr extends TS::PHP::IncludeExpression {
  /** Gets the file path expression. */
  Expr getPath() { result = this.getChild() }
}

/**
 * An include_once expression.
 */
class IncludeOnceExpr extends TS::PHP::IncludeOnceExpression {
  /** Gets the file path expression. */
  Expr getPath() { result = this.getChild() }
}

/**
 * A require expression.
 */
class RequireExpr extends TS::PHP::RequireExpression {
  /** Gets the file path expression. */
  Expr getPath() { result = this.getChild() }
}

/**
 * A require_once expression.
 */
class RequireOnceExpr extends TS::PHP::RequireOnceExpression {
  /** Gets the file path expression. */
  Expr getPath() { result = this.getChild() }
}

/**
 * An anonymous function (closure).
 */
class Closure extends TS::PHP::AnonymousFunction {
  /** Gets the function parameters. */
  TS::PHP::FormalParameters getParametersNode() { result = this.getParameters() }

  /** Gets the function body. */
  TS::PHP::CompoundStatement getBodyNode() { result = this.getBody() }

  /** Gets the use clause, if any. */
  TS::PHP::AnonymousFunctionUseClause getUseClause() { result = this.getChild() }

  /** Gets the return type, if specified. */
  TS::PHP::AstNode getReturnTypeNode() { result = this.getReturnType() }

  /** Holds if this is a static closure. */
  predicate isStatic() { exists(this.getStaticModifier()) }
}

/**
 * An arrow function (fn($x) => $x * 2).
 */
class ArrowFunc extends TS::PHP::ArrowFunction {
  /** Gets the function parameters. */
  TS::PHP::FormalParameters getParametersNode() { result = this.getParameters() }

  /** Gets the body expression. */
  Expr getBodyExpr() { result = this.getBody() }

  /** Gets the return type, if specified. */
  TS::PHP::AstNode getReturnTypeNode() { result = this.getReturnType() }

  /** Holds if this is a static arrow function. */
  predicate isStatic() { exists(this.getStaticModifier()) }
}

/**
 * A parenthesized expression.
 */
class ParenExpr extends TS::PHP::ParenthesizedExpression {
  /** Gets the inner expression. */
  Expr getInnerExpr() { result = this.getChild() }
}

/**
 * A shell command expression (`command`).
 */
class ShellExec extends TS::PHP::ShellCommandExpression {
  /** Gets the i-th part of the command. */
  TS::PHP::AstNode getPart(int i) { result = this.getChild(i) }

  /** Gets any part of the command. */
  TS::PHP::AstNode getAPart() { result = this.getChild(_) }
}

/**
 * A list literal for destructuring (list($a, $b) or [$a, $b]).
 */
class ListExpr extends TS::PHP::ListLiteral {
  /** Gets the i-th element. */
  TS::PHP::AstNode getElement(int i) { result = this.getChild(i) }

  /** Gets any element. */
  TS::PHP::AstNode getAnElement() { result = this.getChild(_) }
}

/**
 * A superglobal variable access.
 */
class Superglobal extends Variable {
  Superglobal() {
    this.getName() in ["_GET", "_POST", "_REQUEST", "_COOKIE", "_SESSION", "_SERVER", "_FILES", "_ENV", "GLOBALS"]
  }

  /** Gets the superglobal type (GET, POST, etc.). */
  string getSuperglobalType() { result = this.getName() }
}
