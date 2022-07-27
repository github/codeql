/**
 * @name Variables without types
 * @description List all variables that don't have a type in the database.
 * @kind diagnostic
 * @id cpp/diagnostics/variables-without-types
 */

import cpp

from Variable i
where not exists(i.getType())
select i, "Variable " + i + " doesn't have a type", /*severity=*/1
