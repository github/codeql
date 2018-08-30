/**
 * @name Cross-site scripting from local source
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/xss-local
 * @tags security
 *       external/cwe/cwe-079
 */
import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XSS

class XSSLocalConfig extends TaintTracking::Configuration2 {
  XSSLocalConfig() { this = "XSSLocalConfig" }
  override predicate isSource(DataFlow::Node source) { source instanceof LocalUserInput }
  override predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }
}

from XssSink sink, LocalUserInput source, XSSLocalConfig conf
where conf.hasFlow(source, sink)
select sink, "Cross-site scripting vulnerability due to $@.",
  source, "user-provided value"
