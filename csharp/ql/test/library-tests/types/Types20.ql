/**
 * @name Test for interface type
 * @kind table
 */

import csharp

from Interface i
where i.hasQualifiedName("Types", "Interface")
select i
