/**
 * @name Call to sprintf with non-literal format string
 * @description Passing a non-constant 'format' string to a printf-like
 *              function can lead to a mismatch between the number of arguments
 *              defined by the 'format' and the number of arguments actually
 *              passed to the function. If the format string ultimately stems
 *              from an untrusted source, this can be used for exploits.
 * @kind problem
 * @problem.severity warning
 */

import cpp

from FunctionCall fc
where
  fc.getTarget().getQualifiedName() = "sprintf" and
  not fc.getArgument(1) instanceof StringLiteral
select fc, "sprintf called with variable format string."
