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
import semmle.code.cpp.ir.dataflow.TaintTracking2
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.models.implementations.Strcat
import DataFlow::PathGraph

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

class ConcatState extends DataFlow::FlowState {
  ConcatState() { this = "ConcatState" }
}

class ExecState extends DataFlow::FlowState {
  DataFlow::Node incoming;
  DataFlow::Node outgoing;

  ExecState() {
    this =
      "ExecState (" + incoming.getLocation() + " | " + incoming + ", " + outgoing.getLocation() +
        " | " + outgoing + ")" and
    interestingConcatenation(pragma[only_bind_into](incoming), pragma[only_bind_into](outgoing))
  }

  DataFlow::Node getIncomingNode() { result = incoming }

  DataFlow::Node getOutgoingNode() { result = outgoing }

  /** Holds if this is a possible `ExecState` for `sink`. */
  predicate isFeasibleForSink(DataFlow::Node sink) {
    any(ExecStateConfiguration conf).hasFlow(outgoing, sink)
  }
}

predicate isSinkImpl(DataFlow::Node sink, Expr command, string callChain) {
  command = sink.asIndirectArgument() and
  shellCommand(command, callChain)
}

/**
 * A `TaintTracking` configuration that's used to find the relevant `ExecState`s for a
 * given sink. This avoids a cartesian product between all sinks and all `ExecState`s in
 * `ExecTaintConfiguration::isSink`.
 */
class ExecStateConfiguration extends TaintTracking2::Configuration {
  ExecStateConfiguration() { this = "ExecStateConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    any(ExecState state).getOutgoingNode() = source
  }

  override predicate isSink(DataFlow::Node sink) { isSinkImpl(sink, _, _) }

  override predicate isSanitizerOut(DataFlow::Node node) {
    isSink(node, _) // Prevent duplicates along a call chain, since `shellCommand` will include wrappers
  }
}

class ExecTaintConfiguration extends TaintTracking::Configuration {
  ExecTaintConfiguration() { this = "ExecTaintConfiguration" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof FlowSource and
    state instanceof ConcatState
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    any(ExecStateConfiguration conf).isSink(sink) and
    state.(ExecState).isFeasibleForSink(sink)
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    state1 instanceof ConcatState and
    state2.(ExecState).getIncomingNode() = node1 and
    state2.(ExecState).getOutgoingNode() = node2
  }

  override predicate isSanitizer(DataFlow::Node node, DataFlow::FlowState state) {
    (
      node.asInstruction().getResultType() instanceof IntegralType
      or
      node.asInstruction().getResultType() instanceof FloatingPointType
    ) and
    state instanceof ConcatState
  }

  override predicate isSanitizerOut(DataFlow::Node node) {
    isSink(node, _) // Prevent duplicates along a call chain, since `shellCommand` will include wrappers
  }
}

from
  ExecTaintConfiguration conf, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode,
  string taintCause, string callChain, DataFlow::Node concatResult, Expr command
where
  conf.hasFlowPath(sourceNode, sinkNode) and
  taintCause = sourceNode.getNode().(FlowSource).getSourceType() and
  isSinkImpl(sinkNode.getNode(), command, callChain) and
  concatResult = sinkNode.getState().(ExecState).getOutgoingNode()
select command, sourceNode, sinkNode,
  "This argument to an OS command is derived from $@, dangerously concatenated into $@, and then passed to "
    + callChain + ".", sourceNode, "user input (" + taintCause + ")", concatResult,
  concatResult.toString()
