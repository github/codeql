/**
 * Provide universal sanitizer guards.
 */

import java
import semmle.code.java.dataflow.DataFlow

/**
 * An contains method sanitizer guard.
 * 
 * e.g. `if(test.contains("test")) {...`
 */
class ContainsSanitizer extends DataFlow::BarrierGuard {
  ContainsSanitizer() { this.(MethodAccess).getMethod().hasName("contains") }

  override predicate checks(Expr e, boolean branch) {
    e = this.(MethodAccess).getArgument(0) and branch = true
  }
}

/**
 * An equals method sanitizer guard.
 * 
 * e.g. `if("test".equals(test)) {...`
 */
class EqualsSanitizer extends DataFlow::BarrierGuard {
  EqualsSanitizer() { this.(MethodAccess).getMethod().hasName("equals") }

  override predicate checks(Expr e, boolean branch) {
    e = [this.(MethodAccess).getArgument(0), this.(MethodAccess).getQualifier()] and
    branch = true
  }
}
