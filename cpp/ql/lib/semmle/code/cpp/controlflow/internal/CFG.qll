/**
 * Provides classes and predicates for calculating the raw control-flow graph.
 *
 * The predicates in this file produce the _raw_ CFG. Subsequent passes will
 * prune it to remove impossible edges before exposing it through the
 * `ControlFlowNode` class.
 */

/*
 * The calculation is in two stages. First, a graph of _sub-nodes_ is produced.
 * A sub-node is either an actual CFG node or a _virtual node_. Second, the
 * virtual nodes are eliminated from the graph by collapsing edges such that
 * any _actual sub-nodes_ connected through zero or more _virtual sub-nodes_
 * are still connected in the final graph.
 *
 * The graph of sub-nodes is produced by a comprehensive case analysis that
 * specifies the shape of the CFG for all known language constructs. The case
 * analysis is large but does _not_ contain recursion. Recursion is needed in
 * the second stage in order to collapse virtual nodes, but that recursion is
 * simply a transitive closure and so is fast.
 *
 * A sub-node is a pair `(Node, Pos)`, where the type `Node` is
 * `ControlFlowNode`, and `Pos` is usually one of three values: "at", "before",
 * or "after". The "at" position represents the control-flow node itself, and
 * sub-nodes with "at"-positions are what we call _actual_ sub-nodes. Other
 * positions are _virtual_, and they are used for forming paths between actual
 * sub-nodes and will get erased to produce the final graph. The "before" and
 * "after" positions represent the points in control flow just before and after
 * evaluating the associated node and its children.
 *
 * The computation of the sub-edges is a large disjunction in which each case
 * contributes all the edges for a particular type of node. As an example,
 * consider the case for `AddExpr` (`e1 + e2`). We can compute the sub-edges
 * contributed by the `AddExpr` independently of the edges contributed by `e1`
 * and `e2`. The points where the `AddExpr` connects to its children are simply
 * represented as the virtual nodes corresponding to what's "before" and
 * "after" each child. In the cases where edges are computed for each child,
 * these "before" and "after" nodes get their remaining neighbors. Concretely,
 * an `AddExpr e` contributes the following edges:
 *
 *     before(e) -> before(e1)
 *     after(e1) -> before(e2)
 *     after(e2) -> at(e)
 *     at(e)     -> after(e)
 *
 * These four edges are not all connected, but they will be part of a connected
 * graph when all expressions under `e1` and `e2` are added as well. Suppose
 * `e1` and `e2` are of type Literal. Then they contribute the following edges.
 *
 *     before(e1) -> at(e1)
 *     at(e1)     -> after(e1)
 *
 *     before(e2) -> at(e2)
 *     at(e2)     -> after(e2)
 *
 * When the complete graph is transformed to remove the virtual sub-nodes
 * ("before" and "after") and collapse the edges around them, we are left with
 * the correct CFG for `e`:
 *
 *     e1 -> e2 -> e
 *
 * To produce all edges around each control-flow node without recursion, we
 * need to pre-compute the targets of exception sources (throw, propagating
 * handlers, ...) and short-circuiting operators (||, ? :, ...). This
 * pre-computation involves recursion, but it's quick to compute because it
 * only involves the nodes themselves and their (transitive) parents.
 *
 * Many kinds of AST nodes share the same pattern of control flow. To add
 * control flow for a new AST construct, use one of the following predicates.
 * They are listed in order of increasing generality, where less general
 * predicates can be extended with less effort.
 *
 * - PostOrderNode and PreOrderNode
 * - straightLineSparse
 * - subEdge
 * - conditionJumps and conditionJumpsTop
 *
 * For nodes whose flow passes through their children in left-to-right order,
 * the `getControlOrderChildSparse` predicate is used to specify that order.
 */

private import cpp

/**
 * A control-flow node. This class exists to provide a shorter name than
 * `ControlFlowNodeBase` within this file and to avoid a seemingly cyclic
 * dependency on the `ControlFlowNode` class, whose implementation relies on
 * this file.
 */
private class Node extends ControlFlowNodeBase {
  /**
   * Gets the nearest control-flow node that's a parent of this one, never
   * crossing function boundaries.
   */
  final Node getParentNode() {
    result = this.(Expr).getParent()
    or
    result = this.(Stmt).getParent()
    or
    result.(DeclStmt).getADeclaration().(LocalVariable) = this.(Initializer).getDeclaration()
    // It's possible that the VLA cases of DeclStmt (see
    // getControlOrderChildSparse) should also be here, but that currently
    // won't make a difference in practice.
    //
    // An `Initializer` under a `ConditionDeclExpr` is not part of the CFG;
    // only the `getExpr()` of the `Initializer` is in the CFG. That can be
    // changed when we no longer need compatibility with the extractor-based
    // CFG.
  }
}

/**
 * Holds if `e` and all of its transitive children should not have CFG edges.
 */
private predicate excludeNodeAndNodesBelow(Expr e) {
  not exists(e.getParent()) and
  not e instanceof DestructorCall
  or
  // Constructor init lists should be evaluated, and we can change this in
  // the future, but it would mean that a `Function` entry point is not
  // always a `BlockStmt` or `FunctionTryStmt`.
  e instanceof ConstructorInit
  or
  // Destructor field destructions should also be hooked into the CFG
  // properly in the future.
  e instanceof DestructorFieldDestruction
}

/**
 * A node that is part of the CFG but whose arguments are not. That means the
 * arguments should not be linked to the CFG and should not have internal
 * control flow in them.
 */
private predicate excludeNodesStrictlyBelow(Node n) {
  n instanceof BuiltInOperationBuiltInOffsetOf
  or
  n instanceof BuiltInIntAddr
  or
  n instanceof BuiltInOperationBuiltInShuffleVector
  or
  n instanceof BuiltInOperationBuiltInAddressOf
  or
  n instanceof BuiltInOperationBuiltInConvertVector
  or
  n instanceof AssumeExpr
  or
  // Switch cases must be constant, so there is no control flow within the
  // expression of the switch case, but the `SwitchCase` statement still has
  // flow in and out.
  n instanceof SwitchCase
  or
  // This excludes the synthetic VariableAccess that ought to be the result
  // of the ConditionDeclExpr after the variable has been initialized. It
  // would be more correct to include this VariableAccess in the CFG, but for
  // now we omit it for compatibility with the extractor CFG.
  n instanceof ConditionDeclExpr
  or
  skipInitializer(n)
}

