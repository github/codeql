/**
 * Provides an extension point for contributing flow edges prior
 * to call graph construction and type tracking.
 */

private import javascript
private import semmle.javascript.Unit
private import semmle.javascript.internal.CachedStages

/**
 * Internal extension point for adding flow edges prior to call graph construction
 * and type tracking.
 *
 * Steps added here will be added to both `SharedFlowStep` and `SharedTypeTrackingStep`.
 *
 * Contributing steps that rely on type tracking will lead to negative recursion.
 */
class PreCallGraphStep extends Unit {
  /**
   * Holds if there is a step from `pred` to `succ`.
   */
  predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if there is a step from `pred` into the `prop` property of `succ`.
   */
  predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) { none() }

  /**
   * Holds if there is a step from the `prop` property of `pred` to `succ`.
   */
  predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

  /**
   * Holds if there is a step from the `prop` property of `pred` to the same property in `succ`.
   */
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) { none() }

  /**
   * Holds if there is a step from the `loadProp` property of `pred` to the `storeProp` property in `succ`.
   */
  predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::SourceNode succ, string loadProp, string storeProp
  ) {
    none()
  }

  /**
   * Holds if `node` can hold an instance of `cls`.
   */
  predicate classInstanceSource(DataFlow::ClassNode cls, DataFlow::Node node) { none() }

  /**
   * Holds if `node` can hold an reference to the `cls` class itself.
   */
  predicate classObjectSource(DataFlow::ClassNode cls, DataFlow::Node node) { none() }
}

cached
module PreCallGraphStep {
  /**
   * Holds if there is a step from `pred` to `succ`.
   */
  cached
  predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    any(PreCallGraphStep s).step(pred, succ)
  }

  /**
   * Holds if there is a step from `pred` into the `prop` property of `succ`.
   */
  cached
  predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    any(PreCallGraphStep s).storeStep(pred, succ, prop)
  }

  /**
   * Holds if there is a step from the `prop` property of `pred` to `succ`.
   */
  cached
  predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    Stages::TypeTracking::ref() and
    any(PreCallGraphStep s).loadStep(pred, succ, prop)
  }

  /**
   * Holds if there is a step from the `prop` property of `pred` to the same property in `succ`.
   */
  cached
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    any(PreCallGraphStep s).loadStoreStep(pred, succ, prop)
  }

  /**
   * Holds if there is a step from the `loadProp` property of `pred` to the `storeProp` property in `succ`.
   */
  cached
  predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::SourceNode succ, string loadProp, string storeProp
  ) {
    any(PreCallGraphStep s).loadStoreStep(pred, succ, loadProp, storeProp)
  }

  /**
   * Holds if `node` can hold an instance of `cls`.
   */
  cached
  predicate classInstanceSource(DataFlow::ClassNode cls, DataFlow::Node node) {
    any(PreCallGraphStep s).classInstanceSource(cls, node)
  }

  /**
   * Holds if `node` can hold an reference to the `cls` class itself.
   */
  cached
  predicate classObjectSource(DataFlow::ClassNode cls, DataFlow::Node node) {
    any(PreCallGraphStep s).classObjectSource(cls, node)
  }
}

/**
 * Internal extension point for adding legacy flow edges prior to call graph construction
 * and type tracking, but where the steps should not be used by the new data flow library.
 *
 * Steps added here will be added to both `LegacyFlowStep` and `SharedTypeTrackingStep`.
 *
 * Contributing steps that rely on type tracking will lead to negative recursion.
 */
class LegacyPreCallGraphStep extends Unit {
  /**
   * Holds if there is a step from `pred` to `succ`.
   */
  predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if there is a step from `pred` into the `prop` property of `succ`.
   */
  predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) { none() }

  /**
   * Holds if there is a step from the `prop` property of `pred` to `succ`.
   */
  predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) { none() }

  /**
   * Holds if there is a step from the `prop` property of `pred` to the same property in `succ`.
   */
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) { none() }

  /**
   * Holds if there is a step from the `loadProp` property of `pred` to the `storeProp` property in `succ`.
   */
  predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::SourceNode succ, string loadProp, string storeProp
  ) {
    none()
  }
}

cached
module LegacyPreCallGraphStep {
  /**
   * Holds if there is a step from `pred` to `succ`.
   */
  cached
  predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    any(LegacyPreCallGraphStep s).step(pred, succ)
  }

  /**
   * Holds if there is a step from `pred` into the `prop` property of `succ`.
   */
  cached
  predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    any(LegacyPreCallGraphStep s).storeStep(pred, succ, prop)
  }

  /**
   * Holds if there is a step from the `prop` property of `pred` to `succ`.
   */
  cached
  predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    Stages::TypeTracking::ref() and
    any(LegacyPreCallGraphStep s).loadStep(pred, succ, prop)
  }

  /**
   * Holds if there is a step from the `prop` property of `pred` to the same property in `succ`.
   */
  cached
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    any(LegacyPreCallGraphStep s).loadStoreStep(pred, succ, prop)
  }

  /**
   * Holds if there is a step from the `loadProp` property of `pred` to the `storeProp` property in `succ`.
   */
  cached
  predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::SourceNode succ, string loadProp, string storeProp
  ) {
    any(LegacyPreCallGraphStep s).loadStoreStep(pred, succ, loadProp, storeProp)
  }
}

private class SharedFlowStepFromPreCallGraph extends DataFlow::SharedFlowStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    PreCallGraphStep::step(pred, succ)
  }

  override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    PreCallGraphStep::storeStep(pred, succ, prop)
  }

  override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    PreCallGraphStep::loadStep(pred, succ, prop)
  }

  override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    PreCallGraphStep::loadStoreStep(pred, succ, prop)
  }

  override predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
  ) {
    PreCallGraphStep::loadStoreStep(pred, succ, loadProp, storeProp)
  }
}

private class LegacyFlowStepFromPreCallGraph extends DataFlow::LegacyFlowStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    LegacyPreCallGraphStep::step(pred, succ)
  }

  override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    LegacyPreCallGraphStep::storeStep(pred, succ, prop)
  }

  override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    LegacyPreCallGraphStep::loadStep(pred, succ, prop)
  }

  override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    LegacyPreCallGraphStep::loadStoreStep(pred, succ, prop)
  }

  override predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
  ) {
    LegacyPreCallGraphStep::loadStoreStep(pred, succ, loadProp, storeProp)
  }
}

private class SharedTypeTrackingStepFromPreCallGraph extends DataFlow::SharedTypeTrackingStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    PreCallGraphStep::step(pred, succ)
    or
    LegacyPreCallGraphStep::step(pred, succ)
  }

  override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    PreCallGraphStep::storeStep(pred, succ, prop)
    or
    LegacyPreCallGraphStep::storeStep(pred, succ, prop)
  }

  override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    PreCallGraphStep::loadStep(pred, succ, prop)
    or
    LegacyPreCallGraphStep::loadStep(pred, succ, prop)
  }

  override predicate loadStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    PreCallGraphStep::loadStoreStep(pred, succ, prop)
    or
    LegacyPreCallGraphStep::loadStoreStep(pred, succ, prop)
  }

  override predicate loadStoreStep(
    DataFlow::Node pred, DataFlow::SourceNode succ, string loadProp, string storeProp
  ) {
    PreCallGraphStep::loadStoreStep(pred, succ, loadProp, storeProp)
    or
    LegacyPreCallGraphStep::loadStoreStep(pred, succ, loadProp, storeProp)
  }
}
