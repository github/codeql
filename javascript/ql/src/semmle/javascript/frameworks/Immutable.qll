/**
 * Provides classes and predicates for reasoning about [immutable](https://www.npmjs.com/package/immutable).
 */

import javascript

/**
 * Provides classes implementing data-flow for Immutable.
 *
 * The implemention rely on the flowsteps implemented in `Collections.qll`.
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
    // keep this list in sync with the constructors defined in `storeStep`.
    result = immutableImport().getMember(["Map", "OrderedMap", "List", "fromJS"]).getReturn()
    or
    result = immutableCollection().getMember(["set", "map", "filter", "push"]).getReturn()
  }

  /**
   * Gets the immutable collection where `pred` has been stored using the name `prop`.
   */
  DataFlow::SourceNode storeStep(DataFlow::Node pred, string prop) {
    // Immutable.Map() and Immutable.fromJS().
    exists(DataFlow::CallNode call |
      call = immutableImport().getMember(["Map", "OrderedMap", "fromJS"]).getACall()
    |
      pred = call.getOptionArgument(0, prop) and
      result = call
    )
    or
    // Immutable.List()
    exists(DataFlow::CallNode call, DataFlow::ArrayCreationNode arr |
      call = immutableImport().getMember("List").getACall()
    |
      arr = call.getArgument(0).getALocalSource() and
      exists(int i |
        prop = DataFlow::PseudoProperties::arrayElement(i) and
        pred = arr.getElement(i) and
        result = call
      )
    )
    or
    // collection.set(key, value)
    exists(DataFlow::CallNode call | call = immutableCollection().getMember("set").getACall() |
      call.getArgument(0).mayHaveStringValue(prop) and
      pred = call.getArgument(1) and
      result = call
    )
    or
    // list.push(x)
    exists(DataFlow::CallNode call | call = immutableCollection().getMember("push").getACall() |
      pred = call.getArgument(0) and
      result = call and
      prop = DataFlow::PseudoProperties::arrayElement()
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
    // map.set() / list.push() copies all existing values
    exists(DataFlow::CallNode call |
      call = immutableCollection().getMember(["set", "push"]).getACall()
    |
      pred = call.getReceiver() and
      result = call
    )
    or
    // toJS()/toList() on any immutable collection converts it to a plain JavaScript object/array (and vice versa for `fromJS`).
    exists(DataFlow::CallNode call |
      call = immutableCollection().getMember(["toJS", "toList"]).getACall()
    |
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
