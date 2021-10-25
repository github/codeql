/**
 * @name Test for unbound generic struct type
 * @kind table
 */

import csharp

from UnboundGenericStruct c
where c.getQualifiedName() = "Types.GenericStruct<>"
select c
