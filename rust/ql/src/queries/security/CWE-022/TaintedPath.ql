/**
 * @name Uncontrolled data used in path expression
 * @description Accessing paths influenced by users can allow an attacker to access unexpected resources.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id rust/path-injection
 * @tags security
 *       external/cwe/cwe-022
 *       external/cwe/cwe-023
 *       external/cwe/cwe-036
 *       external/cwe/cwe-073
 *       external/cwe/cwe-099
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.internal.DataFlowImpl as DataflowImpl
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.TaintedPathExtensions
import TaintedPathFlow::PathGraph
private import codeql.rust.Concepts

newtype NormalizationState =
  /** A state signifying that the file path has not been normalized. */
  NotNormalized() or
  /** A state signifying that the file path has been normalized, but not checked. */
  NormalizedUnchecked()

/**
 * This configuration uses two flow states, `NotNormalized` and `NormalizedUnchecked`,
 * to track the requirement that a file path must be first normalized and then checked
 * before it is safe to use.
 *
 * At sources, paths are assumed not normalized. At normalization points, they change
 * state to `NormalizedUnchecked` after which they can be made safe by an appropriate
 * check of the prefix.
 *
 * Such checks are ineffective in the `NotNormalized` state.
 */
module TaintedPathConfig implements DataFlow::StateConfigSig {
  class FlowState = NormalizationState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof TaintedPath::Source and state instanceof NotNormalized
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof TaintedPath::Sink and
    (
      state instanceof NotNormalized or
      state instanceof NormalizedUnchecked
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof TaintedPath::Barrier or node instanceof TaintedPath::SanitizerGuard
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    // Block `NotNormalized` paths here, since they change state to `NormalizedUnchecked`
    (
      node instanceof Path::PathNormalization or
      DataflowImpl::optionalBarrier(node, "normalize-path")
    ) and
    state instanceof NotNormalized
    or
    node instanceof Path::SafeAccessCheck and
    state instanceof NormalizedUnchecked
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
  ) {
    (
      nodeFrom = nodeTo.(Path::PathNormalization).getPathArg() or
      DataflowImpl::optionalStep(nodeFrom, "normalize-path", nodeTo)
    ) and
    stateFrom instanceof NotNormalized and
    stateTo instanceof NormalizedUnchecked
  }
}

module TaintedPathFlow = TaintTracking::GlobalWithState<TaintedPathConfig>;

from TaintedPathFlow::PathNode source, TaintedPathFlow::PathNode sink
where TaintedPathFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This path depends on a $@.", source.getNode(),
  "user-provided value"
