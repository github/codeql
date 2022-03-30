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
 * DEPRECATED. Exists only to support other deprecated elements.
 *
 * Type-tracking now automatically determines the set of pseudo-properties to include
 * ased on which properties are contributed by `SharedTaintStep`s.
 */
deprecated private class PseudoProperty extends string {
  PseudoProperty() {
    this = [arrayLikeElement(), "1"] or // the "1" is required for the `ForOfStep`.
    this =
      [
        mapValue(any(DataFlow::CallNode c | c.getCalleeName() = "set").getArgument(0)),
        mapValueAll()
      ]
  }
}

/**
 * DEPRECATED. Use `SharedFlowStep` or `SharedTaintTrackingStep` instead.
 */
abstract deprecated class CollectionFlowStep extends DataFlow::AdditionalFlowStep {
  final override predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

  final override predicate step(
    DataFlow::Node p, DataFlow::Node s, DataFlow::FlowLabel pl, DataFlow::FlowLabel sl
  ) {
    none()
  }

  /**
   * Holds if the property `prop` of the object `pred` should be loaded into `succ`.
   */
  predicate load(DataFlow::Node pred, DataFlow::Node succ, PseudoProperty prop) { none() }

  final override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    this.load(pred, succ, prop)
  }

  /**
   * Holds if `pred` should be stored in the object `succ` under the property `prop`.
   */
  predicate store(DataFlow::Node pred, DataFlow::SourceNode succ, PseudoProperty prop) { none() }

  final override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    this.store(pred, succ, prop)
  }

  /**
   * Holds if the property `prop` should be copied from the object `pred` to the object `succ`.
   */
  predicate loadStore(DataFlow::Node pred, DataFlow::Node succ, PseudoProperty prop) { none() }

  final override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    this.loadStore(pred, succ, prop, prop)
  }

  /**
   * Holds if the property `loadProp` should be copied from the object `pred` to the property `storeProp` of object `succ`.
   */
  predicate loadStore(
    DataFlow::Node pred, DataFlow::Node succ, PseudoProperty loadProp, PseudoProperty storeProp
  ) {
    none()
  }

  final override predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
  ) {
    this.loadStore(pred, succ, loadProp, storeProp)
  }
}

/**
 * DEPRECATED. These steps are now included in the default type tracking steps,
 * in most cases one can simply use those instead.
 */
deprecated module CollectionsTypeTracking {
  /**
   * Gets the result from a single step through a collection, from `pred` to `result` summarized by `summary`.
   */
  pragma[inline]
  DataFlow::SourceNode collectionStep(DataFlow::Node pred, StepSummary summary) {
    exists(PseudoProperty field |
      summary = LoadStep(field) and
      DataFlow::SharedTypeTrackingStep::loadStep(pred, result, field) and
      not field = mapValueUnknownKey() // prune unknown reads in type-tracking
      or
      summary = StoreStep(field) and
      DataFlow::SharedTypeTrackingStep::storeStep(pred, result, field)
      or
      summary = CopyStep(field) and
      DataFlow::SharedTypeTrackingStep::loadStoreStep(pred, result, field)
      or
      exists(PseudoProperty toField | summary = LoadStoreStep(field, toField) |
        DataFlow::SharedTypeTrackingStep::loadStoreStep(pred, result, field, toField)
      )
    )
  }

  /**
   * Gets the result from a single step through a collection, from `pred` with tracker `t2` to `result` with tracker `t`.
   */
  pragma[inline]
  DataFlow::SourceNode collectionStep(
    DataFlow::SourceNode pred, DataFlow::TypeTracker t, DataFlow::TypeTracker t2
  ) {
    exists(DataFlow::Node mid, StepSummary summary | pred.flowsTo(mid) and t = t2.append(summary) |
      result = collectionStep(mid, summary)
    )
  }
}

/**
 * A module for data-flow steps related standard library collection implementations.
 */
private module CollectionDataFlow {
  /**
   * A step for `Set.add()` method, which adds an element to a Set.
   */
  private class SetAdd extends PreCallGraphStep {
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
  private class SetConstructor extends PreCallGraphStep {
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
  private class ForOfStep extends PreCallGraphStep {
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
  private class SetMapForEach extends PreCallGraphStep {
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
  private class MapGet extends PreCallGraphStep {
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
  class MapSet extends PreCallGraphStep {
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
  private class MapAndSetValues extends PreCallGraphStep {
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
  private class SetKeys extends PreCallGraphStep {
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
}
