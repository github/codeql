/**
 * @name CGI script vulnerable to cross-site scripting
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cpp/cgi-xss
 * @tags security
 *       external/cwe/cwe-079
 */

import cpp
import semmle.code.cpp.commons.Environment
import semmle.code.cpp.security.TaintTracking
import TaintedWithPath

/** A call that prints its arguments to `stdout`. */
class PrintStdoutCall extends FunctionCall {
  PrintStdoutCall() {
    getTarget().hasGlobalOrStdName("puts") or
    getTarget().hasGlobalOrStdName("printf")
  }
}

/** A read of the QUERY_STRING environment variable */
class QueryString extends EnvironmentRead {
  QueryString() { getEnvironmentVariable() = "QUERY_STRING" }
}

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element tainted) {
    exists(PrintStdoutCall call | call.getAnArgument() = tainted)
  }
}

from QueryString query, Element printedArg, PathNode sourceNode, PathNode sinkNode
where taintedWithPath(query, printedArg, sourceNode, sinkNode)
select printedArg, sourceNode, sinkNode, "Cross-site scripting vulnerability due to $@.", query,
  "this query data"
