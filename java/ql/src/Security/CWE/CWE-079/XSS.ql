/**
 * @name Cross-site scripting
 * @description Writing user input directly to a web page
 *              allows for a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/xss
 * @tags security
 *       external/cwe/cwe-079
 */

 java
 semmle.code.java.dataflow.FlowSources
 semmle.code.java.security.XSS
 DataFlow::PathGraph

 XSSConfig extends TaintTracking::Configuration {
  XSSConfig() { this = "XSSConfig" }

  override  isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override  isSink(DataFlow::Node sink) { sink instanceof XssSink }

  override  isSanitizer(DataFlow::Node node) { node instanceof XssSanitizer }

  override  isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(XssAdditionalTaintStep s).step(node1, node2)
  }
}

 DataFlow::PathNode source, DataFlow::PathNode sink, XSSConfig conf
 conf.hasFlowPath(source, sink)
 sink.getNode(), source, sink, "Cross-site scripting vulnerability due to $@.",
  source.getNode(), "user-provided value"
