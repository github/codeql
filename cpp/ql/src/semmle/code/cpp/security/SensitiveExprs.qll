/**
 * Provides classes for heuristically identifying variables and functions that
 * might contain or return a password or other sensitive information.
 */

import cpp

/**
 * Holds if the name `s` suggests something might contain or return a password
 * or other sensitive information.
 */
bindingset[s]
private predicate suspicious(string s) {
  (
    s.matches("%password%") or
    s.matches("%passwd%") or
    s.matches("%trusted%")
  ) and
  not (
    s.matches("%hash%") or
    s.matches("%crypt%") or
    s.matches("%file%") or
    s.matches("%path%")
  )
}

/**
 * A variable that might contain a password or other sensitive information.
 */
class SensitiveVariable extends Variable {
  SensitiveVariable() {
    suspicious(getName().toLowerCase()) and
    not this.getUnspecifiedType() instanceof IntegralType
  }
}

/**
 * A function that might return a password or other sensitive information.
 */
class SensitiveFunction extends Function {
  SensitiveFunction() {
    suspicious(getName().toLowerCase()) and
    not this.getUnspecifiedType() instanceof IntegralType
  }
}

/**
 * An expression whose value might be a password or other sensitive information.
 */
class SensitiveExpr extends Expr {
  SensitiveExpr() {
    this.(VariableAccess).getTarget() instanceof SensitiveVariable or
    this.(FunctionCall).getTarget() instanceof SensitiveFunction
  }
}
