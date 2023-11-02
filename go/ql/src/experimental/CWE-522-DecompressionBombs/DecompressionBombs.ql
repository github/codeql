/**
 * @name Uncontrolled file decompression
 * @description Uncontrolled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id go/uncontrolled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import go
import semmle.go.dataflow.Properties
import MultipartAndFormRemoteSource
import experimental.frameworks.DecompressionBombs

module DecompressionBombsConfig implements DataFlow::StateConfigSig {
  class FlowState = DecompressionBombs::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof UntrustedFlowSource and
    state = ""
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof DecompressionBombs::Sink and
    state =
      [
        "ZstdNewReader", "XzNewReader", "GzipNewReader", "S2NewReader", "SnapyNewReader",
        "ZlibNewReader", "FlateNewReader", "Bzip2NewReader", "ZipOpenReader", "ZipKlauspost"
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

  predicate isBarrier(DataFlow::Node node) {
    // here I want to the CopyN return value be compared with < or > but I can't reach the tainted result
    exists(Function f | f.hasQualifiedName("io", "CopyN") |
      node = f.getACall().getArgument(1) and
      TaintTracking::localExprTaint(f.getACall().getResult(0).asExpr(),
        // only >=, <=,>,<
        any(RelationalComparisonExpr rce).getAnOperand())
    )
  }
}

module DecompressionBombsFlow = TaintTracking::GlobalWithState<DecompressionBombsConfig>;

import DecompressionBombsFlow::PathGraph

from DecompressionBombsFlow::PathNode source, DecompressionBombsFlow::PathNode sink
where DecompressionBombsFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This decompression is $@.", source.getNode(),
  "decompressing compressed data without managing output size"
