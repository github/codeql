/**
 * @name Inconsistent return statements
 * @description A function should either always return an explicit value, or never return a value.
 * @kind problem
 * @problem.severity recommendation
 * @id js/mixed-returns
 * @tags reliability
 *       maintainability
 * @precision medium
 */

import javascript

from Function f, ReturnStmt explicit, ReturnStmt implicit
where
  explicit.getContainer() = f and
  implicit.getContainer() = f and
  exists(explicit.getExpr()) and
  not exists(implicit.getExpr())
select implicit,
  "This return statement implicitly returns 'undefined', whereas $@ returns an explicit value.",
  explicit, "another return statement in the same function"
