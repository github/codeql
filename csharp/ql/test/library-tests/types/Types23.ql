/**
 * @name Test for unbound generic struct type
 * @kind table
 */

import csharp

from UnboundGenericStruct c
where c.hasQualifiedName("Types", "GenericStruct<>")
select c
