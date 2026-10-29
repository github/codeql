/**
 * @name Test for unbound generic class type
 * @kind table
 */

import csharp

from UnboundGenericClass c
where c.hasFullyQualifiedName("Types", "GenericClass`1")
select c
