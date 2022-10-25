/** Provides commonly used barriers to dataflow. */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.CFG
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.dataflow.SSA
private import codeql.ruby.ast.internal.Constant
private import codeql.ruby.InclusionTests

private predicate stringConstCompare(CfgNodes::AstCfgNode guard, CfgNode testedNode, boolean branch) {
  exists(CfgNodes::ExprNodes::ComparisonOperationCfgNode c |
    c = guard and
    exists(CfgNodes::ExprNodes::StringLiteralCfgNode strLitNode |
      c.getExpr() instanceof EqExpr and branch = true
      or
      c.getExpr() instanceof CaseEqExpr and branch = true
      or
      c.getExpr() instanceof NEExpr and branch = false
    |
      c.getLeftOperand() = strLitNode and c.getRightOperand() = testedNode
      or
      c.getLeftOperand() = testedNode and c.getRightOperand() = strLitNode
    )
  )
  or
  stringConstCaseCompare(guard, testedNode, branch)
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

private predicate stringConstArrayInclusionCall(
  CfgNodes::AstCfgNode guard, CfgNode testedNode, boolean branch
) {
  exists(InclusionTest t |
    t.asExpr() = guard and
    testedNode = t.getContainedNode().asExpr() and
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

/**
 * A validation of a value by comparing with a constant string via a `case`
 * expression. For example:
 *
 * ```rb
 * name = params[:user_name]
 * case name
 * when "alice"
 *   User.find_by("username = #{name}")
 * end
 * ```
 */
private predicate stringConstCaseCompare(
  CfgNodes::AstCfgNode guard, CfgNode testedNode, boolean branch
) {
  branch = true and
  exists(CfgNodes::ExprNodes::CaseExprCfgNode case |
    case.getValue() = testedNode and
    exists(CfgNodes::ExprNodes::WhenClauseCfgNode branchNode |
      branchNode = case.getBranch(_) and
      guard = branchNode.getPattern(_) and
      // For simplicity, consider patterns that contain only string literals or arrays of string literals
      forall(ExprCfgNode pattern | pattern = branchNode.getPattern(_) |
        // when "foo"
        // when "foo", "bar"
        pattern instanceof ExprNodes::StringLiteralCfgNode
        or
        // array literals behave weirdly in the CFG so we need to drop down to the AST level for this bit
        // specifically: `SplatExprCfgNode.getOperand()` does not return results for array literals
        exists(CfgNodes::ExprNodes::SplatExprCfgNode splat | splat = pattern |
          // when *["foo", "bar"]
          exists(ArrayLiteral arr |
            splat.getExpr().getOperand() = arr and
            forall(Expr elem | elem = arr.getAnElement() | elem instanceof StringLiteral)
          )
          or
          // when *some_var
          // when *SOME_CONST
          exists(ExprNodes::ArrayLiteralCfgNode arr |
            isArrayConstant(splat.getOperand(), arr) and
            forall(ExprCfgNode elem | elem = arr.getAnArgument() |
              elem instanceof ExprNodes::StringLiteralCfgNode
            )
          )
        )
      )
    )
  )
}
