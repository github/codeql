/**
 * INTERNAL: Analyses should use module `SSA` instead.
 *
 * Provides predicates for constructing an SSA representation for functions.
 */

import go
private import codeql.ssa.Ssa as SsaImplCommon

cached
private module Internal {
  /** Holds if the `i`th node of `bb` defines `v`. */
  cached
  predicate defAt(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    bb.getNode(i).(IR::Instruction).writes(v, _)
  }

  /** Holds if the `i`th node of `bb` reads `v`. */
  cached
  predicate useAt(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    bb.getNode(i).(IR::Instruction).reads(v)
  }

  /**
   * Holds if `v` is a captured variable which is declared in `declFun` and read in `useFun`.
   */
  private predicate readsCapturedVar(FuncDef useFun, SsaSourceVariable v, FuncDef declFun) {
    declFun = v.getDeclaringFunction() and
    useFun = any(IR::Instruction u | u.reads(v)).getRoot() and
    v.isCaptured()
  }

  /** Holds if the `i`th node of `bb` in function `f` is an entry node. */
  private predicate entryNode(FuncDef f, ReachableBasicBlock bb, int i) {
    f = bb.getRoot() and
    bb.getNode(i).isEntryNode()
  }

  /**
   * Holds if the `i`th node of `bb` in function `f` is a function call.
   */
  private predicate callNode(FuncDef f, ReachableBasicBlock bb, int i) {
    f = bb.getRoot() and
    bb.getNode(i).(IR::EvalInstruction).getExpr() instanceof CallExpr
  }

  /**
   * Holds if the `i`th node of basic block `bb` may induce a pseudo-definition for
   * modeling updates to captured variable `v`. Whether the definition is actually
   * introduced depends on whether `v` is live at this point in the program.
   */
  cached
  predicate mayCapture(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    exists(FuncDef capturingContainer, FuncDef declContainer |
      // capture initial value of variable declared in enclosing scope
      readsCapturedVar(capturingContainer, v, declContainer) and
      capturingContainer != declContainer and
      entryNode(capturingContainer, bb, i)
      or
      // re-capture value of variable after a call if it is assigned non-locally
      readsCapturedVar(capturingContainer, v, declContainer) and
      assignedThroughClosure(v) and
      callNode(capturingContainer, bb, i)
    )
  }

  /** A classification of variable references into reads and writes. */
  private newtype RefKind =
    ReadRef() or
    WriteRef()

  /**
   * Holds if the `i`th node of basic block `bb` is a reference to `v`, either a read
   * (when `tp` is `ReadRef()`) or a direct or indirect write (when `tp` is `WriteRef()`).
   */
  private predicate ref(ReachableBasicBlock bb, int i, SsaSourceVariable v, RefKind tp) {
    useAt(bb, i, v) and tp = ReadRef()
    or
    (mayCapture(bb, i, v) or defAt(bb, i, v)) and
    tp = WriteRef()
  }

  /**
   * Gets the (1-based) rank of the reference to `v` at the `i`th node of basic block `bb`,
   * which has the given reference kind `tp`.
   */
  private int refRank(ReachableBasicBlock bb, int i, SsaSourceVariable v, RefKind tp) {
    i = rank[result](int j | ref(bb, j, v, _)) and
    ref(bb, i, v, tp)
  }

  /**
   * Holds if variable `v` is live at the beginning of basic block `bb`.
   *
   * For the purposes of this predicate, function calls are considered as writes of captured variables.
   */
  private predicate liveAtEntry(ReachableBasicBlock bb, SsaSourceVariable v) {
    // the first reference to `v` inside `bb` is a read
    refRank(bb, _, v, ReadRef()) = 1
    or
    // there is no reference to `v` inside `bb`, but `v` is live at entry
    // to a successor basic block of `bb`
    not exists(refRank(bb, _, v, _)) and
    liveAtSuccEntry(bb, v)
  }

  /**
   * Holds if `v` is live at the beginning of any successor of basic block `bb`.
   */
  private predicate liveAtSuccEntry(ReachableBasicBlock bb, SsaSourceVariable v) {
    liveAtEntry(bb.getASuccessor(), v)
  }

