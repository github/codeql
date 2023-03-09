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
import ExecTaint::PathGraph

Expr sinkAsArgumentIndirection(DataFlow::Node sink) {
  result =
    sink.asOperand()
        .(SideEffectOperand)
        .getAddressOperand()
        .getAnyDef()
        .getUnconvertedResultExpression()
}

/**
 * Holds if `fst` is a string that is used in a format or concatenation function resulting in `snd`,
 * and is *not* placed at the start of the resulting string. This indicates that the author did not
 * expect `fst` to control what program is run if the resulting string is eventually interpreted as
 * a command line, for example as an argument to `system`.
 */
predicate interestingConcatenation(DataFlow::Node fst, DataFlow::Node snd) {
  exists(FormattingFunctionCall call, int index, FormatLiteral literal |
    sinkAsArgumentIndirection(fst) = call.getConversionArgument(index) and
    snd.asDefiningArgument() = call.getOutputArgument(false) and
    literal = call.getFormat() and
    not literal.getConvSpecOffset(index) = 0 and
    literal.getConversionChar(index) = ["s", "S"]
  )
  or
  // strcat and friends
  exists(StrcatFunction strcatFunc, CallInstruction call, ReadSideEffectInstruction rse |
    call.getStaticCallTarget() = strcatFunc and
    rse.getArgumentDef() = call.getArgument(strcatFunc.getParamSrc()) and
    fst.asOperand() = rse.getSideEffectOperand() and
    snd.asInstruction().(WriteSideEffectInstruction).getDestinationAddress() =
      call.getArgument(strcatFunc.getParamDest())
  )
  or
  exists(CallInstruction call, Operator op, ReadSideEffectInstruction rse |
    call.getStaticCallTarget() = op and
    op.hasQualifiedName("std", "operator+") and
    op.getType().(UserType).hasQualifiedName("std", "basic_string") and
    call.getArgument(1) = rse.getArgumentOperand().getAnyDef() and // left operand
    fst.asOperand() = rse.getSideEffectOperand() and
    call = snd.asInstruction()
  )
}

newtype TState =
  TConcatState() or
  TExecState(DataFlow::Node fst, DataFlow::Node snd) { interestingConcatenation(fst, snd) }

class ConcatState extends TConcatState {
  string toString() { result = "ConcatState" }
}

class ExecState extends TExecState {
  DataFlow::Node fst;
  DataFlow::Node snd;

  ExecState() { this = TExecState(fst, snd) }

  DataFlow::Node getFstNode() { result = fst }

  DataFlow::Node getSndNode() { result = snd }

  /** Holds if this is a possible `ExecState` for `sink`. */
  predicate isFeasibleForSink(DataFlow::Node sink) { ExecState::hasFlow(snd, sink) }

  string toString() { result = "ExecState" }
}

/**
 * A `TaintTracking` configuration that's used to find the relevant `ExecState`s for a
 * given sink. This avoids a cartesian product between all sinks and all `ExecState`s in
 * `ExecTaintConfiguration::isSink`.
 */
module ExecStateConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(ExecState state | state.getSndNode() = source)
  }

  predicate isSink(DataFlow::Node sink) { shellCommand(sinkAsArgumentIndirection(sink), _) }

  predicate isBarrierOut(DataFlow::Node node) {
    isSink(node) // Prevent duplicates along a call chain, since `shellCommand` will include wrappers
  }
}

module ExecState = TaintTracking::Make<ExecStateConfiguration>;

module ExecTaintConfiguration implements DataFlow::StateConfigSig {
  class FlowState = TState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof FlowSource and
    state instanceof ConcatState
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    ExecStateConfiguration::isSink(sink) and
    state.(ExecState).isFeasibleForSink(sink)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    state1 instanceof ConcatState and
    state2.(ExecState).getFstNode() = node1 and
    state2.(ExecState).getSndNode() = node2
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    (
      node.asInstruction().getResultType() instanceof IntegralType
      or
      node.asInstruction().getResultType() instanceof FloatingPointType
    ) and
    state instanceof ConcatState
  }

  predicate isBarrierOut(DataFlow::Node node) {
    isSink(node, _) // Prevent duplicates along a call chain, since `shellCommand` will include wrappers
  }
}

module ExecTaint = TaintTracking::MakeWithState<ExecTaintConfiguration>;

from
  ExecTaint::PathNode sourceNode, ExecTaint::PathNode sinkNode, string taintCause, string callChain,
  DataFlow::Node concatResult
where
  ExecTaint::hasFlowPath(sourceNode, sinkNode) and
  taintCause = sourceNode.getNode().(FlowSource).getSourceType() and
  shellCommand(sinkAsArgumentIndirection(sinkNode.getNode()), callChain) and
  concatResult = sinkNode.getState().(ExecState).getSndNode()
select sinkAsArgumentIndirection(sinkNode.getNode()), sourceNode, sinkNode,
  "This argument to an OS command is derived from $@, dangerously concatenated into $@, and then passed to "
    + callChain + ".", sourceNode, "user input (" + taintCause + ")", concatResult,
  concatResult.toString()
