/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/user-controlled-file-decompression-bzip2
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.commons.File

/**
 * A `bz_stream` Variable as a Flow source
 */
private class BzStreamVar extends VariableAccess {
  BzStreamVar() { this.getType().hasName("bz_stream") }
}

/**
 * A `BZFILE` Variable as a Flow source
 */
private class BZFILEVar extends VariableAccess {
  BZFILEVar() { this.getType().hasName("BZFILE") }
}

/**
 * The `BZ2_bzopen`,`BZ2_bzdopen` functions as a Flow source
 */
private class BZ2BzopenFunction extends Function {
  BZ2BzopenFunction() { this.hasGlobalName(["BZ2_bzopen", "BZ2_bzdopen"]) }
}

/**
 * The `BZ2_bzDecompress` function as a Flow source
 */
private class BZ2BzDecompressFunction extends Function {
  BZ2BzDecompressFunction() { this.hasGlobalName(["BZ2_bzDecompress"]) }
}

/**
 * The `BZ2_bzReadOpen` function
 */
private class BZ2BzReadOpenFunction extends Function {
  BZ2BzReadOpenFunction() { this.hasGlobalName(["BZ2_bzReadOpen"]) }
}

/**
 * The `BZ2_bzRead` function is used in Flow sink
 */
private class BZ2BzReadFunction extends Function {
  BZ2BzReadFunction() { this.hasGlobalName("BZ2_bzRead") }
}

/**
 * The `BZ2_bzRead` function is used in Flow sink
 */
private class BZ2BzBuffToBuffDecompressFunction extends Function {
  BZ2BzBuffToBuffDecompressFunction() { this.hasGlobalName("BZ2_bzBuffToBuffDecompress") }
}

/**
 * https://www.sourceware.org/bzip2/manual/manual.html
 */
module Bzip2TaintConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.asExpr() instanceof BzStreamVar and
    state = ""
    or
    source.asExpr() instanceof BZFILEVar and
    state = ""
    or
    // will flow into BZ2BzReadOpenFunction
    exists(FunctionCall fc | fopenCall(fc) |
      fc = source.asExpr() and
      state = ""
    )
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof BZ2BzDecompressFunction |
      fc.getArgument(0) = sink.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof BZ2BzReadFunction |
      fc.getArgument(1) = sink.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof BZ2BzBuffToBuffDecompressFunction |
      fc.getArgument(2) = sink.asExpr() and
      state = ""
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(FunctionCall fc | fc.getTarget() instanceof BZ2BzReadOpenFunction |
      node1.asExpr() = fc.getArgument(1) and
      node2.asExpr() = fc and
      state1 = "" and
      state2 = ""
    )
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) { none() }
}

module Bzip2Taint = TaintTracking::GlobalWithState<Bzip2TaintConfig>;

import Bzip2Taint::PathGraph

from Bzip2Taint::PathNode source, Bzip2Taint::PathNode sink
where Bzip2Taint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompressiondepends on a $@.", source.getNode(),
  "potentially untrusted source"
