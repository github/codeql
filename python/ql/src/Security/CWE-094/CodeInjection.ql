/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user to perform arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @sub-severity high
 * @precision high
 * @id py/code-injection
 * @tags security
 *       external/owasp/owasp-a1
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-116
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts
import semmle.python.dataflow.new.RemoteFlowSources
import DataFlow::PathGraph

class CodeInjectionConfiguration extends TaintTracking::Configuration {
  CodeInjectionConfiguration() { this = "CodeInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink = any(CodeExecution e).getCode() }
}

from CodeInjectionConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is interpreted as code.",
  source.getNode(), "A user-provided value"
