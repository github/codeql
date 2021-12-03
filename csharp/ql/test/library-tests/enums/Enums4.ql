/**
 * @name Test for enums
 */

import csharp

where forall(Enum e | e.getBaseClass().hasQualifiedName("System.Enum"))
select 1
