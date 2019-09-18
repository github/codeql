import javascript

/*
 * The range analysis is based on Difference Bound constraints, that is, inequalities of form:
 *
 *      a - b <= c
 *
 * or equivalently,
 *
 *      a <= b + c
 *
 * where a and b are variables in the constraint system, and c is an integer constant.
 *
 * Such constraints obey a transitive law. Given two constraints,
 *
 *      a - x <= c1
 *      x - b <= c2
 *
 * adding the two inequalities yields the obvious transitive conclusion:
 *
 *      a - b <= c1 + c2
 *
 * We view the system of constraints as a weighted graph, where `a - b <= c`
 * corresponds to the edge `a -> b` with weight `c`.
 *
 * Paths in this graph corresponds to the additional inequalities we can derive from the constraint set.
 * A negative-weight cycle represents a contradiction, such as `a <= a - 1`.
 *
 *
 * CONTROL FLOW:
 *
 * Each constraint is associated with a CFG node where that constraint is known to be valid.
 * The constraint is only valid within the dominator subtree of that node.
 *
 * The transitive rule additionally requires that, in order to compose two edges, one of
 * their CFG nodes must dominate the other, and the resulting edge becomes associated with the
 * dominated CFG node (i.e. the most restrictive scope).  This ensures constraints
 * cannot be taken out of context.
 *
 * If a negative-weight cycle can be constructed from the edges "in scope" at a given CFG node
 * (i.e. associated with a dominator of the node), that node is unreachable.
 *
 *
 * DUAL CONSTRAINTS:
 *
 * For every data flow node `a` we have two constraint variables, `+a` and `-a` (or just `a` and `-a`)
 * representing the numerical value of `a` and its negation.  Negations let us reason about the sum of
 * two variables. For example:
 *
 *     a + b <= 10  becomes  a - (-b) <= 10
 *
 * It also lets us reason about the upper and lower bounds of a single variable:
 *
 *     a <= 10  becomes  a + a <= 20  becomes  a - (-a) <= 20
 *     a >= 10  becomes  -a <= -10    becomes  (-a) - a <= -20
 *
 * For the graph analogy to include the relationship between `a` and `-a`, all constraints
 * imply their dual constraint:
 *
 *     a - b <= c  implies  (-b) - (-a) <= c
 *
 * That is, for every edge from a -> b, there is an edge with the same weight from (-b) -> (-a).
 *
 *
 * PATH FINDING:
 *
 * See `extendedEdge` predicate for details about how we find negative-weight paths in the graph.
 *
 *
 * CAVEATS:
 *
 * - We assume !(x <= y) means x > y, ignoring NaN, unless a nearby comment or identifier mentions NaN.
 *
 * - We assume integer arithmetic is exact, ignoring values above 2^53.
 */

/**
 * Contains predicates for reasoning about the relative numeric value of expressions.
 */
module RangeAnalysis {
  /**
   * Holds if the given node is relevant for range analysis.
   */
  private predicate isRelevant(DataFlow::Node node) {
    node = any(Comparison cmp).getAnOperand().flow()
    or
    node = any(ConditionGuardNode guard).getTest().flow()
    or
    exists(DataFlow::Node succ | isRelevant(succ) |
      succ = node.getASuccessor()
      or
      linearDefinitionStep(succ, node, _, _)
      or
      exists(BinaryExpr bin | bin instanceof AddExpr or bin instanceof SubExpr |
        succ.asExpr() = bin and
        bin.getAnOperand().flow() = node
      )
    )
  }

  /**
   * Gets a data flow node holding the result of the add/subtract operation in
   * the given increment/decrement expression.
   */
  private DataFlow::Node updateExprResult(UpdateExpr expr) {
    result = DataFlow::ssaDefinitionNode(SSA::definition(expr))
    or
    expr.isPrefix() and
    result = expr.flow()
  }

  /**
   * Gets a data flow node holding the result of the given componund assignment.
   */
  private DataFlow::Node compoundAssignResult(CompoundAssignExpr expr) {
    result = DataFlow::ssaDefinitionNode(SSA::definition(expr))
    or
    result = expr.flow()
  }

