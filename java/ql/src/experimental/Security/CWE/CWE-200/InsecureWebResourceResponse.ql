/**
 * @name Insecure Android WebView Resource Response
 * @description An insecure implementation of Android `WebResourceResponse` may lead to leakage of arbitrary
 *               sensitive content.
 * @kind path-problem
 * @id java/insecure-webview-resource-response
 * @problem.severity error
 * @tags security
 *       external/cwe/cwe-200
 */

import java
import semmle.code.java.controlflow.Guards
import experimental.semmle.code.java.PathSanitizer
import AndroidWebResourceResponse
import DataFlow::PathGraph

class InsecureWebResourceResponseConfig extends TaintTracking::Configuration {
  InsecureWebResourceResponseConfig() { this = "InsecureWebResourceResponseConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof WebResourceResponseSink }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof PathTraversalBarrierGuard
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, InsecureWebResourceResponseConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Leaking arbitrary content in Android from $@.",
  source.getNode(), "this user input"
