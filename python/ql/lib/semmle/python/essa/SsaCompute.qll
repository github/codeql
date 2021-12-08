/**
 * Provides predicates for computing Enhanced SSA form
 * Computation of ESSA form is identical to plain SSA form,
 * but what counts as a use of definition differs.
 *
 * ## Language independent data-flow graph construction
 *
 * Construction of the data-flow graph is based on the principles behind SSA variables.
 *
 * The definition of an SSA variable is that (statically):
 *
 * * Each variable has exactly one definition
 * * A variable's definition dominates all its uses.
 *
 * SSA form was originally designed for compiler use and thus a "definition" of an SSA variable is
 * the same as a definition of the underlying source-code variable. For register allocation this is
 * sufficient to treat the variable as equivalent to the value held in the variable.
 *
 * However, this doesn't always work the way we want it for data-flow analysis.
 *
 * When we start to consider attribute assignment, tests on the value referred to be a variable,
 * escaping variables, implicit definitions, etc., we need something finer grained.
 *
 * A data-flow variable has the same properties as a normal SSA variable, but it also has the property that
 * *anything* that may change the way we view an object referred to by a variable should be treated as a definition of that variable.
 *
 * For example, tests are treated as definitions, so for the following Python code:
 * ```python
 * x = None
 * if not x:
 *      x = True
 * ```
 * The data-flow graph (for `x`) is:
 * ```
 * x0 = None
 * x1 = pi(x0, not x)
 * x2 = True
 * x3 = phi(x1, x2)
 * ```
 * from which is it possible to infer that `x3` may not be None.
 * [ Phi functions are standard SSA, a Pi function is a filter or guard on the possible values that a variable
 * may hold]
 *
 * Attribute assignments are also treated as definitions, so for the following Python code:
 * ```python
 * x = C()
 * x.a = 1
 * y = C()
 * y.b = 2
 * ```
 * The data-flow graph is:
 * ```
 * x0 = C()
 * x1 = attr-assign(x0, .a = 1)
 * y0 = C()
 * y1 = attr-assign(y0, .b = 1)
 * ```
 * From which we can infer that `x1.a` is `1` but we know nothing about `y0.a` despite it being the same type.
 *
 * We can also insert "definitions" for transfers of values (say in global variables) where we do not yet know the call-graph. For example,
 * ```python
 * def foo():
 *     global g
 *     g = 1
 *
 * def bar():
 *     foo()
 *     g
 * ```
 * It should be clear in the above code that the use of `g` will have a value of `1`.
 * The data-flow graph looks like:
 * ```python
 * def foo():
 *     g0 = scope-entry(g)
 *     g1 = 1
 *
 * def bar():
 *     g2 = scope-entry(g)
 *     foo()
 *     g3 = call-site(g, foo())
 * ```
 * Once we have established that `foo()` calls `foo`, then it is possible to link `call-site(g, foo())` to the final value of `g` in `foo`, i.e. `g1`, so effectively `g3 = call-site(g, foo())` becomes `g3 = g1` and the global data-flow graph for `g` effectively becomes:
 * ```
 * g0 = scope-entry(g)
 * g1 = 1
 * g2 = scope-entry(g)
 * g3 = g1
 * ```
 * and thus it falls out that `g3` must be `1`.
 */

import python
private import semmle.python.internal.CachedStages

cached
private module SsaComputeImpl {
  cached
  module EssaDefinitionsImpl {
    /** Whether `n` is a live update that is a definition of the variable `v`. */
    cached
    predicate variableDefinition(
      SsaSourceVariable v, ControlFlowNode n, BasicBlock b, int rankix, int i
    ) {
      SsaComputeImpl::variableDefine(v, n, b, i) and
      SsaComputeImpl::defUseRank(v, b, rankix, i) and
      (
        SsaComputeImpl::defUseRank(v, b, rankix + 1, _) and
        not SsaComputeImpl::defRank(v, b, rankix + 1, _)
        or
        not SsaComputeImpl::defUseRank(v, b, rankix + 1, _) and Liveness::liveAtExit(v, b)
      )
    }

