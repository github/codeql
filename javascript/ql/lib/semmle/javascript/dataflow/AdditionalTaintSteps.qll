/**
 * Note: The contents of this file are exposed with the `TaintTracking::` prefix, via an import in `TaintTracking.qll`.
 */

private import javascript
private import semmle.javascript.internal.CachedStages

/**
 * A taint-propagating data flow edge that should be added to all taint tracking
 * configurations, but only those that use the new data flow library.
 *
 * This class is a singleton, and thus subclasses do not need to specify a characteristic predicate.
 *
 * As an alternative to this class, consider using `DataFlow::SummarizedCallable`.
 *
 * Note: For performance reasons, all subclasses of this class should be part
 * of the standard library. Use `isAdditionalFlowStep` for query-specific taint steps.
 */
class AdditionalTaintStep extends Unit {
  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge.
   */
  predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }
}

/**
 * A taint-propagating data flow edge that should be added to all taint tracking
 * configurations in addition to standard data flow edges.
 *
 * This class is a singleton, and thus subclasses do not need to specify a characteristic predicate.
 *
 * Note: For performance reasons, all subclasses of this class should be part
 * of the standard library. Override `Configuration::isAdditionalTaintStep`
 * for analysis-specific taint steps.
 *
 * This class has multiple kinds of `step` predicates; these all have the same
 * effect on taint-tracking configurations. However, the categorization of steps
 * allows some data-flow configurations to opt in to specific kinds of taint steps.
 */
class SharedTaintStep extends Unit {
  // Each step relation in this class should have a cached version in the `Cached` module
  // and be included in the `sharedTaintStep` predicate.
  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge.
   */
  predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through URI manipulation.
   *
   * Does not include string operations that aren't specific to URIs, such
   * as concatenation and substring operations.
   */
  predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge contributed by the heuristics library.
   *
   * Such steps are provided by the `semmle.javascript.heuristics` libraries
   * and will default to be being empty if those libraries are not imported.
   */
  predicate heuristicStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through persistent storage.
   */
  predicate persistentStorageStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through the heap.
   */
  predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through arrays.
   *
   * These steps considers an array to be tainted if it contains tainted elements.
   */
  predicate arrayStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through the `state` or `props` or a React component.
   */
  predicate viewComponentStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through string concatenation.
   */
  predicate stringConcatenationStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through string manipulation (other than concatenation).
   */
  predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through data serialization, such as `JSON.stringify`.
   */
  predicate serializeStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through data deserialization, such as `JSON.parse`.
   */
  predicate deserializeStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through a promise.
   *
   * These steps consider a promise object to tainted if it can resolve to
   * a tainted value.
   */
  predicate promiseStep(DataFlow::Node pred, DataFlow::Node succ) { none() }
}

/**
 * A taint-propagating data flow edge that should be used with the old data flow library.
 *
 * This class is a singleton, and thus subclasses do not need to specify a characteristic predicate.
 *
 * Note: For performance reasons, all subclasses of this class should be part
 * of the standard library. Override `Configuration::isAdditionalTaintStep`
 * for analysis-specific taint steps.
 *
 * This class has multiple kinds of `step` predicates; these all have the same
 * effect on taint-tracking configurations. However, the categorization of steps
 * allows some data-flow configurations to opt in to specific kinds of taint steps.
 */
class LegacyTaintStep extends Unit {
  // Each step relation in this class should have a cached version in the `Cached` module
  // and be included in the `sharedTaintStep` predicate.
  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge.
   */
  predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through URI manipulation.
   *
   * Does not include string operations that aren't specific to URIs, such
   * as concatenation and substring operations.
   */
  predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge contributed by the heuristics library.
   *
   * Such steps are provided by the `semmle.javascript.heuristics` libraries
   * and will default to be being empty if those libraries are not imported.
   */
  predicate heuristicStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through persistent storage.
   */
  predicate persistentStorageStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through the heap.
   */
  predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through arrays.
   *
   * These steps considers an array to be tainted if it contains tainted elements.
   */
  predicate arrayStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through the `state` or `props` or a React component.
   */
  predicate viewComponentStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through string concatenation.
   */
  predicate stringConcatenationStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through string manipulation (other than concatenation).
   */
  predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through data serialization, such as `JSON.stringify`.
   */
  predicate serializeStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through data deserialization, such as `JSON.parse`.
   */
  predicate deserializeStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge through a promise.
   *
   * These steps consider a promise object to tainted if it can resolve to
   * a tainted value.
   */
  predicate promiseStep(DataFlow::Node pred, DataFlow::Node succ) { none() }
}

/**
 * Module existing only to ensure all taint steps are cached as a single stage,
 * and without the the `Unit` type column.
 */
