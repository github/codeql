/**
 * DEPRECATED: Objective-C is no longer supported.
 */

import semmle.code.cpp.exprs.Expr
import semmle.code.cpp.Class
import semmle.code.cpp.ObjectiveC
private import semmle.code.cpp.internal.ResolveClass

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C message expression, for example `[myColor changeColorToRed:5.0 green:2.0 blue:6.0]`.
 */
deprecated class MessageExpr extends Expr, Call {
  MessageExpr() { none() }

  override string toString() { none() }

  /**
   * Gets the selector of this message expression, for example `-changeColorToRed:green:blue:`.
   */
  string getSelector() { none() }

  /**
   * Gets the function invoked by this message expression, as inferred by the compiler.
   *
   * If the compiler could infer the type of the receiver, and that type had a method
   * whose name matched the selector, then the result of this predicate is said method.
   * Otherwise this predicate has no result.
   *
   * In all cases, actual function dispatch isn't performed until runtime, but the
   * lack of a static target is often cause for concern.
   */
  MemberFunction getStaticTarget() { none() }

  /**
   * Provided for compatibility with Call. It is the same as the static target.
   */
  override MemberFunction getTarget() { none() }

  /**
   * Holds if the compiler could infer a function as the target of this message.
   *
   * In all cases, actual function dispatch isn't performed until runtime, but the
   * lack of a static target is often cause for concern.
   */
  predicate hasStaticTarget() { none() }

  /**
   * Gets the number of arguments passed by this message expression.
   *
   * In most cases, this equals the number of colons in the selector, but this needn't be the
   * case for variadic methods like "-initWithFormat:", which can have more than one argument.
   */
  override int getNumberOfArguments() { none() }

  /**
   * Gets an argument passed by this message expression.
   */
  override Expr getAnArgument() { none() }

  /**
   * Gets the nth argument passed by this message expression.
   *
   * The range of `n` is [`0` .. `getNumberOfArguments()`].
   */
  override Expr getArgument(int n) { none() }

  override int getPrecedence() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C message expression whose receiver is `super`, for example `[super init]`.
 */
deprecated class SuperMessageExpr extends MessageExpr {
  SuperMessageExpr() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C message expression whose receiver is the name of a class, and
 * is therefore calling a class method rather than an instance method. This occurs
 * most commonly for the "+alloc", "+new", and "+class" selectors.
 */
deprecated class ClassMessageExpr extends MessageExpr {
  ClassMessageExpr() { none() }

  /**
   * Gets the class which is the receiver of this message.
   */
  Type getReceiver() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C message expression whose receiver is an expression (which includes the
 * common case of the receiver being "self").
 */
deprecated class ExprMessageExpr extends MessageExpr {
  ExprMessageExpr() { none() }

  /**
   * Gets the expression which gives the receiver of this message.
   */
  Expr getReceiver() { none() }

  /**
   * Gets the Objective C class of which the receiving expression is an instance.
   *
   * If the receiving expression has type `id` or type `id<P>` for some protocol `P`,
   * then there will be no result. If the receiving expression has type `C*` or type
   * `C<P>*` for some protocol `P`, then the result will be the type `C`.
   */
  ObjectiveClass getReceiverClass() { none() }

  /**
   * Gets the Objective C classes and/or protocols which are statically implemented
   * by the receiving expression.
   *
   * If the receiving expression has type `id`, then there will be no result.
   * If the receiving expression has type `id<P>`, then `P` will be the sole result.
   * If the receiving expression has type `C*`, then `C` will be the sole result.
   * If the receiving expression has type `C<P>*`, then `C` and `P` will both be results.
   */
  Class getAReceiverClassOrProtocol() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An access to an Objective C property using dot syntax.
 *
 * Such accesses are de-sugared into a message expression to the property's getter or setter.
 */
deprecated class PropertyAccess extends ExprMessageExpr {
  PropertyAccess() { none() }

  /**
   * Gets the property being accessed by this expression.
   */
  Property getProperty() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C `@selector` expression, for example `@selector(driveForDistance:)`.
 */
deprecated class AtSelectorExpr extends Expr {
  AtSelectorExpr() { none() }

  override string toString() { none() }

  /**
   * Gets the selector of this `@selector` expression, for example `driveForDistance:`.
   */
  string getSelector() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C `@protocol` expression, for example `@protocol(SomeProtocol)`.
 */
deprecated class AtProtocolExpr extends Expr {
  AtProtocolExpr() { none() }

  override string toString() { none() }

  /**
   * Gets the protocol of this `@protocol` expression, for example `SomeProtocol`.
   */
  Protocol getProtocol() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C `@encode` expression, for example `@encode(int *)`.
 */
deprecated class AtEncodeExpr extends Expr {
  AtEncodeExpr() { none() }

  override string toString() { none() }

  /**
   * Gets the type this `@encode` expression encodes, for example `int *`.
   */
  Type getEncodedType() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C throw expression.
 */
deprecated class ObjcThrowExpr extends ThrowExpr {
  ObjcThrowExpr() { none() }

  override string toString() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C throw expression with no argument (which causes the
 * current exception to be re-thrown).
 */
deprecated class ObjcReThrowExpr extends ReThrowExpr, ObjcThrowExpr {
  ObjcReThrowExpr() { none() }

  override string toString() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C @ expression which boxes a single value, such as @(22).
 */
deprecated class AtExpr extends UnaryOperation {
  AtExpr() { none() }

  override string toString() { none() }

  override string getOperator() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C @[...] literal.
 */
deprecated class ArrayLiteral extends Expr {
  ArrayLiteral() { none() }

  /** Gets a textual representation of this array literal. */
  override string toString() { none() }

  /** An element of the array */
  Expr getElement(int i) { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C @{...} literal.
 */
deprecated class DictionaryLiteral extends Expr {
  DictionaryLiteral() { none() }

  /** Gets a textual representation of this dictionary literal. */
  override string toString() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C @"..." string literal.
 */
deprecated class ObjCLiteralString extends TextLiteral {
  ObjCLiteralString() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C/C++ overloaded subscripting access expression.
 *
 * Either
 *     obj[idx]
 * or
 *     obj[idx] = expr
 */
deprecated class SubscriptExpr extends Expr {
  SubscriptExpr() { none() }

  /**
   * Gets the object expression being subscripted.
   */
  Expr getSubscriptBase() { none() }

  /**
   * Gets the expression giving the index into the object.
   */
  Expr getSubscriptIndex() { none() }

  /**
   * Gets the expression being assigned (if this is an assignment).
   */
  Expr getAssignedExpr() { none() }

  override string toString() { none() }
}

/**
 * DEPRECATED: Objective-C is no longer supported.
 * An Objective C _cmd expression.
 */
deprecated class CmdExpr extends Expr {
  CmdExpr() { none() }

  override string toString() { none() }

  override predicate mayBeImpure() { none() }

  override predicate mayBeGloballyImpure() { none() }
}
