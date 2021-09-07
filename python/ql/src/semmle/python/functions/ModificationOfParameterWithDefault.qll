/**
 * Provides a data-flow configuration for detecting modifications of a parameters default value.
 *
 * Note, for performance reasons: only import this file if
 * `ModificationOfParameterWithDefault::Configuration` is needed, otherwise
 * `ModificationOfParameterWithDefaultCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow

/**
 * Provides a data-flow configuration for detecting modifications of a parameters default value.
 */
module ModificationOfParameterWithDefault {
  import ModificationOfParameterWithDefaultCustomizations::ModificationOfParameterWithDefault

  /**
   * A data-flow configuration for detecting modifications of a parameters default value.
   */
  class Configuration extends DataFlow::Configuration {
    /** Record whether the default value being tracked is non-empty. */
    boolean nonEmptyDefault;

    Configuration() {
      nonEmptyDefault in [true, false] and
      this = "ModificationOfParameterWithDefault:" + nonEmptyDefault.toString()
    }

    override predicate isSource(DataFlow::Node source) {
      source.(Source).isNonEmpty() = nonEmptyDefault
    }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }

    override predicate isBarrierGuard(DataFlow::BarrierGuard guard) {
      // if we are tracking a empty default, then we should not modify falsey values
      nonEmptyDefault = false and guard instanceof BlocksFalsey
      or
      // if we are tracking a non-empty default, then we should not modify truthy values
      nonEmptyDefault = true and guard instanceof BlocksTruthy
    }
  }
}
