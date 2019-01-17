/**
 * @name Insecure temporary file
 * @description Creating a temporary file using mktemp may be insecure.
 * @id py/insecure-temporary-file
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @tags external/cwe/cwe-377
 *       security
 */

import python

FunctionObject mktemp() {
    result = any(ModuleObject m | m.getName() = "tempfile").getAttribute("mktemp")
}

from CallNode c
where c.getFunction().refersTo(mktemp())
select c, "Call to deprecated function mktemp may be insecure."