  /**
   * Holds if `v` is assigned outside its declaring function.
   */
  private predicate assignedThroughClosure(SsaSourceVariable v) {
    any(IR::Instruction def | def.writes(v, _)).getRoot() != v.getDeclaringFunction()
  }

  /**
   * Holds if the `i`th node of `bb` is a use or an SSA definition of variable `v`, with
   * `k` indicating whether it is the former or the latter.
   *
   * Note this includes phi nodes, whereas `ref` above only includes explicit writes and captures.
   */
  private predicate ssaRef(ReachableBasicBlock bb, int i, SsaSourceVariable v, RefKind k) {
    useAt(bb, i, v) and k = ReadRef()
    or
    any(SsaDefinition def).definesAt(v, bb, i) and k = WriteRef()
  }

  /**
   * Gets the (1-based) rank of the `i`th node of `bb` among all SSA definitions
   * and uses of `v` in `bb`, with `k` indicating whether it is a definition or a use.
   *
   * For example, if `bb` is a basic block with a phi node for `v` (considered
   * to be at index -1), uses `v` at node 2 and defines it at node 5, we have:
   *
   * ```
   * ssaRefRank(bb, -1, v, WriteRef()) = 1    // phi node
   * ssaRefRank(bb,  2, v, ReadRef())  = 2    // use at node 2
   * ssaRefRank(bb,  5, v, WriteRef()) = 3    // definition at node 5
   * ```
   */
  private int ssaRefRank(ReachableBasicBlock bb, int i, SsaSourceVariable v, RefKind k) {
    i = rank[result](int j | ssaRef(bb, j, v, _)) and
    ssaRef(bb, i, v, k)
  }

  /**
   * Gets the minimum rank of a read in `bb` such that all references to `v` between that
   * read and the read at index `i` are reads (and not writes).
   */
  private int rewindReads(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    exists(int r | r = ssaRefRank(bb, i, v, ReadRef()) |
      exists(int j, RefKind k | r - 1 = ssaRefRank(bb, j, v, k) |
        k = ReadRef() and result = rewindReads(bb, j, v)
        or
        k = WriteRef() and result = r
      )
      or
      r = 1 and result = r
    )
  }

  /**
   * Gets the SSA definition of `v` in `bb` that reaches the read of `v` at node `i`, if any.
   */
  private SsaDefinition getLocalDefinition(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    exists(int r | r = rewindReads(bb, i, v) |
      exists(int j | result.definesAt(v, bb, j) and ssaRefRank(bb, j, v, _) = r - 1)
    )
  }

  /**
   * Gets an SSA definition of `v` that reaches the end of the immediate dominator of `bb`.
   */
  pragma[noinline]
  private SsaDefinition getDefReachingEndOfImmediateDominator(
    ReachableBasicBlock bb, SsaSourceVariable v
  ) {
    result = getDefReachingEndOf(bb.getImmediateDominator(), v)
  }

  /**
   * Gets an SSA definition of `v` that reaches the end of basic block `bb`.
   */
  cached
  SsaDefinition getDefReachingEndOf(ReachableBasicBlock bb, SsaSourceVariable v) {
    exists(int lastRef | lastRef = max(int i | ssaRef(bb, i, v, _)) |
      result = getLocalDefinition(bb, lastRef, v)
      or
      result.definesAt(v, bb, lastRef) and
      liveAtSuccEntry(bb, v)
    )
    or
    // In SSA form, the (unique) reaching definition of a use is the closest
    // definition that dominates the use. If two definitions dominate a node
    // then one must dominate the other, so we can find the reaching definition
    // by following the idominance relation backwards.
    result = getDefReachingEndOfImmediateDominator(bb, v) and
    not exists(SsaDefinition ssa | ssa.definesAt(v, bb, _)) and
    liveAtSuccEntry(bb, v)
  }

  /**
   * Gets the unique SSA definition of `v` whose value reaches the `i`th node of `bb`,
   * which is a use of `v`.
   */
  cached
  SsaDefinition getDefinition(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    result = getLocalDefinition(bb, i, v)
    or
    rewindReads(bb, i, v) = 1 and result = getDefReachingEndOf(bb.getImmediateDominator(), v)
  }

