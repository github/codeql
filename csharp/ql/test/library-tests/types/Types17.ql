/**
 * @name Test for enum type
 * @kind table
 */

import csharp

from Enum e
where e.hasFullyQualifiedName("Types", "Enum")
select e
