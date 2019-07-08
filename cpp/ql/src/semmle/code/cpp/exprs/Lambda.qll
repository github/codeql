import semmle.code.cpp.exprs.Expr
import semmle.code.cpp.Class

/**
 * A C++11 lambda expression, such as `[&amp;, =y](int x) mutable -> double {return z = (y += x);}`.
 *
 * The type given by `getType()` will be an instance of `Closure`.
 */
class LambdaExpression extends Expr, @lambdaexpr {
  override string toString() {
    result = "[...](...){...}"
  }

  /** Canonical QL class corresponding to this element. */
  override string getCanonicalQLClass() { result = "LambdaExpression" }

  /**
   * Gets an implicitly or explicitly captured value of this lambda expression.
   */
  LambdaCapture getACapture() {
    result = getCapture(_)
  }

  /**
   * Gets the nth implicitly or explicitly captured value of this lambda expression.
   */
  LambdaCapture getCapture(int index) {
    lambda_capture(result, underlyingElement(this), index, _, _, _)
  }

  /**
   * Gets the default variable capture mode for the lambda expression.
   *
   * Will be one of:
   *   - "" if no default was specified, meaning that all captures must be explicit.
   *   - "&amp;" if capture-by-reference is the default for implicit captures.
   *   - "=" if capture-by-value is the default for implicit captures.
   */
  string getDefaultCaptureMode() {
    lambdas(underlyingElement(this), result, _)
  }

  /**
   * Holds if the return type (of the call operator of the resulting object) was explicitly specified.
   */
  predicate returnTypeIsExplicit() {
    lambdas(underlyingElement(this), _, true)
  }

  /**
   * Gets the function which will be invoked when the resulting object is called.
   *
   * Various components of the lambda expression can be obtained from components of this
   * function, such as:
   *   - The number and type of parameters.
   *   - Whether the mutable keyword was used (iff this function is not const).
   *   - The return type.
   *   - The statements comprising the lambda body.
   */
  Operator getLambdaFunction() {
    result = getType().(Closure).getLambdaFunction()
  }

  /**
   * Gets the initializer that initializes the captured variables in the closure, if any.
   * A lambda that does not capture any variables will not have an initializer.
   */
  Expr getInitializer() {
    result = getChild(0)
  }
}

/**
 * A class written by the compiler to be the type of a C++11 lambda expression.
 */
class Closure extends Class {
  Closure() {
    exists(LambdaExpression e | this = e.getType())
  }

  /** Canonical QL class corresponding to this element. */
  override string getCanonicalQLClass() { result = "Closure" }

  /** Gets the lambda expression of which this is the type. */
  LambdaExpression getLambdaExpression() {
    result.getType() = this
  }

  /** Gets the compiler-generated operator() of this closure type. */
  Operator getLambdaFunction() {
    result = this.getAMember()
    and result.getName() = "operator()"
  }

  override string toString() {
    result = "decltype([...](...){...})"
  }
}

/**
 * Information about a value captured as part of a lambda expression.
 */
class LambdaCapture extends @lambdacapture {
  string toString() {
    result = getField().toString()
  }

  /** Canonical QL class corresponding to this element. */
  override string getCanonicalQLClass() { result = "LambdaCapture" }

  /**
   * Holds if this capture was made implicitly.
   */
  predicate isImplicit() {
    lambda_capture(this, _, _, _, true, _)
  }

  /**
   * Holds if the variable was captured by reference.
   *
   * An identifier is captured by reference if:
   *   - It is explicitly captured by reference.
   *   - It is implicitly captured, and the lambda's default capture mode is by-reference.
   *   - The identifier is "this". [Said behaviour is dictated by the C++11 standard, but it
   *                                is actually "*this" being captured rather than "this".]
   */
  predicate isCapturedByReference() {
    lambda_capture(this, _, _, true, _, _)
  }

  /**
   * Gets the location of the declaration of this capture.
   *
   * For explicit captures, this is a location within the "[...]" part of the lambda expression.
   *
   * For implicit captures, this is the first location within the "{...}" part of the lambda
   * expression which accesses the captured variable.
   */
  Location getLocation() {
    lambda_capture(this, _, _, _, _, result)
  }

  /**
   * Gets the field of the lambda expression's closure type which is used to store this capture.
   */
  MemberVariable getField() {
    exists(LambdaExpression lambda, int index | this = lambda.getCapture(index) |
      result = lambda.getType().(Closure).getCanonicalMember(index)
    )
  }

  /**
   * Gets the expression which yields the final captured value.
   *
   * In many cases, this will be an instance of VariableAccess.
   * If a this-pointer is being captured, this will be an instance of ThisExpr.
   * For by-value captures of non-primitive types, this will be a call to a copy constructor.
   */
  Expr getInitializer() {
    exists(LambdaExpression lambda, int index | this = lambda.getCapture(index) |
      result = lambda.getChild(0)     // Call to the constructor of the closure type.
                     .getChild(index) // The appropriate argument to the constructor.
    )
  }
}
