/**
 * Provides classes for working with Google Closure code.
 */

import javascript

/**
 * A call to a function in the `goog` namespace such as `goog.provide` or `goog.load`.
 */
class GoogFunctionCall extends CallExpr {
  GoogFunctionCall() {
    exists(GlobalVariable gv | gv.getName() = "goog" |
      this.getCallee().(DotExpr).getBase() = gv.getAnAccess()
    )
  }

  /** Gets the name of the invoked function. */
  string getFunctionName() { result = getCallee().(DotExpr).getPropertyName() }
}

/**
 * An expression statement consisting of a call to a function
 * in the `goog` namespace.
 */
class GoogFunctionCallStmt extends ExprStmt {
  GoogFunctionCallStmt() { super.getExpr() instanceof GoogFunctionCall }

  override GoogFunctionCall getExpr() { result = super.getExpr() }

  /** Gets the name of the invoked function. */
  string getFunctionName() { result = getExpr().getFunctionName() }

  /** Gets the `i`th argument to the invoked function. */
  Expr getArgument(int i) { result = getExpr().getArgument(i) }

  /** Gets an argument to the invoked function. */
  Expr getAnArgument() { result = getArgument(_) }
}

/**
 * A call to `goog.provide`.
 */
class GoogProvide extends GoogFunctionCallStmt {
  GoogProvide() { getFunctionName() = "provide" }

  /** Gets the identifier of the namespace created by this call. */
  string getNamespaceId() { result = getArgument(0).(ConstantString).getStringValue() }
}

/**
 * A call to `goog.require`.
 */
class GoogRequire extends GoogFunctionCallStmt {
  GoogRequire() { getFunctionName() = "require" }

  /** Gets the identifier of the namespace imported by this call. */
  string getNamespaceId() { result = getArgument(0).(ConstantString).getStringValue() }
}

/**
 * A Closure module, that is, a toplevel that contains a call to `goog.provide` or
 * `goog.require`.
 */
class ClosureModule extends TopLevel {
  ClosureModule() {
    getAChildStmt() instanceof GoogProvide or
    getAChildStmt() instanceof GoogRequire
  }

  /** Gets the identifier of a namespace required by this module. */
  string getARequiredNamespace() { result = getAChildStmt().(GoogRequire).getNamespaceId() }

  /** Gets the identifer of a namespace provided by this module. */
  string getAProvidedNamespace() { result = getAChildStmt().(GoogProvide).getNamespaceId() }
}
