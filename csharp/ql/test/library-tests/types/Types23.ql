/**
 * @name Test for unbound generic struct type
 * @kind table
 */

import csharp

from UnboundGenericStruct c
where c.hasFullyQualifiedName("Types", "GenericStruct`1")
select c
