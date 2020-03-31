import javascript
private import semmle.javascript.dataflow.internal.StepSummary
private import DataFlow::PseudoProperties

/**
 * Common predicates and classes for type and data-flow tracking on Maps and Sets.
 */
private module MapsAndSets {
  /**
   * An `AdditionalFlowStep` used to model a data-flow step related to Maps and Sets.
   *
   * The `loadStep`/`storeStep`/`loadStoreStep` methods are overloaded such that the new predicates
   * `load`/`store`/`loadStore` can be used in the `MapsAndSetsTypeTracking` module.
   * (Thereby avoiding conflicts with a "cousin" `AdditionalFlowStep` implementation.)
   */
  abstract class MapOrSetFlowStep extends DataFlow::AdditionalFlowStep {
    final override predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

    final override predicate step(
      DataFlow::Node p, DataFlow::Node s, DataFlow::FlowLabel pl, DataFlow::FlowLabel sl
    ) {
      none()
    }

    /**
     * Holds if the property `prop` of the object `pred` should be loaded into `succ`.
     */
    predicate load(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

    final override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      this.load(pred, succ, prop)
    }

    /**
     * Holds if `pred` should be stored in the object `succ` under the property `prop`.
     */
    predicate store(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

    final override predicate storeStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      this.store(pred, succ, prop)
    }

    /**
     * Holds if the property `prop` should be copied from the object `pred` to the object `succ`.
     */
    predicate loadStore(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

    final override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
      this.loadStore(pred, succ, prop, prop)
    }

    /**
     * Holds if the property `loadProp` should be copied from the object `pred` to the property `storeProp` of object `succ`.
     */
    predicate loadStore(DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp) {
      none()
    }

    final override predicate loadStoreStep(
      DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
    ) {
      this.loadStore(pred, succ, loadProp, storeProp)
    }

    /**
     * Holds if this is a map step that could potentially load a value where the corresponding key has a known string value.
     */
    predicate canLoadKnownKey() { none() }
  }
}

/**
 * A collection of predicates and clases for type-tracking Maps and Sets.
 */
module MapsAndSetsTypeTracking {
  private import MapsAndSets

  /**
   * Gets the result from a single step through a Map or Set, from `pred` to `result` summarized by `summary`.
   */
  pragma[inline]
  DataFlow::SourceNode mapOrSetStep(DataFlow::Node pred, StepSummary summary) {
    exists(MapOrSetFlowStep step, string field |
      summary = LoadStep(field) and
      step.load(pred, result, field) and
      (not step.canLoadKnownKey() or not field = mapValueUnknownKey()) // for a step that could load a known key, we prune the steps where the key is unknown. 
      or
      summary = StoreStep(field) and
      step.store(pred, result, field)
      or
      exists(string toField | summary = LoadStoreStep(field, toField) |
        field = toField and
        step.loadStore(pred, result, field)
        or
        step.loadStore(pred, result, field, toField)
      )
    )
  }

  /**
   * Gets the result from a single step through a Map or set, from `pred` with tracker `t2` to `result` with tracker `t`.
   */
  pragma[inline]
  DataFlow::SourceNode mapOrSetStep(
    DataFlow::SourceNode pred, DataFlow::TypeTracker t, DataFlow::TypeTracker t2
  ) {
    exists(DataFlow::Node mid, StepSummary summary | pred.flowsTo(mid) and t = t2.append(summary) |
      result = mapOrSetStep(mid, summary)
    )
  }

  /**
   * A class enabling the use of the Map and Set related pseudo-properties as a pseudo-property in type-tracking predicates.
   */
  private class MapRelatedPseudoFieldAsTypeTrackingProperty extends TypeTrackingPseudoProperty {
    MapRelatedPseudoFieldAsTypeTrackingProperty() {
      this = [setElement(), iteratorElement()] or
      any(MapOrSetFlowStep step).store(_, _, this)
    }

    override string getLoadStoreToProp() { 
      exists(MapOrSetFlowStep step | step.loadStore(_, _, this, result))
    }
  }
}

/**
 * A module for data-flow steps related to `Set` and `Map`.
 */
private module MapAndSetDataFlow {
  private import MapsAndSets

  /**
   * A step for an `add` method, which adds an element to a Set.
   */
  private class SetAdd extends MapOrSetFlowStep, DataFlow::MethodCallNode {
    SetAdd() { this.getMethodName() = "add" }

