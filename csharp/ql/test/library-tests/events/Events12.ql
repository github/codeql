/**
 * @name Test for events
 */

import csharp

where
  forex(AddEventAccessor a | a.fromSource() |
    a.getParameter(0).hasName("value") and
    a.getParameter(0).getType() = a.getDeclaration().getType() and
    a.getNumberOfParameters() = 1
  )
select 1
