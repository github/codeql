/**
 * @name AV Rule 13
 * @description Multi-byte characters and wide string literals will not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-13
 * @problem.severity error
 * @tags maintainability
 *       portability
 *       external/jsf
 */

import cpp

from Literal l
where
  l.getType() instanceof Wchar_t or
  l.getType().(ArrayType).getBaseType().getUnspecifiedType() instanceof Wchar_t
select l, "AV Rule 13: Multi-byte characters and wide string literals will not be used."
