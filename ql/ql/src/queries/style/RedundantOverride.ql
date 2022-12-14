/**
 * @name Redundant override
 * @description Redundant override
 * @kind problem
 * @problem.severity warning
 * @id ql/redundant-override
 * @tags maintainability
 * @precision high
 */

import ql
import codeql_ql.style.RedundantOverrideQuery

from ClassPredicate pred, ClassPredicate sup
where redundantOverride(pred, sup)
select pred, "Redundant override of $@.", sup, "this predicate"
