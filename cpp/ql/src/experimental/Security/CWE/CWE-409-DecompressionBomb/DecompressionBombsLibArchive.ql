/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/user-controlled-file-decompression-libarchive
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * The `archive_read_new` function as a Flow source
 * create a `archive` instance
 */
private class Archive_read_new extends Function {
  Archive_read_new() { this.hasGlobalName("archive_read_new") }
}

/**
 * The `archive_read_data*` functions are used in Flow Sink
 * [Examples](https://github.com/libarchive/libarchive/wiki/Examples)
 */
private class Archive_read_data_block extends Function {
  Archive_read_data_block() {
    this.hasGlobalName(["archive_read_data_block", "archive_read_data", "archive_read_data_into_fd"])
  }
}

module LibArchiveTaintConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof Archive_read_new |
      fc.getArgument(0) = source.asExpr() and
      state = "unzFile"
    )
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof Archive_read_data_block |
      fc.getArgument(1) = sink.asExpr() and
      state = "unzFile"
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(FunctionCall fc | fc.getTarget() instanceof Archive_read_data_block |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc.getArgument(1) and
      state1 = "" and
      state2 = "mz_zip_reader"
    )
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) { none() }
}

module LibArchiveTaint = TaintTracking::GlobalWithState<LibArchiveTaintConfig>;

import LibArchiveTaint::PathGraph

from LibArchiveTaint::PathNode source, LibArchiveTaint::PathNode sink
where LibArchiveTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompressiondepends on a $@.", source.getNode(),
  "potentially untrusted source"
