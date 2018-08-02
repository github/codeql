/**
 * @name Parameter return trap file generator
 * @description Generate trap files (in CSV form) describing CPython extension functions return one of their parameters.
 * @kind trap
 * @id cpp/c-python/parameter-return-trap
 */

import cpp
import CPython.Extensions

predicate argument_flows_to_return(Function func, int arg) {
    exists(Parameter p | p = func.getParameter(arg) |
        forall(ReturnStmt ret | ret.getEnclosingFunction() = func |
        local_flows_to(p, ret.getExpr()))
    )
}

from TypedPythonExtensionFunction func, PythonExtensionFunction code, int arg
where func.getCode() = code and argument_flows_to_return(code, arg)
select "ext_argreturn", func.getTrapID(), arg
