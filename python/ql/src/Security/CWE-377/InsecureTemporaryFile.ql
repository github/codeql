/**
 * @name Insecure temporary file
 * @description Creating a temporary file name may be insecure.
 * @id py/insecure-temporary-file
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @tags external/cwe/cwe-377
 *       security
 */

import python

FunctionObject temporary_name_function(string mod, string function) {
    (
        mod = "tempfile" and function = "mktemp"
        or
        mod = "os" and
        (
            function = "tmpnam"
            or
            function = "tempnam"
        )
    ) and
    result = any(ModuleObject m | m.getName() = mod).getAttribute(function)
}

from CallNode c, string mod, string function
where
  c.getFunction().refersTo(temporary_name_function(mod, function))
select c, "Call to deprecated function $@.$@ may be insecure.", mod, function
