/**
 * @name Reference equality test on java.lang.Object
 * @description Reference comparisons (== or !=) with operands where the static type is 'Object' may
 *              not work as intended.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/reference-equality-with-object
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-595
 */

import semmle.code.java.Member
import semmle.code.java.JDK

/** An expression that accesses a field declared `final`. */
class FinalFieldAccess extends VarAccess {
  FinalFieldAccess() { this.getVariable().(Field).isFinal() }
}

class ReferenceEqualityTestOnObject extends ReferenceEqualityTest {
  ReferenceEqualityTestOnObject() {
    this.getLeftOperand().getType() instanceof TypeObject and
    this.getRightOperand().getType() instanceof TypeObject and
    not this.getLeftOperand() instanceof FinalFieldAccess and
    not this.getRightOperand() instanceof FinalFieldAccess
  }
}

from ReferenceEqualityTestOnObject scw
where
  not exists(Variable left, Variable right, MethodCall equals |
    left = scw.getLeftOperand().(VarAccess).getVariable() and
    right = scw.getRightOperand().(VarAccess).getVariable() and
    scw.getEnclosingCallable() = equals.getEnclosingCallable() and
    equals.getMethod() instanceof EqualsMethod and
    equals.getQualifier().(VarAccess).getVariable() = left and
    equals.getAnArgument().(VarAccess).getVariable() = right
  )
select scw, "Avoid reference equality for java.lang.Object comparisons."