  private module AdjacentUsesImpl {
    /** Holds if `v` is defined or used in `b`. */
    private predicate varOccursInBlock(SsaSourceVariable v, ReachableBasicBlock b) {
      ssaRef(b, _, v, _)
    }

    /** Holds if `v` occurs in `b` or one of `b`'s transitive successors. */
    private predicate blockPrecedesVar(SsaSourceVariable v, ReachableBasicBlock b) {
      varOccursInBlock(v, b)
      or
      exists(getDefReachingEndOf(b, v))
    }

    /**
     * Holds if `v` occurs in `b1` and `b2` is one of `b1`'s successors.
     *
     * Factored out of `varBlockReaches` to force join order compared to the larger
     * set `blockPrecedesVar(v, b2)`.
     */
    pragma[noinline]
    private predicate varBlockReachesBaseCand(
      SsaSourceVariable v, ReachableBasicBlock b1, ReachableBasicBlock b2
    ) {
      varOccursInBlock(v, b1) and
      b2 = b1.getASuccessor()
    }

    /**
     * Holds if `b2` is a transitive successor of `b1` and `v` occurs in `b1` and
     * in `b2` or one of its transitive successors but not in any block on the path
     * between `b1` and `b2`. Unlike `varBlockReaches` this may include blocks `b2`
     * where `v` is dead.
     *
     * Factored out of `varBlockReaches` to force join order compared to the larger
     * set `blockPrecedesVar(v, b2)`.
     */
    pragma[noinline]
    private predicate varBlockReachesRecCand(
      SsaSourceVariable v, ReachableBasicBlock b1, ReachableBasicBlock mid, ReachableBasicBlock b2
    ) {
      varBlockReaches(v, b1, mid) and
      not varOccursInBlock(v, mid) and
      b2 = mid.getASuccessor()
    }

    /**
     * Holds if `b2` is a transitive successor of `b1` and `v` occurs in `b1` and
     * in `b2` or one of its transitive successors but not in any block on the path
     * between `b1` and `b2`.
     */
    private predicate varBlockReaches(
      SsaSourceVariable v, ReachableBasicBlock b1, ReachableBasicBlock b2
    ) {
      varBlockReachesBaseCand(v, b1, b2) and
      blockPrecedesVar(v, b2)
      or
      exists(ReachableBasicBlock mid |
        varBlockReachesRecCand(v, b1, mid, b2) and
        blockPrecedesVar(v, b2)
      )
    }

    /**
     * Holds if `b2` is a transitive successor of `b1` and `v` occurs in `b1` and
     * `b2` but not in any block on the path between `b1` and `b2`.
     */
    private predicate varBlockStep(
      SsaSourceVariable v, ReachableBasicBlock b1, ReachableBasicBlock b2
    ) {
      varBlockReaches(v, b1, b2) and
      varOccursInBlock(v, b2)
    }

    /**
     * Gets the maximum rank among all SSA references to `v` in basic block `bb`.
     */
    private int maxSsaRefRank(ReachableBasicBlock bb, SsaSourceVariable v) {
      result = max(ssaRefRank(bb, _, v, _))
    }

    /**
     * Holds if `v` occurs at index `i1` in `b1` and at index `i2` in `b2` and
     * there is a path between them without any occurrence of `v`.
     */
    pragma[nomagic]
    predicate adjacentVarRefs(
      SsaSourceVariable v, ReachableBasicBlock b1, int i1, ReachableBasicBlock b2, int i2
    ) {
      exists(int rankix |
        b1 = b2 and
        ssaRefRank(b1, i1, v, _) = rankix and
        ssaRefRank(b2, i2, v, _) = rankix + 1
      )
      or
      maxSsaRefRank(b1, v) = ssaRefRank(b1, i1, v, _) and
      varBlockStep(v, b1, b2) and
      ssaRefRank(b2, i2, v, _) = 1
    }

