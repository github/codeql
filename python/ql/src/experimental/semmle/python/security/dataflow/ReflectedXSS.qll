/**
 * Provides a taint-tracking configuration for detecting reflected server-side
 * cross-site scripting vulnerabilities.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.BarrierGuards
import experimental.semmle.python.Concepts

/**
 * A taint-tracking configuration for detecting reflected server-side cross-site
 * scripting vulnerabilities.
 */
class ReflectedXssConfiguration extends TaintTracking::Configuration {
  ReflectedXssConfiguration() { this = "ReflectedXssConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink = any(EmailSender email).getHtmlBody() }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof StringConstCompare
  }
}
