/**
 * @name Call to function with extraneous arguments
 * @description A function call to a function passed more arguments than there are
 *              declared parameters of the function.  This may indicate
 *              that the code does not follow the author's intent.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/futile-params
 * @tags correctness
 *       maintainability
 */

import cpp
import TooManyArguments

from FunctionCall fc, Function f
where tooManyArguments(fc, f)
select fc, "This call has more arguments than required by $@.", f, f.toString()
