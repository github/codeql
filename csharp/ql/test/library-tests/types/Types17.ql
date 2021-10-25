/**
 * @name Test for enum type
 * @kind table
 */

import csharp

from Enum e
where e.getQualifiedName() = "Types.Enum"
select e
