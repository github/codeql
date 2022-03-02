/**
 * @name Use of `Kernel.open` or `IO.read`
 * @description Using `Kernel.open` or `IO.read` may allow a malicious
 *              user to execute arbitrary system commands.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id rb/kernel-open
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 *       external/cwe/cwe-073
 */

import ruby
import codeql.ruby.ApiGraphs
import codeql.ruby.frameworks.core.Kernel::Kernel
import codeql.ruby.TaintTracking
import codeql.ruby.dataflow.BarrierGuards
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.DataFlow
import DataFlow::PathGraph

/**
 * A method call that has a suggested replacement.
 */
abstract class Replacement extends DataFlow::CallNode {
  abstract string getFrom();

  abstract string getTo();
}

class KernelOpenCall extends KernelMethodCall, Replacement {
  KernelOpenCall() { this.getMethodName() = "open" }

  override string getFrom() { result = "Kernel.open" }

  override string getTo() { result = "File.open" }
}

class IOReadCall extends DataFlow::CallNode, Replacement {
  IOReadCall() { this = API::getTopLevelMember("IO").getAMethodCall("read") }

  override string getFrom() { result = "IO.read" }

  override string getTo() { result = "File.read" }
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "KernelOpen" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(KernelOpenCall c | c.getArgument(0) = sink)
    or
    exists(IOReadCall c | c.getArgument(0) = sink)
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof StringConstCompare or
    guard instanceof StringConstArrayInclusionCall
  }
}

from
  Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink,
  DataFlow::Node sourceNode, DataFlow::CallNode call
where
  config.hasFlowPath(source, sink) and
  sourceNode = source.getNode() and
  call.asExpr().getExpr().(MethodCall).getArgument(0) = sink.getNode().asExpr().getExpr()
select sink.getNode(), source, sink,
  "This call to " + call.(Replacement).getFrom() +
    " depends on a user-provided value. Replace it with " + call.(Replacement).getTo() + "."
