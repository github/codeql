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
    this =
      [
        DataFlow::BarrierGuard<stringConstCompare/3>::getABarrierNode(),
        CaseBarrier::getABarrierNode()
      ]
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

/**
 * Predicates that define a barrier for string constant comparison inside case
 * expressions.
 *
 * This is a copy of the `DataFlow::BarrierGuard` parameterized module that uses
 * `whenClauseControls` instead of `ConditionBlock.controls`.
 */
module CaseBarrier {
  private import codeql.ruby.dataflow.internal.SsaImpl as SsaImpl
  private import codeql.ruby.controlflow.ControlFlowGraph::SuccessorTypes

  /** Holds if the guard `guard` controls block `bb` upon evaluating to `branch`. */
  private predicate guardControlsBlock(CfgNodes::AstCfgNode guard, BasicBlock bb, boolean branch) {
    exists(ConditionBlock conditionBlock, SuccessorTypes::ConditionalSuccessor s |
      guard = conditionBlock.getLastNode() and
      s.getValue() = branch and
      whenClauseControls(conditionBlock, bb, s)
    )
  }

  /**
   * Gets an implicit entry definition for a captured variable that
   * may be guarded, because a call to the capturing callable is guarded.
   *
   * This is restricted to calls where the variable is captured inside a
   * block.
   */
  private Ssa::Definition getAMaybeGuardedCapturedDef() {
    exists(
      CfgNodes::ExprCfgNode g, boolean branch, CfgNodes::ExprCfgNode testedNode,
      Ssa::Definition def, CfgNodes::ExprNodes::CallCfgNode call
    |
      def.getARead() = testedNode and
      stringConstCaseCompare(g, testedNode, branch) and
      SsaImpl::captureFlowIn(call, def, result) and
      guardControlsBlock(g, call.getBasicBlock(), branch) and
      result.getBasicBlock().getScope() = call.getExpr().(MethodCall).getBlock()
    )
  }

  /**
   * Holds if all control flow paths reaching `succ` first exit `cb` with
   * successor type `s`, assuming that the last node of `cb` is a `when` clause.
   *
   * ```
   *   case foo
   *         |
   *     +---+
   *     |
   *     v
   *   when  "foo" ---> "bar" ----+
   *         |  |        |        |
   * no-match|  |match   |match   |no-match
   *         |  v        |        |
   *         |  foo <----+        |
   *         |                    |
   *   end <-+--------------------+
   * ```
   *
   * The read of `foo` in the `then` block is not technically controlled by
   * either `"foo"` or `"bar"` because it can be reached from either of them.
   * However if we consider the `when` clause as a whole, then it is
   * controlled because _at least one of the patterns_ must match.
   *
   * We determine this by finding a common successor `succ` of each pattern
   * with the same successor type `s`. We check that all predecessors of
   * `succ` are patterns in the clause, or are dominated by a pattern in the
   * clause.
   */
  cached
  private predicate whenClauseImmediatelyControls(
    ConditionBlock cb, BasicBlock succ, ConditionalSuccessor s
  ) {
    exists(ExprNodes::WhenClauseCfgNode when |
      cb = when.getBasicBlock() and
      forall(ExprCfgNode pattern | pattern = when.getPattern(_) |
        succ = pattern.getBasicBlock().getASuccessor(s) and
        forall(BasicBlock pred |
          pred = succ.getAPredecessor() and
          pred != cb
        |
          pred = when.getPattern(_).getBasicBlock()
          or
          when.getPattern(_).getBasicBlock().dominates(pred)
        )
      )
    )
  }

  // The predicates below are all identical to their counterparts in
  // `DataFlow::BarrierGuard`.
  cached
  private predicate whenClauseControls(
    ConditionBlock whenCb, BasicBlock controlled, ConditionalSuccessor s
  ) {
    exists(BasicBlock succ | whenClauseImmediatelyControls(whenCb, succ, s) |
      succ.dominates(controlled)
    )
  }

  pragma[nomagic]
  private predicate guardChecksSsaDef(CfgNodes::AstCfgNode g, boolean branch, Ssa::Definition def) {
    stringConstCaseCompare(g, def.getARead(), branch)
  }

  pragma[nomagic]
  private predicate guardControlsSsaDef(
    CfgNodes::AstCfgNode g, boolean branch, Ssa::Definition def, DataFlow::Node n
  ) {
    def.getARead() = n.asExpr() and
    guardControlsBlock(g, n.asExpr().getBasicBlock(), branch)
  }

  /** Gets a node that is safely guarded by the given guard check. */
  DataFlow::Node getABarrierNode() {
    exists(CfgNodes::AstCfgNode g, boolean branch, Ssa::Definition def |
      guardChecksSsaDef(g, branch, def) and
      guardControlsSsaDef(g, branch, def, result)
    )
    or
    result.asExpr() = getAMaybeGuardedCapturedDef().getARead()
  }
}