  /**
   * A 30-bit integer.
   *
   * Adding two such integers is guaranteed not to overflow. We simply omit constraints
   * whose parameters would exceed this range.
   */
  private class Bias extends int {
    bindingset[this]
    Bias() { -536870912 < this and this < 536870912 }
  }

  /**
   * Holds if `r` can be modelled as `r = root * sign + bias`.
   *
   * Only looks "one step", that is, does not follow data flow and does not recursively
   * unfold nested arithmetic expressions.
   */
  private predicate linearDefinitionStep(DataFlow::Node r, DataFlow::Node root, int sign, Bias bias) {
    not exists(r.asExpr().getIntValue()) and
    (
      exists(AddExpr expr | r.asExpr() = expr |
        // r = root + k
        root = expr.getLeftOperand().flow() and
        bias = expr.getRightOperand().getIntValue() and
        sign = 1
        or
        // r = k + root
        bias = expr.getLeftOperand().getIntValue() and
        root = expr.getRightOperand().flow() and
        sign = 1
      )
      or
      exists(SubExpr expr | r.asExpr() = expr |
        // r = root - k
        root = expr.getLeftOperand().flow() and
        bias = -expr.getRightOperand().getIntValue() and
        sign = 1
        or
        // r = k - root
        bias = expr.getLeftOperand().getIntValue() and
        root = expr.getRightOperand().flow() and
        sign = -1
      )
      or
      exists(NegExpr expr | r.asExpr() = expr |
        // r = -root
        root = expr.getOperand().flow() and
        bias = 0 and
        sign = -1
      )
      or
      exists(UpdateExpr update | r = updateExprResult(update) |
        // r = ++root
        root = update.getOperand().flow() and
        sign = 1 and
        if update instanceof IncExpr then bias = 1 else bias = -1
      )
      or
      exists(UpdateExpr update |
        r.asExpr() = update // Return value of x++ is just x (coerced to an int)
      |
        // r = root++
        root = update.getOperand().flow() and
        not update.isPrefix() and
        sign = 1 and
        bias = 0
      )
      or
      exists(CompoundAssignExpr assign | r = compoundAssignResult(assign) |
        root = assign.getLhs().flow() and
        sign = 1 and
        (
          // r = root += k
          assign instanceof AssignAddExpr and
          bias = assign.getRhs().getIntValue()
          or
          // r = root -= k
          assign instanceof AssignSubExpr and
          bias = -assign.getRhs().getIntValue()
        )
      )
    )
  }

  /**
   * Holds if `r` can be modelled as `r = root * sign + bias`.
   */
  predicate linearDefinition(DataFlow::Node r, DataFlow::Node root, int sign, Bias bias) {
    if exists(r.getImmediatePredecessor())
    then linearDefinition(r.getImmediatePredecessor(), root, sign, bias)
    else
      if linearDefinitionStep(r, _, _, _)
      then
        exists(DataFlow::Node pred, int sign1, int bias1, int sign2, int bias2 |
          // r = pred * sign1 + bias1
          linearDefinitionStep(r, pred, sign1, bias1) and
          // pred = root * sign2 + bias2
          linearDefinition(pred, root, sign2, bias2) and
          // r = (root * sign2 + bias2) * sign1 + bias1
          sign = sign1 * sign2 and
          bias = bias1 + sign1 * bias2
        )
      else (
        isRelevant(r) and
        root = r and
        sign = 1 and
        bias = 0
      )
  }

  /**
   * Holds if `r` can be modelled as `r = xroot * xsign + yroot * ysign + bias`.
   */
  predicate linearDefinitionSum(
    DataFlow::Node r, DataFlow::Node xroot, int xsign, DataFlow::Node yroot, int ysign, Bias bias
  ) {
    if exists(r.getImmediatePredecessor())
    then linearDefinitionSum(r.getImmediatePredecessor(), xroot, xsign, yroot, ysign, bias)
    else
      if exists(r.asExpr().getIntValue())
      then none() // do not model constants as sums
      else (
        exists(AddExpr add, int bias1, int bias2 | r.asExpr() = add |
          // r = r1 + r2
          linearDefinition(add.getLeftOperand().flow(), xroot, xsign, bias1) and
          linearDefinition(add.getRightOperand().flow(), yroot, ysign, bias2) and
          bias = bias1 + bias2
        )
        or
        exists(SubExpr sub, int bias1, int bias2 | r.asExpr() = sub |
          // r = r1 - r2
          linearDefinition(sub.getLeftOperand().flow(), xroot, xsign, bias1) and
          linearDefinition(sub.getRightOperand().flow(), yroot, -ysign, -bias2) and // Negate right-hand operand
          bias = bias1 + bias2
        )
        or
        linearDefinitionSum(r.asExpr().(NegExpr).getOperand().flow(), xroot, -xsign, yroot, -ysign,
          -bias)
      )
  }

