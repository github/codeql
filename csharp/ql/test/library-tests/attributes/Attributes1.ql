/**
 * @name Test that types, methods, and parameters can have attributes
 */

import csharp

where
  exists(Attribute a | a.getTarget() instanceof Type) and
  exists(Attribute a | a.getTarget() instanceof Method) and
  exists(Attribute a | a.getTarget() instanceof Parameter)
select 1
