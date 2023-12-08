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
        "ZstdNewReader", "XzNewReader", "GzipNewReader", "S2NewReader", "SnappyNewReader",
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
    // `io.CopyN` should not be a sink if its return value flows to a
    // comparison (<, >, <=, >=).
    exists(Function f, DataFlow::CallNode cn |
      f.hasQualifiedName("io", "CopyN") and cn = f.getACall()
    |
      node = cn.getArgument(1) and
      localStep*(cn.getResult(0), any(DataFlow::RelationalComparisonNode rcn).getAnOperand())
    )
  }
}

/**
 * Holds if the value of `pred` can flow into `succ` in one step through an
 * arithmetic operation (other than remainder).
 *
 * Note: this predicate is copied from AllocationSizeOverflow. When this query
 * is promoted it should be put in a shared location.
 */
predicate additionalStep(DataFlow::Node pred, DataFlow::Node succ) {
  succ.asExpr().(ArithmeticExpr).getAnOperand() = pred.asExpr() and
  not succ.asExpr() instanceof RemExpr
}

/**
 * Holds if the value of `pred` can flow into `succ` in one step, either by a standard taint step
 * or by an additional step.
 *
 * Note: this predicate is copied from AllocationSizeOverflow. When this query
 * is promoted it should be put in a shared location.
 */
predicate localStep(DataFlow::Node pred, DataFlow::Node succ) {
  TaintTracking::localTaintStep(pred, succ) or
  additionalStep(pred, succ)
}

module DecompressionBombsFlow = TaintTracking::GlobalWithState<DecompressionBombsConfig>;

import DecompressionBombsFlow::PathGraph

from DecompressionBombsFlow::PathNode source, DecompressionBombsFlow::PathNode sink
where DecompressionBombsFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This decompression is $@.", source.getNode(),
  "decompressing compressed data without managing output size"
