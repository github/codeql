/**
 * @name Redundant inline cast
 * @description Redundant inline casts
 * @kind problem
 * @problem.severity warning
 * @id ql/redundant-inline-cast
 * @tags maintainability
 * @precision high
 */

import ql
import codeql_ql.style.RedundantInlineCastQuery

from RedundantInlineCast cast
select cast, "Redundant cast to $@", cast.getTypeExpr(),
  cast.getTypeExpr().getResolvedType().getName()
