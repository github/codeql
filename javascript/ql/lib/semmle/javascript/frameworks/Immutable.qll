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
   * Gets an import of the `Immutable` library.
   */
  API::Node immutableImport() {
    result = API::moduleImport("immutable")
    or
    result = any(ImmutableGlobalEntry i).getANode()
  }

  /**
   * Gets an instance of any immutable collection.
   *
   * This predicate keeps track of which values in the program are Immutable collections.
   */
  API::Node immutableCollection() {
    // keep this predicate in sync with the constructors defined in `storeStep`/`step`.
    result =
      immutableImport()
          .getMember(["Map", "OrderedMap", "List", "Stack", "Set", "OrderedSet", "fromJS", "merge"])
          .getReturn()
    or
    result = immutableImport().getMember("Record").getReturn().getReturn()
    or
    result =
      immutableImport()
          .getMember(["List", "Set", "OrderedSet", "Stack"])
          .getMember("of")
          .getReturn()
    or
    result = immutableCollection().getMember(["set", "map", "filter", "push", "merge"]).getReturn()
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
      call = immutableImport().getMember(["List", "Stack", "Set", "OrderedSet"]).getACall()
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
    or
    // Immutable.Record({defaults})({values}).
    exists(API::CallNode factoryCall, API::CallNode recordCall |
      factoryCall = immutableImport().getMember("Record").getACall() and
      recordCall = factoryCall.getReturn().getACall()
    |
      pred = [factoryCall, recordCall].getOptionArgument(0, prop) and
      result = recordCall
    )
    or
    // List/Set/Stack.of(values)
    exists(API::CallNode call |
      call =
        immutableImport()
            .getMember(["List", "Set", "OrderedSet", "Stack"])
            .getMember("of")
            .getACall()
    |
      pred = call.getAnArgument() and
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
    or
    // Immutable.merge(x, y)
    exists(DataFlow::CallNode call | call = immutableImport().getMember("merge").getACall() |
      pred = call.getAnArgument() and
      result = call
    )
    or
    // collection.merge(other)
    exists(DataFlow::CallNode call | call = immutableCollection().getMember("merge").getACall() |
      pred = [call.getAnArgument(), call.getReceiver()] and
      result = call
    )
  }

  /**
   * A dataflow step for an immutable collection.
   */
  class ImmutableConstructionStep extends DataFlow::SharedFlowStep {
    override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      succ = loadStep(pred, prop)
    }

    override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      succ = storeStep(pred, prop)
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) { succ = step(pred) }
  }
}