    /** Whether `n` is a live update that is a definition of the variable `v`. */
    cached
    predicate variableRefinement(
      SsaSourceVariable v, ControlFlowNode n, BasicBlock b, int rankix, int i
    ) {
      SsaComputeImpl::variableRefine(v, n, b, i) and
      SsaComputeImpl::defUseRank(v, b, rankix, i) and
      (
        SsaComputeImpl::defUseRank(v, b, rankix + 1, _) and
        not SsaComputeImpl::defRank(v, b, rankix + 1, _)
        or
        not SsaComputeImpl::defUseRank(v, b, rankix + 1, _) and Liveness::liveAtExit(v, b)
      )
    }

    cached
    predicate variableUpdate(SsaSourceVariable v, ControlFlowNode n, BasicBlock b, int rankix, int i) {
      variableDefinition(v, n, b, rankix, i)
      or
      variableRefinement(v, n, b, rankix, i)
    }

    /** Holds if `def` is a pi-node for `v` on the edge `pred` -> `succ` */
    cached
    predicate piNode(SsaSourceVariable v, BasicBlock pred, BasicBlock succ) {
      v.hasRefinementEdge(_, pred, succ) and
      Liveness::liveAtEntry(v, succ)
    }

    /** Holds if there is a phi node for `v` at the beginning of basic block `b`. */
    cached
    predicate phiNode(SsaSourceVariable v, BasicBlock b) {
      (
        exists(BasicBlock def | def.dominanceFrontier(b) | SsaComputeImpl::ssaDef(v, def))
        or
        piNode(v, _, b) and strictcount(b.getAPredecessor()) > 1
      ) and
      Liveness::liveAtEntry(v, b)
    }
  }

  cached
  predicate variableDefine(SsaSourceVariable v, ControlFlowNode n, BasicBlock b, int i) {
    v.hasDefiningNode(n) and
    exists(int j |
      n = b.getNode(j) and
      i = j * 2 + 1
    )
  }

  cached
  predicate variableRefine(SsaSourceVariable v, ControlFlowNode n, BasicBlock b, int i) {
    v.hasRefinement(_, n) and
    exists(int j |
      n = b.getNode(j) and
      i = j * 2 + 1
    )
  }

  cached
  predicate variableDef(SsaSourceVariable v, ControlFlowNode n, BasicBlock b, int i) {
    variableDefine(v, n, b, i) or variableRefine(v, n, b, i)
  }

  /**
   * Holds if the `rankix`th definition or use of the SSA variable `v` in the basic block `b` occurs
   * at index `i`.
   *
   * Basic block indices are translated to rank indices in order to skip
   * irrelevant indices at which there is no definition or use when traversing
   * basic blocks.
   */
  cached
  predicate defUseRank(SsaSourceVariable v, BasicBlock b, int rankix, int i) {
    i = rank[rankix](int j | variableDef(v, _, b, j) or variableUse(v, _, b, j))
  }

  /** Holds if there is a definition of a variable occurring at the specified rank index in basic block `b`. */
  cached
  predicate defRank(SsaSourceVariable v, BasicBlock b, int rankix, int i) {
    variableDef(v, _, b, i) and
    defUseRank(v, b, rankix, i)
  }

  /** Holds if there is a variable access `use` of `v` in `b` at index `i`. */
  cached
  predicate variableUse(SsaSourceVariable v, ControlFlowNode use, BasicBlock b, int i) {
    (v.getAUse() = use or v.hasRefinement(use, _)) and
    exists(int j |
      b.getNode(j) = use and
      i = 2 * j
    )
  }

  /**
   * Holds if there is a definition of an SSA variable occurring at the specified position.
   * This is either a phi node, a `VariableUpdate`, or a parameter.
   */
  cached
  predicate ssaDef(SsaSourceVariable v, BasicBlock b) {
    EssaDefinitions::phiNode(v, b)
    or
    EssaDefinitions::variableUpdate(v, _, b, _, _)
    or
    EssaDefinitions::piNode(v, _, b)
  }

  /*
   * The construction of SSA form ensures that each use of a variable is
   * dominated by its definition. A definition of an SSA variable therefore
   * reaches a `ControlFlowNode` if it is the _closest_ SSA variable definition
   * that dominates the node. If two definitions dominate a node then one must
   * dominate the other, so therefore the definition of _closest_ is given by the
   * dominator tree. Thus, reaching definitions can be calculated in terms of
   * dominance.
   */

  /** Gets the maximum rank index for the given variable and basic block. */
  cached
  int lastRank(SsaSourceVariable v, BasicBlock b) {
    result = max(int rankix | defUseRank(v, b, rankix, _))
    or
    not defUseRank(v, b, _, _) and
    (EssaDefinitions::phiNode(v, b) or EssaDefinitions::piNode(v, _, b)) and
    result = 0
  }

