/**
 * @name Unsafe resource fetching in Android webview
 * @description JavaScript rendered inside WebViews can access any protected
 *              application file and web resource from any origin
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/android/unsafe-android-webview-fetch
 * @tags security
 *       external/cwe/cwe-749
 *       external/cwe/cwe-079
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.UnsafeAndroidAccess
import DataFlow::PathGraph

/**
 * Taint configuration tracking flow from untrusted inputs to a resource fetching call.
 */
class FetchUntrustedResourceConfiguration extends TaintTracking::Configuration {
  FetchUntrustedResourceConfiguration() { this = "FetchUntrustedResourceConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UrlResourceSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, FetchUntrustedResourceConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe resource fetching in Android webview due to $@.",
  source.getNode(), sink.getNode().(UrlResourceSink).getSinkType()