/**
 * For compatibility with the extractor-generated CFG, the QL-generated CFG
 * will not be produced for nodes in this predicate.
 */
predicate excludeNode(Node n) {
  excludeNodeAndNodesBelow(n)
  or
  excludeNodesStrictlyBelow(n.getParentNode())
  or
  n = any(Expr e | not exists(e.getEnclosingFunction()))
  or
  // Fast TC has turned out to be more expensive than this manual recursion.
  excludeNode(n.getParentNode())
}

/**
 * A constant that indicates the type of sub-node in a pair of `(Node, Pos)`.
 * See the comment block at the top of this file.
 */
private class Pos extends int {
  bindingset[this]
  Pos() { any() }

  /** Holds if this is the position just _before_ the associated `Node`. */
  predicate isBefore() { this = 0 }

  /** Holds if `(n, this)` is the sub-node that represents `n` itself. */
  predicate isAt() { this = 1 }

  /** Holds if this is the position just _after_ the associated `Node`. */
  predicate isAfter() { this = 2 }

  /**
   * Holds if `(n, this)` is the virtual sub-node that comes just _before_ any
   * implicit destructor calls following `n`. The node `n` will be some node
   * that may be followed by local variables going out of scope.
   */
  predicate isBeforeDestructors() { this = 3 }

  /**
   * Holds if `(n, this)` is the virtual sub-node that comes just _after_ any
   * implicit destructor calls following `n`. The node `n` will be some node
   * that may be followed by local variables going out of scope.
   */
  predicate isAfterDestructors() { this = 4 }

  pragma[inline]
  predicate nodeBefore(Node n, Node nEq) { this.isBefore() and n = nEq }

  pragma[inline]
  predicate nodeAt(Node n, Node nEq) { this.isAt() and n = nEq }

  pragma[inline]
  predicate nodeAfter(Node n, Node nEq) { this.isAfter() and n = nEq }

  pragma[inline]
  predicate nodeBeforeDestructors(Node n, Node nEq) { this.isBeforeDestructors() and n = nEq }

  pragma[inline]
  predicate nodeAfterDestructors(Node n, Node nEq) { this.isAfterDestructors() and n = nEq }
}

/**
 * An initializer that should be a `PostOrderNode` instead of a `PreOrderNode`.
 * This class only exists for extractor CFG compatibility.
 */
private class PostOrderInitializer extends Initializer {
  PostOrderInitializer() {
    exists(RangeBasedForStmt for |
      this.getDeclaration() = for.getVariable()
      or
      this.getDeclaration() = for.getRangeVariable()
      or
      this.getDeclaration() = for.getBeginEndDeclaration().getADeclaration()
    )
  }
}

/**
 * Holds if control flow for this node starts with its children according to
 * the order in `getControlOrderChildSparse`, ends with the node itself, and
 * does not jump. This is the case for most types of expression.
 */
private class PostOrderNode extends Node {
  PostOrderNode() {
    this instanceof Expr and
    not this instanceof ShortCircuitOperator and
    not this instanceof ThrowExpr and
    not this instanceof Conversion and // not in CFG
    not excludeNode(this) // for performance
    or
    // VlaDeclStmt is a post-order node for extractor CFG compatibility only.
    this instanceof VlaDeclStmt
    or
    this instanceof PostOrderInitializer
  }
}

/**
 * Holds if control flow for this node starts with the node itself, is followed
 * by its children according to the order in `getControlOrderChildSparse`, and
 * does not jump.
 */
private class PreOrderNode extends Node {
  PreOrderNode() {
    // For extractor CFG compatibility, we only compute flow for local
    // variables.
    this.(Initializer).getDeclaration() instanceof LocalVariable and
    not this instanceof PostOrderInitializer
    or
    this instanceof DeclStmt
    or
    this instanceof LabelStmt
    or
    this instanceof ExprStmt
    or
    this instanceof EmptyStmt
    or
    this instanceof AsmStmt
    or
    this instanceof VlaDimensionStmt
    or
    this instanceof MicrosoftTryFinallyStmt
  }
}

/** Holds if `c` is part of a `delete` or `delete[]` operation. */
private predicate isDeleteDestructorCall(DestructorCall c) {
  exists(DeleteExpr del | c = del.getDestructorCall())
  or
  exists(DeleteArrayExpr del | c = del.getDestructorCall())
}

/**
 * Gets the `i`th child of `n` in control-flow order, where the `i`-indexes
 * don't need to be contiguous or positive. All children specified by this
 * predicate will be linked together with edges from "after" the `j`th child to
 * "before" the `k`th child, where `k` is the smallest child greater than `j`.
 */
