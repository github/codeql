/**
 * Provides a tracking configuration for reasoning about type
 * confusion for HTTP request inputs.
 *
 * Note, for performance reasons: only import this file if
 * `TypeConfusionThroughParameterTampering::Configuration` is needed,
 * otherwise `TypeConfusionThroughParameterTamperingCustomizations`
 * should be imported instead.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

module TypeConfusionThroughParameterTampering {
  import TypeConfusionThroughParameterTamperingCustomizations::TypeConfusionThroughParameterTampering

  /**
   * A taint tracking configuration for type confusion for HTTP request inputs.
   */
  class Configuration extends DataFlow::Configuration {
    Configuration() { this = "TypeConfusionThroughParameterTampering" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink and
      sink.analyze().getAType() = TTString() and
      sink.analyze().getAType() = TTObject()
    }

    override predicate isBarrier(DataFlow::Node node) { node instanceof Barrier }
  }
}
