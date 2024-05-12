/**
 * @name User-controlled data may not be null terminated
 * @description String operations on user-controlled strings can result in
 *              buffer overflow or buffer over-read.
 * @kind problem
 * @id cpp/user-controlled-null-termination-tainted
 * @problem.severity warning
 * @security-severity 10.0
 * @tags security
 *       external/cwe/cwe-170
 */

import cpp
import semmle.code.cpp.commons.NullTermination
import semmle.code.cpp.security.FlowSources as FS
import semmle.code.cpp.dataflow.new.TaintTracking
import semmle.code.cpp.ir.IR

predicate isSource(FS::FlowSource source, string sourceType) {
  sourceType = source.getSourceType() and
  exists(VariableAccess va, Call call |
    va = source.asDefiningArgument() and
    call.getAnArgument() = va and
    va.getTarget() instanceof SemanticStackVariable and
    call.getTarget().hasGlobalName(["read", "fread", "recv", "recvfrom", "recvmsg"])
  )
}

predicate isSink(DataFlow::Node sink, VariableAccess va) {
  va = [sink.asExpr(), sink.asIndirectExpr()] and
  variableMustBeNullTerminated(va)
}

private module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isSource(source, _) }

  predicate isBarrier(DataFlow::Node node) {
    isSink(node) and node.asExpr().getUnspecifiedType() instanceof ArithmeticType
    or
    node.asInstruction().(StoreInstruction).getResultType() instanceof ArithmeticType
    or
    mayAddNullTerminator(_, node.asIndirectExpr())
  }

  predicate isSink(DataFlow::Node sink) { isSink(sink, _) }
}

module Flow = TaintTracking::Global<Config>;

from DataFlow::Node source, DataFlow::Node sink, VariableAccess va, string sourceType
where
  Flow::flow(source, sink) and
  isSource(source, sourceType) and
  isSink(sink, va)
select va, "String operation depends on $@ that may not be null terminated.", source, sourceType
