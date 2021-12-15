/**
 * Provides .Net expression classes.
 */

import Expr
import Type
import Callable

/** An expression. */
class Expr extends Element, @dotnet_expr {
  /** Gets the callable containing this expression. */
  Callable getEnclosingCallable() { none() }

  /** Gets the type of this expression. */
  Type getType() { none() }

  /** Gets the constant value of this expression, if any. */
  string getValue() { none() }

  /** Holds if this expression has a value. */
  final predicate hasValue() { exists(this.getValue()) }

  /**
   * Gets the parent of this expression. This is for example the element
   * that uses the result of this expression.
   */
  Element getParent() { none() }
}

/** A call. */
class Call extends Expr, @dotnet_call {
  /** Gets the target of this call. */
  Callable getTarget() { none() }

  /** Gets any potential target of this call. */
  Callable getARuntimeTarget() { none() }

  /**
   * Gets the `i`th "raw" argument to this call, if any.
   * For instance methods, argument 0 is the qualifier.
   */
  Expr getRawArgument(int i) { none() }

  /** Gets the `i`th argument to this call, if any. */
  Expr getArgument(int i) { none() }

  /** Gets an argument to this call. */
  Expr getAnArgument() { result = this.getArgument(_) }

  /** Gets the expression that is supplied for parameter `p`. */
  Expr getArgumentForParameter(Parameter p) { none() }
}

/** A literal expression. */
class Literal extends Expr, @dotnet_literal { }

/** A string literal expression. */
class StringLiteral extends Literal, @dotnet_string_literal { }

/** An integer literal expression. */
class IntLiteral extends Literal, @dotnet_int_literal { }

/** A `null` literal expression. */
class NullLiteral extends Literal, @dotnet_null_literal { }
