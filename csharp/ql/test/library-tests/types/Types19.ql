/**
 * @name Test for class type
 * @kind table
 */

import csharp

from Class c
where c.hasFullyQualifiedName("Types", "Class")
select c
