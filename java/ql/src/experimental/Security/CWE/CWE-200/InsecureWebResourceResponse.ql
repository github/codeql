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
import AndroidWebResourceResponse
import InsecureWebResourceResponseFlow::PathGraph

module InsecureWebResourceResponseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof WebResourceResponseSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof PathInjectionSanitizer }
}

module InsecureWebResourceResponseFlow = TaintTracking::Global<InsecureWebResourceResponseConfig>;

from
  InsecureWebResourceResponseFlow::PathNode source, InsecureWebResourceResponseFlow::PathNode sink
where InsecureWebResourceResponseFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Leaking arbitrary content in Android from $@.",
  source.getNode(), "this user input"