    predicate variableUse(SsaSourceVariable v, IR::Instruction use, ReachableBasicBlock bb, int i) {
      bb.getNode(i) = use and
      exists(SsaVariable sv |
        sv.getSourceVariable() = v and
        use = sv.getAUse()
      )
    }
  }

  private import AdjacentUsesImpl

  /**
   * Holds if the value defined at `def` can reach `use` without passing through
   * any other uses, but possibly through phi nodes.
   */
  cached
  predicate firstUse(SsaDefinition def, IR::Instruction use) {
    exists(SsaSourceVariable v, ReachableBasicBlock b1, int i1, ReachableBasicBlock b2, int i2 |
      adjacentVarRefs(v, b1, i1, b2, i2) and
      def.definesAt(v, b1, i1) and
      variableUse(v, use, b2, i2)
    )
    or
    exists(
      SsaSourceVariable v, SsaPhiNode redef, ReachableBasicBlock b1, int i1, ReachableBasicBlock b2,
      int i2
    |
      adjacentVarRefs(v, b1, i1, b2, i2) and
      def.definesAt(v, b1, i1) and
      redef.definesAt(v, b2, i2) and
      firstUse(redef, use)
    )
  }

  /**
   * Holds if `use1` and `use2` form an adjacent use-use-pair of the same SSA
   * variable, that is, the value read in `use1` can reach `use2` without passing
   * through any other use or any SSA definition of the variable.
   */
  cached
  predicate adjacentUseUseSameVar(IR::Instruction use1, IR::Instruction use2) {
    exists(SsaSourceVariable v, ReachableBasicBlock b1, int i1, ReachableBasicBlock b2, int i2 |
      adjacentVarRefs(v, b1, i1, b2, i2) and
      variableUse(v, use1, b1, i1) and
      variableUse(v, use2, b2, i2)
    )
  }

  /**
   * Holds if `use1` and `use2` form an adjacent use-use-pair of the same
   * `SsaSourceVariable`, that is, the value read in `use1` can reach `use2`
   * without passing through any other use or any SSA definition of the variable
   * except for phi nodes and uncertain implicit updates.
   */
  cached
  predicate adjacentUseUse(IR::Instruction use1, IR::Instruction use2) {
    adjacentUseUseSameVar(use1, use2)
    or
    exists(
      SsaSourceVariable v, SsaPhiNode def, ReachableBasicBlock b1, int i1, ReachableBasicBlock b2,
      int i2
    |
      adjacentVarRefs(v, b1, i1, b2, i2) and
      variableUse(v, use1, b1, i1) and
      def.definesAt(v, b2, i2) and
      firstUse(def, use2)
    )
  }

  private module SsaInput implements SsaImplCommon::InputSig<Location> {
    private import go as G

    class BasicBlock = G::BasicBlock;

    class ControlFlowNode = G::ControlFlow::Node;

    BasicBlock getImmediateBasicBlockDominator(BasicBlock bb) {
      result = bb.getImmediateDominator()
    }

    BasicBlock getABasicBlockSuccessor(BasicBlock bb) { result = bb.getASuccessor() }

    class SourceVariable = SsaSourceVariable;

    /**
     * Holds if the `i`th node of basic block `bb` is a (potential) write to source
     * variable `v`. The Boolean `certain` indicates whether the write is certain.
     *
     * This includes implicit writes via calls.
     */
    predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      defAt(bb, i, v) and
      certain = true
      or
      mayCapture(bb, i, v) and certain = true
    }

    /**
     * Holds if the `i`th of basic block `bb` reads source variable `v`.
     *
     * This includes implicit reads via calls.
     */
    predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      useAt(bb, i, v) and certain = true
      or
      mayCapture(bb, i, v) and certain = true
    }
  }

  import SsaImplCommon::Make<Location, SsaInput> as Impl

  final class ZZZDefinition = Impl::Definition;

  final class ZZZWriteDefinition = Impl::WriteDefinition;

  final class ZZZUncertainWriteDefinition = Impl::UncertainWriteDefinition;

  final class ZZZPhiNode = Impl::PhiNode;
}

import Internal

predicate captures = Internal::mayCapture/3;
