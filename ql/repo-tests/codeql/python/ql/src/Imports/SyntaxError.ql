/**
 * @name Syntax error
 * @description Syntax errors cause failures at runtime and prevent analysis of the code.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @id py/syntax-error
 */

import python

from SyntaxError error
where not error instanceof EncodingError
select error, error.getMessage() + " (in Python " + major_version() + ")."
