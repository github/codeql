/**
 * @name Wait on condition
 * @description Calling 'wait' on a 'Condition' interface may result in unexpected behavior and is
 *              probably a typographical error.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/wait-on-condition-interface
 * @tags reliability
 *       correctness
 *       concurrency
 *       external/cwe/cwe-662
 */

import java

class WaitMethod extends Method {
  WaitMethod() {
    this.hasName("wait") and
    this.hasNoParameters() and
    this.getDeclaringType().hasQualifiedName("java.lang", "Object")
  }
}

class ConditionInterface extends Interface {
  ConditionInterface() { this.hasQualifiedName("java.util.concurrent.locks", "Condition") }
}

from MethodCall ma, ConditionInterface condition
where
  ma.getMethod() instanceof WaitMethod and
  ma.getQualifier().getType().(RefType).hasSupertype*(condition)
select ma, "Waiting for a condition should use Condition.await, not Object.wait."
