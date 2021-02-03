/**
 * Provides classes and predicates for reasoning about [immutable](https://www.npmjs.com/package/immutable).
 */

import javascript

/**
 * Provides classes implementing data-flow for Immutable.
 */
private module Immutable {
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
   * An instance of any immutable collection.
   */
  API::Node immutableCollection() {
    result = immutableImport().getMember(["Map", "fromJS"]).getReturn()
    or
    result.getAnImmediateUse() = step(immutableCollection().getAUse())
  }

  /**
   * Gets the immutable collection where `pred` has been stored using the name `prop`.
   */
  DataFlow::SourceNode storeStep(DataFlow::Node pred, string prop) {
    exists(DataFlow::CallNode call |
      call = immutableImport().getMember(["Map", "fromJS"]).getACall()
    |
      pred = call.getOptionArgument(0, prop) and
      result = call
    )
    or
    exists(DataFlow::CallNode call | call = immutableCollection().getMember("set").getACall() |
      call.getArgument(0).mayHaveStringValue(prop) and
      pred = call.getArgument(1) and
      result = call
    )
  }

  /**
   * Gets the value that was stored in the immutable collection `pred` under the name `prop`.
   */
  DataFlow::Node loadStep(DataFlow::Node pred, string prop) {
    // map.get()
    exists(DataFlow::MethodCallNode call |
      call = immutableCollection().getMember("get").getACall()
    |
      call.getArgument(0).mayHaveStringValue(prop) and
      pred = call.getReceiver() and
      result = call
    )
  }

  /**
   * Gets an immutable collection that contains all the elements from `pred`.
   */
  DataFlow::SourceNode step(DataFlow::Node pred) {
    // map.set() copies all existing values
    exists(DataFlow::CallNode call | call = immutableCollection().getMember("set").getACall() |
      pred = call.getReceiver() and
      result = call
    )
    or
    // toJS() or any immutable collection converts it to a plain JavaScript object/array (and vice versa for `fromJS`).
    exists(DataFlow::CallNode call | call = immutableCollection().getMember("toJS").getACall() |
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
