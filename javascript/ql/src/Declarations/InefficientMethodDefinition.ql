/**
 * @name Inefficient method definition
 * @description Defining methods in the constructor (as opposed to adding them to the
 *              prototype object) is inefficient.
 * @kind problem
 * @problem.severity recommendation
 * @id js/method-definition-in-constructor
 * @tags efficiency
 *       maintainability
 * @precision medium
 * @deprecated This query is prone to false positives. Deprecated since 1.17.
 */

import javascript
import semmle.javascript.RestrictedLocations

/**
 * Holds if `stmt` is of the form `this.<name> = <method>;`.
 */
predicate methodDefinition(ExprStmt stmt, string name, Function method) {
  exists(AssignExpr assgn, PropAccess pacc |
    assgn = stmt.getExpr() and
    pacc = assgn.getLhs() and
    pacc.getBase() instanceof ThisExpr and
    name = pacc.getPropertyName() and
    method = assgn.getRhs()
  )
}

from Function ctor, ExprStmt defn, string name, Function method
where
  not ctor instanceof ImmediatelyInvokedFunctionExpr and
  defn = ctor.getABodyStmt() and
  methodDefinition(defn, name, method) and
  // if the method captures a local variable of the constructor, it cannot
  // easily be moved to the constructor object
  not exists(Variable v | v.getScope() = ctor.getScope() |
    v.getAnAccess().getContainer().getEnclosingContainer*() = method
  )
select defn.(FirstLineOf),
  name + " should be added to the prototype object rather than to each instance."
