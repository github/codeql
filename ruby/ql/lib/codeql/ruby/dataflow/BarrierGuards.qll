/** Provides commonly used barriers to dataflow. */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.CFG
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.dataflow.SSA
private import codeql.ruby.ast.internal.Constant
private import codeql.ruby.InclusionTests
private import codeql.ruby.ast.internal.Literal

cached
private predicate stringConstCompare(CfgNodes::AstCfgNode guard, CfgNode testedNode, boolean branch) {
  exists(CfgNodes::ExprNodes::ComparisonOperationCfgNode c |
    c = guard and
    exists(ExprCfgNode strNode |
      strNode.getConstantValue().isStringlikeValue(_) and
      (
        c.getExpr() instanceof EqExpr and
        branch = true
        or
        c.getExpr() instanceof CaseEqExpr and branch = true
        or
        c.getExpr() instanceof NEExpr and branch = false
      )
    |
      c.getLeftOperand() = strNode and c.getRightOperand() = testedNode
      or
      c.getLeftOperand() = testedNode and c.getRightOperand() = strNode
    )
  )
  or
  stringConstCaseCompare(guard, testedNode, branch)
  or
  exists(CfgNodes::ExprNodes::BinaryOperationCfgNode g |
    g = guard and
    stringConstCompareOr(guard, branch) and
    stringConstCompare(g.getLeftOperand(), testedNode, _)
  )
}

/**
 * Holds if `guard` is an `or` expression whose operands are string comparison guards.
 * For example:
 *
 * ```rb
 * x == "foo" or x == "bar"
 * ```
 */
private predicate stringConstCompareOr(
  CfgNodes::ExprNodes::BinaryOperationCfgNode guard, boolean branch
) {
  guard.getExpr() instanceof LogicalOrExpr and
  branch = true and
  forall(CfgNode innerGuard | innerGuard = guard.getAnOperand() |
    stringConstCompare(innerGuard, any(Ssa::Definition def).getARead(), branch)
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

cached
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
        elem.getConstantValue().isStringlikeValue(_)
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
 * A validation of a value by comparing with a constant string via a `case`
 * expression. For example:
 *
 * ```rb
 * name = params[:user_name]
 * case name
 * when "alice"
 *   User.find_by("username = #{name}")
 * when *["bob", "charlie"]
 *   User.find_by("username = #{name}")
 * when "dave", "eve" # this is not yet recognised as a barrier guard
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
    (
      guard =
        any(CfgNodes::ExprNodes::WhenClauseCfgNode branchNode |
          branchNode = case.getBranch(_) and
          // For simplicity, consider patterns that contain only string literals, string-valued variables, or arrays of the same.
          forall(ExprCfgNode pattern | pattern = branchNode.getPattern(_) |
            // foo = "foo"
            //
            // when foo
            // when foo, bar
            // when "foo"
            // when "foo", "bar"
            pattern.getConstantValue().isStringlikeValue(_)
            or
            pattern =
              any(CfgNodes::ExprNodes::SplatExprCfgNode splat |
                // when *["foo", "bar"]
                forex(ExprCfgNode elem |
                  elem = splat.getOperand().(ExprNodes::ArrayLiteralCfgNode).getAnArgument()
                |
                  elem.getConstantValue().isStringlikeValue(_)
                )
                or
                // when *some_var
                // when *SOME_CONST
                exists(ExprNodes::ArrayLiteralCfgNode arr |
                  isArrayConstant(splat.getOperand(), arr) and
                  forall(ExprCfgNode elem | elem = arr.getAnArgument() |
                    elem.getConstantValue().isStringlikeValue(_)
                  )
                )
              )
          )
        )
      or
      // foo = "foo"
      //
      // in foo
      // in "foo"
      exists(CfgNodes::ExprNodes::InClauseCfgNode branchNode, ExprCfgNode pattern |
        branchNode = case.getBranch(_) and
        pattern = branchNode.getPattern() and
        pattern.getConstantValue().isStringlikeValue(_) and
        guard = pattern
      )
    )
  )
}
