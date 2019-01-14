/**
 * @name Test for generics
 */

import csharp

from Class c
where
  c.hasName("A") and
  not c instanceof UnboundGenericClass
select c
