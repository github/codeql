/**
 * @name Problem query
 * @description Description of the problem
 * @kind problem
 * @problem.severity warning
 * @id ql/problem-query
 */

import ql

from VarDecl decl
where none()
select decl, "Problem"
