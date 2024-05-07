/**
 * @name Implicit narrowing conversion in compound assignment
 * @description Compound assignment statements (for example 'intvar += longvar') that implicitly
 *              cast a value of a wider type to a narrower type may result in information loss and
 *              numeric errors such as overflows.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision very-high
 * @id java/implicit-cast-in-compound-assignment
 * @tags reliability
 *       security
 *       external/cwe/cwe-190
 *       external/cwe/cwe-192
 *       external/cwe/cwe-197
 *       external/cwe/cwe-681
 */

import semmle.code.java.arithmetic.Overflow

class DangerousAssignOpExpr extends AssignOp {
  DangerousAssignOpExpr() {
    this instanceof AssignAddExpr or
    this instanceof AssignMulExpr
  }
}

predicate problematicCasting(Type t, Expr e) { e.getType().(NumType).widerThan(t) }

Variable getVariable(Expr dest) {
  result = dest.(VarAccess).getVariable()
  or
  result = dest.(ArrayAccess).getArray().(VarAccess).getVariable()
}

from DangerousAssignOpExpr a, Expr e, Top v
where
  e = a.getSource() and
  problematicCasting(a.getDest().getType(), e) and
  (
    v = getVariable(a.getDest())
    or
    // fallback, in case we can't easily determine the variable
    not exists(getVariable(a.getDest())) and
    v = a.getDest()
  )
select a,
  "Implicit cast of source type " + e.getType().getName() + " to narrower destination type $@.", v,
  a.getDest().getType().getName()
