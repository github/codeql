/**
 * @name Unsafe resource fetching in Android WebView
 * @description JavaScript rendered inside WebViews can access protected
 *              application files and web resources from any origin exposing them to attack.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @precision medium
 * @id java/android/unsafe-android-webview-fetch
 * @tags security
 *       external/cwe/cwe-749
 *       external/cwe/cwe-079
 */

import java
import semmle.code.java.security.UnsafeAndroidAccessQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, FetchUntrustedResourceConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe resource fetching in Android WebView due to $@.",
  source.getNode(), sink.getNode().(UrlResourceSink).getSinkType()
