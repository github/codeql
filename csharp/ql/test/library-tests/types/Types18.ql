/**
 * @name Test for struct type
 * @kind table
 */

import csharp

from Struct s
where s.hasFullyQualifiedName("Types", "Struct")
select s
