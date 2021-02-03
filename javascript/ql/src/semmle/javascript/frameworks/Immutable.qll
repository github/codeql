/**
 * Provides classes and predicates for reasoning about [immutable](https://www.npmjs.com/package/immutable).
 */

import javascript

/**
 * Provides classes implementing data-flow for Immutable.
 */
private module Immutable {
  private import DataFlow::PseudoProperties

  /**
   * An API entrypoint for the global `Immutable` variable.
   */
  private class ImmutableGlobalEntry extends API::EntryPoint {
    ImmutableGlobalEntry() { this = "ImmutableGlobalEntry" }

    override DataFlow::SourceNode getAUse() { result = DataFlow::globalVarRef("Immutable") }

    override DataFlow::Node getARhs() { none() }
  }

  /**
   * An import of the `Immutable` library.
   */
  API::Node immutableImport() {
    result = API::moduleImport("immutable")
    or
    result = API::root().getASuccessor(any(ImmutableGlobalEntry i))
  }

  /**
   * An instance of an immutable map.
   */
  API::Node immutableMap() {
    result = immutableImport().getMember("Map").getReturn()
    or
    result = immutableMap().getMember("set").getReturn()
  }

  /**
   * Gets the immutable collection where `pred` has been stored using the pseudoproperty `prop`.
   */
  DataFlow::SourceNode storeStep(DataFlow::Node pred, string prop) {
    exists(DataFlow::CallNode call, string key |
      call = immutableImport().getMember("Map").getACall()
    |
      prop = mapValueKey(key) and
      pred = call.getOptionArgument(0, key) and
      result = call
    )
    // TODO: map set.
  }

  /**
   * Gets the value that was stored in the immutable collection `pred` under the pseudoproperty `prop`.
   */
  DataFlow::Node loadStep(DataFlow::Node pred, string prop) {
    // map.get()
    exists(DataFlow::MethodCallNode call | call = immutableMap().getMember("get").getACall() |
      pred = call.getReceiver() and
      result = call and
      prop = mapValue(call.getArgument(0))
    )
  }

  /**
   * Gets an immutable collection that contains all the elements from `pred`.
   */
  DataFlow::Node step(DataFlow::Node pred) {
    // map.set() copies all existing values
    exists(DataFlow::CallNode call | call = immutableMap().getMember("set").getACall() |
      pred = call.getReceiver() and
      result = call
    )
  }

  /**
   * A dataflow step for an immutable collection.
   */
  class ImmutableConstructionStep extends DataFlow::AdditionalFlowStep {
    ImmutableConstructionStep() { this = [loadStep(_, _), storeStep(_, _), step(_)] }

    override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      this = loadStep(pred, prop) and
      succ = this
    }

    override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      this = storeStep(pred, prop) and
      succ = this
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      this = step(pred) and
      succ = this
    }
  }
}
