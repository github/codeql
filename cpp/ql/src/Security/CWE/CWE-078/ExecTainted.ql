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
import DataFlow::PathGraph

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

class ConcatState extends DataFlow::FlowState {
  ConcatState() { this = "ConcatState" }
}

class ExecState extends DataFlow::FlowState {
  DataFlow::Node fst;
  DataFlow::Node snd;

  ExecState() {
    this =
      "ExecState (" + fst.getLocation() + " | " + fst + ", " + snd.getLocation() + " | " + snd + ")" and
    interestingConcatenation(fst, snd)
  }

  DataFlow::Node getFstNode() { result = fst }

  DataFlow::Node getSndNode() { result = snd }
}

class ExecTaintConfiguration extends TaintTracking::Configuration {
  ExecTaintConfiguration() { this = "ExecTaintConfiguration" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof FlowSource and
    state instanceof ConcatState
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    shellCommand(sinkAsArgumentIndirection(sink), _) and
    state instanceof ExecState
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    state1 instanceof ConcatState and
    state2.(ExecState).getFstNode() = node1 and
    state2.(ExecState).getSndNode() = node2
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
  string taintCause, string callChain, DataFlow::Node concatResult
where
  conf.hasFlowPath(sourceNode, sinkNode) and
  taintCause = sourceNode.getNode().(FlowSource).getSourceType() and
  shellCommand(sinkAsArgumentIndirection(sinkNode.getNode()), callChain) and
  concatResult = sinkNode.getState().(ExecState).getSndNode()
select sinkAsArgumentIndirection(sinkNode.getNode()), sourceNode, sinkNode,
  "This argument to an OS command is derived from $@, dangerously concatenated into $@, and then passed to "
    + callChain, sourceNode, "user input (" + taintCause + ")", concatResult,
  concatResult.toString()
