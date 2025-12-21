/**
 * @name Assert with string argument
 * @description Calling `assert` with a string argument can be dangerous because it may evaluate the string as code.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id php/assert-string-argument
 * @tags security
 */

import codeql.php.ast.Calls

from FunctionCall call
where
  call.getCalleeName() = "assert" and
  exists(Php::Expression arg0 |
    arg0 = call.getArgumentExpr(0) and
    (arg0 instanceof Php::String or arg0 instanceof Php::EncapsedString)
  )
select call, "Call to 'assert' with a string argument."
