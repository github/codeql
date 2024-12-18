/**
 * Provides taint-tracking configurations for detecting "path injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `PathInjection::Configuration` is needed, otherwise
 * `PathInjectionCustomizations` should be imported instead.
 */

private import python
private import semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import PathInjectionCustomizations::PathInjection

abstract private class NormalizationState extends string {
  bindingset[this]
  NormalizationState() { any() }
}

/** A state signifying that the file path has not been normalized. */
class NotNormalized extends NormalizationState {
  NotNormalized() { this = "NotNormalized" }
}

/** A state signifying that the file path has been normalized, but not checked. */
class NormalizedUnchecked extends NormalizationState {
  NormalizedUnchecked() { this = "NormalizedUnchecked" }
}

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
module PathInjectionConfig implements DataFlow::StateConfigSig {
  class FlowState = NormalizationState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof Source and state instanceof NotNormalized
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof Sink and
    (
      state instanceof NotNormalized or
      state instanceof NormalizedUnchecked
    )
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    // Block `NotNormalized` paths here, since they change state to `NormalizedUnchecked`
    node instanceof Path::PathNormalization and
    state instanceof NotNormalized
    or
    node instanceof Path::SafeAccessCheck and
    state instanceof NormalizedUnchecked
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
  ) {
    nodeFrom = nodeTo.(Path::PathNormalization).getPathArg() and
    stateFrom instanceof NotNormalized and
    stateTo instanceof NormalizedUnchecked
  }
}

/** Global taint-tracking for detecting "path injection" vulnerabilities. */
module PathInjectionFlow = TaintTracking::GlobalWithState<PathInjectionConfig>;
