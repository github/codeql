private import javascript as raw

/**
 * EXPERIMENTAL. This API may change in the future.
 *
 * A configuration class for defining known endpoints and endpoint filters for adaptive threat
 * modeling (ATM). Each boosted query must define its own extension of this abstract class.
 *
 * A configuration defines a set of known sources (`isKnownSource`) and sinks (`isKnownSink`).
 * It must also define a sink endpoint filter (`isEffectiveSink`) that filters candidate sinks
 * predicted by the machine learning model to a set of effective sinks.
 *
 * Optionally, a configuration may also define additional edges beyond the base data flow edges
 * (`isAdditionalFlowStep`) and sanitizers (`isSanitizer` and `isSanitizerGuard`).
 *
 * To get started with ATM, you can copy-paste an implementation of the `DataFlow::Configuration`
 * class for a standard security query, for example `SqlInjection::Configuration`. Note that if
 * the security query configuration defines additional edges beyond the standard data flow edges,
 * such as `NosqlInjection::Configuration`, you may need to replace the definition of
 * `isAdditionalFlowStep` with a more generalised definition of additional edges. See
 * `NosqlInjectionATM.ql` for an example of doing this.
 *
 * Technical information:
 *
 * - Conceptually, this class is very similar to the subclass of `DataFlow::Configuration` that is
 * used to define the base security query. The reason why we define a new class to provide this
 * information to ATM is due to performance implications of QL's dispatch behaviour: defining
 * another `DataFlow::Configuration` instance would slow the evaluation of the boosted query.
 *
 * - Furthermore, we cannot use the approach used by the `ForwardExploration` and
 * `BackwardExploration` modules to implement ATM, since ATM needs access to the sets of sources
 * and sinks from the *original* dataflow configuration in order to perform similarity search.
 */
abstract class ATMConfig extends string {
  bindingset[this]
  ATMConfig() { any() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if `source` is a known source of flow.
   */
  predicate isKnownSource(raw::DataFlow::Node source) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if `source` is a known source of flow labeled with `lbl`.
   */
  predicate isKnownSource(raw::DataFlow::Node source, raw::DataFlow::FlowLabel lbl) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if `sink` is a known sink of flow.
   */
  predicate isKnownSink(raw::DataFlow::Node sink) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if `sink` is a known sink of flow labeled with `lbl`.
   */
  predicate isKnownSink(raw::DataFlow::Node sink, raw::DataFlow::FlowLabel lbl) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the candidate sink `candidateSink` predicted by the machine learning model should be
   * an effective sink, i.e. one considered as a possible sink of flow in the boosted query.
   */
  abstract predicate isEffectiveSink(raw::DataFlow::Node candidateSink);

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the intermediate node `node` is a taint sanitizer.
   */
  predicate isSanitizer(raw::DataFlow::Node node) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if for the boosted query the data flow node `guard` can act as a sanitizer when
   * appearing in a condition.
   *
   * For example, if `guard` is the comparison expression in
   * `if(x == 'some-constant'){ ... x ... }`, it could sanitize flow of `x` into the "then"
   * branch.
   */
  predicate isSanitizerGuard(raw::TaintTracking::SanitizerGuardNode guard) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if the additional taint propagation step from `src` to `trg` must be taken into account
   * in the boosted query.
   */
  predicate isAdditionalTaintStep(raw::DataFlow::Node src, raw::DataFlow::Node trg) { none() }

  /**
   * EXPERIMENTAL. This API may change in the future.
   *
   * Holds if `src -> trg` should be considered as a flow edge in addition to standard data flow
   * edges in the boosted query.
   */
  predicate isAdditionalFlowStep(
    raw::DataFlow::Node src, raw::DataFlow::Node trg, raw::DataFlow::FlowLabel inlbl,
    raw::DataFlow::FlowLabel outlbl
  ) {
    none()
  }
}

// To debug the ATMConfig module, import this module by adding "import ATMConfigDebugging" to the
// top-level.
module ATMConfigDebugging {
  query predicate knownSources(ATMConfig config, raw::DataFlow::Node source) {
    config.isKnownSource(source) or config.isKnownSource(source, _)
  }

  query predicate anchorSinks(ATMConfig config, raw::DataFlow::Node sink) {
    config.isKnownSink(sink) or config.isKnownSink(sink, _)
  }
}
