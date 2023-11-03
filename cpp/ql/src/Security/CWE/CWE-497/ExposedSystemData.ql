/**
 * @name Exposure of system data to an unauthorized control sphere
 * @description Exposing system data or debugging information helps
 *              a malicious user learn about the system and form an
 *              attack plan.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision high
 * @id cpp/system-data-exposure
 * @tags security
 *       external/cwe/cwe-497
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.models.interfaces.FlowSource
import semmle.code.cpp.models.implementations.Memset
import ExposedSystemData::PathGraph
import SystemData

module ExposedSystemDataConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source = any(SystemData sd).getAnExpr() }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc, FunctionInput input, int arg |
      fc.getTarget().(RemoteFlowSinkFunction).hasRemoteFlowSink(input, _) and
      input.isParameterDeref(arg) and
      fc.getArgument(arg).getAChild*() = sink.asIndirectExpr()
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node.asIndirectArgument() = any(MemsetFunction func).getACallToThisFunction().getAnArgument()
  }
}

module ExposedSystemData = TaintTracking::Global<ExposedSystemDataConfig>;

from ExposedSystemData::PathNode source, ExposedSystemData::PathNode sink
where ExposedSystemData::flowPath(source, sink)
select sink, source, sink, "This operation exposes system data from $@.", source,
  source.getNode().toString()
