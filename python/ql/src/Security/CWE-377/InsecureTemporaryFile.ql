/**
 * @name Insecure temporary file
 * @description Creating a temporary file using this method may be insecure.
 * @kind problem
 * @id py/insecure-temporary-file
 * @problem.severity error
 * @security-severity 7.0
 * @sub-severity high
 * @precision high
 * @tags external/cwe/cwe-377
 *       security
 */

import python
import semmle.python.ApiGraphs

API::Node temporary_name_function(string mod, string function) {
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
  result = API::moduleImport(mod).getMember(function)
}

from Call c, string mod, string function
where temporary_name_function(mod, function).getACall().asExpr() = c
select c, "Call to deprecated function " + mod + "." + function + " may be insecure."
