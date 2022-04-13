/**
 * @name Redundant cast
 * @description Redundant casts
 * @kind problem
 * @problem.severity warning
 * @id ql/redundant-cast
 * @tags maintainability
 * @precision high
 */

import ql
import codeql_ql.style.RedundantCastQuery

from AstNode node, TypeExpr type
where redundantCast(node, type)
select node, "Redundant cast to $@", type, type.getResolvedType().getName()
