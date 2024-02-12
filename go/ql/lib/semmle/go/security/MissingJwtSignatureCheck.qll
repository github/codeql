/**
 * Provides a taint tracking flow for reasoning about JWT vulnerabilities.
 *
 * Note: for performance reasons, only import this file if `MissingJwtSignatureCheck::Config` or `MissingJwtSignatureCheck::Flow` are needed,
 * otherwise `MissingJwtSignatureCheckCustomizations` should be imported instead.
 */

import go

/** Provides a taint-tracking flow for reasoning about JWT vulnerabilities. */
module MissingJwtSignatureCheck {
  import MissingJwtSignatureCheckCustomizations::MissingJwtSignatureCheck

  /** Config for reasoning about JWT vulnerabilities. */
  module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source instanceof Source and
      not SafeParse::flow(source, _)
    }

    predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      any(AdditionalFlowStep s).step(nodeFrom, nodeTo)
    }
  }

  /** Tracks taint flow for reasoning about JWT vulnerabilities. */
  module Flow = TaintTracking::Global<Config>;

  private module SafeParseConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof Source }

    predicate isSink(DataFlow::Node sink) { sink = any(JwtSafeParse jwtParse).getTokenArg() }

    predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      any(AdditionalFlowStep s).step(nodeFrom, nodeTo)
    }
  }

  private module SafeParse = TaintTracking::Global<SafeParseConfig>;
}
