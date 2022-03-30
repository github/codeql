/** Provides commonly used barriers to dataflow. */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.CFG

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
  private CfgNode checkedNode;
  // The value of the condition that results in the node being validated.
  private boolean checkedBranch;

  StringConstCompare() {
    exists(CfgNodes::ExprNodes::StringLiteralCfgNode strLitNode |
      this.getExpr() instanceof EqExpr and checkedBranch = true
      or
      this.getExpr() instanceof CaseEqExpr and checkedBranch = true
      or
      this.getExpr() instanceof NEExpr and checkedBranch = false
    |
      this.getLeftOperand() = strLitNode and this.getRightOperand() = checkedNode
      or
      this.getLeftOperand() = checkedNode and this.getRightOperand() = strLitNode
    )
  }

  override predicate checks(CfgNode expr, boolean branch) {
    expr = checkedNode and branch = checkedBranch
  }
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
  private CfgNode checkedNode;

  StringConstArrayInclusionCall() {
    exists(ArrayLiteral aLit |
      this.getExpr().getMethodName() = "include?" and
      [this.getExpr().getReceiver(), this.getExpr().getReceiver().(ConstantReadAccess).getValue()] =
        aLit
    |
      forall(Expr elem | elem = aLit.getAnElement() | elem instanceof StringLiteral) and
      this.getArgument(0) = checkedNode
    )
  }

  override predicate checks(CfgNode expr, boolean branch) { expr = checkedNode and branch = true }
}
