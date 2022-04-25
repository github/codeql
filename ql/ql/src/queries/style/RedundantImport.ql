/**
 * @name Redundant import
 * @description An import that is redundant due to an earlier import
 * @kind problem
 * @problem.severity warning
 * @id ql/redundant-import
 * @tags correctness
 *       performance
 * @precision high
 */

import ql
import codeql_ql.style.RedundantImportQuery

from Import imp, Import redundant, string message
where problem(imp, redundant, message)
select redundant, message, imp, imp.getImportString()
