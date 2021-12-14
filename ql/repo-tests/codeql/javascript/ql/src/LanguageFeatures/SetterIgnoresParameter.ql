/**
 * @name Setter ignores its parameter
 * @description A setter function can silently ignore the new value that the property is meant to
 *              be set to, but this may result in unexpected behavior and could indicate a bug.
 * @kind problem
 * @problem.severity recommendation
 * @id js/ignored-setter-parameter
 * @tags reliability
 *       maintainability
 *       language-features
 * @precision low
 */

import javascript
import semmle.javascript.RestrictedLocations

from PropertySetter s, FunctionExpr f, SimpleParameter p
where
  f = s.getInit() and
  p = f.getAParameter() and
  not exists(p.getVariable().getAnAccess()) and
  not f.usesArgumentsObject() and
  // the setter body is either empty, or it is not just a single 'throw' statement
  (
    not exists(f.getABodyStmt())
    or
    exists(Stmt stmt | stmt = f.getABodyStmt() | not stmt instanceof ThrowStmt)
  )
select s.(FirstLineOf), "This setter function does not use its parameter $@.", p, p.getName()
