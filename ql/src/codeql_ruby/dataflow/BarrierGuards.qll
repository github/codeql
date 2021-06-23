/** Provides commonly used barriers to dataflow. */

private import ruby
private import codeql_ruby.DataFlow
private import codeql_ruby.CFG

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
class StringConstCompare extends DataFlow::BarrierGuard,
  CfgNodes::ExprNodes::ComparisonOperationCfgNode {
  private CfgNode checked_node;

  StringConstCompare() {
    exists(CfgNodes::ExprNodes::StringLiteralCfgNode str_lit_node |
      this.getExpr() instanceof EqExpr or
      this.getExpr() instanceof CaseEqExpr
    |
      this.operands(str_lit_node, checked_node)
      or
      this.operands(checked_node, str_lit_node)
    )
  }

  override DataFlow::Node getAGuardedNode() { result.asExpr() = checked_node }
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
//
class StringConstArrayInclusionCall extends DataFlow::BarrierGuard,
  CfgNodes::ExprNodes::MethodCallCfgNode {
  private CfgNode checked_node;

  StringConstArrayInclusionCall() {
    exists(ArrayLiteral a_lit, MethodCall include_call |
      include_call = this.getExpr() and
      include_call.getMethodName() = "include?" and
      include_call.getReceiver() = a_lit
    |
      forall(Expr elem | elem = a_lit.getAnElement() | elem instanceof StringLiteral) and
      include_call.getArgument(0) = checked_node.getNode() and
      checked_node.getBasicBlock().dominates(this.getBasicBlock())
    )
  }

  override DataFlow::Node getAGuardedNode() { result.asExpr() = checked_node }
}
