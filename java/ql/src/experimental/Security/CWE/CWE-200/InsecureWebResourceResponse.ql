/**
 * @name Insecure Android WebView Resource Response
 * @description An insecure implementation of Android `WebResourceResponse` may lead to leakage of arbitrary
 *               sensitive content.
 * @kind path-problem
 * @id java/insecure-webview-resource-response
 * @problem.severity error
 * @tags security
 *       experimental
 *       external/cwe/cwe-200
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.PathSanitizer
deprecated import AndroidWebResourceResponse
deprecated import InsecureWebResourceResponseFlow::PathGraph

deprecated module InsecureWebResourceResponseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof WebResourceResponseSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof PathInjectionSanitizer }
}

deprecated module InsecureWebResourceResponseFlow =
  TaintTracking::Global<InsecureWebResourceResponseConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, InsecureWebResourceResponseFlow::PathNode source,
  InsecureWebResourceResponseFlow::PathNode sink, string message1, DataFlow::Node sourceNode,
  string message2
) {
  InsecureWebResourceResponseFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Leaking arbitrary content in Android from $@." and
  sourceNode = source.getNode() and
  message2 = "this user input"
}