  /**
   * Holds if the given comparison can be modelled as `A <op> B + bias` where `<op>` is the comparison operator,
   * and `A` is `a * asign` and likewise `B` is `b * bsign`.
   */
  predicate linearComparison(
    Comparison comparison, DataFlow::Node a, int asign, DataFlow::Node b, int bsign, Bias bias
  ) {
    exists(Expr left, Expr right, int bias1, int bias2 |
      left = comparison.getLeftOperand() and right = comparison.getRightOperand()
    |
      // A <= B + c
      linearDefinition(left.flow(), a, asign, bias1) and
      linearDefinition(right.flow(), b, bsign, bias2) and
      bias = bias2 - bias1
      or
      // A - B + c1 <= c2  becomes  A <= B + (c2 - c1)
      linearDefinitionSum(left.flow(), a, asign, b, -bsign, bias1) and
      right.getIntValue() = bias2 and
      bias = bias2 - bias1
      or
      // c1 <= -A + B + c2  becomes  A <= B + (c2 - c1)
      left.getIntValue() = bias1 and
      linearDefinitionSum(right.flow(), a, -asign, b, bsign, bias2) and
      bias = bias2 - bias1
    )
  }

  /**
   * Holds if the given container has a comment or identifier mentioning `NaN`.
   */
  predicate hasNaNIndicator(StmtContainer container) {
    exists(Comment comment |
      comment.getText().regexpMatch("(?s).*N[aA]N.*") and
      comment.getFile() = container.getFile() and
      (
        comment.getLocation().getStartLine() >= container.getLocation().getStartLine() and
        comment.getLocation().getEndLine() <= container.getLocation().getEndLine()
        or
        comment.getNextToken() = container.getFirstToken()
      )
    )
    or
    exists(Identifier id | id.getName() = "NaN" or id.getName() = "isNaN" |
      id.getContainer() = container
    )
  }

  /**
   * Holds if `guard` asserts that the outcome of `A <op> B + bias` is true, where `<op>` is a comparison operator.
   */
  predicate linearComparisonGuard(
    ConditionGuardNode guard, DataFlow::Node a, int asign, string operator, DataFlow::Node b,
    int bsign, Bias bias
  ) {
    exists(Comparison compare |
      compare = guard.getTest().flow().getImmediatePredecessor*().asExpr() and
      linearComparison(compare, a, asign, b, bsign, bias) and
      (
        guard.getOutcome() = true and operator = compare.getOperator()
        or
        not hasNaNIndicator(guard.getContainer()) and
        guard.getOutcome() = false and
        operator = negateOperator(compare.getOperator())
      )
    )
  }

  /**
   * Gets the binary operator whose return value is the opposite of `operator` (excluding NaN comparisons).
   */
  private string negateOperator(string operator) {
    operator = "==" and result = "!="
    or
    operator = "===" and result = "!=="
    or
    operator = "<" and result = ">="
    or
    operator = ">" and result = "<="
    or
    operator = negateOperator(result)
  }

