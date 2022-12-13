/**
 * @name Test for class type
 * @kind table
 */

import csharp

from Class c
where c.hasQualifiedName("Types", "Class")
select c
