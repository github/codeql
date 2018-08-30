/**
 * @name Cross-site scripting
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/xss
 * @tags security
 *       external/cwe/cwe-079
 */
import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XSS

class XSSConfig extends TaintTracking::Configuration2 {
  XSSConfig() { this = "XSSConfig" }
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteUserInput }
  override predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }
  override predicate isSanitizer(DataFlow::Node node) { node.getType() instanceof NumericType or node.getType() instanceof BooleanType }
}

from XssSink sink, RemoteUserInput source, XSSConfig conf
where conf.hasFlow(source, sink)
select sink, "Cross-site scripting vulnerability due to $@.",
  source, "user-provided value"