  /**
   * Holds if immediately after `cfg` it becomes known that `A <= B + c`.
   *
   * These are the initial inputs to the difference bound constraint system.
   *
   * The dual constraint `-B <= -A + c` is not included in this predicate.
   */
  predicate comparisonEdge(
    ControlFlowNode cfg, DataFlow::Node a, int asign, DataFlow::Node b, int bsign, Bias bias,
    boolean sharp
  ) {
    // A <= B + c
    linearComparisonGuard(cfg, a, asign, "<=", b, bsign, bias) and
    sharp = false
    or
    // A < B + c
    linearComparisonGuard(cfg, a, asign, "<", b, bsign, bias) and
    sharp = true
    or
    // A <= B + c   iff   B >= A - c
    linearComparisonGuard(cfg, b, bsign, ">=", a, asign, -bias) and
    sharp = false
    or
    // A < B + c   iff   B > A - c
    linearComparisonGuard(cfg, b, bsign, ">", a, asign, -bias) and
    sharp = true
    or
    sharp = false and
    exists(string operator | operator = "==" or operator = "===" |
      // A == B + c   iff   A <= B + c  and  B <= A - c
      linearComparisonGuard(cfg, a, asign, operator, b, bsign, bias)
      or
      linearComparisonGuard(cfg, b, bsign, operator, a, asign, -bias)
    )
  }

  /**
   * Holds if `node` is a phi node with `left` and `right` has the only two inputs.
   *
   * Note that this predicate is symmetric: when it holds for (left, right) it also holds for (right, left).
   */
  predicate binaryPhiNode(DataFlow::Node node, DataFlow::Node left, DataFlow::Node right) {
    exists(SsaPhiNode phi | node = DataFlow::ssaDefinitionNode(phi) |
      isRelevant(node) and
      strictcount(phi.getAnInput()) = 2 and
      left = DataFlow::ssaDefinitionNode(phi.getAnInput()) and
      right = DataFlow::ssaDefinitionNode(phi.getAnInput()) and
      left != right
    )
  }

  /**
   * Holds if `A <= B + c` can be determined based on a phi node.
   */
  predicate phiEdge(
    ControlFlowNode cfg, DataFlow::Node a, int asign, DataFlow::Node b, int bsign, Bias c
  ) {
    exists(DataFlow::Node phi, DataFlow::Node left, DataFlow::Node right |
      binaryPhiNode(phi, left, right) and
      cfg = phi.getBasicBlock()
    |
      // Both inputs are defined in terms of the same root:
      //  phi = PHI(root + bias1, root + bias2)
      exists(DataFlow::Node root, int sign, Bias bias1, Bias bias2 |
        linearDefinition(left, root, sign, bias1) and
        linearDefinition(right, root, sign, bias2) and
        bias1 < bias2 and
        // root + bias1 <= phi <= root + bias2
        (
          // root <= phi - bias1
          a = root and
          asign = 1 and
          b = phi and
          bsign = 1 and
          c = -bias1
          or
          // phi <= root + bias2
          a = phi and
          asign = 1 and
          b = root and
          bsign = 1 and
          c = bias2
        )
      )
      or
      // One input is defined in terms of the phi node itself:
      //  phi = PHI(phi + increment, x)
      exists(int increment, DataFlow::Node root, int sign, Bias bias |
        linearDefinition(left, phi, 1, increment) and
        linearDefinition(right, root, sign, bias) and
        (
          // If increment is positive (or zero):
          //   phi >= right' + bias
          increment >= 0 and
          a = root and
          asign = sign and
          b = phi and
          bsign = 1 and
          c = -bias
          or
          // If increment is negative (or zero):
          //   phi <= right' + bias
          increment <= 0 and
          a = phi and
          asign = 1 and
          b = root and
          bsign = sign and
          c = bias
        )
      )
    )
  }

