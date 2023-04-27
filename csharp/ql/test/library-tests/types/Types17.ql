/**
 * @name Test for enum type
 * @kind table
 */

import csharp

from Enum e
where e.hasQualifiedName("Types", "Enum")
select e
