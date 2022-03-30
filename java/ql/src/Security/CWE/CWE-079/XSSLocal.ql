/**
 * @name Cross-site scripting from local source
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 6.1
 * @precision medium
 * @id java/xss-local
 * @tags security
 *       external/cwe/cwe-079
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XSS
import DataFlow::PathGraph

class XssLocalConfig extends TaintTracking::Configuration {
  XssLocalConfig() { this = "XSSLocalConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, XssLocalConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Cross-site scripting vulnerability due to $@.",
  source.getNode(), "user-provided value"
