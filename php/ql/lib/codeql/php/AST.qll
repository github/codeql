/**
 * Provides classes for working with the PHP abstract syntax tree (AST).
 *
 * This module re-exports classes from the auto-generated TreeSitter module
 * and provides additional convenience abstractions.
 */

import codeql.php.ast.internal.TreeSitter as TS
import codeql.Locations as L

// Re-export core TreeSitter classes
class AstNode = TS::PHP::AstNode;
class Token = TS::PHP::Token;
class Location = L::Location;
class File = L::File;

// Expression types
class Expression = TS::PHP::Expression;
class BinaryExpression = TS::PHP::BinaryExpression;
class UnaryOpExpression = TS::PHP::UnaryOpExpression;
class AssignmentExpression = TS::PHP::AssignmentExpression;
class AugmentedAssignmentExpression = TS::PHP::AugmentedAssignmentExpression;
class ConditionalExpression = TS::PHP::ConditionalExpression;
class CastExpression = TS::PHP::CastExpression;
class CloneExpression = TS::PHP::CloneExpression;
class MatchExpression = TS::PHP::MatchExpression;
class YieldExpression = TS::PHP::YieldExpression;
class ErrorSuppressionExpression = TS::PHP::ErrorSuppressionExpression;

// Call expressions
class FunctionCallExpression = TS::PHP::FunctionCallExpression;
class MemberCallExpression = TS::PHP::MemberCallExpression;
class ScopedCallExpression = TS::PHP::ScopedCallExpression;
class NullsafeMemberCallExpression = TS::PHP::NullsafeMemberCallExpression;
class ObjectCreationExpression = TS::PHP::ObjectCreationExpression;

// Access expressions
class MemberAccessExpression = TS::PHP::MemberAccessExpression;
class NullsafeMemberAccessExpression = TS::PHP::NullsafeMemberAccessExpression;
class ScopedPropertyAccessExpression = TS::PHP::ScopedPropertyAccessExpression;
class ClassConstantAccessExpression = TS::PHP::ClassConstantAccessExpression;
class SubscriptExpression = TS::PHP::SubscriptExpression;

// Literal types
class Literal = TS::PHP::Literal;
class String = TS::PHP::String;
class EncapsedString = TS::PHP::EncapsedString;
class Heredoc = TS::PHP::Heredoc;
class Nowdoc = TS::PHP::Nowdoc;
class Integer = TS::PHP::Integer;
class Float = TS::PHP::Float;
class Boolean = TS::PHP::Boolean;
class Null = TS::PHP::Null;

// Array types
class ArrayCreationExpression = TS::PHP::ArrayCreationExpression;
class ArrayElementInitializer = TS::PHP::ArrayElementInitializer;

// Variable types
class VariableName = TS::PHP::VariableName;
class DynamicVariableName = TS::PHP::DynamicVariableName;

// Name types
class Name = TS::PHP::Name;
class QualifiedName = TS::PHP::QualifiedName;

// Include/Require
class IncludeExpression = TS::PHP::IncludeExpression;
class IncludeOnceExpression = TS::PHP::IncludeOnceExpression;
class RequireExpression = TS::PHP::RequireExpression;
class RequireOnceExpression = TS::PHP::RequireOnceExpression;

// Statement types
class Statement = TS::PHP::Statement;
class CompoundStatement = TS::PHP::CompoundStatement;
class ExpressionStatement = TS::PHP::ExpressionStatement;
class ReturnStatement = TS::PHP::ReturnStatement;
class EchoStatement = TS::PHP::EchoStatement;
class UnsetStatement = TS::PHP::UnsetStatement;
class BreakStatement = TS::PHP::BreakStatement;
class ContinueStatement = TS::PHP::ContinueStatement;
class GotoStatement = TS::PHP::GotoStatement;
class NamedLabelStatement = TS::PHP::NamedLabelStatement;
class GlobalDeclaration = TS::PHP::GlobalDeclaration;
class StaticVariableDeclaration = TS::PHP::StaticVariableDeclaration;
class ThrowExpression = TS::PHP::ThrowExpression;