  private predicate ssaDefRank(SsaSourceVariable v, BasicBlock b, int rankix, int i) {
    EssaDefinitions::variableUpdate(v, _, b, rankix, i)
    or
    EssaDefinitions::phiNode(v, b) and rankix = 0 and i = phiIndex()
    or
    EssaDefinitions::piNode(v, _, b) and
    EssaDefinitions::phiNode(v, b) and
    rankix = -1 and
    i = piIndex()
    or
    EssaDefinitions::piNode(v, _, b) and
    not EssaDefinitions::phiNode(v, b) and
    rankix = 0 and
    i = piIndex()
  }

  /** Holds if the SSA definition reaches the rank index `rankix` in its own basic block `b`. */
  cached
  predicate ssaDefReachesRank(SsaSourceVariable v, BasicBlock b, int i, int rankix) {
    ssaDefRank(v, b, rankix, i)
    or
    ssaDefReachesRank(v, b, i, rankix - 1) and
    rankix <= lastRank(v, b) and
    not ssaDefRank(v, b, rankix, _)
  }

  /**
   * Holds if the SSA definition of `v` at `def` reaches `use` in the same basic block
   * without crossing another SSA definition of `v`.
   */
  cached
  predicate ssaDefReachesUseWithinBlock(
    SsaSourceVariable v, BasicBlock b, int i, ControlFlowNode use
  ) {
    exists(int rankix, int useix |
      ssaDefReachesRank(v, b, i, rankix) and
      defUseRank(v, b, rankix, useix) and
      variableUse(v, use, b, useix)
    )
  }

  cached
  module LivenessImpl {
    cached
    predicate liveAtExit(SsaSourceVariable v, BasicBlock b) { liveAtEntry(v, b.getASuccessor()) }

    cached
    predicate liveAtEntry(SsaSourceVariable v, BasicBlock b) {
      SsaComputeImpl::defUseRank(v, b, 1, _) and not SsaComputeImpl::defRank(v, b, 1, _)
      or
      not SsaComputeImpl::defUseRank(v, b, _, _) and liveAtExit(v, b)
    }
  }

  cached
  module SsaDefinitionsImpl {
    pragma[noinline]
    private predicate reachesEndOfBlockRec(
      SsaSourceVariable v, BasicBlock defbb, int defindex, BasicBlock b
    ) {
      exists(BasicBlock idom | reachesEndOfBlock(v, defbb, defindex, idom) |
        idom = b.getImmediateDominator()
      )
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches the end of a basic block `b`, at
     * which point it is still live, without crossing another SSA definition of `v`.
     */
    cached
    predicate reachesEndOfBlock(SsaSourceVariable v, BasicBlock defbb, int defindex, BasicBlock b) {
      Stages::AST::ref() and
      Liveness::liveAtExit(v, b) and
      (
        defbb = b and
        SsaComputeImpl::ssaDefReachesRank(v, defbb, defindex, SsaComputeImpl::lastRank(v, b))
        or
        // It is sufficient to traverse the dominator graph, cf. discussion above.
        reachesEndOfBlockRec(v, defbb, defindex, b) and
        not SsaComputeImpl::ssaDef(v, b)
      )
    }

    /**
     * Holds if the SSA definition of `v` at `(defbb, defindex)` reaches `use` without crossing another
     * SSA definition of `v`.
     */
    cached
    predicate reachesUse(SsaSourceVariable v, BasicBlock defbb, int defindex, ControlFlowNode use) {
      SsaComputeImpl::ssaDefReachesUseWithinBlock(v, defbb, defindex, use)
      or
      exists(BasicBlock b |
        SsaComputeImpl::variableUse(v, use, b, _) and
        reachesEndOfBlock(v, defbb, defindex, b.getAPredecessor()) and
        not SsaComputeImpl::ssaDefReachesUseWithinBlock(v, b, _, use)
      )
    }

    /**
     * Holds if `(defbb, defindex)` is an SSA definition of `v` that reaches an exit without crossing another
     * SSA definition of `v`.
     */
    cached
    predicate reachesExit(SsaSourceVariable v, BasicBlock defbb, int defindex) {
      exists(BasicBlock last, ControlFlowNode use, int index |
        not Liveness::liveAtExit(v, last) and
        reachesUse(v, defbb, defindex, use) and
        SsaComputeImpl::defUseRank(v, last, SsaComputeImpl::lastRank(v, last), index) and
        SsaComputeImpl::variableUse(v, use, last, index)
      )
    }
  }

