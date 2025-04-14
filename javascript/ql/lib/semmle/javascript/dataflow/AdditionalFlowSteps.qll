/**
 * This contains three step-contribution classes, in order to support graceful deprecation of the old data flow library.
 *
 * - `class AdditionalFlowStep`: steps used only by the new dataflow library
 * - `class LegacyFlowStep`: steps used only by the old data flow library
 * - `class SharedFlowStep`: steps used by both
 *
 * The latter two will be deprecated in the future, but are currently not marked as `deprecated`.
 * This is because a library model should be able to support both data flow libraries simultaneously, without itself getting
 * deprecation warnings.
 *
 * To simplify correct consumption of these steps there is a correspondingly-named module for each:
 *
 * - `module AdditionalFlowStep`: exposes steps from `AdditionalFlowStep` and `SharedFlowStep` subclasses.
 * - `module LegacyFlowStep`: exposes steps from `LegacyFlowStep` and `SharedFlowStep` subclasses.
 * - `module SharedFlowStep`: exposes steps from all three classes.
 *
 * This design is intended to simplify consumption of steps, and to ensure existing consumers of `SharedFlowStep`
 * outside this codebase will continue to work with as few surprises as possible.
 */

private import javascript
private import semmle.javascript.internal.CachedStages

/**
 * A value-preserving data flow edge that should be used in all data flow configurations in
 * addition to standard data flow edges.
 *
 * This class is a singleton, and thus subclasses do not need to specify a characteristic predicate.
 *
 * As an alternative to this class, consider using `DataFlow::SummarizedCallable`.
 *
 * Note: For performance reasons, all subclasses of this class should be part
 * of the standard library. Use `isAdditionalFlowStep` for query-specific flow steps.
 */
