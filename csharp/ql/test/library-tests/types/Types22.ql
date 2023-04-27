/**
 * @name Test for unbound generic interface type
 * @kind table
 */

import csharp

from UnboundGenericInterface c
where c.hasQualifiedName("Types", "GenericInterface<>")
select c
