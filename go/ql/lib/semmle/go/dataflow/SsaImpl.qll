/**
 * INTERNAL: Analyses should use module `SSA` instead.
 *
 * Provides predicates for constructing an SSA representation for functions.
 */

import go

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
   * A data type representing SSA definitions.
   *
   * We distinguish three kinds of SSA definitions:
   *
   *   1. Variable definitions, including declarations, assignments and increments/decrements.
   *   2. Pseudo-definitions for captured variables at the beginning of the capturing function
   *      as well as after calls.
   *   3. Phi nodes.
   *
   * SSA definitions are only introduced where necessary. In particular,
   * unreachable code has no SSA definitions associated with it, and neither
   * have dead assignments (that is, assignments whose value is never read).
   */
  cached
  newtype TSsaDefinition =
    /**
     * An SSA definition that corresponds to an explicit assignment or other variable definition.
     */
    TExplicitDef(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
      defAt(bb, i, v) and
      (liveAfterDef(bb, i, v) or v.isCaptured())
    } or
    /**
     * An SSA definition representing the capturing of an SSA-convertible variable
     * in the closure of a nested function.
     *
     * Capturing definitions appear at the beginning of such functions, as well as
     * at any function call that may affect the value of the variable.
     */
    TCapture(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
      mayCapture(bb, i, v) and
      liveAfterDef(bb, i, v)
    } or
    /**
     * An SSA phi node, that is, a pseudo-definition for a variable at a point
     * in the flow graph where otherwise two or more definitions for the variable
     * would be visible.
     */
    TPhi(ReachableJoinBlock bb, SsaSourceVariable v) {
      liveAtEntry(bb, v) and
      inDefDominanceFrontier(bb, v)
    }

  /**
   * Holds if `bb` is in the dominance frontier of a block containing a definition of `v`.
   */
  pragma[noinline]
  private predicate inDefDominanceFrontier(ReachableJoinBlock bb, SsaSourceVariable v) {
    exists(ReachableBasicBlock defbb, SsaDefinition def |
      def.definesAt(defbb, _, v) and
      bb.inDominanceFrontierOf(defbb)
    )
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
  private predicate mayCapture(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
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
   * Gets the maximum rank among all references to `v` in basic block `bb`.
   */
  private int maxRefRank(ReachableBasicBlock bb, SsaSourceVariable v) {
    result = max(refRank(bb, _, v, _))
  }

  /**
   * Holds if variable `v` is live after the `i`th node of basic block `bb`, where
   * `i` is the index of a node that may assign or capture `v`.
   *
   * For the purposes of this predicate, function calls are considered as writes of captured variables.
   */
  private predicate liveAfterDef(ReachableBasicBlock bb, int i, SsaSourceVariable v) {
    exists(int r | r = refRank(bb, i, v, WriteRef()) |
      // the next reference to `v` inside `bb` is a read
      r + 1 = refRank(bb, _, v, ReadRef())
      or
      // this is the last reference to `v` inside `bb`, but `v` is live at entry
      // to a successor basic block of `bb`
      r = maxRefRank(bb, v) and
      liveAtSuccEntry(bb, v)
    )
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
   */
  private predicate ssaRef(ReachableBasicBlock bb, int i, SsaSourceVariable v, RefKind k) {
    useAt(bb, i, v) and k = ReadRef()
    or
    any(SsaDefinition def).definesAt(bb, i, v) and k = WriteRef()
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
      exists(int j | result.definesAt(bb, j, v) and ssaRefRank(bb, j, v, _) = r - 1)
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
      result.definesAt(bb, lastRef, v) and
      liveAtSuccEntry(bb, v)
    )
    or
    // In SSA form, the (unique) reaching definition of a use is the closest
    // definition that dominates the use. If two definitions dominate a node
    // then one must dominate the other, so we can find the reaching definition
    // by following the idominance relation backwards.
    result = getDefReachingEndOfImmediateDominator(bb, v) and
    not exists(SsaDefinition ssa | ssa.definesAt(bb, _, v)) and
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
}

import Internal
