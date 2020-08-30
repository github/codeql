/**
 * @name Raising a tuple
 * @description Raising a tuple will result in all but the first element being discarded
 * @kind problem
 * @tags maintainability
 * @problem.severity warning
 * @sub-severity high
 * @precision very-high
 * @id py/raises-tuple
 */

import python

from Raise r, Value v, AstNode origin
where
  r.getException().pointsTo(v, origin) and
  v.getClass() = ClassValue::tuple() and
  major_version() = 2
/* Raising a tuple is a type error in Python 3, so is handled by the IllegalRaise query. */
select r,
  "Raising $@ will result in the first element (recursively) being raised and all other elements being discarded.",
  origin, "a tuple"
