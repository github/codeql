/**
 * @name Test for unbound generic interface type
 * @kind table
 */

import csharp

from UnboundGenericInterface c
where c.hasFullyQualifiedName("Types", "GenericInterface`1")
select c
