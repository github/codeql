/**
 * @name Syntax error
 * @description A piece of code could not be parsed due to syntax errors.
 * @kind problem
 * @problem.severity error
 * @id js/syntax-error
 * @tags reliability
 *       correctness
 *       language-features
 * @precision high
 */

import javascript

from JSParseError pe
select pe, pe.getMessage()
