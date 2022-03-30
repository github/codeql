/**
 * @name Test for unbound generic class type
 * @kind table
 */

import csharp

from UnboundGenericClass c
where c.getQualifiedName() = "Types.GenericClass<>"
select c
