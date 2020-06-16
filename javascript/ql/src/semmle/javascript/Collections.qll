/**
 * Provides predicates and classes for working with the standard library collection implementations.
 * Currently [Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) and
 * [Set](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set) are implemented.
 */

import javascript
private import semmle.javascript.dataflow.internal.StepSummary
private import DataFlow::PseudoProperties

/**
 * A pseudo-property used in a data-flow/type-tracking step for collections.
 *
 * By extending `TypeTrackingPseudoProperty` the class enables the use of the collection related pseudo-properties in type-tracking predicates.
 */
private class PseudoProperty extends TypeTrackingPseudoProperty {
  PseudoProperty() {
    this = [arrayLikeElement(), "1"] or // the "1" is required for the `ForOfStep`.
    this = any(CollectionDataFlow::MapSet step).getAPseudoProperty()
  }

  override PseudoProperty getLoadStoreToProp() {
    exists(CollectionFlowStep step | step.loadStore(_, _, this, result))
  }
}

/**
 * An `AdditionalFlowStep` used to model a data-flow step related to standard library collections.
 *
 * The `loadStep`/`storeStep`/`loadStoreStep` methods are overloaded such that the new predicates
 * `load`/`store`/`loadStore` can be used in the `CollectionsTypeTracking` module.
 * (Thereby avoiding naming conflicts with a "cousin" `AdditionalFlowStep` implementation.)
 */
abstract class CollectionFlowStep extends DataFlow::AdditionalFlowStep {
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
 * Provides predicates and clases for type-tracking collections.
 */
module CollectionsTypeTracking {
  /**
   * Gets the result from a single step through a collection, from `pred` to `result` summarized by `summary`.
   */
  pragma[inline]
  DataFlow::SourceNode collectionStep(DataFlow::Node pred, StepSummary summary) {
    exists(CollectionFlowStep step, PseudoProperty field |
      summary = LoadStep(field) and
      step.load(pred, result, field) and
      not field = mapValueUnknownKey() // prune unknown reads in type-tracking
      or
      summary = StoreStep(field) and
      step.store(pred, result, field)
      or
      summary = CopyStep(field) and
      step.loadStore(pred, result, field)
      or
      exists(PseudoProperty toField | summary = LoadStoreStep(field, toField) |
        step.loadStore(pred, result, field, toField)
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
  private class SetAdd extends CollectionFlowStep, DataFlow::MethodCallNode {
    SetAdd() { this.getMethodName() = "add" }

    override predicate store(DataFlow::Node element, DataFlow::SourceNode obj, PseudoProperty prop) {
      this = obj.getAMethodCall() and
      element = this.getArgument(0) and
      prop = setElement()
    }
  }

  /**
   * A step for the `Set` constructor, which copies any elements from the first argument into the resulting set.
   */
  private class SetConstructor extends CollectionFlowStep, DataFlow::NewNode {
    SetConstructor() { this = DataFlow::globalVarRef("Set").getAnInstantiation() }

    override predicate loadStore(
      DataFlow::Node pred, DataFlow::Node succ, PseudoProperty fromProp, PseudoProperty toProp
    ) {
      pred = this.getArgument(0) and
      succ = this and
      fromProp = arrayLikeElement() and
      toProp = setElement()
    }
  }

  /**
   * A step for a `for of` statement on a Map, Set, or Iterator.
   * For Sets and iterators the l-value are the elements of the set/iterator.
   * For Maps the l-value is a tuple containing a key and a value.
   */
  // This is partially duplicated behavior with the `for of` step for Arrays (`ArrayDataFlow::ForOfStep`).
  // This duplication is required for the type-tracking steps defined in `CollectionsTypeTracking`.
  private class ForOfStep extends CollectionFlowStep, DataFlow::ValueNode {
    ForOfStmt forOf;
    DataFlow::Node element;

    ForOfStep() {
      this.asExpr() = forOf.getIterationDomain() and
      element = DataFlow::lvalueNode(forOf.getLValue())
    }

    override predicate load(DataFlow::Node obj, DataFlow::Node e, PseudoProperty prop) {
      obj = this and
      e = element and
      prop = arrayLikeElement()
    }

    override predicate loadStore(
      DataFlow::Node pred, DataFlow::Node succ, PseudoProperty fromProp, PseudoProperty toProp
    ) {
      pred = this and
      succ = element and
      fromProp = mapValueAll() and
      toProp = "1"
    }
  }

  /**
   * A step for a call to `forEach` on a Set or Map.
   */
  private class SetMapForEach extends CollectionFlowStep, DataFlow::MethodCallNode {
    SetMapForEach() { this.getMethodName() = "forEach" }

    override predicate load(DataFlow::Node obj, DataFlow::Node element, PseudoProperty prop) {
      obj = this.getReceiver() and
      element = this.getCallback(0).getParameter(0) and
      prop = [setElement(), mapValueAll()]
    }
  }

  /**
   * A call to the `get` method on a Map.
   * If the key of the call to `get` has a known string value, then only the value corresponding to that key will be retrieved. (The known string value is encoded as part of the pseudo-property)
   */
  private class MapGet extends CollectionFlowStep, DataFlow::MethodCallNode {
    MapGet() { this.getMethodName() = "get" }

    override predicate load(DataFlow::Node obj, DataFlow::Node element, PseudoProperty prop) {
      obj = this.getReceiver() and
      element = this and
      // reading the join of known and unknown values
      (prop = mapValue(this.getArgument(0)) or prop = mapValueUnknownKey())
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
  class MapSet extends CollectionFlowStep, DataFlow::MethodCallNode {
    MapSet() { this.getMethodName() = "set" }

    override predicate store(DataFlow::Node element, DataFlow::SourceNode obj, PseudoProperty prop) {
      this = obj.getAMethodCall() and
      element = this.getArgument(1) and
      prop = getAPseudoProperty()
    }

    /**
     * Gets a pseudo-property used to store an element in a map.
     * The pseudo-property represents both values where the key is a known string value (which is encoded in the pseudo-property),
     * and values where the key is unknown.
     *
     * Additionally, all elements are stored into the pseudo-property `mapValueAll()`.
     *
     * The return-type is `string` as this predicate is used to define which pseudo-properties exist.
     */
    string getAPseudoProperty() { result = [mapValue(this.getArgument(0)), mapValueAll()] }
  }

  /**
   * A step for a call to `values` on a Map or a Set.
   */
  private class MapAndSetValues extends CollectionFlowStep, DataFlow::MethodCallNode {
    MapAndSetValues() { this.getMethodName() = "values" }

    override predicate loadStore(
      DataFlow::Node pred, DataFlow::Node succ, PseudoProperty fromProp, PseudoProperty toProp
    ) {
      pred = this.getReceiver() and
      succ = this and
      fromProp = [mapValueAll(), setElement()] and
      toProp = iteratorElement()
    }
  }

  /**
   * A step for a call to `keys` on a Set.
   */
  private class SetKeys extends CollectionFlowStep, DataFlow::MethodCallNode {
    SetKeys() { this.getMethodName() = "keys" }

    override predicate loadStore(
      DataFlow::Node pred, DataFlow::Node succ, PseudoProperty fromProp, PseudoProperty toProp
    ) {
      pred = this.getReceiver() and
      succ = this and
      fromProp = setElement() and
      toProp = iteratorElement()
    }
  }
}
