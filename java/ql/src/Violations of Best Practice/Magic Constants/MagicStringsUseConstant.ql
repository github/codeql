/**
 * @name Magic strings: use defined constant
 * @description A magic string, which is used instead of an existing named constant, makes code less
 *              readable and maintainable.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/use-string-constant
 * @tags maintainability
 *       readability
 */

import java
import MagicConstants

from StringLiteral magicLiteral, string message, Field field, string linkText
where literalInsteadOfConstant(magicLiteral, message, field, linkText)
select magicLiteral, message, field, linkText