private Node getControlOrderChildSparse(Node n, int i) {
  result = n.(PostOrderNode).(Expr).getChild(i) and
  not n instanceof AssignExpr and
  not n instanceof Call and
  not n instanceof DeleteExpr and
  not n instanceof DeleteArrayExpr and
  not n instanceof NewArrayExpr and
  not n instanceof NewExpr and
  not excludeNodesStrictlyBelow(n) and
  not n.(Expr).getParent() instanceof LambdaExpression and
  not result instanceof TypeName and
  not isDeleteDestructorCall(n)
  or
  n =
    any(AssignExpr a |
      i = 0 and result = a.getRValue()
      or
      i = 1 and result = a.getLValue()
    )
  or
  n =
    any(Call c |
      not isDeleteDestructorCall(c) and
      (
        result = c.getArgument(i)
        or
        i = c.getNumberOfArguments() and result = c.(ExprCall).getExpr()
        or
        i = c.getNumberOfArguments() + 1 and result = c.getQualifier()
      )
    )
  or
  n = any(ConditionDeclExpr cd | i = 0 and result = cd.getInitializingExpr())
  or
  n =
    any(DeleteOrDeleteArrayExpr del |
      i = 0 and result = del.getExpr()
      or
      i = 1 and result = del.getDestructorCall()
      or
      i = 2 and result = del.getDeallocatorCall()
    )
  or
  n =
    any(NewArrayExpr new |
      // Extra arguments to a built-in allocator, such as alignment or pointer
      // address, are found at child positions >= 3. Extra arguments to custom
      // allocators are instead placed as subexpressions of `getAllocatorCall`.
      exists(int extraArgPos |
        extraArgPos >= 3 and
        result = new.getChild(extraArgPos) and
        i = extraArgPos - max(int iMax | exists(new.getChild(iMax)))
      )
      or
      i = 1 and result = new.getExtent()
      or
      i = 2 and result = new.getAllocatorCall()
      or
      i = 3 and result = new.getInitializer()
    )
  or
  n =
    any(NewExpr new |
      // Extra arguments to a built-in allocator, such as alignment or pointer
      // address, are found at child positions >= 3. Extra arguments to custom
      // allocators are instead placed as subexpressions of `getAllocatorCall`.
      exists(int extraArgPos |
        extraArgPos >= 3 and
        result = new.getChild(extraArgPos) and
        i = extraArgPos - max(int iMax | exists(new.getChild(iMax)))
      )
      or
      i = 1 and result = new.getAllocatorCall()
      or
      i = 2 and result = new.getInitializer()
    )
  or
  // The extractor sometimes emits literals with no value for captures and
  // routes control flow around them.
  n =
    any(Expr e |
      e.getParent() instanceof LambdaExpression and
      result = e.getChild(i) and
      forall(Literal lit | result = lit | exists(lit.getValue()))
    )
  or
  n = any(StmtExpr e | i = 0 and result = e.getStmt())
  or
  n =
    any(Initializer init |
      not skipInitializer(init) and
      not exists(ConditionDeclExpr cd | result = cd.getInitializingExpr()) and
      i = 0 and
      result = n.(Initializer).getExpr()
    )
  or
  result = n.(PreOrderNode).(Stmt).getChild(i)
  or
  // VLAs are special because of how their associated statements are added
  // in-line in the block containing their corresponding DeclStmt but should
  // not be evaluated in the order implied by their position in the block. We
  // do the following.
  // - BlockStmt skips all the VlaDeclStmt and VlaDimensionStmt children.
  // - VlaDeclStmt is inserted as a child of DeclStmt
  // - VlaDimensionStmt is inserted as a child of VlaDeclStmt
  result = n.(BlockStmt).getChild(i) and
  not result instanceof VlaDeclStmt and
  not result instanceof VlaDimensionStmt
  or
  n =
    any(DeclStmt s |
      exists(LocalVariable var | var = s.getDeclaration(i) |
        result = var.getInitializer() and
        not skipInitializer(result)
        or
        // A VLA cannot have an initializer, so there is no conflict between this
        // case and the above.
        result.(VlaDeclStmt).getVariable() = var
      )
      or
      // C allows typedef declarations in function scope to depend on local
      // variables when computing VLA dimensions.
      exists(LocalTypedefType def | def = s.getDeclaration(i) |
        result.(VlaDeclStmt).getType() = def
      )
    )
  or
  result = n.(VlaDeclStmt).getVlaDimensionStmt(i)
}

/**
 * Holds if the expression in this initializer is evaluated at compile time and
 * thus should not have control flow computed.
 */
private predicate skipInitializer(Initializer init) {
  exists(StaticLocalVariable local |
    init = local.getInitializer() and
    not local.hasDynamicInitialization()
  )
}

/**
 * Gets the `i`th child of `n` in control-flow order, where the `i`-indexes are
 * contiguous, and the first index is 0.
 */
private Node getControlOrderChildDense(Node n, int i) {
  result =
    rank[i + 1](Node child, int childIdx |
      child = getControlOrderChildSparse(n, childIdx)
    |
      child order by childIdx
    )
}

/** Gets the last child of `n` in control-flow order. */
private Node getLastControlOrderChild(Node n) {
  result = getControlOrderChildDense(n, max(int i | exists(getControlOrderChildDense(n, i))))
}

/**
 * A constant that represents two positions: one position for when it's used as
 * the _source_ of a sub-edge, and another position for when it's used as the
 * _target_. Values include all the values of `Pos`, which resolve to
 * themselves as both source and target, as well as two _around_ values and a
 * _barrier_ value.
 */
private class Spec extends Pos {
  bindingset[this]
  Spec() { any() }

  /**
   * Holds if this spec, when used on a node `n` between `(n1, p1)` and
   * `(n2, p2)`, should add the following sub-edges.
   *
   *     (n1, p1) ----> before(n)
   *     after(n) ----> (n2, p2)
   */
  predicate isAround() { this = 5 }

  /**
   * Holds if this spec, when used on a node `n` between `(n1, p1)` and
   * `(n2, p2)`, should add the following sub-edges.
   *
   *     (n1, p1)            ----> beforeDestructors(n)
   *     afterDestructors(n) ----> (n2, p2)
   */
  predicate isAroundDestructors() { this = 6 }

  /**
   * Holds if this node is a _barrier_. A barrier resolves to no positions and
   * can be inserted between nodes that should have no sub-edges between them.
   */
  predicate isBarrier() { this = 7 }

  Pos getSourcePos() {
    this = [0 .. 4] and
    result = this
    or
    this.isAround() and
    result.isAfter()
    or
    this.isAroundDestructors() and
    result.isAfterDestructors()
  }

  Pos getTargetPos() {
    this = [0 .. 4] and
    result = this
    or
    this.isAround() and
    result.isBefore()
    or
    this.isAroundDestructors() and
    result.isBeforeDestructors()
  }
}

/**
 * Holds if `(ni, spec)` is the `i`th node in a straight line of control-flow
 * sub-edges associated with `scope`. The `spec` can resolve to a different
 * `Pos` depending on whether it's at the source or target of an edge -- see
 * the documentation on `Spec`.
 *
 * This predicate is particularly convenient for specifying control flow of
 * nodes that have optional children. For example, a `ThrowExpr` may or may not
 * have an operand. If the operand is missing, then there will simply be a hole
 * in the sequence of `i`s, and the two adjacent sub-nodes will be connected
 * together instead.
 */
