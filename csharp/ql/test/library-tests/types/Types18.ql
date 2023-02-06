/**
 * @name Test for struct type
 * @kind table
 */

import csharp

from Struct s
where s.hasQualifiedName("Types", "Struct")
select s
