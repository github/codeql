/**
 * Provides classes and predicates to detect comparing a parameter to a hard-coded credential.
 */

import java
import HardcodedCredentials

/**
 * A call to a method that is or overrides `java.lang.Object.equals`.
 */
class EqualsCall extends MethodCall {
  EqualsCall() { this.getMethod() instanceof EqualsMethod }
}

/**
 * Holds if `sink` compares password `p` against a hardcoded expression `source`.
 */
predicate isHardcodedCredentialsComparison(EqualsCall sink, HardcodedExpr source, PasswordVariable p) {
  source = sink.getQualifier() and
  p.getAnAccess() = sink.getArgument(0)
  or
  source = sink.getArgument(0) and
  p.getAnAccess() = sink.getQualifier()
}