private predicate straightLineSparse(Node scope, int i, Node ni, Spec spec) {
  scope =
    any(BlockStmt b |
      i = -1 and ni = b and spec.isAt()
      or
      if exists(getLastControlOrderChild(b))
      then (
        i = 0 and ni = getControlOrderChildDense(b, 0) and spec.isBefore()
        or
        i = 1 and /* BARRIER */ ni = b and spec.isBarrier()
        or
        i = 2 and ni = getLastControlOrderChild(b) and spec.isAfter()
        or
        i = 3 and ni = b and spec.isAroundDestructors()
        or
        i = 4 and ni = b and spec.isAfter()
      ) else (
        // There can be destructors even when the body is empty. This happens
        // when a `WhileStmt` with an empty body has a `ConditionDeclExpr` in its
        // condition.
        i = 0 and ni = b and spec.isAroundDestructors()
        or
        i = 1 and ni = b and spec.isAfter()
      )
    )
  or
  scope =
    any(ShortCircuitOperator op |
      i = -1 and ni = op and spec.isBefore()
      or
      i = 0 and ni = op and spec.isAt()
      or
      i = 1 and ni = op.getFirstChildNode() and spec.isBefore()
    )
  or
  scope =
    any(ThrowExpr e |
      i = -1 and ni = e and spec.isBefore()
      or
      i = 0 and ni = e.getExpr() and spec.isAround()
      or
      i = 1 and ni = e and spec.isAt()
      or
      i = 2 and ni = e and spec.isAroundDestructors()
      or
      i = 3 and ni = e.(ExceptionSource).getExceptionTarget() and spec.isBefore()
    )
  or
  scope =
    any(ReturnStmt ret |
      i = -1 and ni = ret and spec.isAt()
      or
      i = 0 and ni = ret.getExpr() and spec.isAround()
      or
      i = 1 and ni = ret and spec.isAroundDestructors()
      or
      i = 2 and ni = ret.getEnclosingFunction() and spec.isAt()
    )
  or
  scope =
    any(JumpStmt s |
      i = -1 and ni = s and spec.isAt()
      or
      i = 0 and ni = s and spec.isAroundDestructors()
      or
      i = 1 and ni = s.getTarget() and spec.isBefore()
    )
  or
  scope =
    any(ForStmt s |
      // ForStmt [-> init]
      i = -1 and ni = s and spec.isAt()
      or
      i = 0 and ni = s.getInitialization() and spec.isAround()
      or
      if exists(s.getCondition())
      then (
        // ... -> before condition
        i = 1 and ni = s.getCondition() and spec.isBefore()
        or
        // body [-> update] -> before condition
        i = 2 and /* BARRIER */ ni = s and spec.isBarrier()
        or
        i = 3 and ni = s.getStmt() and spec.isAfter()
        or
        i = 4 and ni = s.getUpdate() and spec.isAround()
        or
        // Can happen when the condition is a `ConditionDeclExpr`
        i = 5 and ni = s.getUpdate() and spec.isAroundDestructors()
        or
        i = 6 and ni = s.getCondition() and spec.isBefore()
        or
        i = 7 and /* BARRIER */ ni = s and spec.isBarrier()
        or
        i = 8 and ni = s and spec.isAfterDestructors()
        or
        i = 9 and ni = s and spec.isAfter()
      ) else (
        // ... -> body [-> update] -> before body
        i = 1 and ni = s.getStmt() and spec.isAround()
        or
        i = 2 and ni = s.getUpdate() and spec.isAround()
        or
        i = 3 and ni = s.getStmt() and spec.isBefore()
      )
    )
  or
  scope =
    any(RangeBasedForStmt for |
      i = -1 and ni = for and spec.isAt()
      or
      i = 0 and ni = for.getInitialization() and spec.isAround()
      or
      exists(DeclStmt s | s.getADeclaration() = for.getRangeVariable() |
        i = 1 and ni = s and spec.isAround()
      )
      or
      exists(DeclStmt s |
        s = for.getBeginEndDeclaration() and
        // A DeclStmt with no declarations can arise here in an uninstantiated
        // template, where the calls to `begin` and `end` cannot be resolved. For
        // compatibility with the extractor, we omit the CFG node for the
        // DeclStmt in that case.
        exists(s.getADeclaration())
      |
        i = 2 and ni = s and spec.isAround()
      )
      or
      i = 3 and ni = for.getCondition() and spec.isBefore()
      or
      i = 4 and /* BARRIER */ ni = for and spec.isBarrier()
      or
      exists(DeclStmt declStmt | declStmt.getADeclaration() = for.getVariable() |
        i = 5 and ni = declStmt and spec.isAfter()
      )
      or
      i = 6 and ni = for.getStmt() and spec.isAround()
      or
      i = 7 and ni = for.getUpdate() and spec.isAround()
      or
      i = 8 and ni = for.getCondition() and spec.isBefore()
    )
  or
  scope =
    any(TryStmt s |
      i = -1 and ni = s and spec.isAt()
      or
      i = 0 and ni = s.getStmt() and spec.isAround()
      or
      i = 1 and ni = s and spec.isAfter()
    )
  or
  scope =
    any(MicrosoftTryExceptStmt s |
      i = -1 and ni = s and spec.isAt()
      or
      i = 0 and ni = s.getStmt() and spec.isAround()
      or
      i = 1 and ni = s and spec.isAfter()
      or
      i = 2 and /* BARRIER */ ni = s and spec.isBarrier()
      or
      i = 3 and ni = s.getExcept() and spec.isAfter()
      or
      i = 4 and ni = s and spec.isAfter()
      or
      i = 5 and /* BARRIER */ ni = s and spec.isBarrier()
      or
      i = 6 and ni = s and spec.isAfterDestructors()
      or
      i = 7 and ni = s.(ExceptionSource).getExceptionTarget() and spec.isBefore()
    )
  or
  scope =
    any(SwitchStmt s |
      // SwitchStmt [-> init] -> expr
      i = -1 and ni = s and spec.isAt()
      or
      i = 0 and ni = s.getInitialization() and spec.isAround()
      or
      i = 1 and ni = s.getExpr() and spec.isAround()
      or
      // If the switch body is not a block then this step is skipped, and the
      // expression jumps directly to the cases.
      i = 2 and ni = s.getStmt().(BlockStmt) and spec.isAt()
      or
      i = 3 and ni = s.getASwitchCase() and spec.isBefore()
      or
      // If there is no default case, we can jump to after the block. Note: `i`
      // is same value as above.
      not s.getASwitchCase() instanceof DefaultCase and
      i = 3 and
      ni = s.getStmt() and
      spec.isAfter()
      or
      i = 4 and /* BARRIER */ ni = s and spec.isBarrier()
      or
      i = 5 and ni = s.getStmt() and spec.isAfter()
      or
      i = 6 and ni = s and spec.isAroundDestructors()
      or
      i = 7 and ni = s and spec.isAfter()
    )
  or
  scope =
    any(ComputedGotoStmt s |
      i = -1 and ni = s and spec.isAt()
      or
      i = 0 and ni = s.getExpr() and spec.isBefore()
    )
}

