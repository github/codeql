/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/user-controlled-file-decompression-minizip
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * A `unzFile` Variable as a Flow source
 */
private class UnzFileVar extends VariableAccess {
  UnzFileVar() { this.getType().hasName("unzFile") }
}

/**
 * The `UnzOpen` function as a Flow source
 */
private class UnzOpenFunction extends Function {
  UnzOpenFunction() { this.hasGlobalName(["UnzOpen", "unzOpen64", "unzOpen2", "unzOpen2_64"]) }
}

/**
 * The `mz_stream_open` function is used in Flow source
 */
private class MzStreamOpenFunction extends Function {
  MzStreamOpenFunction() { this.hasGlobalName("mz_stream_open") }
}

/**
 * The `unzReadCurrentFile` function is used in Flow sink
 */
private class UnzReadCurrentFileFunction extends Function {
  UnzReadCurrentFileFunction() { this.hasGlobalName(["unzReadCurrentFile"]) }
}

module MiniZipTaintConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof UnzOpenFunction |
      fc.getArgument(0) = source.asExpr() and
      state = "unzFile"
    )
    or
    source.asExpr() instanceof UnzFileVar and
    state = "unzFile"
    or
    // TO Check
    exists(FunctionCall fc | fc.getTarget() instanceof MzStreamOpenFunction |
      fc.getArgument(0).getEnclosingVariable() = source.asVariable() and
      state = "MzStream"
    )
    or
    // TO Check
    exists(FunctionCall fc | fc.getTarget() instanceof MzStreamOpenFunction |
      fc.getArgument(0).getEnclosingVariable() = source.asVariable() and
      state = "MzStream"
    )
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof UnzReadCurrentFileFunction |
      fc.getArgument(0) = sink.asExpr() and
      state = "unzFile"
      // and not sanitizer(fc)
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(FunctionCall fc | fc.getTarget() instanceof UnzOpenFunction |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc and
      state1 = "" and
      state2 = "unzFile"
    )
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) { none() }
}


module MiniZipTaint = TaintTracking::GlobalWithState<MiniZipTaintConfig>;

import MiniZipTaint::PathGraph

from MiniZipTaint::PathNode source, MiniZipTaint::PathNode sink
where MiniZipTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompressiondepends on a $@.", source.getNode(),
  "potentially untrusted source"
