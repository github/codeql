/**
 * Provides a data-flow configuration for detecting modifications of a parameters default value.
 *
 * Note, for performance reasons: only import this file if
 * `ModificationOfParameterWithDefault::Configuration` is needed, otherwise
 * `ModificationOfParameterWithDefaultCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs

/**
 * Provides a data-flow configuration for detecting modifications of a parameters default value.
 */
module ModificationOfParameterWithDefault {
  import ModificationOfParameterWithDefaultCustomizations::ModificationOfParameterWithDefault

  private module Config implements DataFlow::StateConfigSig {
    class FlowState = boolean;

    predicate isSource(DataFlow::Node source, FlowState state) {
      source.(Source).isNonEmpty() = state
    }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isSink(DataFlow::Node sink, FlowState state) {
      // dummy implementation since this predicate is required, but actual logic is in
      // the predicate above.
      none()
    }

    predicate isBarrier(DataFlow::Node node, FlowState state) {
      // if we are tracking a non-empty default, then it is ok to modify empty values,
      // so our tracking ends at those.
      state = true and node instanceof MustBeEmpty
      or
      // if we are tracking a empty default, then it is ok to modify non-empty values,
      // so our tracking ends at those.
      state = false and node instanceof MustBeNonEmpty
      or
      // the target of a copy step is (presumably) a different object, and hence modifications of
      // this object no longer matter for the purposes of this query.
      copyTarget(node) and state in [true, false]
    }

    private predicate copyTarget(DataFlow::Node node) {
      node = API::moduleImport("copy").getMember(["copy", "deepcopy"]).getACall()
      or
      node.(DataFlow::MethodCallNode).calls(_, "copy")
    }
  }

  /** Global data-flow for detecting modifications of a parameters default value. */
  module Flow = DataFlow::GlobalWithState<Config>;
}
