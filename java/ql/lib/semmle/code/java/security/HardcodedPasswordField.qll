/**
 * Provides a predicate identifying assignments of harcoded values to password fields.
 */
overlay[local?]
module;

import java
import HardcodedCredentials

/**
 * Holds if non-empty constant value `e` is assigned to password field `f`.
 */
predicate passwordFieldAssignedHardcodedValue(PasswordVariable f, CompileTimeConstantExpr e) {
  f instanceof Field and
  f.getAnAssignedValue() = e and
  not e.(StringLiteral).getValue() = ""
}
