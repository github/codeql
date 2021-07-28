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

// TODO: maybe we can drop this?
class TaintToConcatenationConfiguration extends TaintTracking::Configuration {
  TaintToConcatenationConfiguration() { this = "TaintToConcatenationConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  override predicate isSink(DataFlow::Node sink) { interestingConcatenation(sink, _) }

  override predicate isSanitizer(DataFlow::Node node) {
    node.asInstruction().getResultType() instanceof IntegralType
    or
    node.asInstruction().getResultType() instanceof FloatingPointType
  }
}

class ExecTaintConfiguration extends TaintTracking2::Configuration {
  ExecTaintConfiguration() { this = "ExecTaintConfiguration" }

  override predicate isSource(DataFlow::Node source) { interestingConcatenation(_, source) }

  override predicate isSink(DataFlow::Node sink) {
    shellCommand(sinkAsArgumentIndirection(sink), _)
  }

  override predicate isSanitizerOut(DataFlow::Node node) {
    isSink(node) // Prevent duplicates along a call chain, since `shellCommand` will include wrappers
  }
}

module StitchedPathGraph {
  // There's a different PathNode class for each DataFlowImplN.qll, so we can't simply combine the
  // PathGraph predicates directly. Instead, we use a newtype so there's a single type that
  // contains both sets of PathNodes.
  newtype TMergedPathNode =
    TPathNode1(DataFlow::PathNode node) or
    TPathNode2(DataFlow2::PathNode node)

  // this wraps the toString and location predicates so we can use the merged node type in a
  // selection
  class MergedPathNode extends TMergedPathNode {
    string toString() {
      exists(DataFlow::PathNode n |
        this = TPathNode1(n) and
        result = n.toString()
      )
      or
      exists(DataFlow2::PathNode n |
        this = TPathNode2(n) and
        result = n.toString()
      )
    }

    DataFlow::Node getNode() {
      exists(DataFlow::PathNode n |
        this = TPathNode1(n) and
        result = n.getNode()
      )
      or
      exists(DataFlow2::PathNode n |
        this = TPathNode2(n) and
        result = n.getNode()
      )
    }

    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      exists(DataFlow::PathNode n |
        this = TPathNode1(n) and
        n.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      )
      or
      exists(DataFlow2::PathNode n |
        this = TPathNode2(n) and
        n.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      )
    }
  }

  query predicate edges(MergedPathNode a, MergedPathNode b) {
    exists(DataFlow::PathNode an, DataFlow::PathNode bn |
      a = TPathNode1(an) and
      b = TPathNode1(bn) and
      DataFlow::PathGraph::edges(an, bn)
    )
    or
    exists(DataFlow2::PathNode an, DataFlow2::PathNode bn |
      a = TPathNode2(an) and
      b = TPathNode2(bn) and
      DataFlow2::PathGraph::edges(an, bn)
    )
    or
    // This is where paths from the two configurations are connected. `interestingConcatenation`
    // is the only thing in this module that's actually specific to the query - everything else is
    // just using types and predicates from the DataFlow library.
    interestingConcatenation(a.getNode(), b.getNode()) and
    a instanceof TPathNode1 and
    b instanceof TPathNode2
  }

  query predicate nodes(MergedPathNode mpn, string key, string val) {
    // here we just need the union of the underlying `nodes` predicates
    exists(DataFlow::PathNode n |
      mpn = TPathNode1(n) and
      DataFlow::PathGraph::nodes(n, key, val)
    )
    or
    exists(DataFlow2::PathNode n |
      mpn = TPathNode2(n) and
      DataFlow2::PathGraph::nodes(n, key, val)
    )
  }
}

import StitchedPathGraph

from
  DataFlow::PathNode sourceNode, DataFlow::PathNode concatSink, DataFlow2::PathNode concatSource,
  DataFlow2::PathNode sinkNode, string taintCause, string callChain,
  TaintToConcatenationConfiguration conf1, ExecTaintConfiguration conf2
where
  taintCause = sourceNode.getNode().(FlowSource).getSourceType() and
  conf1.hasFlowPath(sourceNode, concatSink) and
  interestingConcatenation(concatSink.getNode(), concatSource.getNode()) and // this loses call context
  conf2.hasFlowPath(concatSource, sinkNode) and
  shellCommand(sinkAsArgumentIndirection(sinkNode.getNode()), callChain)
select sinkAsArgumentIndirection(sinkNode.getNode()), TPathNode1(sourceNode).(MergedPathNode),
  TPathNode2(sinkNode).(MergedPathNode),
  "This argument to an OS command is derived from $@, dangerously concatenated into $@, and then passed to "
    + callChain, sourceNode, "user input (" + taintCause + ")", concatSource,
  concatSource.toString()
