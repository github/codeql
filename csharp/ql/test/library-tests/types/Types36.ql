/* Ensure that built-in types can be interfaces */

import csharp

from Interface i
where i.hasQualifiedName("System.Collections.IEnumerable")
select i.getQualifiedName()