  /**
   * Holds if a comparison implies that `A <= B + c`.
   *
   * Comparisons where one operand is really a constant are converted into a unary constraint.
   */
  predicate foldedComparisonEdge(
    ControlFlowNode cfg, DataFlow::Node a, int asign, DataFlow::Node b, int bsign, Bias c,
    boolean sharp
  ) {
    // A <= B + c    (where A and B are not constants)
    comparisonEdge(cfg, a, asign, b, bsign, c, sharp) and
    not exists(a.asExpr().getIntValue()) and
    not exists(b.asExpr().getIntValue())
    or
    // A - k <= c  becomes  A - (-A) <= 2*(k + c)
    exists(DataFlow::Node k, int ksign, Bias kbias, Bias value |
      comparisonEdge(cfg, a, asign, k, ksign, kbias, sharp) and
      value = k.asExpr().getIntValue() and
      b = a and
      bsign = -asign and
      c = 2 * (value * ksign + kbias)
    )
    or
    // k - A <= c   becomes   -A - A <= 2(-k + c)
    exists(DataFlow::Node k, int ksign, Bias kbias, Bias value |
      comparisonEdge(cfg, k, ksign, b, bsign, kbias, sharp) and
      value = k.asExpr().getIntValue() and
      a = b and
      asign = -bsign and
      c = 2 * (-value * ksign + kbias)
    )
    or
    // For completeness, generate a contradictory constraint for trivially false conditions.
    exists(DataFlow::Node k, int ksign, Bias bias, int avalue, int kvalue |
      comparisonEdge(cfg, a, asign, k, ksign, bias, sharp) and
      avalue = a.asExpr().getIntValue() * asign and
      kvalue = k.asExpr().getIntValue() * ksign and
      (
        avalue > kvalue + bias
        or
        sharp = true and avalue = kvalue + bias
      ) and
      a = b and
      asign = bsign and
      c = -1
    )
  }

  /**
   * The set of initial edges including those from dual constraints.
   */
  predicate seedEdge(
    ControlFlowNode cfg, DataFlow::Node a, int asign, DataFlow::Node b, int bsign, Bias c,
    boolean sharp
  ) {
    foldedComparisonEdge(cfg, a, asign, b, bsign, c, sharp)
    or
    phiEdge(cfg, a, asign, b, bsign, c) and sharp = false
  }

  private predicate seedEdgeWithDual(
    ControlFlowNode cfg, DataFlow::Node a, int asign, DataFlow::Node b, int bsign, Bias c,
    boolean sharp
  ) {
    // A <= B + c
    seedEdge(cfg, a, asign, b, bsign, c, sharp)
    or
    // -B <= -A + c   (dual constraint)
    seedEdge(cfg, b, -bsign, a, -asign, c, sharp)
  }

  /**
   * Adds a negative and positive integer, but only if they are within in the same
   * order of magnitude.
   */
  bindingset[x, sharpx, y, sharpy]
  private int wideningAddition(int x, boolean sharpx, int y, boolean sharpy) {
    (
      x < 0
      or
      x = 0 and sharpx = true
    ) and
    (
      y > 0
      or
      y = 0 and sharpy = false
    ) and
    (
      x <= 0 and x >= 0
      or
      y <= 0 and y >= 0
      or
      // If non-zero, check that the values are within a factor 16 of each other
      x.abs().bitShiftRight(4) < y.abs() and
      y.abs().bitShiftRight(4) < x.abs()
    ) and
    result = x + y
  }

  /**
   * Applies a restricted transitive rule to the edge set.
   *
   * In particular, we apply the transitive rule only where a negative edge followed by a non-negative edge.
   * For example:
   *
   *   A  --(-1)--> B --(+3)--> C
   *
   * yields:
   *
   *   A  --(+2)--> C
   *
   * In practice, the restriction to edges of different sign prevent the
   * quadratic blow-up you would normally get from a transitive closure.
   *
   * It also prevents the relation from becoming infinite in case
   * there are negative-weight cycles, where the transitive weights would
   * otherwise diverge towards minus infinity.
   *
   * Moreover, the rule is enough to guarantee the following property:
   *
   *    A negative-weight path from X to Y exists iff a path of negative-weight edges exists from X to Y.
   *
   * This means negative-weight cycles (contradictions) can be detected using simple cycle detection.
   */
  pragma[noopt]
  private predicate extendedEdge(
    DataFlow::Node a, int asign, DataFlow::Node b, int bsign, Bias c, boolean sharp,
    ControlFlowNode cfg
  ) {
    seedEdgeWithDual(cfg, a, asign, b, bsign, c, sharp)
    or
    // One of the two CFG nodes must dominate the other, and `cfg` must be bound to the dominated one.
    exists(ControlFlowNode cfg1, ControlFlowNode cfg2 |
      // They are in the same basic block
      extendedEdgeCandidate(a, asign, b, bsign, c, sharp, cfg1, cfg2) and
      exists(BasicBlock bb, int i, int j |
        bb.getNode(i) = cfg1 and
        bb.getNode(j) = cfg2 and
        if i < j then cfg = cfg2 else cfg = cfg1
      )
      or
      // They are in different basic blocks
      extendedEdgeCandidate(a, asign, b, bsign, c, sharp, cfg1, cfg2) and
      exists(
        BasicBlock cfg1BB, ReachableBasicBlock cfg1RBB, BasicBlock cfg2BB,
        ReachableBasicBlock cfg2RBB
      |
        cfg1BB = cfg1.getBasicBlock() and
        cfg1RBB = cfg1BB.(ReachableBasicBlock) and
        cfg2BB = cfg2.getBasicBlock() and
        cfg2RBB = cfg2BB.(ReachableBasicBlock) and
        (
          cfg1RBB.strictlyDominates(cfg2BB) and
          cfg = cfg2
          or
          cfg2RBB.strictlyDominates(cfg1RBB) and
          cfg = cfg1
        )
      )
    ) and
    cfg instanceof ControlFlowNode
  }