/**
 * Holds if `(nrnk, spec)` is the `rnk`th node in a straight line of
 * control-flow sub-edges associated with `scope`. The `rnk` numbers start from
 * 1 and are contiguous.
 */
private predicate straightLineDense(Node scope, int rnk, Node nrnk, Spec spec) {
  exists(int i |
    straightLineSparse(scope, i, nrnk, spec) and
    i = rank[rnk](int idx | straightLineSparse(scope, idx, _, _))
  )
}

/**
 * Holds if there should be a sub-edge from `(n1, p1)` to `(n2, p2)`. This
 * predicate includes all sub-edges except those with true/false labels (see
 * `conditionJumps`) and those around implicit destructor calls (see
 * `subEdgeIncludingDestructors`).
 *
 * The most difficult control flow can be modeled directly in this predicate,
 * but most cases should be handled through one of the convenience predicates
 * as outlined in the comment at the top of this file.
 */
// The parameters are ordered this way for performance.
private predicate subEdge(Pos p1, Node n1, Node n2, Pos p2) {
  exists(Node scope, int rnk, Spec spec1, Spec spec2 |
    straightLineDense(scope, rnk, n1, spec1) and
    straightLineDense(scope, rnk + 1, n2, spec2) and
    p1 = spec1.getSourcePos() and
    p2 = spec2.getTargetPos()
  )
  or
  // child1 -> ... -> childn
  exists(Node n, int childIdx |
    p1.nodeAfter(n1, getControlOrderChildDense(n, childIdx)) and
    p2.nodeBefore(n2, getControlOrderChildDense(n, childIdx + 1))
  )
  or
  // -> [children ->] PostOrderNode ->
  exists(PostOrderNode n |
    p1.nodeBefore(n1, n) and
    p2.nodeBefore(n2, getControlOrderChildDense(n, 0))
    or
    p1.nodeAfter(n1, getLastControlOrderChild(n)) and
    p2.nodeAt(n2, n)
    or
    // Short circuit if there are no children.
    not exists(getLastControlOrderChild(n)) and
    p1.nodeBefore(n1, n) and
    p2.nodeAt(n2, n)
    or
    p1.nodeAt(n1, n) and
    p2.nodeAfter(n2, n)
  )
  or
  // -> PreOrderNode -> [children ->]
  exists(PreOrderNode n |
    p1.nodeBefore(n1, n) and
    p2.nodeAt(n2, n)
    or
    p1.nodeAt(n1, n) and
    p2.nodeBefore(n2, getControlOrderChildDense(n, 0))
    or
    p1.nodeAfter(n1, getLastControlOrderChild(n)) and
    p2.nodeAfter(n2, n)
    or
    // Short circuit if there are no children
    not exists(getLastControlOrderChild(n)) and
    p1.nodeAt(n1, n) and
    p2.nodeAfter(n2, n)
  )
  or
  // ALmost all statements start with themselves.
  exists(Stmt s |
    not s instanceof VlaDeclStmt and
    p1.nodeBefore(n1, s) and
    p2.nodeAt(n2, s)
  )
  or
  // Exceptions always jump to "before" their target, so we redirect from
  // "before" the function to "at" the function.
  exists(Function f |
    p1.nodeBefore(n1, f) and
    p2.nodeAt(n2, f)
  )
  or
  // entry point -> Function
  // This makes a difference when the extractor doesn't synthesize a
  // `ReturnStmt` because it can tell that it wouldn't be reached. This case is
  // only for extractor CFG compatibility.
  exists(Function f |
    p1.nodeAfter(n1, f.getEntryPoint()) and
    p2.nodeAt(n2, f)
  )
  or
  // IfStmt -> [ init -> ] condition ; { then, else } ->
  exists(IfStmt s |
    p1.nodeAt(n1, s) and
    p2.nodeBefore(n2, s.getInitialization())
    or
    p1.nodeAfter(n1, s.getInitialization()) and
    p2.nodeBefore(n2, s.getCondition())
    or
    not exists(s.getInitialization()) and
    p1.nodeAt(n1, s) and
    p2.nodeBefore(n2, s.getCondition())
    or
    p1.nodeAfter(n1, s.getThen()) and
    p2.nodeBeforeDestructors(n2, s)
    or
    p1.nodeAfter(n1, s.getElse()) and
    p2.nodeBeforeDestructors(n2, s)
    or
    p1.nodeAfterDestructors(n1, s) and
    p2.nodeAfter(n2, s)
  )
  or
  // ConstexprIfStmt -> [ init -> ] condition ; { then, else } -> // same as IfStmt
  exists(ConstexprIfStmt s |
    p1.nodeAt(n1, s) and
    p2.nodeBefore(n2, s.getInitialization())
    or
    p1.nodeAfter(n1, s.getInitialization()) and
    p2.nodeBefore(n2, s.getCondition())
    or
    not exists(s.getInitialization()) and
    p1.nodeAt(n1, s) and
    p2.nodeBefore(n2, s.getCondition())
    or
    p1.nodeAfter(n1, s.getThen()) and
    p2.nodeBeforeDestructors(n2, s)
    or
    p1.nodeAfter(n1, s.getElse()) and
    p2.nodeBeforeDestructors(n2, s)
    or
    p1.nodeAfterDestructors(n1, s) and
    p2.nodeAfter(n2, s)
  )
  or
  // NotConstevalIfStmt -> { then, else } ->
  exists(ConstevalIfStmt s |
    p1.nodeAt(n1, s) and
    p2.nodeBefore(n2, s.getThen())
    or
    p1.nodeAt(n1, s) and
    p2.nodeBefore(n2, s.getElse())
    or
    p1.nodeAt(n1, s) and
    not exists(s.getElse()) and
    p2.nodeAfter(n2, s)
    or
    p1.nodeAfter(n1, s.getThen()) and
    p2.nodeAfter(n2, s)
    or
    p1.nodeAfter(n1, s.getElse()) and
    p2.nodeAfter(n2, s)
  )
  or
  // WhileStmt -> condition ; body -> condition ; after dtors -> after
  exists(WhileStmt s |
    p1.nodeAt(n1, s) and
    p2.nodeBefore(n2, s.getCondition())
    or
    p1.nodeAfter(n1, s.getStmt()) and
    p2.nodeBefore(n2, s.getCondition())
    or
    p1.nodeAfterDestructors(n1, s) and
    p2.nodeAfter(n2, s)
  )
  or
  // DoStmt -> body ; body -> condition ; after dtors -> after
  exists(DoStmt s |
    p1.nodeAt(n1, s) and
    p2.nodeBefore(n2, s.getStmt())
    or
    p1.nodeAfter(n1, s.getStmt()) and
    p2.nodeBefore(n2, s.getCondition())
    or
    p1.nodeAfterDestructors(n1, s) and
    p2.nodeAfter(n2, s)
  )
  or
  exists(DeclStmt s |
    // For static locals in C++, the declarations will be skipped after the
    // first init. We only check whether the first declared variable is static
    // since there is no syntax for declaring one variable static without all
    // of them becoming static.
    // There is no CFG for initialization of static locals in C, so this edge
    // is redundant there.
    s.getDeclaration(0).isStatic() and
    p1.nodeAt(n1, s) and
    p2.nodeAfter(n2, s)
  )
  or
  // SwitchCase ->
  // (note: doesn't evaluate its argument)
  exists(SwitchCase s |
    p1.nodeAt(n1, s) and
    p2.nodeAfter(n2, s)
  )
  or
  exists(Handler h |
    p1.nodeAt(n1, h) and
    p2.nodeBefore(n2, h.getBlock())
    or
    // If this is not a catch-all handler, add an edge to the next handler in
    // case it doesn't match.
    exists(int i, TryStmt try |
      h = try.getChild(i) and
      p1.nodeAt(n1, h) and
      p2.nodeAt(n2, try.getChild(i + 1))
    )
    or
    p1.nodeAt(n1, h) and
    p2.nodeBeforeDestructors(n2, h.(ExceptionSource))
    or
    p1.nodeAfterDestructors(n1, h) and
    p2.nodeBefore(n2, h.(ExceptionSource).getExceptionTarget())
  )
  or
  exists(CatchBlock cb |
    p1.nodeAfter(n1, cb) and
    p2.nodeAfter(n2, cb.getTryStmt())
  )
  or
  // Additional edges for `MicrosoftTryFinallyStmt` for the case where an
  // exception is propagated. It gets its other edges from being a
  // `PreOrderNode` and a `Stmt`.
  exists(MicrosoftTryFinallyStmt s |
    p1.nodeAfter(n1, s) and
    p2.nodeBeforeDestructors(n2, s)
    or
    p1.nodeAfterDestructors(n1, s) and
    p2.nodeBefore(n2, s.(ExceptionSource).getExceptionTarget())
  )
}

