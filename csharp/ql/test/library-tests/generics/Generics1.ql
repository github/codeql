/**
 * @name Test for generics
 */

import csharp

from UnboundGenericDelegateType d
where
  d.hasName("GenericDelegate<>") and
  d.getTypeParameter(0).hasName("T") and
  d.getParameter(0).getType().hasName("T")
select d