cached
private module Cached {
  cached
  predicate forceStage() { Stages::Taint::ref() }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge, which doesn't fit into a more specific category.
   */
  cached
  predicate genericStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(SharedTaintStep step).step(pred, succ)
    or
    any(LegacyTaintStep step).step(pred, succ)
  }

  /**
   * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
   * data flow edge, contribued by the heuristics library.
   */
  cached
  predicate heuristicStep(DataFlow::Node pred, DataFlow::Node succ) {
    any(SharedTaintStep step).heuristicStep(pred, succ)
    or
    any(LegacyTaintStep step).heuristicStep(pred, succ)
  }

  /**
   * Public taint step relations.
   */
  cached
  module Public {
    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through a URI library function.
     */
    cached
    predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).uriStep(pred, succ)
      or
      any(LegacyTaintStep step).uriStep(pred, succ)
    }

    /**
     * Holds if `pred -> succ` is a taint propagating data flow edge through persistent storage.
     */
    cached
    predicate persistentStorageStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).persistentStorageStep(pred, succ)
      or
      any(LegacyTaintStep step).persistentStorageStep(pred, succ)
    }

    /**
     * Holds if `pred -> succ` is a taint propagating data flow edge through the heap.
     */
    cached
    predicate heapStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).heapStep(pred, succ)
      or
      any(LegacyTaintStep step).heapStep(pred, succ)
    }

    /**
     * Holds if `pred -> succ` is a taint propagating data flow edge through an array.
     */
    cached
    predicate arrayStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).arrayStep(pred, succ)
      or
      any(LegacyTaintStep step).arrayStep(pred, succ)
    }

    /**
     * Holds if `pred -> succ` is a taint propagating data flow edge through the
     * properties of a view compenent, such as the `state` or `props` of a React component.
     */
    cached
    predicate viewComponentStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).viewComponentStep(pred, succ)
      or
      any(LegacyTaintStep step).viewComponentStep(pred, succ)
    }

    /**
     * Holds if `pred -> succ` is a taint propagating data flow edge through string
     * concatenation.
     */
    cached
    predicate stringConcatenationStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).stringConcatenationStep(pred, succ)
      or
      any(LegacyTaintStep step).stringConcatenationStep(pred, succ)
    }

    /**
     * Holds if `pred -> succ` is a taint propagating data flow edge through string manipulation
     * (other than concatenation).
     */
    cached
    predicate stringManipulationStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).stringManipulationStep(pred, succ)
      or
      any(LegacyTaintStep step).stringManipulationStep(pred, succ)
    }

    /**
     *  Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through data serialization, such as `JSON.stringify`.
     */
    cached
    predicate serializeStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).serializeStep(pred, succ)
      or
      any(LegacyTaintStep step).serializeStep(pred, succ)
    }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through data deserialization, such as `JSON.parse`.
     */
    cached
    predicate deserializeStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).deserializeStep(pred, succ)
      or
      any(LegacyTaintStep step).deserializeStep(pred, succ)
    }

    /**
     * Holds if `pred` &rarr; `succ` should be considered a taint-propagating
     * data flow edge through a promise.
     *
     * These steps consider a promise object to tainted if it can resolve to
     * a tainted value.
     */
    cached
    predicate promiseStep(DataFlow::Node pred, DataFlow::Node succ) {
      any(SharedTaintStep step).promiseStep(pred, succ)
      or
      any(LegacyTaintStep step).promiseStep(pred, succ)
    }
  }
}

import Cached::Public

/**
 * Holds if `pred -> succ` is an edge used by all taint-tracking configurations in
 * the old data flow library.
 *
 * The new data flow library uses a different set of steps, exposed by `AdditionalTaintStep::step`.
 */
predicate sharedTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  Cached::genericStep(pred, succ) or
  Cached::heuristicStep(pred, succ) or
  uriStep(pred, succ) or
  persistentStorageStep(pred, succ) or
  heapStep(pred, succ) or
  arrayStep(pred, succ) or
  viewComponentStep(pred, succ) or
  stringConcatenationStep(pred, succ) or
  stringManipulationStep(pred, succ) or
  serializeStep(pred, succ) or
  deserializeStep(pred, succ) or
  promiseStep(pred, succ)
}

/**
 * Contains predicates for accessing the taint steps used by taint-tracking configurations
 * in the new data flow library.
 */
module AdditionalTaintStep {
  /**
   * Holds if `pred` &rarr; `succ` is considered a taint-propagating data flow edge when
   * using the new data flow library.
   */
  cached
  predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    any(AdditionalTaintStep step).step(pred, succ) or
    any(SharedTaintStep step).step(pred, succ) or
    any(SharedTaintStep step).heuristicStep(pred, succ) or
    any(SharedTaintStep step).uriStep(pred, succ) or
    any(SharedTaintStep step).persistentStorageStep(pred, succ) or
    any(SharedTaintStep step).heapStep(pred, succ) or
    any(SharedTaintStep step).arrayStep(pred, succ) or
    any(SharedTaintStep step).viewComponentStep(pred, succ) or
    any(SharedTaintStep step).stringConcatenationStep(pred, succ) or
    any(SharedTaintStep step).stringManipulationStep(pred, succ) or
    any(SharedTaintStep step).serializeStep(pred, succ) or
    any(SharedTaintStep step).deserializeStep(pred, succ) or
    any(SharedTaintStep step).promiseStep(pred, succ)
  }
}
