/**
 * @name Scopes3
 * @kind table
 */

import cpp

from MemberFunction f, string constructor, Class declType, int countAtScope
where
  (if f instanceof Constructor then constructor = "Constructor" else constructor = "") and
  declType = f.getDeclaringType() and
  countAtScope = count(Element other | other.getParentScope() = declType)
select f, constructor, declType, countAtScope
