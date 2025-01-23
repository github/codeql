/**
 * Provides predicates and classes for working with the standard library collection implementations.
 * Currently [Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) and
 * [Set](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set) are implemented.
 */

import javascript
private import semmle.javascript.dataflow.internal.StepSummary
private import semmle.javascript.dataflow.internal.PreCallGraphStep
private import DataFlow::PseudoProperties

/**
 * A module for data-flow steps related standard library collection implementations.
 */
private module CollectionDataFlow {
  /**
   * A step for `Set.add()` method, which adds an element to a Set.
   */
  private class SetAdd extends LegacyPreCallGraphStep {
    override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
      exists(DataFlow::MethodCallNode call |
        call = obj.getAMethodCall("add") and
        element = call.getArgument(0) and
        prop = setElement()
      )
    }
  }

  /**
   * A step for the `Set` constructor, which copies any elements from the first argument into the resulting set.
   */
  private class SetConstructor extends LegacyPreCallGraphStep {
    override predicate loadStoreStep(
      DataFlow::Node pred, DataFlow::SourceNode succ, string fromProp, string toProp
    ) {
      exists(DataFlow::NewNode invoke |
        invoke = DataFlow::globalVarRef("Set").getAnInstantiation() and
        pred = invoke.getArgument(0) and
        succ = invoke and
        fromProp = arrayLikeElement() and
        toProp = setElement()
      )
    }
  }

  /**
   * A step for modeling `for of` iteration on arrays, maps, sets, and iterators.
   *
   * For sets and iterators the l-value are the elements of the set/iterator.
   * For maps the l-value is a tuple containing a key and a value.
   */
  private class ForOfStep extends LegacyPreCallGraphStep {
    override predicate loadStep(DataFlow::Node obj, DataFlow::Node e, string prop) {
      exists(ForOfStmt forOf |
        obj = forOf.getIterationDomain().flow() and
        e = DataFlow::lvalueNode(forOf.getLValue()) and
        prop = arrayLikeElement()
      )
    }

    override predicate loadStoreStep(
      DataFlow::Node pred, DataFlow::SourceNode succ, string fromProp, string toProp
    ) {
      exists(ForOfStmt forOf |
        pred = forOf.getIterationDomain().flow() and
        succ = DataFlow::lvalueNode(forOf.getLValue()) and
        fromProp = mapValueAll() and
        toProp = "1"
      )
    }
  }

  /**
   * A step for a call to `forEach` on a Set or Map.
   */
  private class SetMapForEach extends LegacyPreCallGraphStep {
    override predicate loadStep(DataFlow::Node obj, DataFlow::Node element, string prop) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = "forEach" and
        obj = call.getReceiver() and
        element = call.getCallback(0).getParameter(0) and
        prop = [setElement(), mapValueAll()]
      )
    }
  }

  /**
   * A call to the `get` method on a Map.
   * If the key of the call to `get` has a known string value, then only the value corresponding to that key will be retrieved. (The known string value is encoded as part of the pseudo-property)
   */
  private class MapGet extends LegacyPreCallGraphStep {
    override predicate loadStep(DataFlow::Node obj, DataFlow::Node element, string prop) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = "get" and
        obj = call.getReceiver() and
        element = call and
        // reading the join of known and unknown values
        (prop = mapValue(call.getArgument(0)) or prop = mapValueUnknownKey())
      )
    }
  }

  /**
   * A call to the `set` method on a Map.
   *
   * If the key of the call to `set` has a known string value,
   * then the value will be stored into a pseudo-property corresponding to the known string value.
   * Otherwise the value will be stored into a pseudo-property corresponding to values with unknown keys.
   * The value will additionally be stored into a pseudo-property corresponding to all values.
   */
  class MapSet extends LegacyPreCallGraphStep {
    override predicate storeStep(DataFlow::Node element, DataFlow::SourceNode obj, string prop) {
      exists(DataFlow::MethodCallNode call |
        call = obj.getAMethodCall("set") and
        element = call.getArgument(1) and
        prop = [mapValue(call.getArgument(0)), mapValueAll()]
      )
    }
  }

  /**
   * A step for a call to `values` on a Map or a Set.
   */
  private class MapAndSetValues extends LegacyPreCallGraphStep {
    override predicate loadStoreStep(
      DataFlow::Node pred, DataFlow::SourceNode succ, string fromProp, string toProp
    ) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = "values" and
        pred = call.getReceiver() and
        succ = call and
        fromProp = [mapValueAll(), setElement()] and
        toProp = iteratorElement()
      )
    }
  }

  /**
   * A step for a call to `keys` on a Set.
   */
  private class SetKeys extends LegacyPreCallGraphStep {
    override predicate loadStoreStep(
      DataFlow::Node pred, DataFlow::SourceNode succ, string fromProp, string toProp
    ) {
      exists(DataFlow::MethodCallNode call |
        call.getMethodName() = "keys" and
        pred = call.getReceiver() and
        succ = call and
        fromProp = setElement() and
        toProp = iteratorElement()
      )
    }
  }

  /**
   * A step for a call to `groupBy` on an iterable object.
   */
  private class GroupByTaintStep extends TaintTracking::SharedTaintStep {
    override predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::MethodCallNode call |
        call = DataFlow::globalVarRef(["Map", "Object"]).getAMemberCall("groupBy") and
        pred = call.getArgument(0) and
        (succ = call.getCallback(1).getParameter(0) or succ = call)
      )
    }
  }

  /**
   * A step for handling data flow and taint tracking for the groupBy method on iterable objects.
   * Ensures propagation of taint and data flow through the groupBy operation.
   */
  private class GroupByDataFlowStep extends PreCallGraphStep {
    override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
      exists(DataFlow::MethodCallNode call |
        call = DataFlow::globalVarRef("Map").getAMemberCall("groupBy") and
        pred = call.getArgument(0) and
        succ = call and
        prop = mapValueUnknownKey()
      )
    }
  }
}
