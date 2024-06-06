import java
import semmle.code.java.comparison.Comparison

/**
 * An `equals` method that implies the superclass `equals` method is a "finer" equality check.
 *
 * Importantly, in this case an inherited hash code is still valid, since
 *
 *     subclass equals holds => superclass equals holds => hash codes match
 */
class RefiningEquals extends EqualsMethod {
  RefiningEquals() {
    // For each return statement `ret` in this method, ...
    forall(ReturnStmt ret | ret.getEnclosingCallable() = this |
      // ... there is a `super` access that ...
      exists(MethodCall sup, SuperAccess qual |
        // ... is of the form `super.something`, but not `A.super.something` ...
        qual = sup.getQualifier() and
        not exists(qual.getQualifier()) and
        // ... calls `super.equals` ...
        sup.getCallee() instanceof EqualsMethod and
        // ... on the (only) parameter of this method ...
        sup.getArgument(0).(VarAccess).getVariable() = this.getAParameter() and
        // ... and its result is implied by the result of `ret`.
        exprImplies(ret.getResult(), true, sup, true)
      )
    )
  }
}