  cached
  module AdjacentUsesImpl {
    /**
     * Holds if `rankix` is the rank the index `i` at which there is an SSA definition or explicit use of
     * `v` in the basic block `b`.
     */
    cached
    predicate defSourceUseRank(SsaSourceVariable v, BasicBlock b, int rankix, int i) {
      i = rank[rankix](int j | variableDefine(v, _, b, j) or variableSourceUse(v, _, b, j))
    }

    /** Holds if there is a variable access `use` of `v` in `b` at index `i`. */
    cached
    predicate variableSourceUse(SsaSourceVariable v, ControlFlowNode use, BasicBlock b, int i) {
      v.getASourceUse() = use and
      exists(int j |
        b.getNode(j) = use and
        i = 2 * j
      )
    }

    /** Gets the maximum rank index for the given variable and basic block. */
    private int lastSourceUseRank(SsaSourceVariable v, BasicBlock b) {
      result = max(int rankix | defSourceUseRank(v, b, rankix, _))
    }

    /** Holds if `v` is defined or used in `b`. */
    private predicate varOccursInBlock(SsaSourceVariable v, BasicBlock b) {
      defSourceUseRank(v, b, _, _)
    }

    /** Holds if `v` occurs in `b` or one of `b`'s transitive successors. */
    private predicate blockPrecedesVar(SsaSourceVariable v, BasicBlock b) {
      varOccursInBlock(v, b)
      or
      SsaDefinitionsImpl::reachesEndOfBlock(v, _, _, b)
    }

    /**
     * Holds if `b2` is a transitive successor of `b1` and `v` occurs in `b1` and
     * in `b2` or one of its transitive successors but not in any block on the path
     * between `b1` and `b2`.
     */
    private predicate varBlockReaches(SsaSourceVariable v, BasicBlock b1, BasicBlock b2) {
      varOccursInBlock(v, b1) and
      b2 = b1.getASuccessor() and
      blockPrecedesVar(v, b2)
      or
      exists(BasicBlock mid |
        varBlockReaches(v, b1, mid) and
        b2 = mid.getASuccessor() and
        not varOccursInBlock(v, mid) and
        blockPrecedesVar(v, b2)
      )
    }

    /**
     * Holds if `b2` is a transitive successor of `b1` and `v` occurs in `b1` and
     * `b2` but not in any block on the path between `b1` and `b2`.
     */
    private predicate varBlockStep(SsaSourceVariable v, BasicBlock b1, BasicBlock b2) {
      varBlockReaches(v, b1, b2) and
      varOccursInBlock(v, b2)
    }

    /**
     * Holds if `v` occurs at index `i1` in `b1` and at index `i2` in `b2` and
     * there is a path between them without any occurrence of `v`.
     */
    cached
    predicate adjacentVarRefs(SsaSourceVariable v, BasicBlock b1, int i1, BasicBlock b2, int i2) {
      exists(int rankix |
        b1 = b2 and
        defSourceUseRank(v, b1, rankix, i1) and
        defSourceUseRank(v, b2, rankix + 1, i2)
      )
      or
      defSourceUseRank(v, b1, lastSourceUseRank(v, b1), i1) and
      varBlockStep(v, b1, b2) and
      defSourceUseRank(v, b2, 1, i2)
    }

    /**
     * Holds if `use1` is a use of the variable `v`, and there exists an adjacent reference to `v`
     * in basic block `b1` at index `i1`.
     *
     * A helper predicate for `adjacentUseUseSameVar`, to prevent the first join from being between
     * the two instances of `variableSourceUse` in
     * ```ql
     * exists(SsaSourceVariable v, BasicBlock b1, int i1, BasicBlock b2, int i2 |
     *     adjacentVarRefs(v, b1, i1, b2, i2) and
     *     variableSourceUse(v, use1, b1, i1) and
     *     variableSourceUse(v, use2, b2, i2)
     * )
     * ```
     */
    pragma[nomagic]
    private predicate adjacentRefUse(
      SsaSourceVariable v, BasicBlock b2, int i2, ControlFlowNode use1
    ) {
      exists(BasicBlock b1, int i1 |
        adjacentVarRefs(v, b1, i1, b2, i2) and
        variableSourceUse(v, use1, b1, i1)
      )
    }

