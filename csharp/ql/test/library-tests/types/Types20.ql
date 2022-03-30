/**
 * @name Test for interface type
 * @kind table
 */

import csharp

from Interface i
where i.getQualifiedName() = "Types.Interface"
select i
