/**
 * @name Reference equality test on strings
 * @description Comparing two strings using the == or != operator
 *              compares object identity, which may not be intended.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/reference-equality-on-strings
 * @tags reliability
 *       external/cwe/cwe-597
 */

import java

/** An expression of type `java.lang.String`. */
class StringValue extends Expr {
  StringValue() { this.getType() instanceof TypeString }

  predicate isInterned() {
    // A call to `String.intern()`.
    exists(Method intern |
      intern.getDeclaringType() instanceof TypeString and
      intern.hasName("intern") and
      this.(MethodCall).getMethod() = intern
    )
    or
    // Ternary conditional operator.
    this.(ConditionalExpr).getTrueExpr().(StringValue).isInterned() and
    this.(ConditionalExpr).getFalseExpr().(StringValue).isInterned()
    or
    // Values of type `String` that are compile-time constant expressions (JLS 15.28).
    this instanceof CompileTimeConstantExpr
    or
    // Variables that are only ever assigned an interned `StringValue`.
    variableValuesInterned(this.(VarAccess).getVariable())
    or
    // Method accesses whose results are all interned.
    forex(ReturnStmt rs | rs.getEnclosingCallable() = this.(MethodCall).getMethod() |
      rs.getResult().(StringValue).isInterned()
    )
  }
}

pragma[noinline]
predicate candidateVariable(Variable v) {
  v.fromSource() and
  // For parameters, assume they could be non-interned.
  not v instanceof Parameter and
  // If the string is modified with `+=`, then the new string is not interned
  // even if the components are.
  not exists(AssignOp append | append.getDest() = v.getAnAccess())
}

predicate variableValuesInterned(Variable v) {
  candidateVariable(v) and
  // All assignments to variables are interned.
  forall(StringValue sv | sv = v.getAnAssignedValue() | sv.isInterned())
}

from ReferenceEqualityTest e, StringValue lhs, StringValue rhs
where
  e.getLeftOperand() = lhs and
  e.getRightOperand() = rhs and
  not (lhs.isInterned() and rhs.isInterned())
select e, "String values compared with " + e.getOp() + "."
