/**
 * @name Magic strings: use defined constant
 * @description A string literal that matches the initializer of a constant variable was found. Consider using the constant variable instead of the string literal.
 * @kind problem
 * @id cpp/use-string-constant
 * @problem.severity recommendation
 * @precision low
 * @tags maintainability
 */

import cpp
import MagicConstants

from Literal magicLiteral, string message, Variable constant, string linkText
where
  stringLiteral(magicLiteral) and
  literalInsteadOfConstant(magicLiteral, message, constant, linkText)
select magicLiteral, message, constant, linkText