    override predicate store(DataFlow::Node element, DataFlow::Node obj, string prop) {
      obj = this.getReceiver().getALocalSource() and
      element = this.getArgument(0) and
      prop = setElement()
    }
  }

  /**
   * A step for the `Set` constructor, which copies any elements from the first argument into the resulting set.
   */
  private class SetConstructor extends MapOrSetFlowStep, DataFlow::NewNode {
    SetConstructor() { this = DataFlow::globalVarRef("Set").getAnInstantiation() }

    override predicate loadStore(
      DataFlow::Node pred, DataFlow::Node succ, string fromProp, string toProp
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
   * 
   * This is partially duplicated behavior with the `for of` step for Arrays (in Arrays.qll). 
   * This duplication is required for the type-tracking steps defined in `MapsAndSetsTypeTracking`. 
   */
  private class ForOfStep extends MapOrSetFlowStep, DataFlow::ValueNode {
    ForOfStmt forOf;
    DataFlow::Node element;

    ForOfStep() {
      this.asExpr() = forOf.getIterationDomain() and
      element = DataFlow::lvalueNode(forOf.getLValue())
    }

    override predicate load(DataFlow::Node obj, DataFlow::Node e, string prop) {
      obj = this and
      e = element and
      prop = arrayLikeElement()
    }

    override predicate loadStore(
      DataFlow::Node pred, DataFlow::Node succ, string fromProp, string toProp
    ) {
      pred = this and
      succ = element and
      fromProp = mapValueUnknownKey() and
      toProp = "1"
    }
  }

  /**
   * A step for a call to `forEach` on a Set or Map.
   */
  private class SetMapForEach extends MapOrSetFlowStep, DataFlow::MethodCallNode {
    SetMapForEach() { this.getMethodName() = "forEach" }

    override predicate load(DataFlow::Node obj, DataFlow::Node element, string prop) {
      obj = this.getReceiver() and
      element = this.getCallback(0).getParameter(0) and
      prop = [setElement(), mapValueUnknownKey()]
    }
  }

  /**
   * A call to the `get` method on a Map.
   * If the key of the call to `get` has a known string value, then only the value corresponding to that key will be retrieved.
   */
  private class MapGet extends MapOrSetFlowStep, DataFlow::MethodCallNode {
    MapGet() { this.getMethodName() = "get" }

    override predicate load(DataFlow::Node obj, DataFlow::Node element, string prop) {
      obj = this.getReceiver() and
      element = this and
      prop = mapValue(this.getArgument(0))
    }

    override predicate canLoadKnownKey() { any() }
  }

  /**
   * A call to the `set` method on a Map.
   * 
   * If the key of the call to `set` has a known string value, 
   * then the value will be saved into a pseudo-property corresponding to the known string value. 
   * The value will additionally be saved into a pseudo-property corresponding to values with unknown keys.
   */
  private class MapSet extends MapOrSetFlowStep, DataFlow::MethodCallNode {
    MapSet() { this.getMethodName() = "set" }

    override predicate store(DataFlow::Node element, DataFlow::Node obj, string prop) {
      obj = this.getReceiver().getALocalSource() and
      element = this.getArgument(1) and
      // Makes sure that both known and unknown gets will work.
      prop = [mapValue(this.getArgument(0)), mapValueUnknownKey()]
    }
  }

  /** 
   * A step for a call to `values` on a Map or a Set.
   */ 
  private class MapAndSetValues extends MapOrSetFlowStep, DataFlow::MethodCallNode {
    MapAndSetValues() { this.getMethodName() = "values" }

    override predicate loadStore(
      DataFlow::Node pred, DataFlow::Node succ, string fromProp, string toProp
    ) {
      pred = this.getReceiver() and
      succ = this and
      fromProp = [mapValueUnknownKey(),setElement()] and
      toProp = iteratorElement()
    }
  }

  /** 
   * A step for a call to `keys` on a Set.
   */ 
  private class SetKeys extends MapOrSetFlowStep, DataFlow::MethodCallNode {
    SetKeys() { this.getMethodName() = "keys" }

    override predicate loadStore(
      DataFlow::Node pred, DataFlow::Node succ, string fromProp, string toProp
    ) {
      pred = this.getReceiver() and
      succ = this and
      fromProp = setElement() and
      toProp = iteratorElement()
    }
  }
}
