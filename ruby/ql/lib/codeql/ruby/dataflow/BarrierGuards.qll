/** Provides commonly used barriers to dataflow. */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.CFG
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.dataflow.SSA
private import codeql.ruby.ast.internal.Constant
private import codeql.ruby.InclusionTests

private predicate stringConstCompare(CfgNodes::ExprCfgNode g, CfgNode e, boolean branch) {
  exists(CfgNodes::ExprNodes::ComparisonOperationCfgNode c |
    c = g and
    exists(CfgNodes::ExprNodes::StringLiteralCfgNode strLitNode |
      c.getExpr() instanceof EqExpr and branch = true
      or
      c.getExpr() instanceof CaseEqExpr and branch = true
      or
      c.getExpr() instanceof NEExpr and branch = false
    |
      c.getLeftOperand() = strLitNode and c.getRightOperand() = e
      or
      c.getLeftOperand() = e and c.getRightOperand() = strLitNode
    )
  )
}

/**
 * A validation of value by comparing with a constant string value, for example
 * in:
 *
 * ```rb
 * dir = params[:order]
 * dir = "DESC" unless dir == "ASC"
 * User.order("name #{dir}")
 * ```
 *
 * the equality operation guards against `dir` taking arbitrary values when used
 * in the `order` call.
 */
class StringConstCompareBarrier extends DataFlow::Node {
  StringConstCompareBarrier() {
    this = DataFlow::BarrierGuard<stringConstCompare/3>::getABarrierNode()
  }
}

/**
 * DEPRECATED: Use `StringConstCompareBarrier` instead.
 *
 * A validation of value by comparing with a constant string value, for example
 * in:
 *
 * ```rb
 * dir = params[:order]
 * dir = "DESC" unless dir == "ASC"
 * User.order("name #{dir}")
 * ```
 *
 * the equality operation guards against `dir` taking arbitrary values when used
 * in the `order` call.
 */
deprecated class StringConstCompare extends DataFlow::BarrierGuard,
  CfgNodes::ExprNodes::ComparisonOperationCfgNode {
  private CfgNode checkedNode;
  // The value of the condition that results in the node being validated.
  private boolean checkedBranch;

  StringConstCompare() { stringConstCompare(this, checkedNode, checkedBranch) }

  override predicate checks(CfgNode expr, boolean branch) {
    expr = checkedNode and branch = checkedBranch
  }
}

private predicate stringConstArrayInclusionCall(CfgNodes::ExprCfgNode g, CfgNode e, boolean branch) {
  exists(InclusionTest t |
    t.asExpr() = g and
    e = t.getContainedNode().asExpr() and
    branch = t.getPolarity()
  |
    exists(ExprNodes::ArrayLiteralCfgNode arr |
      isArrayConstant(t.getContainerNode().asExpr(), arr)
    |
      forall(ExprCfgNode elem | elem = arr.getAnArgument() |
        elem instanceof ExprNodes::StringLiteralCfgNode
      )
    )
  )
}

/**
 * A validation of a value by checking for inclusion in an array of string
 * literal values, for example in:
 *
 * ```rb
 * name = params[:user_name]
 * if %w(alice bob charlie).include? name
 *   User.find_by("username = #{name}")
 * end
 * ```
 *
 * the `include?` call guards against `name` taking arbitrary values when used
 * in the `find_by` call.
 */
class StringConstArrayInclusionCallBarrier extends DataFlow::Node {
  StringConstArrayInclusionCallBarrier() {
    this = DataFlow::BarrierGuard<stringConstArrayInclusionCall/3>::getABarrierNode()
  }
}

/**
 * DEPRECATED: Use `StringConstArrayInclusionCallBarrier` instead.
 *
 * A validation of a value by checking for inclusion in an array of string
 * literal values, for example in:
 *
 * ```rb
 * name = params[:user_name]
 * if %w(alice bob charlie).include? name
 *   User.find_by("username = #{name}")
 * end
 * ```
 *
 * the `include?` call guards against `name` taking arbitrary values when used
 * in the `find_by` call.
 */
deprecated class StringConstArrayInclusionCall extends DataFlow::BarrierGuard,
  CfgNodes::ExprNodes::MethodCallCfgNode {
  private CfgNode checkedNode;

  StringConstArrayInclusionCall() { stringConstArrayInclusionCall(this, checkedNode, true) }

  override predicate checks(CfgNode expr, boolean branch) { expr = checkedNode and branch = true }
}