/**
 * Holds if there should be a sub-edge from `(n1, p1)` to `(n2, p2)`. This
 * predicate includes all sub-edges except those with true/false labels (see
 * `conditionJumps`).
 */
private predicate subEdgeIncludingDestructors(Pos p1, Node n1, Node n2, Pos p2) {
  subEdge(p1, n1, n2, p2)
  or
  // If `n1` has sub-nodes to accommodate destructors, but there are none to be
  // called, connect the "before destructors" node directly to the "after
  // destructors" node. For performance, only do this when the nodes exist.
  exists(Pos afterDtors | afterDtors.isAfterDestructors() | subEdge(afterDtors, n1, _, _)) and
  not exists(getSynthesisedDestructorCallAfterNode(n1, 0)) and
  p1.nodeBeforeDestructors(n1, n1) and
  p2.nodeAfterDestructors(n2, n1)
  or
  exists(Node n |
    // before destructors -> access(max)
    exists(int maxCallIndex |
      maxCallIndex = max(int i | exists(getSynthesisedDestructorCallAfterNode(n, i))) and
      p1.nodeBeforeDestructors(n1, n) and
      p2.nodeAt(n2, getSynthesisedDestructorCallAfterNode(n, maxCallIndex).getQualifier())
    )
    or
    // call(i+1) -> access(i)
    exists(int i |
      p1.nodeAt(n1, getSynthesisedDestructorCallAfterNode(n, i + 1)) and
      p2.nodeAt(n2, getSynthesisedDestructorCallAfterNode(n, i).getQualifier())
    )
    or
    // call(0) -> after destructors end
    p1.nodeAt(n1, getSynthesisedDestructorCallAfterNode(n, 0)) and
    p2.nodeAfterDestructors(n2, n)
  )
}

/**
 * Gets the synthetic constructor call for the `index`'th entity that
 * should be destructed following `node`. Note that entities should be
 * destructed in reverse construction order, so these should be called
 * from highest to lowest index.
 *
 * The exact placement of that call in the CFG depends on the type of
 * `node` as follows:
 *
 * - `BlockStmt`: after ordinary control flow falls off the end of the block
 *   without jumps or exceptions.
 * - `ReturnStmt`: After the statement itself or after its operand (if
 *   present).
 * - `ThrowExpr`: After the `throw` expression or after its operand (if
 *   present).
 * - `JumpStmt` (`BreakStmt`, `ContinueStmt`, `GotoStmt`): after the statement.
 * - A `ForStmt`, `WhileStmt`, `SwitchStmt`, or `IfStmt`: after control flow
 *   falls off the end of the statement without jumping. Destruction can occur
 *   here for `for`-loops that have an initializer (`for (C x = a; ...; ...)`)
 *   and for statements whose condition is a `ConditionDeclExpr`
 *   (`if (C x = a)`).
 * - The `getUpdate()` of a `ForStmt`: after the `getUpdate()` expression. This
 *   can happen when the condition is a `ConditionDeclExpr`
 * - `Handler`: On the edge out of the `Handler` for the case where the
 *   exception was not matched and is propagated to the next handler or
 *   function exit point.
 * - `MicrosoftTryExceptStmt`: After the false-edge out of the `e` in
 *   `__except(e)`, before propagating the exception up to the next handler or
 *   function exit point.
 * - `MicrosoftTryFinallyStmt`: On the edge following the `__finally` block for
 *   the case where an exception was thrown and needs to be propagated.
 */
