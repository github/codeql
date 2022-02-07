/**
 * @name Equality test on floating point values
 * @description Equality tests on floating point values may lead to unexpected results.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/equality-test-on-floating-point
 * @tags reliability
 *       correctness
 */

import semmle.code.java.Type
import semmle.code.java.Expr

// Either `float`, `double`, `Float`, or `Double`.
class Floating extends Type {
  Floating() {
    exists(string s | s = this.getName().toLowerCase() |
      s = "float" or
      s = "double"
    )
  }
}

predicate trivialLiteral(Literal e) {
  e.getValue() = "0.0" or
  e.getValue() = "0" or
  e.getValue() = "1.0" or
  e.getValue() = "1"
}

predicate definedConstant(Expr e) {
  exists(Field f |
    f.isStatic() and
    (
      f.getDeclaringType().hasName("Float") or
      f.getDeclaringType().hasName("Double")
    )
  |
    e = f.getAnAccess()
  )
}

// The contract of `compareTo` would not really allow anything other than `<` or `>` on floats.
predicate comparisonMethod(Method m) { m.getName() = "compareTo" }

// Check for equalities of the form `a.x == b.x` or `a.x == x`, where `x` is assigned to `a.x`,
// which are less interesting but occur often.
predicate similarVarComparison(EqualityTest e) {
  exists(Field f |
    e.getLeftOperand() = f.getAnAccess() and
    e.getRightOperand() = f.getAnAccess()
  )
  or
  exists(Field f, Variable v |
    e.getAnOperand() = f.getAnAccess() and
    e.getAnOperand() = v.getAnAccess() and
    f.getAnAssignedValue() = v.getAnAccess()
  )
}

from EqualityTest ee
where
  ee.getAnOperand().getType() instanceof Floating and
  not ee.getAnOperand() instanceof NullLiteral and
  not trivialLiteral(ee.getAnOperand()) and
  not definedConstant(ee.getAnOperand()) and
  not similarVarComparison(ee) and
  not comparisonMethod(ee.getEnclosingCallable())
select ee, "Equality test on floating point values."
