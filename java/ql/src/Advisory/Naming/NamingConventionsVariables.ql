/**
 * @name Misnamed variable
 * @description A variable name that begins with an uppercase letter decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/misnamed-variable
 * @tags maintainability
 */

import java
import NamingConventionsCommon

from Variable v
where
  v.fromSource() and
  not v instanceof ConstantField and
  v.getName().substring(0, 1).toLowerCase() != v.getName().substring(0, 1)
select v, "Variable names should start in lowercase."