  /**
   * Holds if an extended edge from `A` to `B` can potentially be generates from two edges, from `cfg1` and `cfg2`, respectively.
   *
   * This does not check for dominance between `cfg1` and `cfg2`.
   */
  pragma[nomagic]
  private predicate extendedEdgeCandidate(
    DataFlow::Node a, int asign, DataFlow::Node b, int bsign, Bias c, boolean sharp,
    ControlFlowNode cfg1, ControlFlowNode cfg2
  ) {
    exists(DataFlow::Node mid, int midx, Bias c1, Bias c2, boolean sharp1, boolean sharp2 |
      extendedEdge(a, asign, mid, midx, c1, sharp1, cfg1) and
      extendedEdge(mid, midx, b, bsign, c2, sharp2, cfg2) and
      (a != mid or asign != midx) and
      (b != mid or bsign != midx) and
      sharp = sharp1.booleanOr(sharp2) and
      c = wideningAddition(c1, sharp1, c2, sharp2)
    )
  }

  /**
   * Holds if there is a negative-weight edge from src to dst.
   */
  private predicate negativeEdge(
    DataFlow::Node a, int asign, DataFlow::Node b, int bsign, ControlFlowNode cfg
  ) {
    exists(int weight, boolean sharp | extendedEdge(a, asign, b, bsign, weight, sharp, cfg) |
      weight = 0 and sharp = true // a strict "< 0" edge counts as negative
      or
      weight < 0
    )
  }

  /**
   * Holds if `src` can reach `dst` using only negative-weight edges.
   *
   * The initial outgoing edge from `src` must be derived at `cfg`.
   */
  pragma[noopt]
  private predicate reachableByNegativeEdges(
    DataFlow::Node a, int asign, DataFlow::Node b, int bsign, ControlFlowNode cfg
  ) {
    negativeEdge(a, asign, b, bsign, cfg)
    or
    exists(DataFlow::Node mid, int midx, ControlFlowNode midcfg |
      reachableByNegativeEdges(a, asign, mid, midx, cfg) and
      negativeEdge(mid, midx, b, bsign, midcfg) and
      exists(BasicBlock bb, int i, int j |
        bb.getNode(i) = midcfg and
        bb.getNode(j) = cfg and
        i <= j
      )
    )
    or
    // Same as above, but where CFG nodes are in different basic blocks
    exists(
      DataFlow::Node mid, int midx, ControlFlowNode midcfg, BasicBlock midBB,
      ReachableBasicBlock midRBB, BasicBlock cfgBB
    |
      reachableByNegativeEdges(a, asign, mid, midx, cfg) and
      negativeEdge(mid, midx, b, bsign, midcfg) and
      midBB = midcfg.getBasicBlock() and
      midRBB = midBB.(ReachableBasicBlock) and
      cfgBB = cfg.getBasicBlock() and
      midRBB.strictlyDominates(cfgBB)
    )
  }

  /**
   * Holds if the condition asserted at `guard` is contradictory, that is, its condition always has the
   * opposite of the expected outcome.
   */
  predicate isContradictoryGuardNode(ConditionGuardNode guard) {
    exists(DataFlow::Node a, int asign | reachableByNegativeEdges(a, asign, a, asign, guard))
  }
}
