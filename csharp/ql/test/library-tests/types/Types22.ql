/**
 * @name Test for unbound generic interface type
 * @kind table
 */

import csharp

from UnboundGenericInterface c
where c.getQualifiedName() = "Types.GenericInterface<>"
select c
