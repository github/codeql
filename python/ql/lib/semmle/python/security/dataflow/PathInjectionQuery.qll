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

/**
 * A taint-tracking configuration for detecting "path injection" vulnerabilities.
 *
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
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PathInjection" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof Source and state instanceof NotNormalized
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    sink instanceof Sink and
    (
      state instanceof NotNormalized or
      state instanceof NormalizedUnchecked
    )
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

  override predicate isSanitizer(DataFlow::Node node, DataFlow::FlowState state) {
    // Block `NotNormalized` paths here, since they change state to `NormalizedUnchecked`
    node instanceof Path::PathNormalization and
    state instanceof NotNormalized
    or
    node = any(Path::SafeAccessCheck c).getAGuardedNode() and
    state instanceof NormalizedUnchecked
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof SanitizerGuard
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
    DataFlow::FlowState stateTo
  ) {
    nodeFrom = nodeTo.(Path::PathNormalization).getPathArg() and
    stateFrom instanceof NotNormalized and
    stateTo instanceof NormalizedUnchecked
  }
}

/** A state signifying that the file path has not been normalized. */
class NotNormalized extends DataFlow::FlowState {
  NotNormalized() { this = "NotNormalized" }
}

/** A state signifying that the file path has been normalized, but not checked. */
class NormalizedUnchecked extends DataFlow::FlowState {
  NormalizedUnchecked() { this = "NormalizedUnchecked" }
}
