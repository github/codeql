/**
 * @name Denial of Service using unconstrained integer/float value
 * @description A remote user-controlled integer/float value can reach a condition that controls how many times a repeatable operation can be executed. A malicious user may misuse that value to cause an application-level denial of service.
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

/**
 * Ensure that the user-provided value is limited to a certain amount
 *
 * @param node The node to check if limited by:
 * 1. A comparison operation node with a less than or less than or equal operator
 * 2. A comparison operation node with a greater than or greater than or equal operator
 * 3. A comparison operation node with a greater than or greater than or equal operator and the branch is false
 * 4. A comparison operation node with a less than or less than or equal operator and the branch is false
 */
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
    )
  )
}

/**
 * Sidekiq ensure using the `params` function that all keys in the resulting hash are strings and ingest `request.params`. So a call to `params` function is considered as a remote flow source.
 *
 * https://github.com/sidekiq/sidekiq/blob/79d254d9045bb5805beed6aaffec1886ef89f71b/lib/sidekiq/web/action.rb#L30-L37
 */
class ParamsRFS extends RemoteFlowSource::Range {
  ParamsRFS() {
    exists(ElementReference er, MethodCall mc |
      er.getReceiver() = mc and
      mc.getMethodName() = "params" and
      this.asExpr() = er.getAControlFlowNode()
    )
  }

  override string getSourceType() { result = "Request params data" }
}

private module DoSConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    //source instanceof ParamsRFS or
    source instanceof RemoteFlowSource
  }

  predicate isBarrier(DataFlow::Node sanitizer) {
    // Sanitize the user-provided value if limited (underAValue check)
    sanitizer = DataFlow::BarrierGuard<underAValue/3>::getABarrierNode()
  }

  /**
   * Support additional flow step for a case like using a default value `(params["days"] | 100).to_i`
   */
  predicate isAdditionalFlowStep(DataFlow::Node previousNode, DataFlow::Node nextNode) {
    // Additional flow step like `(RFS | INTEGER).to_i` or `(FLOAT | RFS).to_f`
    exists(ParenthesizedExpr loe, DataFlow::CallNode c, ExprNode en |
      en = c.getReceiver() and
      c.getMethodName() = ["to_i", "to_f"] and
      c = nextNode and
      loe = en.asExpr().getExpr() and
      loe.getStmt(_).(LogicalOrExpr).getAnOperand() = previousNode.asExpr().getExpr() and
      not previousNode.asExpr().getExpr() instanceof IntegerLiteral
    )
    or
    // Additional flow step like `RFS.to_i` or `RFS.to_f`
    exists(MethodCall mc |
      mc.getReceiver() = previousNode.asExpr().getExpr() and
      mc.getMethodName() = ["to_i", "to_f"] and
      mc = nextNode.asExpr().getExpr()
    )
  }

  /**
   * - Check if the user-provided value is used in a repeatable operation using `downto`, `upto` or `times`
   * - Check if the user-provided value is used in a repeatable operation using `for` loop or conditional loop like `until` or `while`.
   */
  predicate isSink(DataFlow::Node sink) {
    // sink = n in `100.downto(n)` or `1.upto(n)`
    exists(MethodCall mc |
      sink.asExpr().getExpr() = mc.getArgument(0) and
      mc.getMethodName() = ["downto", "upto"]
    )
    or
    // sink = n in `n.times()` or `n.downto(1)` or `n.upto(100)`
    exists(MethodCall mc |
      sink.asExpr().getExpr() = mc.getReceiver() and
      mc.getMethodName() = ["times", "downto", "upto"]
    )
    or
    // sink = 1..n in `for i in 0..n`
    exists(ForExpr forLoop | sink.asExpr().getExpr() = forLoop.getValue())
    or
    // sink = n in `until n`
    exists(ConditionalLoop conditionalLoop |
      sink.asExpr().getExpr() = conditionalLoop.getCondition()
    )
  }
}

module DoSFlow = TaintTracking::Global<DoSConfig>;

import DoSFlow::PathGraph

from DoSFlow::PathNode source, DoSFlow::PathNode sink
where DoSFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This $@ can control $@ a repeatable operation is executed.",
  source.getNode(), "user-provided value", sink.getNode(), "how many times"