DestructorCall getSynthesisedDestructorCallAfterNode(Node n, int i) {
  synthetic_destructor_call(n, i, result)
}

/**
 * An expression whose outgoing true/false sub-edges may come from different
 * sub-nodes.
 */
abstract private class ShortCircuitOperator extends Expr {
  final Expr getFirstChildNode() { result = this.getChild(0) }
}

/** An expression whose control flow is the same as `&&`. */
private class LogicalAndLikeExpr extends ShortCircuitOperator, LogicalAndExpr { }

/** An expression whose control flow is the same as `||`. */
private class LogicalOrLikeExpr extends ShortCircuitOperator {
  Expr left;
  Expr right;

  LogicalOrLikeExpr() {
    this =
      any(LogicalOrExpr e |
        left = e.getLeftOperand() and
        right = e.getRightOperand()
      )
    or
    // GNU extension: the binary `? :` operator
    this =
      any(ConditionalExpr e |
        e.isTwoOperand() and
        left = e.getCondition() and
        right = e.getElse()
      )
  }

  Expr getLeftOperand() { result = left }

  Expr getRightOperand() { result = right }
}

/** An expression whose control flow is the same as `b ? x : y`. */
private class ConditionalLikeExpr extends ShortCircuitOperator {
  Expr condition;
  Expr thenExpr;
  Expr elseExpr;

  ConditionalLikeExpr() {
    this =
      any(ConditionalExpr e |
        not e.isTwoOperand() and
        condition = e.getCondition() and
        thenExpr = e.getThen() and
        elseExpr = e.getElse()
      )
    or
    this =
      any(BuiltInChooseExpr e |
        condition = e.getChild(0) and
        thenExpr = e.getChild(1) and
        elseExpr = e.getChild(2)
      )
  }

  Expr getCondition() { result = condition }

  Expr getThen() { result = thenExpr }

  Expr getElse() { result = elseExpr }
}

/**
 * A `Handler` that might fail to match its exception and instead propagate it
 * further up the AST. This can happen in the last `Handler` of a `TryStmt` if
 * it's not a catch-all handler.
 */
private class PropagatingHandler extends Handler {
  PropagatingHandler() {
    exists(this.getParameter()) and
    exists(int i, TryStmt try |
      this = try.getChild(i) and
      i = max(int j | exists(try.getChild(j)))
    )
  }
}

/** A control-flow node that might pass an exception up in the AST. */
private class ExceptionSource extends Node {
  ExceptionSource() {
    this instanceof ThrowExpr
    or
    this instanceof PropagatingHandler
    or
    // By reusing the same set of predicates for Microsoft exceptions and C++
    // exceptions, we're pretending that their handlers can catch each other.
    // This may or may not be true depending on compiler options.
    this instanceof MicrosoftTryExceptStmt
    or
    this instanceof MicrosoftTryFinallyStmt
  }

  private predicate reachesParent(Node parent) {
    parent = this.(Expr).getEnclosingStmt()
    or
    parent = this.(Stmt)
    or
    exists(Node mid |
      this.reachesParent(mid) and
      not mid = any(TryStmt try).getStmt() and
      not mid = any(MicrosoftTryStmt try).getStmt() and
      parent = mid.getParentNode()
    )
  }

  /**
   * Gets the target node where this exception source will jump in case it
   * throws or propagates an exception. The jump will target the "before"
   * position of this node, not the "at" position. This is because possible
   * jump targets include the condition of a `MicrosoftTryExceptStmt`, which is
   * an `Expr`.
   */
  Node getExceptionTarget() {
    exists(Stmt parent | this.reachesParent(parent) |
      result.(Function).getEntryPoint() = parent
      or
      exists(TryStmt try |
        parent = try.getStmt() and
        result = try.getChild(1)
      )
      or
      exists(MicrosoftTryExceptStmt try |
        parent = try.getStmt() and
        result = try.getCondition()
      )
      or
      exists(MicrosoftTryFinallyStmt try |
        parent = try.getStmt() and
        result = try.getFinally()
      )
    )
  }
}

/**
 * Holds if `test` is the test of a control-flow construct where the `truth`
 * sub-edge goes to `(n2, p2)`.
 */
private predicate conditionJumpsTop(Expr test, boolean truth, Node n2, Pos p2) {
  exists(IfStmt s | test = s.getCondition() |
    truth = true and
    p2.nodeBefore(n2, s.getThen())
    or
    truth = false and
    p2.nodeBefore(n2, s.getElse())
    or
    not exists(s.getElse()) and
    truth = false and
    p2.nodeBeforeDestructors(n2, s)
  )
  or
  exists(ConstexprIfStmt s, string cond |
    test = s.getCondition() and
    cond = test.getFullyConverted().getValue()
  |
    truth = true and
    cond != "0" and
    p2.nodeBefore(n2, s.getThen())
    or
    truth = false and
    cond = "0" and
    p2.nodeBefore(n2, s.getElse())
    or
    not exists(s.getElse()) and
    truth = false and
    cond = "0" and
    p2.nodeBeforeDestructors(n2, s)
  )
  or
  exists(Loop l |
    (
      l instanceof WhileStmt
      or
      l instanceof DoStmt
      or
      l instanceof ForStmt
    ) and
    test = l.getCondition()
  |
    truth = true and
    p2.nodeBefore(n2, l.getStmt())
    or
    truth = false and
    p2.nodeBeforeDestructors(n2, l)
  )
  or
  exists(RangeBasedForStmt for | test = for.getCondition() |
    truth = true and
    exists(DeclStmt declStmt |
      declStmt.getADeclaration() = for.getVariable() and
      p2.nodeBefore(n2, declStmt)
    )
    or
    truth = false and
    p2.nodeAfter(n2, for)
  )
  or
  exists(MicrosoftTryExceptStmt try | test = try.getCondition() |
    truth = true and
    p2.nodeBefore(n2, try.getExcept())
    or
    // Actually, this test is ternary. The extractor CFG doesn't model that
    // either.
    truth = false and
    p2.nodeBeforeDestructors(n2, try)
  )
}

