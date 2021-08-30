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
    boolean nonEmpty;

    Configuration() {
      nonEmpty in [true, false] and
      this = "ModificationOfParameterWithDefault:" + nonEmpty.toString()
    }

    override predicate isSource(DataFlow::Node source) { source.(Source).isNonEmpty() = nonEmpty }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }

    override predicate isBarrierGuard(DataFlow::BarrierGuard guard) {
      guard.(BarrierGuard).blocksNonEmpty() = nonEmpty
    }
  }
}
