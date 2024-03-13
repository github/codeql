/**
 * @name Test for interface type
 * @kind table
 */

import csharp

from Interface i
where i.hasFullyQualifiedName("Types", "Interface")
select i
