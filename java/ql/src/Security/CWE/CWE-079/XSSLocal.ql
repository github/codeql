/**
 * @name Cross-site scripting from local source
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/xss-local
 * @tags security
 *       external/cwe/cwe-079
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.security.XSS
import DataFlow2::PathGraph

class XSSLocalConfig extends TaintTracking2::Configuration {
  XSSLocalConfig() { this = "XSSLocalConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }
}

from DataFlow2::PathNode source, DataFlow2::PathNode sink, XSSLocalConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Cross-site scripting vulnerability due to $@.",
  source.getNode(), "user-provided value"
