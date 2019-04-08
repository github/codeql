/**
 * @name Equals method does not inspect argument type
 * @description An implementation of 'equals' that does not check the type
 *              of its argument may lead to failing casts.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/unchecked-cast-in-equals
 * @tags reliability
 *       correctness
 */

import semmle.code.java.Member
import semmle.code.java.JDK

/** A cast inside a try-catch block that catches `ClassCastException`. */
class CheckedCast extends CastExpr {
  CheckedCast() {
    exists(TryStmt try, RefType cce |
      this.getEnclosingStmt().getEnclosingStmt+() = try and
      try.getACatchClause().getVariable().getType() = cce and
      cce.getQualifiedName() = "java.lang.ClassCastException"
    )
  }

  Variable castVariable() { result.getAnAccess() = this.getExpr() }
}

/**
 * An `equals` method with a body of either `return o == this;`
 *  or `return o == field;`
 */
class ReferenceEquals extends EqualsMethod {
  ReferenceEquals() {
    exists(Block b, ReturnStmt ret, EQExpr eq |
      this.getBody() = b and
      b.getStmt(0) = ret and
      (
        ret.getResult() = eq
        or
        exists(ParExpr pe | ret.getResult() = pe and pe.getExpr() = eq)
      ) and
      eq.getAnOperand() = this.getAParameter().getAnAccess() and
      (eq.getAnOperand() instanceof ThisAccess or eq.getAnOperand() instanceof FieldAccess)
    )
  }
}

from EqualsMethod m
where
  // The parameter is accessed at least once ...
  exists(VarAccess va | va.getVariable() = m.getParameter()) and
  // ... but its type is not checked using `instanceof`.
  not exists(InstanceOfExpr e |
    e.getEnclosingCallable() = m and
    e.getExpr().(VarAccess).getVariable() = m.getParameter()
  ) and
  // Exclude cases that are probably OK.
  not exists(MethodAccess ma, Method c | ma.getEnclosingCallable() = m and ma.getMethod() = c |
    c.hasName("getClass")
    or
    c.hasName("compareTo")
    or
    c.hasName("equals")
    or
    c.hasName("isInstance")
    or
    c.hasName("reflectionEquals")
    or
    // If both `this` and the argument are passed to another method,
    // or if the argument is passed to a method declared or inherited by `this` type,
    // that method may do the right thing.
    ma.getAnArgument() = m.getParameter().getAnAccess() and
    (
      ma.getAnArgument() instanceof ThisAccess
      or
      exists(Method delegate | delegate.getSourceDeclaration() = ma.getMethod() |
        m.getDeclaringType().inherits(delegate)
      )
    )
  ) and
  not m.getDeclaringType() instanceof Interface and
  // Exclude checked casts (casts inside `try`-blocks).
  not exists(CheckedCast cast | cast.castVariable() = m.getAParameter()) and
  // Exclude `equals` methods that implement reference-equality.
  not m instanceof ReferenceEquals
select m, "equals() method does not seem to check argument type."
