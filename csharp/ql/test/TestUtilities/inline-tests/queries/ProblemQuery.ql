/**
 * @kind problem
 * @id problem-query
 */

import csharp

from StringLiteral sl
where sl.getValue() = "Alert"
select sl, "This is a problem"