// Control flow
class IfStatement = TS::PHP::IfStatement;
class ElseClause = TS::PHP::ElseClause;
class ElseIfClause = TS::PHP::ElseIfClause;
class SwitchStatement = TS::PHP::SwitchStatement;
class SwitchBlock = TS::PHP::SwitchBlock;
class CaseStatement = TS::PHP::CaseStatement;
class DefaultStatement = TS::PHP::DefaultStatement;
class WhileStatement = TS::PHP::WhileStatement;
class DoStatement = TS::PHP::DoStatement;
class ForStatement = TS::PHP::ForStatement;
class ForeachStatement = TS::PHP::ForeachStatement;
class TryStatement = TS::PHP::TryStatement;
class CatchClause = TS::PHP::CatchClause;
class FinallyClause = TS::PHP::FinallyClause;
class DeclareStatement = TS::PHP::DeclareStatement;

// Declaration types
class FunctionDefinition = TS::PHP::FunctionDefinition;
class ClassDeclaration = TS::PHP::ClassDeclaration;
class InterfaceDeclaration = TS::PHP::InterfaceDeclaration;
class TraitDeclaration = TS::PHP::TraitDeclaration;
class EnumDeclaration = TS::PHP::EnumDeclaration;
class NamespaceDefinition = TS::PHP::NamespaceDefinition;
class NamespaceUseDeclaration = TS::PHP::NamespaceUseDeclaration;

// Class members
class MethodDeclaration = TS::PHP::MethodDeclaration;
class PropertyDeclaration = TS::PHP::PropertyDeclaration;
class ConstDeclaration = TS::PHP::ConstDeclaration;
class UseDeclaration = TS::PHP::UseDeclaration;

// Parameters and arguments
class FormalParameters = TS::PHP::FormalParameters;
class SimpleParameter = TS::PHP::SimpleParameter;
class PropertyPromotionParameter = TS::PHP::PropertyPromotionParameter;
class VariadicParameter = TS::PHP::VariadicParameter;
class Arguments = TS::PHP::Arguments;
class Argument = TS::PHP::Argument;

// Anonymous functions
class AnonymousFunction = TS::PHP::AnonymousFunction;
class ArrowFunction = TS::PHP::ArrowFunction;
class AnonymousClass = TS::PHP::AnonymousClass;

// Type annotations
class Type = TS::PHP::Type;
class NamedType = TS::PHP::NamedType;
class OptionalType = TS::PHP::OptionalType;
class UnionType = TS::PHP::UnionType;
class IntersectionType = TS::PHP::IntersectionType;
class DisjunctiveNormalFormType = TS::PHP::DisjunctiveNormalFormType;

// Attributes (PHP 8.0+)
class AttributeList = TS::PHP::AttributeList;
class AttributeGroup = TS::PHP::AttributeGroup;
class Attribute = TS::PHP::Attribute;

// Visibility modifiers
class VisibilityModifier = TS::PHP::VisibilityModifier;
class AbstractModifier = TS::PHP::AbstractModifier;
class FinalModifier = TS::PHP::FinalModifier;
class StaticModifier = TS::PHP::StaticModifier;
class ReadonlyModifier = TS::PHP::ReadonlyModifier;

// Program root
class Program = TS::PHP::Program;

/**
 * A call expression (function call, method call, or constructor call).
 */
class Call extends AstNode {
  Call() {
    this instanceof FunctionCallExpression or
    this instanceof MemberCallExpression or
    this instanceof ScopedCallExpression or
    this instanceof NullsafeMemberCallExpression or
    this instanceof ObjectCreationExpression
  }

  /** Gets the arguments to this call. */
  Arguments getArguments() {
    result = this.(FunctionCallExpression).getArguments() or
    result = this.(MemberCallExpression).getArguments() or
    result = this.(ScopedCallExpression).getArguments() or
    result = this.(NullsafeMemberCallExpression).getArguments() or
    result = this.(ObjectCreationExpression).getChild(_)
  }
}

