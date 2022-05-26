/**
 * Provides classes for heuristically identifying variables and functions that
 * might contain or return a password or other credential.
 *
 * This library is not concerned with other kinds of sensitive private
 * information. See `PrivateData.qll` for expressions related to that.
 */

import cpp

/**
 * Holds if the name `s` suggests something might contain or return a password
 * or other credential.
 */
bindingset[s]
private predicate suspicious(string s) {
  s.regexpMatch(".*(password|passwd|accountid|account.?key|accnt.?key|license.?key|trusted).*") and
  not s.matches(["%hash%", "%crypt%", "%file%", "%path%", "%invalid%"])
}

/**
 * A variable that might contain a password or other credential.
 */
class SensitiveVariable extends Variable {
  SensitiveVariable() {
    suspicious(this.getName().toLowerCase()) and
    not this.getUnspecifiedType() instanceof IntegralType
  }
}

/**
 * A function that might return a password or other credential.
 */
class SensitiveFunction extends Function {
  SensitiveFunction() {
    suspicious(this.getName().toLowerCase()) and
    not this.getUnspecifiedType() instanceof IntegralType
  }
}

/**
 * An expression whose value might be a password or other credential.
 */
class SensitiveExpr extends Expr {
  SensitiveExpr() {
    this.(VariableAccess).getTarget() instanceof SensitiveVariable or
    this.(FunctionCall).getTarget() instanceof SensitiveFunction
  }
}
