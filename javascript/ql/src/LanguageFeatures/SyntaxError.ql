/**
 * @name Syntax error
 * @description A piece of code could not be parsed due to syntax errors.
 * @kind problem
 * @problem.severity recommendation
 * @id js/syntax-error
 * @tags reliability
 *       correctness
 *       language-features
 * @precision very-high
 */

import javascript

from JSParseError pe
where not pe.getTopLevel() instanceof Angular2::TemplateTopLevel
select pe, pe.getMessage()
