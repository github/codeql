/**
 * Provides a taint tracking configuration for reasoning about decompression bomb vulnerabilities.
 */

import go

/** Provides a taint tracking configuration for reasoning about decompression bomb vulnerabilities. */
module DecompressionBomb {
  import experimental.frameworks.DecompressionBombsCustomizations

  module Config implements DataFlow::StateConfigSig {
    class FlowState = DecompressionBombs::FlowState;

    predicate isSource(DataFlow::Node source, FlowState state) {
      source instanceof RemoteFlowSource and
      state = ""
    }

    predicate isSink(DataFlow::Node sink, FlowState state) {
      sink instanceof DecompressionBombs::Sink and
      state =
        [
          "ZstdNewReader", "XzNewReader", "GzipNewReader", "PgzipNewReader", "S2NewReader",
          "SnappyNewReader", "ZlibNewReader", "FlateNewReader", "Bzip2NewReader", "ZipOpenReader",
          "ZipKlauspost"
        ]
    }

    predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
      exists(DecompressionBombs::AdditionalTaintStep addStep |
        addStep.isAdditionalFlowStep(fromNode, toNode)
      )
    }

    predicate isAdditionalFlowStep(
      DataFlow::Node fromNode, FlowState fromState, DataFlow::Node toNode, FlowState toState
    ) {
      exists(DecompressionBombs::AdditionalTaintStep addStep |
        addStep.isAdditionalFlowStep(fromNode, fromState, toNode, toState)
      )
    }
  }

  /** Tracks taint flow for reasoning about decompression bomb vulnerabilities. */
  module Flow = TaintTracking::GlobalWithState<Config>;
}