/**
 * A binary operation with a specific operator.
 */
class BinaryOp extends BinaryExpression {
  /** Gets the left operand. */
  Expression getLeftOperand() { result = this.getLeft() }

  /** Gets the right operand. */
  AstNode getRightOperand() { result = this.getRight() }
}

/**
 * An arithmetic binary operation (+, -, *, /, %, **).
 */
class ArithmeticOp extends BinaryOp {
  ArithmeticOp() {
    this.getOperator() in ["+", "-", "*", "/", "%", "**"]
  }
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
 * A logical operation (&&, ||, and, or, xor).
 */
class LogicalOp extends BinaryOp {
  LogicalOp() {
    this.getOperator() in ["&&", "||", "and", "or", "xor"]
  }
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
 * A string concatenation operation (.).
 */
class ConcatOp extends BinaryOp {
  ConcatOp() {
    this.getOperator() = "."
  }
}

/**
 * A null coalescing operation (??).
 */
class NullCoalesceOp extends BinaryOp {
  NullCoalesceOp() {
    this.getOperator() = "??"
  }
}

/**
 * An instanceof expression.
 */
class InstanceofExpr extends BinaryOp {
  InstanceofExpr() {
    this.getOperator() = "instanceof"
  }
}

/**
 * A variable reference (either simple or dynamic).
 */
class Variable extends AstNode {
  Variable() {
    this instanceof VariableName or
    this instanceof DynamicVariableName
  }

  /** Gets the name of this variable, if it's a simple variable. */
  string getName() {
    result = this.(VariableName).getChild().getValue()
  }
}

/**
 * A function or method definition.
 */
class Function extends AstNode {
  Function() {
    this instanceof FunctionDefinition or
    this instanceof MethodDeclaration or
    this instanceof AnonymousFunction or
    this instanceof ArrowFunction
  }

  /** Gets the name of this function, if it has one. */
  string getName() {
    result = this.(FunctionDefinition).getName().getValue() or
    result = this.(MethodDeclaration).getName().getValue()
  }

  /** Gets the parameters of this function. */
  FormalParameters getParameters() {
    result = this.(FunctionDefinition).getParameters() or
    result = this.(MethodDeclaration).getParameters() or
    result = this.(AnonymousFunction).getParameters() or
    result = this.(ArrowFunction).getParameters()
  }
}

/**
 * A class-like declaration (class, interface, trait, or enum).
 */
class ClassLike extends AstNode {
  ClassLike() {
    this instanceof ClassDeclaration or
    this instanceof InterfaceDeclaration or
    this instanceof TraitDeclaration or
    this instanceof EnumDeclaration or
    this instanceof AnonymousClass
  }

  /** Gets the name of this class-like, if it has one. */
  string getName() {
    result = this.(ClassDeclaration).getName().getValue() or
    result = this.(InterfaceDeclaration).getName().getValue() or
    result = this.(TraitDeclaration).getName().getValue() or
    result = this.(EnumDeclaration).getName().getValue()
  }
}

/**
 * A loop statement (while, do-while, for, foreach).
 */
class Loop extends AstNode {
  Loop() {
    this instanceof WhileStatement or
    this instanceof DoStatement or
    this instanceof ForStatement or
    this instanceof ForeachStatement
  }
}

/**
 * A string literal (single-quoted, double-quoted, heredoc, or nowdoc).
 */
class StringLiteral extends AstNode {
  StringLiteral() {
    this instanceof String or
    this instanceof EncapsedString or
    this instanceof Heredoc or
    this instanceof Nowdoc
  }

  /** Gets the string value for simple strings. */
  string getValue() {
    result = this.(String).getChild(_).(Token).getValue()
  }
}

/**
 * A numeric literal (integer or float).
 */
class NumericLiteral extends AstNode {
  NumericLiteral() {
    this instanceof Integer or
    this instanceof Float
  }

  /** Gets the numeric value as a string. */
  string getValue() {
    result = this.(Integer).getValue() or
    result = this.(Float).getValue()
  }
}
