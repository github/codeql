/**
 * @name Magic numbers: use defined constant
 * @description A numeric literal that matches the initializer of a final variable was found. Consider using the final variable instead of the numeric literal.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/use-number-constant
 * @tags changeability
 *       maintainability
 */

import MagicConstants

from Literal magicLiteral, string message, Field constant
where
  isNumber(magicLiteral) and
  literalInsteadOfConstant(magicLiteral, _, message, constant)
select magicLiteral, message, constant, constant.getName()
