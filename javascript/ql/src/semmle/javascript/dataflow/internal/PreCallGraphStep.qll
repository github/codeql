/**
 * Provides an extension point for contributing flow edges prior
 * to call graph construction and type tracking.
 */

private import javascript

private newtype TUnit = MkUnit()

private class Unit extends TUnit {
  string toString() { result = "unit" }
}

/**
 * Internal extension point for adding flow edges prior to call graph construction
 * and type tracking.
 *
 * Steps added here will be added to both `AdditionalFlowStep` and `AdditionalTypeTrackingStep`.
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
}

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
    any(PreCallGraphStep s).loadStep(pred, succ, prop)
  }

  /**
   * Holds if there is a step from the `prop` property of `pred` to the same property in `succ`.
   */
  cached
  predicate loadStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    any(PreCallGraphStep s).loadStoreStep(pred, succ, prop)
  }
}

private class NodeWithPreCallGraphStep extends DataFlow::Node {
  NodeWithPreCallGraphStep() {
    PreCallGraphStep::step(this, _)
    or
    PreCallGraphStep::storeStep(this, _, _)
    or
    PreCallGraphStep::loadStep(this, _, _)
    or
    PreCallGraphStep::loadStoreStep(this, _, _)
  }
}

private class AdditionalFlowStepFromPreCallGraph extends NodeWithPreCallGraphStep,
  DataFlow::AdditionalFlowStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = this and
    PreCallGraphStep::step(this, succ)
  }

  override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    pred = this and
    PreCallGraphStep::storeStep(this, succ, prop)
  }

  override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    pred = this and
    PreCallGraphStep::loadStep(this, succ, prop)
  }

  override predicate loadStoreStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    pred = this and
    PreCallGraphStep::loadStoreStep(this, succ, prop)
  }
}

private class AdditionalTypeTrackingStepFromPreCallGraph extends NodeWithPreCallGraphStep,
  DataFlow::AdditionalTypeTrackingStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    pred = this and
    PreCallGraphStep::step(this, succ)
  }

  override predicate storeStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    pred = this and
    PreCallGraphStep::storeStep(this, succ, prop)
  }

  override predicate loadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    pred = this and
    PreCallGraphStep::loadStep(this, succ, prop)
  }

  override predicate loadStoreStep(DataFlow::Node pred, DataFlow::SourceNode succ, string prop) {
    pred = this and
    PreCallGraphStep::loadStoreStep(this, succ, prop)
  }
}
