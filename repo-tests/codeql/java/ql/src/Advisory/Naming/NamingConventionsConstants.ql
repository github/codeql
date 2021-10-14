/**
 * @name Misnamed static final field
 * @description A static, final field name that contains lowercase letters decreases readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/misnamed-constant
 * @tags maintainability
 */

import java
import NamingConventionsCommon

from ConstantField f
where
  f.fromSource() and
  not f.getName() = "serialVersionUID" and
  f.getType() instanceof ImmutableType and
  not f.getName().toUpperCase() = f.getName()
select f, "Static final fields should not contain lowercase letters."
