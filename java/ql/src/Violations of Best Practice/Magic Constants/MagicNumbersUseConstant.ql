/**
 * @name Magic numbers: use defined constant
 * @description A magic number, which is used instead of an existing named constant, makes code less
 *              readable and maintainable.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/use-number-constant
 * @tags maintainability
 *       readability
 */

import java
import MagicConstants

from Literal magicLiteral, string message, Field field, string linkText
where
  isNumber(magicLiteral) and
  literalInsteadOfConstant(magicLiteral, message, field, linkText)
select magicLiteral, message, field, linkText