    /**
     * Holds if `use1` and `use2` form an adjacent use-use-pair of the same SSA
     * variable, that is, the value read in `use1` can reach `use2` without passing
     * through any other use or any SSA definition of the variable.
     */
    cached
    predicate adjacentUseUseSameVar(ControlFlowNode use1, ControlFlowNode use2) {
      exists(SsaSourceVariable v, BasicBlock b2, int i2 |
        adjacentRefUse(v, b2, i2, use1) and
        variableSourceUse(v, use2, b2, i2)
      )
    }

    /**
     * Holds if `use1` and `use2` form an adjacent use-use-pair of the same
     * `SsaSourceVariable`, that is, the value read in `use1` can reach `use2`
     * without passing through any other use or any SSA definition of the variable
     * except for phi nodes.
     */
    cached
    predicate adjacentUseUse(ControlFlowNode use1, ControlFlowNode use2) {
      adjacentUseUseSameVar(use1, use2)
      or
      exists(SsaSourceVariable v, PhiFunction def, BasicBlock b1, int i1, BasicBlock b2, int i2 |
        adjacentVarRefs(v, b1, i1, b2, i2) and
        variableUse(pragma[only_bind_into](v), use1, b1, i1) and
        definesAt(def, pragma[only_bind_into](v), b2, i2) and
        firstUse(def, use2)
      )
    }

    /**
     * Holds if the value defined at `def` can reach `use` without passing through
     * any other uses, but possibly through phi nodes.
     */
    cached
    predicate firstUse(EssaDefinition def, ControlFlowNode use) {
      exists(SsaSourceVariable v, BasicBlock b1, int i1, BasicBlock b2, int i2 |
        adjacentVarRefs(v, b1, i1, b2, i2) and
        definesAt(def, v, b1, i1) and
        variableSourceUse(v, use, b2, i2)
      )
      or
      exists(
        SsaSourceVariable v, EssaDefinition redef, BasicBlock b1, int i1, BasicBlock b2, int i2
      |
        redef instanceof PhiFunction
      |
        adjacentVarRefs(v, b1, i1, b2, i2) and
        definesAt(def, v, b1, i1) and
        definesAt(redef, v, b2, i2) and
        firstUse(redef, use)
      )
    }

    /**
     * Holds if `def` defines `v` at the specified position.
     * Phi nodes are placed at index -1.
     */
    cached
    predicate definesAt(EssaDefinition def, SsaSourceVariable v, BasicBlock b, int i) {
      exists(ControlFlowNode defNode |
        def.(EssaNodeDefinition).definedBy(v, defNode) and
        variableDefine(v, defNode, b, i)
      )
      or
      v = def.(PhiFunction).getSourceVariable() and
      b = def.(PhiFunction).getBasicBlock() and
      i = -1
    }

    /**
     * Holds if the value defined at `def` can reach `use`, possibly through phi nodes.
     */
    cached
    predicate useOfDef(EssaDefinition def, ControlFlowNode use) {
      exists(ControlFlowNode firstUse |
        firstUse(def, firstUse) and
        adjacentUseUse*(firstUse, use)
      )
    }
  }
}

import SsaComputeImpl::SsaDefinitionsImpl as SsaDefinitions
import SsaComputeImpl::EssaDefinitionsImpl as EssaDefinitions
import SsaComputeImpl::LivenessImpl as Liveness
import SsaComputeImpl::AdjacentUsesImpl as AdjacentUses

/* This is exported primarily for testing */
/*
 * A note on numbering
 * In order to create an SSA graph, we need an order of definitions and uses within a basic block.
 * To do this we index definitions and uses as follows:
 *  Phi-functions have an index of -1, so precede all normal uses and definitions in a block.
 *  Pi-functions (on edges) have an index of -2 in the successor block, so precede all other uses and definitions, including phi-functions
 *  A use of a variable at at a CFG node is assumed to occur before any definition at the same node, so:
 *   * a use at the `j`th node of a block is given the index `2*j` and
 *   * a definition  at the `j`th node of a block is given the index `2*j + 1`.
 */

pragma[inline]
int phiIndex() { result = -1 }

pragma[inline]
int piIndex() { result = -2 }
