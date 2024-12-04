/**
 * @name Uncontrolled data used in OS command
 * @description Using user-supplied data in an OS command, without
 *              neutralizing special elements, can make code vulnerable
 *              to command injection.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id cpp/command-line-injection
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import cpp
import semmle.code.cpp.security.CommandExecution
import semmle.code.cpp.security.Security
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.models.implementations.Strcat
import ExecTaint::PathGraph

/**
 * Holds if `incoming` is a string that is used in a format or concatenation function resulting
 * in `outgoing`, and is *not* placed at the start of the resulting string. This indicates that
 * the author did not expect `incoming` to control what program is run if the resulting string
 * is eventually interpreted as a command line, for example as an argument to `system`.
 */
predicate interestingConcatenation(DataFlow::Node incoming, DataFlow::Node outgoing) {
  exists(FormattingFunctionCall call, int index, FormatLiteral literal |
    incoming.asIndirectArgument() = call.getConversionArgument(index) and
    outgoing.asDefiningArgument() = call.getOutputArgument(false) and
    literal = call.getFormat() and
    not literal.getConvSpecOffset(index) = 0 and
    literal.getConversionChar(index) = ["s", "S"]
  )
  or
  // strcat and friends
  exists(StrcatFunction strcatFunc, Call call |
    call.getTarget() = strcatFunc and
    incoming.asIndirectArgument() = call.getArgument(strcatFunc.getParamSrc()) and
    outgoing.asDefiningArgument() = call.getArgument(strcatFunc.getParamDest())
  )
  or
  exists(Call call, Operator op |
    call.getTarget() = op and
    op.hasQualifiedName("std", "operator+") and
    op.getType().(UserType).hasQualifiedName("std", "basic_string") and
    incoming.asIndirectArgument() = call.getArgument(1) and // left operand
    call = outgoing.asInstruction().getUnconvertedResultExpression()
  )
}

newtype TState =
  TConcatState() or
  TExecState(DataFlow::Node incoming, DataFlow::Node outgoing) {
    interestingConcatenation(pragma[only_bind_into](incoming), pragma[only_bind_into](outgoing))
  }

class ConcatState extends TConcatState {
  string toString() { result = "ConcatState" }
}

class ExecState extends TExecState {
  DataFlow::Node incoming;
  DataFlow::Node outgoing;

  ExecState() { this = TExecState(incoming, outgoing) }

  DataFlow::Node getIncomingNode() { result = incoming }

  DataFlow::Node getOutgoingNode() { result = outgoing }

  /** Holds if this is a possible `ExecState` for `sink`. */
  predicate isFeasibleForSink(DataFlow::Node sink) { ExecState::flow(outgoing, sink) }

  string toString() { result = "ExecState" }
}

predicate isSinkImpl(DataFlow::Node sink, Expr command, string callChain) {
  command = sink.asIndirectArgument() and
  shellCommand(command, callChain)
}

predicate isBarrierImpl(DataFlow::Node node) {
  node.asExpr().getUnspecifiedType() instanceof IntegralType
  or
  node.asExpr().getUnspecifiedType() instanceof FloatingPointType
}

/**
 * A `TaintTracking` configuration that's used to find the relevant `ExecState`s for a
 * given sink. This avoids a cartesian product between all sinks and all `ExecState`s in
 * `ExecTaintConfiguration::isSink`.
 */
module ExecStateConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { any(ExecState state).getOutgoingNode() = source }

  predicate isSink(DataFlow::Node sink) { isSinkImpl(sink, _, _) }

  predicate isBarrier(DataFlow::Node node) { isBarrierImpl(node) }

  predicate isBarrierOut(DataFlow::Node node) {
    isSink(node) // Prevent duplicates along a call chain, since `shellCommand` will include wrappers
  }
}

module ExecState = TaintTracking::Global<ExecStateConfig>;

module ExecTaintConfig implements DataFlow::StateConfigSig {
  class FlowState = TState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof FlowSource and
    state instanceof ConcatState
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    ExecStateConfig::isSink(sink) and
    state.(ExecState).isFeasibleForSink(sink)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    state1 instanceof ConcatState and
    state2.(ExecState).getIncomingNode() = node1 and
    state2.(ExecState).getOutgoingNode() = node2
  }

  predicate isBarrier(DataFlow::Node node) { isBarrierImpl(node) }

  predicate isBarrierOut(DataFlow::Node node) {
    isSink(node, _) // Prevent duplicates along a call chain, since `shellCommand` will include wrappers
  }
}

module ExecTaint = TaintTracking::GlobalWithState<ExecTaintConfig>;

from
  ExecTaint::PathNode sourceNode, ExecTaint::PathNode sinkNode, string taintCause, string callChain,
  DataFlow::Node concatResult, Expr command
where
  ExecTaint::flowPath(sourceNode, sinkNode) and
  taintCause = sourceNode.getNode().(FlowSource).getSourceType() and
  isSinkImpl(sinkNode.getNode(), command, callChain) and
  concatResult = sinkNode.getState().(ExecState).getOutgoingNode()
select command, sourceNode, sinkNode,
  "This argument to an OS command is derived from $@, dangerously concatenated into $@, and then passed to "
    + callChain + ".", sourceNode, "user input (" + taintCause + ")", concatResult,
  concatResult.toString()
