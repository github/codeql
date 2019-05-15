/**
 * @name CGI script vulnerable to cross-site scripting
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cpp/cgi-xss
 * @tags security
 *       external/cwe/cwe-079
 */
import cpp
import semmle.code.cpp.commons.Environment
import semmle.code.cpp.security.TaintTracking

/** A call that prints its arguments to `stdout`. */
class PrintStdoutCall extends FunctionCall {
  PrintStdoutCall() {
    getTarget().hasGlobalName("puts") or
    getTarget().hasGlobalName("printf")
  }
}

/** A read of the QUERY_STRING environment variable */
class QueryString extends EnvironmentRead {
  QueryString() {
    getEnvironmentVariable() = "QUERY_STRING"
  }
}

from QueryString query, PrintStdoutCall call, Element printedArg
where call.getAnArgument() = printedArg
  and tainted(query, printedArg)
select printedArg, "Cross-site scripting vulnerability due to $@.",
  query, "this query data"
