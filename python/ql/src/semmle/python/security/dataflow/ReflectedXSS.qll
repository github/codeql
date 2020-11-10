/**
 * Provides a taint-tracking configuration for detecting reflected server-side
 * cross-site scripting vulnerabilities.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for detecting reflected server-side cross-site
 * scripting vulnerabilities.
 */
class ReflectedXssConfiguration extends TaintTracking::Configuration {
  ReflectedXssConfiguration() { this = "ReflectedXssConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(HTTP::Server::HttpResponse response |
      response.getMimetype().toLowerCase() = "text/html" and
      sink = response.getBody()
    )
  }
}
