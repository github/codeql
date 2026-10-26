/**
 * @name Magic numbers
 * @description A magic number makes code less readable and maintainable.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/magic-number
 * @tags maintainability
 *       readability
 *       statistical
 *       non-attributable
 */

import java
import MagicConstants

from Literal e, string msg
where
  magicConstant(e, msg) and
  isNumber(e)
select e, msg
