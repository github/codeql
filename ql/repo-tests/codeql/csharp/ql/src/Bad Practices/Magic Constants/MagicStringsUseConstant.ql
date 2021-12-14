/**
 * @name Magic strings: use defined constant
 * @description A string literal that matches the initializer of a final variable was found. Consider using the final variable instead of the string literal.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/use-string-constant
 * @tags changeability
 *       maintainability
 */

import MagicConstants

from StringLiteral magicLiteral, string message, Field constant
where literalInsteadOfConstant(magicLiteral, _, message, constant)
select magicLiteral, message, constant, constant.getName()
