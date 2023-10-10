private import javascript

/**
 * A data flow edge that should be added to all data flow configurations in
 * addition to standard data flow edges.
 *
 * This class is a singleton, and thus subclasses do not need to specify a characteristic predicate.
 *
 * Note: For performance reasons, all subclasses of this class should be part
 * of the standard library. Override `Configuration::isAdditionalFlowStep`
 * for analysis-specific flow steps.
 */
class SharedFlowStep extends Unit {
  /**
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge.
   */
  predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge
   * transforming values with label `predlbl` to have label `succlbl`.
   */
  predicate step(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel predlbl,
    DataFlow::FlowLabel succlbl
  ) {
    none()
  }

  /**
   * Holds if `pred` should be stored in the object `succ` under the property `prop`.
   * The object `succ` must be a `DataFlow::SourceNode` for the object wherein the value is stored.
   */
  predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) { none() }

  /**
   * Holds if the property `prop` of the object `pred` should be loaded into `succ`.
   */
  predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

  /**
   * Holds if the property `prop` should be copied from the object `pred` to the object `succ`.
   */
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

  /**
   * Holds if the property `loadProp` should be copied from the object `pred` to the property `storeProp` of object `succ`.
   */
  predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
  ) {
    none()
  }
}

/**
 * Contains predicates for accessing the steps contributed by `SharedFlowStep`, `LegacyFlowStep`, and `AdditionalFlowStep` subclasses.
 */
module SharedFlowStep {
  /**
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge.
   */
  pragma[inline]
  predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    any(SharedFlowStep s).step(pred, succ)
  }

  /**
   * Holds if `pred` should be stored in the object `succ` under the property `prop`.
   * The object `succ` must be a `DataFlow::SourceNode` for the object wherein the value is stored.
   */
  pragma[inline]
  predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    any(SharedFlowStep s).storeStep(pred, succ, prop)
  }

  /**
   * Holds if the property `prop` of the object `pred` should be loaded into `succ`.
   */
  pragma[inline]
  predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    any(SharedFlowStep s).loadStep(pred, succ, prop)
  }

  // The following are aliases for old step predicates that have no corresponding predicate in AdditionalFlowStep
  /**
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge
   * transforming values with label `predlbl` to have label `succlbl`.
   */
  predicate step(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel predlbl,
    DataFlow::FlowLabel succlbl
  ) {
    any(SharedFlowStep s).step(pred, succ, predlbl, succlbl)
  }

  /**
   * Holds if the property `prop` should be copied from the object `pred` to the object `succ`.
   */
  cached
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    any(SharedFlowStep s).loadStoreStep(pred, succ, prop)
  }

  /**
   * Holds if the property `loadProp` should be copied from the object `pred` to the property `storeProp` of object `succ`.
   */
  cached
  predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
  ) {
    any(SharedFlowStep s).loadStoreStep(pred, succ, loadProp, storeProp)
  }
}
