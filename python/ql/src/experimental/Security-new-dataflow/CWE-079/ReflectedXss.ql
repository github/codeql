/**
 * @name Reflected server-side cross-site scripting
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @id py/reflective-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import python
import experimental.dataflow.DataFlow
import experimental.dataflow.TaintTracking
import experimental.semmle.python.Concepts
import experimental.dataflow.RemoteFlowSources
import DataFlow::PathGraph

class ReflectedXssConfiguration extends TaintTracking::Configuration {
  ReflectedXssConfiguration() { this = "ReflectedXssConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(HTTP::Server::HttpResponse response |
      response.getContentType().toLowerCase().matches("text/html%") and
      sink = response.getBody()
    )
  }
}

from ReflectedXssConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Cross-site scripting vulnerability due to $@.",
  source.getNode(), "a user-provided value"
