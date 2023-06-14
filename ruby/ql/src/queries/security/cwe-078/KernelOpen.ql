/**
 * @name Use of `Kernel.open`, `IO.read` or similar sinks with user-controlled input
 * @description Using `Kernel.open`, `IO.read`, `IO.write`, `IO.binread`, `IO.binwrite`,
 *              `IO.foreach`, `IO.readlines`, or `URI.open` may allow a malicious
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

import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.dataflow.BarrierGuards
import ConfigurationInst::PathGraph
import codeql.ruby.security.KernelOpenQuery

module ConfigurationInst = TaintTracking::Global<ConfigurationImpl>;

private module ConfigurationImpl implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink = any(AmbiguousPathCall r).getPathArgument() }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier or
    node instanceof Sanitizer
  }
}

from
  ConfigurationInst::PathNode source, ConfigurationInst::PathNode sink, DataFlow::Node sourceNode,
  DataFlow::CallNode call
where
  ConfigurationInst::flowPath(source, sink) and
  sourceNode = source.getNode() and
  call.getArgument(0) = sink.getNode()
select sink.getNode(), source, sink,
  "This call to " + call.(AmbiguousPathCall).getName() +
    " depends on a $@. Consider replacing it with " + call.(AmbiguousPathCall).getReplacement() +
    ".", source.getNode(), "user-provided value"