/**
 * Holds if there should be a `truth`-labeled sub-edge from _after_ `test` to
 * `(n2, p2)`. This can be because `test` is used in a condition context or
 * because it's a short-circuiting operator in a non-condition context such as
 * `x = a || b`. In the latter case, both the true and the false sub-edge go to
 * the same place, and later steps will turn such pairs into normal edges.
 */
private predicate conditionJumps(Expr test, boolean truth, Node n2, Pos p2) {
  conditionJumpsTop(test, truth, n2, p2)
  or
  // When true and false go to the same place, it's just a normal edge. But we
  // fix this up via post-processing.
  not conditionJumpsTop(test, _, _, _) and
  test instanceof ShortCircuitOperator and
  p2.nodeAfter(n2, test) and
  (truth = false or truth = true)
  or
  exists(ConditionalLikeExpr e |
    (test = e.getThen() or test = e.getElse()) and
    conditionJumps(e, truth, n2, p2)
  )
  or
  exists(ConditionalLikeExpr e | test = e.getCondition() |
    truth = true and
    p2.nodeBefore(n2, e.getThen())
    or
    truth = false and
    p2.nodeBefore(n2, e.getElse())
  )
  or
  exists(LogicalAndLikeExpr e |
    test = e.getLeftOperand() and
    truth = true and
    p2.nodeBefore(n2, e.getRightOperand())
    or
    test = e.getLeftOperand() and
    truth = false and
    conditionJumps(e, false, n2, p2)
    or
    test = e.getRightOperand() and
    conditionJumps(e, truth, n2, p2)
  )
  or
  exists(LogicalOrLikeExpr e |
    test = e.getLeftOperand() and
    truth = false and
    p2.nodeBefore(n2, e.getRightOperand())
    or
    test = e.getLeftOperand() and
    truth = true and
    conditionJumps(e, true, n2, p2)
    or
    test = e.getRightOperand() and
    conditionJumps(e, truth, n2, p2)
  )
}

// Pulled out for performance. See
// https://github.com/github/codeql-coreql-team/issues/1044.
private predicate normalGroupMemberBaseCase(Node memberNode, Pos memberPos, Node atNode) {
  memberNode = atNode and
  memberPos.isAt() and
  // We check for excludeNode here as it's slower to check in all the leaf
  // cases during construction of the sub-graph.
  not excludeNode(atNode)
}

/**
 * Holds if the sub-node `(memberNode, memberPos)` can reach `at(atNode)` by
 * following sub-edges forward without crossing another "at" node. Here,
 * `memberPos.isAt()` holds only when `memberNode = atNode`.
 */
private predicate normalGroupMember(Node memberNode, Pos memberPos, Node atNode) {
  normalGroupMemberBaseCase(memberNode, memberPos, atNode)
  or
  exists(Node succNode, Pos succPos |
    normalGroupMember(succNode, succPos, atNode) and
    not memberPos.isAt() and
    subEdgeIncludingDestructors(memberPos, memberNode, succNode, succPos)
  )
}

/**
 * Holds if the sub-node `(memberNode, memberPos)` can reach `after(test)`
 * by following sub-edges forward without _entering_ an "at" node. That means
 * `(memberNode, memberPos)` can be an "at" node, but it can't come before one.
 */
private predicate precedesCondition(Node memberNode, Pos memberPos, Node test) {
  memberNode = test and
  memberPos.isAfter() and
  conditionJumps(test, _, _, _)
  or
  exists(Node succNode, Pos succPos |
    precedesCondition(succNode, succPos, test) and
    subEdgeIncludingDestructors(memberPos, memberNode, succNode, succPos) and
    // Unlike the similar TC in normalGroupMember we're here including the
    // At-node in the group. This should generalize better to the case where
    // the base case isn't always an After-node.
    not succPos.isAt()
  )
}

/**
 * Holds if `n2` is a `truth`-successor of `n1` in the CFG after all virtual
 * sub-nodes have been collapsed away. This predicate includes cases where both
 * the false and true edges have the same target, but these will be filtered
 * away in subsequent predicates.
 */
private predicate conditionalSuccessor(Node n1, boolean truth, Node n2) {
  // To find true/false edges, we search forward and backward among the
  // ordinary sub-edges from a true/false sub-edge, stopping at At-nodes. Then
  // link, with true/false, any At-nodes found backwards with any At-nodes
  // found forward.
  exists(Node test, Node targetNode, Pos targetPos |
    precedesCondition(n1, any(Pos at | at.isAt()), test) and
    conditionJumps(test, truth, targetNode, targetPos) and
    normalGroupMember(targetNode, targetPos, n2)
  )
}

import Cached

cached
private module Cached {
  /**
   * Holds if `n2` is a successor of `n1` in the CFG. This includes also
   * true-successors and false-successors.
   */
  cached
  predicate qlCfgSuccessor(Node n1, Node n2) {
    exists(Node memberNode, Pos memberPos |
      subEdgeIncludingDestructors(any(Pos at | at.isAt()), n1, memberNode, memberPos) and
      normalGroupMember(memberNode, memberPos, n2)
    )
    or
    conditionalSuccessor(n1, _, n2)
  }

  /**
   * Holds if `n2` is a control-flow node such that the control-flow
   * edge `(n1, n2)` may be taken when `n1` is an expression that is true.
   */
  cached
  predicate qlCfgTrueSuccessor(Node n1, Node n2) {
    conditionalSuccessor(n1, true, n2) and
    not conditionalSuccessor(n1, false, n2)
  }

  /**
   * Holds if `n2` is a control-flow node such that the control-flow
   * edge `(n1, n2)` may be taken when `n1` is an expression that is false.
   */
  cached
  predicate qlCfgFalseSuccessor(Node n1, Node n2) {
    conditionalSuccessor(n1, false, n2) and
    not conditionalSuccessor(n1, true, n2)
  }
}
