/**
 * @name Test for enums
 */

import csharp

from FieldAccess fa
where fa.getParent().(Field).getDeclaringType() instanceof Enum
select fa, fa.getValue()