class AdditionalFlowStep extends Unit {
  /**
   * Holds if `pred` &rarr; `succ` should be considered a value-preserving data flow edge.f
   */
  predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a value-preserving data flow edge that
   * crosses calling contexts.
   */
  predicate jumpStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` should be stored in the given `content` of the object `succ`.
   */
  predicate storeStep(DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ) {
    none()
  }

  /**
   * Holds if the given `content` of the object in `pred` should be read into `succ`.
   */
  predicate readStep(DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ) {
    none()
  }
}

/**
 * Contains predicates for accessing the steps contributed by `AdditionalFlowStep` and `SharedFlowStep` subclasses.
 */
cached
module AdditionalFlowStep {
  cached
  private module Internal {
    // Forces this to be part of the `FlowSteps` stage.
    // We use a public predicate in a private module to avoid warnings about this being unused.
    cached
    predicate forceStage() { Stages::FlowSteps::ref() }
  }

  bindingset[a, b]
  pragma[inline_late]
  private predicate sameContainer(DataFlow::Node a, DataFlow::Node b) {
    a.getContainer() = b.getContainer()
  }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge.
   */
  cached
  predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    any(AdditionalFlowStep s).step(pred, succ)
    or
    any(SharedFlowStep s).step(pred, succ) and
    sameContainer(pred, succ)
  }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a value-preserving data flow edge that
   * crosses calling contexts.
   */
  cached
  predicate jumpStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(AdditionalFlowStep s).jumpStep(pred, succ)
    or
    any(SharedFlowStep s).step(pred, succ) and
    not sameContainer(pred, succ)
  }

  /**
   * Holds if `pred` should be stored in the object `succ` under the property `prop`.
   */
  cached
  predicate storeStep(DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ) {
    any(AdditionalFlowStep s).storeStep(pred, contents, succ)
    or
    exists(string prop |
      any(SharedFlowStep s).storeStep(pred, succ, prop) and
      contents = DataFlow::ContentSet::fromLegacyProperty(prop)
    )
  }

  /**
   * Holds if the property `prop` of the object `pred` should be read into `succ`.
   */
  cached
  predicate readStep(DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ) {
    any(AdditionalFlowStep s).readStep(pred, contents, succ)
    or
    exists(string prop |
      any(SharedFlowStep s).loadStep(pred, succ, prop) and
      contents = DataFlow::ContentSet::fromLegacyProperty(prop)
    )
  }
}

/**
 * A data flow edge that is only seen by the old, deprecated data flow library.
 *
 * This class is typically used when a step has been replaced by a flow summary. Since the old data flow
 * library does not support flow summaries, such a step should remain as a legacy step, until the old data flow
 * library can be removed.
 *
 * Note: For performance reasons, all subclasses of this class should be part
 * of the standard library. Override `Configuration::isAdditionalFlowStep`
 * for analysis-specific flow steps.
 */
class LegacyFlowStep extends Unit {
  /**
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge.
   */
  predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * DEPRECATED. The `FlowLabel` class and steps involving flow labels are no longer used by any queries.
   *
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge
   * transforming values with label `predlbl` to have label `succlbl`.
   */
  deprecated predicate step(
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
 * Contains predicates for accessing the steps contributed by `LegacyFlowStep` and `SharedFlowStep` subclasses.
 */
cached
module LegacyFlowStep {
  /**
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge.
   */
  cached
  predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    any(LegacyFlowStep s).step(pred, succ)
    or
    any(SharedFlowStep s).step(pred, succ)
  }

  /**
   * DEPRECATED. The `FlowLabel` class and steps involving flow labels are no longer used by any queries.
   *
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge
   * transforming values with label `predlbl` to have label `succlbl`.
   */
  cached
  deprecated predicate step(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel predlbl,
    DataFlow::FlowLabel succlbl
  ) {
    any(LegacyFlowStep s).step(pred, succ, predlbl, succlbl)
    or
    any(SharedFlowStep s).step(pred, succ, predlbl, succlbl)
  }

  /**
   * Holds if `pred` should be stored in the object `succ` under the property `prop`.
   * The object `succ` must be a `DataFlow::SourceNode` for the object wherein the value is stored.
   */
  cached
  predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    any(LegacyFlowStep s).storeStep(pred, succ, prop)
    or
    any(SharedFlowStep s).storeStep(pred, succ, prop)
  }

  /**
   * Holds if the property `prop` of the object `pred` should be loaded into `succ`.
   */
  cached
  predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    any(LegacyFlowStep s).loadStep(pred, succ, prop)
    or
    any(SharedFlowStep s).loadStep(pred, succ, prop)
  }

  /**
   * Holds if the property `prop` should be copied from the object `pred` to the object `succ`.
   */
  cached
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    any(LegacyFlowStep s).loadStoreStep(pred, succ, prop)
    or
    any(SharedFlowStep s).loadStoreStep(pred, succ, prop)
  }

  /**
   * Holds if the property `loadProp` should be copied from the object `pred` to the property `storeProp` of object `succ`.
   */
  cached
  predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
  ) {
    any(LegacyFlowStep s).loadStoreStep(pred, succ, loadProp, storeProp)
    or
    any(SharedFlowStep s).loadStoreStep(pred, succ, loadProp, storeProp)
  }
}

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
   * DEPRECATED. The `FlowLabel` class and steps involving flow labels are no longer used by any queries.
   *
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge
   * transforming values with label `predlbl` to have label `succlbl`.
   */
  deprecated predicate step(
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
    or
    any(AdditionalFlowStep s).step(pred, succ)
    or
    any(LegacyFlowStep s).step(pred, succ)
  }

  /**
   * Holds if `pred` should be stored in the object `succ` under the property `prop`.
   * The object `succ` must be a `DataFlow::SourceNode` for the object wherein the value is stored.
   */
  pragma[inline]
  predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    any(SharedFlowStep s).storeStep(pred, succ, prop)
    or
    any(AdditionalFlowStep s)
        .storeStep(pred, DataFlow::ContentSet::property(prop), succ.getALocalUse())
    or
    any(LegacyFlowStep s).storeStep(pred, succ, prop)
  }

  /**
   * Holds if the property `prop` of the object `pred` should be loaded into `succ`.
   */
  pragma[inline]
  predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    any(SharedFlowStep s).loadStep(pred, succ, prop)
    or
    any(AdditionalFlowStep s).readStep(pred, DataFlow::ContentSet::property(prop), succ)
    or
    any(LegacyFlowStep s).loadStep(pred, succ, prop)
  }

  // The following are aliases for old step predicates that have no corresponding predicate in AdditionalFlowStep
  /**
   * DEPRECATED. The `FlowLabel` class and steps involving flow labels are no longer used by any queries.
   *
   * Holds if `pred` &rarr; `succ` should be considered a data flow edge
   * transforming values with label `predlbl` to have label `succlbl`.
   */
  deprecated predicate step(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel predlbl,
    DataFlow::FlowLabel succlbl
  ) {
    any(SharedFlowStep s).step(pred, succ, predlbl, succlbl)
    or
    any(LegacyFlowStep s).step(pred, succ, predlbl, succlbl)
  }

  /**
   * Holds if the property `prop` should be copied from the object `pred` to the object `succ`.
   */
  cached
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    any(SharedFlowStep s).loadStoreStep(pred, succ, prop)
    or
    any(LegacyFlowStep s).loadStoreStep(pred, succ, prop)
  }

  /**
   * Holds if the property `loadProp` should be copied from the object `pred` to the property `storeProp` of object `succ`.
   */
  cached
  predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
  ) {
    any(SharedFlowStep s).loadStoreStep(pred, succ, loadProp, storeProp)
    or
    any(LegacyFlowStep s).loadStoreStep(pred, succ, loadProp, storeProp)
  }
}
