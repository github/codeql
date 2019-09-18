/**
 * @name Test for generics
 */

import csharp

from ConstructedDelegateType d
where
  d.hasName("GenericDelegate<String>") and
  d.getTypeArgument(0) instanceof StringType and
  d.getParameter(0).getType() instanceof StringType
select d
