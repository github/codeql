/**
 * Provides a taint-tracking configuration for detecting regular expression injection
 * vulnerabilities.
 */

import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A class to find methods executing regular expressions.
 *
 * See `RegexExecution`
 */
class RegexInjectionSink extends DataFlow::Node {
  string regexModule;
  Attribute regexMethod;

  RegexInjectionSink() {
    exists(RegexExecution reExec |
      this = reExec.getRegexNode() and
      regexModule = reExec.getRegexModule() and
      regexMethod = reExec.(DataFlow::CallCfgNode).getFunction().asExpr().(Attribute)
    )
  }

  /**
   * Gets the argument containing the executed expression.
   */
  string getRegexModule() { result = regexModule }

  /**
   * Gets the method used to execute the regular expression.
   */
  Attribute getRegexMethod() { result = regexMethod }
}

/**
 * A taint-tracking configuration for detecting regular expression injections.
 */
class RegexInjectionFlowConfig extends TaintTracking::Configuration {
  RegexInjectionFlowConfig() { this = "RegexInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegexInjectionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(RegexEscape reEscape).getRegexNode()
  }
}
