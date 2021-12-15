/**
 * @name Test for struct type
 * @kind table
 */

import csharp

from Struct s
where s.getQualifiedName() = "Types.Struct"
select s
