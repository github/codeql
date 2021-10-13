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

import java

/** A cast inside a try-catch block that catches `ClassCastException`. */
class CheckedCast extends CastExpr {
  CheckedCast() {
    exists(TryStmt try, RefType cce |
      this.getEnclosingStmt().getEnclosingStmt+() = try and
      try.getACatchClause().getVariable().getType() = cce and
      cce.getQualifiedName() = "java.lang.ClassCastException"
    )
  }
}

predicate hasTypeTest(Variable v) {
  any(InstanceOfExpr ioe).getExpr() = v.getAnAccess()
  or
  exists(MethodAccess ma |
    ma.getMethod().getName() = "getClass" and
    ma.getQualifier() = v.getAnAccess()
  )
  or
  any(CheckedCast cc).getExpr() = v.getAnAccess()
  or
  exists(Parameter p | hasTypeTest(p) and p.getAnArgument() = v.getAnAccess())
}

/**
 * An `equals` method with a body of either `return o == this;`
 *  or `return o == field;`
 */
class ReferenceEquals extends EqualsMethod {
  ReferenceEquals() {
    exists(BlockStmt b, ReturnStmt ret, EQExpr eq |
      this.getBody() = b and
      b.getStmt(0) = ret and
      ret.getResult() = eq and
      eq.getAnOperand() = this.getAParameter().getAnAccess() and
      (eq.getAnOperand() instanceof ThisAccess or eq.getAnOperand() instanceof FieldAccess)
    )
  }
}

class UnimplementedEquals extends EqualsMethod {
  UnimplementedEquals() { this.getBody().getStmt(0) instanceof ThrowStmt }
}

from EqualsMethod m
where
  exists(m.getBody()) and
  exists(Parameter p | p = m.getAParameter() |
    // The parameter has no type test
    not hasTypeTest(p) and
    // If the parameter is passed to a method for which we don't have the source
    // we assume it's ok
    not exists(MethodAccess ma |
      not exists(ma.getMethod().getBody()) and
      ma.getAnArgument() = p.getAnAccess()
    )
  ) and
  not m.getDeclaringType() instanceof Interface and
  // Exclude `equals` methods that implement reference-equality.
  not m instanceof ReferenceEquals and
  not m instanceof UnimplementedEquals
select m, "equals() method does not seem to check argument type."
