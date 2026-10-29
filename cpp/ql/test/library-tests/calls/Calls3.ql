/**
 * @name Calls3
 * @kind table
 */

import cpp

from FunctionCall c, CppFile f
where c.getTarget().getFile() = f
select c, c.getTarget().getName(), f.getAbsolutePath()
