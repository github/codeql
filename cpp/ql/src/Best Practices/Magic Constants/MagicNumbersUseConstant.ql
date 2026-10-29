/**
 * @name Magic numbers: use defined constant
 * @description A numeric literal that matches the initializer of a constant variable was found. Consider using the constant variable instead of the numeric literal.
 * @kind problem
 * @id cpp/use-number-constant
 * @problem.severity recommendation
 * @precision low
 * @tags maintainability
 */

import cpp
import MagicConstants

from Literal magicLiteral, string message, Variable constant, string linkText
where
  numberType(magicLiteral.getType()) and
  literalInsteadOfConstant(magicLiteral, message, constant, linkText)
select magicLiteral, message, constant, linkText
