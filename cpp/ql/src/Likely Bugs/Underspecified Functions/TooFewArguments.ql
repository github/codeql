/**
 * @name Call to function with fewer arguments than declared parameters
 * @description A function call is passing fewer arguments than the number of
 *              declared parameters of the function. This may indicate
 *              that the code does not follow the author's intent. It is also
 *              a vulnerability, since the function is likely to operate on
 *              undefined data.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision very-high
 * @id cpp/too-few-arguments
 * @tags correctness
 *       maintainability
 *       security
 *       external/cwe/cwe-234
 *       external/cwe/cwe-685
 */

import cpp
import TooFewArguments

from FunctionCall fc, Function f
where tooFewArguments(fc, f)
select fc, "This call has fewer arguments than required by $@.", f, f.toString()
