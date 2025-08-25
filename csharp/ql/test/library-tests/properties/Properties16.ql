/**
 * @name Test for properties
 */

import csharp

from Property p
where
  p.hasName("Init") and
  p.getDeclaringType().hasFullyQualifiedName("Properties", "Test") and
  p.getSetter().getNumberOfParameters() = 1 and
  p.getSetter().getParameter(0) instanceof ImplicitAccessorParameter
select p, p.getSetter().getParameter(0)
