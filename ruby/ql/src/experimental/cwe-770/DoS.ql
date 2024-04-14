/**
 * @name Denial of Service using huge value
 * @description A remote user-controlled data value can reach a limit of a repeatable operation which a malicious user may misuse to cause a denial of service.
 * @kind path-problem
 * @id rb/dos
 * @precision high
 * @problem.severity error
 * @tags security
 *       experimental
 *       external/cwe/cwe-770
 */

import ruby
import codeql.ruby.ApiGraphs
import codeql.ruby.Concepts
import codeql.ruby.TaintTracking
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.dataflow.BarrierGuards
import codeql.ruby.AST
import codeql.ruby.controlflow.CfgNodes as CfgNodes
import codeql.ruby.CFG
import codeql.ruby.dataflow.internal.DataFlowPublic
import codeql.ruby.InclusionTests

predicate inclusionCheck(CfgNodes::AstCfgNode g, CfgNode node, boolean branch) {
  exists(InclusionTest t | t.asExpr() = g | node = t.getContainedNode().asExpr() and branch = t.getPolarity()) 
}

predicate underAValue(CfgNodes::AstCfgNode g, CfgNode node, boolean branch) {
  exists(CfgNodes::ExprNodes::ComparisonOperationCfgNode cn | cn = g |
    exists(string op |
      (
        // arg <= LIMIT OR arg < LIMIT
        (op = "<" or op = "<=") and
        branch = true and
        op = cn.getOperator() and
        node = cn.getLeftOperand()
        or
        // LIMIT >= arg OR LIMIT > arg
        (op = ">" or op = ">=") and
        branch = true and
        op = cn.getOperator() and
        node = cn.getRightOperand()
        or
        // not arg >= LIMIT OR not arg > LIMIT
        (op = ">" or op = ">=") and
        branch = false and
        op = cn.getOperator() and
        node = cn.getLeftOperand()
        or
        // not LIMIT <= arg OR not LIMIT < argo
        (op = "<" or op = "<=") and
        branch = false and
        op = cn.getOperator() and
        node = cn.getRightOperand()
      )
      //|
      //lenCall = API::builtin("len").getACall() and
      //node = lenCall.getArg(0).asCfgNode()
    ) //and
    //not cn.getLocation().getFile().inStdlib()
  )
}

private module DoSConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isBarrier(DataFlow::Node sanitizer) {
    // underAValue is a check to ensure that the length of the user-provided value is limited to a certain amount
    sanitizer = DataFlow::BarrierGuard<underAValue/3>::getABarrierNode()
    or
    sanitizer = DataFlow::BarrierGuard<inclusionCheck/3>::getABarrierNode()
  }

  /**
   * next_node = (previous_node || 30).to_i
   */
  predicate isAdditionalFlowStep(DataFlow::Node previousNode, DataFlow::Node nextNode) {
    exists(ParenthesizedExpr loe, DataFlow::CallNode c, ExprNode en |
      en = c.getReceiver() and
      c.getMethodName() = ["to_i","to_f"] and
      c = nextNode and
      loe = en.asExpr().getExpr() and
      loe.getStmt(_).(LogicalOrExpr).getAnOperand() = previousNode.asExpr().getExpr() and
      not previousNode.asExpr().getExpr() instanceof IntegerLiteral
    ) //and
    //previousNode.getLocation().getFile().getAbsolutePath().matches("%application.rb")
    or
    exists(MethodCall mc |
      mc.getReceiver() = previousNode.asExpr().getExpr() and
      mc.getMethodName() = ["to_i", "to_f"] and
      mc = nextNode.asExpr().getExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      sink.asExpr().getExpr() = mc.getArgument(0) and
      mc.getMethodName() = ["downto", "upto"]
    )
    or
    exists(MethodCall mc |
      sink.asExpr().getExpr() = mc.getReceiver() and
      mc.getMethodName() = ["times", "downto", "upto"]
    )
    or
    exists(ForExpr forLoop | sink.asExpr().getExpr() = forLoop.getValue())
    or
    exists(ConditionalLoop conditionalLoop |
      sink.asExpr().getExpr() = conditionalLoop.getCondition()
    )
  }
}

module DoSFlow = TaintTracking::Global<DoSConfig>;

import DoSFlow::PathGraph

from DoSFlow::PathNode source, DoSFlow::PathNode sink
where DoSFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This $@ can control $@ a repeatable operation is executed.", source.getNode(),
  "user-provided value", sink.getNode(), "how many times"
