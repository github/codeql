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
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.ir.dataflow.TaintTracking2
import semmle.code.cpp.ir.IR
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
    call =
      snd.asInstruction()
  )
}

// TODO: maybe we can drop this?
class TaintToConcatenationConfiguration extends TaintTracking::Configuration {
  TaintToConcatenationConfiguration() { this = "TaintToConcatenationConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof FlowSource
  }

  override predicate isSink(DataFlow::Node sink) {
    interestingConcatenation(sink, _)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.asInstruction().getResultType() instanceof IntegralType
    or
    node.asInstruction().getResultType() instanceof FloatingPointType
  }
}

class ExecTaintConfiguration extends TaintTracking2::Configuration {
  ExecTaintConfiguration() { this = "ExecTaintConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    interestingConcatenation(_, source)
  }

  override predicate isSink(DataFlow::Node sink) {
    shellCommand(sinkAsArgumentIndirection(sink), _)
  }

  override predicate isSanitizerOut(DataFlow::Node node) {
    isSink(node) // Prevent duplicates along a call chain, since `shellCommand` will include wrappers
  }
}

from
  DataFlow::PathNode sourceNode, DataFlow::PathNode concatSink, DataFlow2::PathNode concatSource, DataFlow2::PathNode sinkNode, string taintCause, string callChain,
  TaintToConcatenationConfiguration conf1, ExecTaintConfiguration conf2
where
  taintCause = sourceNode.getNode().(FlowSource).getSourceType() and
  conf1.hasFlowPath(sourceNode, concatSink) and // TODO: can we link these better?
  interestingConcatenation(concatSink.getNode(), concatSource.getNode()) and
  conf2.hasFlowPath(concatSource, sinkNode) and
  shellCommand(sinkAsArgumentIndirection(sinkNode.getNode()), callChain)
select sinkAsArgumentIndirection(sinkNode.getNode()), sourceNode, sinkNode,
  "This argument to an OS command is derived from $@, dangerously concatenated into $@, and then passed to " + callChain, sourceNode,
  "user input (" + taintCause + ")", concatSource, concatSource.toString()
  