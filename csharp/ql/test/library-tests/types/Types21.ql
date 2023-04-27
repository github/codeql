/**
 * @name Test for unbound generic class type
 * @kind table
 */

import csharp

from UnboundGenericClass c
where c.hasQualifiedName("Types", "GenericClass<>")
select c
