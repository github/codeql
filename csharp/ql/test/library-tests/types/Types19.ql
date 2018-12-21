/**
 * @name Test for class type
 * @kind table
 */

import csharp

from Class c
where c.getQualifiedName() = "Types.Class"
select c
