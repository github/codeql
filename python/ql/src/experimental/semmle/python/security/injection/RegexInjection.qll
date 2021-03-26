/**
 * Provides a taint-tracking configuration for detecting regular expression injection
 * vulnerabilities.
 */

import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs

/**
 * A taint-tracking configuration for detecting regular expression injections.
 */
class RegexInjectionFlowConfig extends TaintTracking::Configuration {
  RegexInjectionFlowConfig() { this = "RegexInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink = any(RegexExecution re).getRegexNode() }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = sanitizer.(RegexEscape).getRegexNode()
  }
}
