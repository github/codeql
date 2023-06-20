/**
 * Provides a language-independent implementation of static single assignment
 * (SSA) form.
 */

/** Provides the input specification of the SSA implementation. */
signature module InputSig {
  /**
   * A basic block, that is, a maximal straight-line sequence of control flow nodes
   * without branches or joins.
   */
  class BasicBlock {
    /** Gets a textual representation of this basic block. */
    string toString();
  }

  /**
   * Gets the basic block that immediately dominates basic block `bb`, if any.
   *
   * That is, all paths reaching `bb` from some entry point basic block must go
   * through the result.
   *
   * Example:
   *
   * ```csharp
   * int M(string s) {
   *   if (s == null)
   *     throw new ArgumentNullException(nameof(s));
   *   return s.Length;
   * }
   * ```
   *
   * The basic block starting on line 2 is an immediate dominator of
   * the basic block on line 4 (all paths from the entry point of `M`
   * to `return s.Length;` must go through the null check.
   */
  BasicBlock getImmediateBasicBlockDominator(BasicBlock bb);

  /** Gets an immediate successor of basic block `bb`, if any. */
  BasicBlock getABasicBlockSuccessor(BasicBlock bb);

  /**
   * An exit basic block, that is, a basic block whose last node is
   * an exit node.
   */
  class ExitBasicBlock extends BasicBlock;

  /** A variable that can be SSA converted. */
  class SourceVariable {
    /** Gets a textual representation of this variable. */
    string toString();
  }

  /**
   * Holds if the `i`th node of basic block `bb` is a (potential) write to source
   * variable `v`. The Boolean `certain` indicates whether the write is certain.
   *
   * Examples of uncertain writes are `ref` arguments in C#, where it is the callee
   * that may or may not update the argument.
   */
  predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain);

  /**
   * Holds if the `i`th node of basic block `bb` reads source variable `v`. The
   * Boolean `certain` indicates whether the read is certain.
   *
   * Examples of uncertain reads are pseudo-reads inserted at the end of a C# method
   * with a `ref` or `out` parameter, where it is the caller that may or may not read
   * the argument.
   */
  predicate variableRead(BasicBlock bb, int i, SourceVariable v, boolean certain);
}

/**
 * Provides an SSA implementation.
 *
 * The SSA construction is pruned based on liveness. That is, SSA definitions are only
 * constructed for `Input::variableWrite`s when it is possible to reach an
 * `Input::variableRead`, without going through a certain write (the same goes for `phi`
 * nodes). Whenever a variable is both read and written at the same index in some basic
 * block, the read is assumed to happen before the write.
 *
 * The result of invoking this parameterized module is not meant to be exposed directly;
 * instead, one should define a language-specific layer on top, and make sure to cache
 * all exposed predicates marked with
 *
 * ```
 * NB: If this predicate is exposed, it should be cached.
 * ```
 */
module Make<InputSig Input> {
  private import Input

  private BasicBlock getABasicBlockPredecessor(BasicBlock bb) {
    getABasicBlockSuccessor(result) = bb
  }

  /**
   * Liveness analysis (based on source variables) to restrict the size of the
   * SSA representation.
   */
  private module Liveness {
    /**
     * A classification of variable references into reads (of a given kind) and
     * (certain or uncertain) writes.
     */
    private newtype TRefKind =
      Read(boolean certain) { certain in [false, true] } or
      Write(boolean certain) { certain in [false, true] }

    private class RefKind extends TRefKind {
      string toString() {
        exists(boolean certain | this = Read(certain) and result = "read (" + certain + ")")
        or
        exists(boolean certain | this = Write(certain) and result = "write (" + certain + ")")
      }

      int getOrder() {
        this = Read(_) and
        result = 0
        or
        this = Write(_) and
        result = 1
      }
    }

    /**
     * Holds if the `i`th node of basic block `bb` is a reference to `v` of kind `k`.
     */
    predicate ref(BasicBlock bb, int i, SourceVariable v, RefKind k) {
      exists(boolean certain | variableRead(bb, i, v, certain) | k = Read(certain))
      or
      exists(boolean certain | variableWrite(bb, i, v, certain) | k = Write(certain))
    }

    private newtype OrderedRefIndex =
      MkOrderedRefIndex(int i, int tag) {
        exists(RefKind rk | ref(_, i, _, rk) | tag = rk.getOrder())
      }

    private OrderedRefIndex refOrd(BasicBlock bb, int i, SourceVariable v, RefKind k, int ord) {
      ref(bb, i, v, k) and
      result = MkOrderedRefIndex(i, ord) and
      ord = k.getOrder()
    }

    /**
     * Gets the (1-based) rank of the reference to `v` at the `i`th node of
     * basic block `bb`, which has the given reference kind `k`.
     *
     * Reads are considered before writes when they happen at the same index.
     */
    private int refRank(BasicBlock bb, int i, SourceVariable v, RefKind k) {
      refOrd(bb, i, v, k, _) =
        rank[result](int j, int ord, OrderedRefIndex res |
          res = refOrd(bb, j, v, _, ord)
        |
          res order by j, ord
        )
    }

    private int maxRefRank(BasicBlock bb, SourceVariable v) {
      result = refRank(bb, _, v, _) and
      not result + 1 = refRank(bb, _, v, _)
    }

    predicate lastRefIsRead(BasicBlock bb, SourceVariable v) {
      maxRefRank(bb, v) = refRank(bb, _, v, Read(_))
    }

    /**
     * Gets the (1-based) rank of the first reference to `v` inside basic block `bb`
     * that is either a read or a certain write.
     */
    private int firstReadOrCertainWrite(BasicBlock bb, SourceVariable v) {
      result =
        min(int r, RefKind k |
          r = refRank(bb, _, v, k) and
          k != Write(false)
        |
          r
        )
    }

    /**
     * Holds if source variable `v` is live at the beginning of basic block `bb`.
     */
    predicate liveAtEntry(BasicBlock bb, SourceVariable v) {
      // The first read or certain write to `v` inside `bb` is a read
      refRank(bb, _, v, Read(_)) = firstReadOrCertainWrite(bb, v)
      or
      // There is no certain write to `v` inside `bb`, but `v` is live at entry
      // to a successor basic block of `bb`
      not exists(firstReadOrCertainWrite(bb, v)) and
      liveAtExit(bb, v)
    }

    /**
     * Holds if source variable `v` is live at the end of basic block `bb`.
     */
    predicate liveAtExit(BasicBlock bb, SourceVariable v) {
      liveAtEntry(getABasicBlockSuccessor(bb), v)
    }

    /**
     * Holds if variable `v` is live in basic block `bb` at index `i`.
     * The rank of `i` is `rnk` as defined by `refRank()`.
     */
    private predicate liveAtRank(BasicBlock bb, int i, SourceVariable v, int rnk) {
      exists(RefKind kind | rnk = refRank(bb, i, v, kind) |
        rnk = maxRefRank(bb, v) and
        liveAtExit(bb, v)
        or
        ref(bb, i, v, kind) and
        kind = Read(_)
        or
        exists(RefKind nextKind |
          liveAtRank(bb, _, v, rnk + 1) and
          rnk + 1 = refRank(bb, _, v, nextKind) and
          nextKind != Write(true)
        )
      )
    }

    /**
     * Holds if variable `v` is live after the (certain or uncertain) write at
     * index `i` inside basic block `bb`.
     */
    predicate liveAfterWrite(BasicBlock bb, int i, SourceVariable v) {
      exists(int rnk | rnk = refRank(bb, i, v, Write(_)) | liveAtRank(bb, i, v, rnk))
    }
  }

  private import Liveness

  /**
   * Holds if `df` is in the dominance frontier of `bb`.
   *
   * This is equivalent to:
   *
   * ```ql
   * bb = getImmediateBasicBlockDominator*(getABasicBlockPredecessor(df)) and
   * not bb = getImmediateBasicBlockDominator+(df)
   * ```
   */
  private predicate inDominanceFrontier(BasicBlock bb, BasicBlock df) {
    bb = getABasicBlockPredecessor(df) and not bb = getImmediateBasicBlockDominator(df)
    or
    exists(BasicBlock prev | inDominanceFrontier(prev, df) |
      bb = getImmediateBasicBlockDominator(prev) and
      not bb = getImmediateBasicBlockDominator(df)
    )
  }

  /**
   * Holds if `bb` is in the dominance frontier of a block containing a
   * definition of `v`.
   */
  pragma[noinline]
  private predicate inDefDominanceFrontier(BasicBlock bb, SourceVariable v) {
    exists(BasicBlock defbb, Definition def |
      def.definesAt(v, defbb, _) and
      inDominanceFrontier(defbb, bb)
    )
  }

  /**
   * Holds if `bb` is in the dominance frontier of a block containing a
   * read of `v`.
   */
  pragma[nomagic]
  private predicate inReadDominanceFrontier(BasicBlock bb, SourceVariable v) {
    exists(BasicBlock readbb | inDominanceFrontier(readbb, bb) |
      lastRefIsRead(readbb, v)
      or
      exists(TPhiReadNode(v, readbb)) and
      not ref(readbb, _, v, _)
    )
  }

  cached
  private newtype TDefinitionExt =
    TWriteDef(SourceVariable v, BasicBlock bb, int i) {
      variableWrite(bb, i, v, _) and
      liveAfterWrite(bb, i, v)
    } or
    TPhiNode(SourceVariable v, BasicBlock bb) {
      inDefDominanceFrontier(bb, v) and
      liveAtEntry(bb, v)
    } or
    TPhiReadNode(SourceVariable v, BasicBlock bb) {
      inReadDominanceFrontier(bb, v) and
      liveAtEntry(bb, v) and
      // no need to create a phi-read if there is already a normal phi
      not any(PhiNode def).definesAt(v, bb, _)
    }

  private class TDefinition = TWriteDef or TPhiNode;

  private module SsaDefReaches {
    newtype TSsaRefKind =
      SsaActualRead() or
      SsaPhiRead() or
      SsaDef()

    class SsaRead = SsaActualRead or SsaPhiRead;

    class SsaDefExt = SsaDef or SsaPhiRead;

    SsaDefExt ssaDefExt() { any() }

    /**
     * A classification of SSA variable references into reads and definitions.
     */
    class SsaRefKind extends TSsaRefKind {
      string toString() {
        this = SsaActualRead() and
        result = "SsaActualRead"
        or
        this = SsaPhiRead() and
        result = "SsaPhiRead"
        or
        this = SsaDef() and
        result = "SsaDef"
      }

      int getOrder() {
        this instanceof SsaRead and
        result = 0
        or
        this = SsaDef() and
        result = 1
      }
    }

    /**
     * Holds if the `i`th node of basic block `bb` is a reference to `v`,
     * either a read (when `k` is `SsaActualRead()`), an SSA definition (when `k`
     * is `SsaDef()`), or a phi-read (when `k` is `SsaPhiRead()`).
     *
     * Unlike `Liveness::ref`, this includes `phi` (read) nodes.
     */
    pragma[nomagic]
    predicate ssaRef(BasicBlock bb, int i, SourceVariable v, SsaRefKind k) {
      variableRead(bb, i, v, _) and
      k = SsaActualRead()
      or
      any(DefinitionExt def).definesAt(v, bb, i, k)
    }

    /**
     * Holds if the `i`th node of basic block `bb` is a reference to `v`, and
     * this reference is not a phi-read.
     */
    predicate ssaRefNonPhiRead(BasicBlock bb, int i, SourceVariable v) {
      ssaRef(bb, i, v, [SsaActualRead().(TSsaRefKind), SsaDef()])
    }

    private newtype OrderedSsaRefIndex =
      MkOrderedSsaRefIndex(int i, SsaRefKind k) { ssaRef(_, i, _, k) }

    private OrderedSsaRefIndex ssaRefOrd(
      BasicBlock bb, int i, SourceVariable v, SsaRefKind k, int ord
    ) {
      ssaRef(bb, i, v, k) and
      result = MkOrderedSsaRefIndex(i, k) and
      ord = k.getOrder()
    }

    /**
     * Gets the (1-based) rank of the reference to `v` at the `i`th node of basic
     * block `bb`, which has the given reference kind `k`.
     *
     * For example, if `bb` is a basic block with a phi node for `v` (considered
     * to be at index -1), reads `v` at node 2, and defines it at node 5, we have:
     *
     * ```ql
     * ssaRefRank(bb, -1, v, SsaDef()) = 1    // phi node
     * ssaRefRank(bb,  2, v, Read())   = 2    // read at node 2
     * ssaRefRank(bb,  5, v, SsaDef()) = 3    // definition at node 5
     * ```
     *
     * Reads are considered before writes when they happen at the same index.
     */
    int ssaRefRank(BasicBlock bb, int i, SourceVariable v, SsaRefKind k) {
      ssaRefOrd(bb, i, v, k, _) =
        rank[result](int j, int ord, OrderedSsaRefIndex res |
          res = ssaRefOrd(bb, j, v, _, ord)
        |
          res order by j, ord
        )
    }

    int maxSsaRefRank(BasicBlock bb, SourceVariable v) {
      result = ssaRefRank(bb, _, v, _) and
      not result + 1 = ssaRefRank(bb, _, v, _)
    }

    /**
     * Holds if the SSA definition `def` reaches rank index `rnk` in its own
     * basic block `bb`.
     */
    predicate ssaDefReachesRank(BasicBlock bb, DefinitionExt def, int rnk, SourceVariable v) {
      exists(int i |
        rnk = ssaRefRank(bb, i, v, ssaDefExt()) and
        def.definesAt(v, bb, i, _)
      )
      or
      ssaDefReachesRank(bb, def, rnk - 1, v) and
      rnk = ssaRefRank(bb, _, v, SsaActualRead())
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches index `i` in the same
     * basic block `bb`, without crossing another SSA definition of `v`.
     */
    predicate ssaDefReachesReadWithinBlock(SourceVariable v, DefinitionExt def, BasicBlock bb, int i) {
      exists(int rnk |
        ssaDefReachesRank(bb, def, rnk, v) and
        rnk = ssaRefRank(bb, i, v, SsaActualRead())
      )
    }

    /**
     * Same as `ssaRefRank()`, but restricted to a particular SSA definition `def`.
     */
    int ssaDefRank(DefinitionExt def, SourceVariable v, BasicBlock bb, int i, SsaRefKind k) {
      result = ssaRefRank(bb, i, v, k) and
      (
        ssaDefReachesReadExt(v, def, bb, i)
        or
        def.definesAt(v, bb, i, k)
      )
    }

    /**
     * Holds if the reference to `def` at index `i` in basic block `bb` is the
     * last reference to `v` inside `bb`.
     */
    pragma[noinline]
    predicate lastSsaRefExt(DefinitionExt def, SourceVariable v, BasicBlock bb, int i) {
      ssaDefRank(def, v, bb, i, _) = maxSsaRefRank(bb, v)
    }

    /** Gets a phi-read node into which `inp` is an input, if any. */
    pragma[nomagic]
    private DefinitionExt getAPhiReadOutput(DefinitionExt inp) {
      phiHasInputFromBlockExt(result.(PhiReadNode), inp, _)
    }

    pragma[nomagic]
    DefinitionExt getAnUltimateOutput(Definition def) { result = getAPhiReadOutput*(def) }

    /**
     * Same as `lastSsaRefExt`, but ignores phi-reads.
     */
    pragma[noinline]
    predicate lastSsaRef(Definition def, SourceVariable v, BasicBlock bb, int i) {
      lastSsaRefExt(getAnUltimateOutput(def), v, bb, i) and
      ssaRefNonPhiRead(bb, i, v)
    }

    predicate defOccursInBlock(DefinitionExt def, BasicBlock bb, SourceVariable v, SsaRefKind k) {
      exists(ssaDefRank(def, v, bb, _, k))
    }

    pragma[noinline]
    private predicate ssaDefReachesThroughBlock(DefinitionExt def, BasicBlock bb) {
      exists(SourceVariable v |
        ssaDefReachesEndOfBlockExt(bb, def, v) and
        not defOccursInBlock(_, bb, v, _)
      )
    }

    /**
     * Holds if `def` is accessed in basic block `bb1` (either a read or a write),
     * `bb2` is a transitive successor of `bb1`, `def` is live at the end of _some_
     * predecessor of `bb2`, and the underlying variable for `def` is neither read
     * nor written in any block on the path between `bb1` and `bb2`.
     */
    pragma[nomagic]
    predicate varBlockReachesExt(DefinitionExt def, SourceVariable v, BasicBlock bb1, BasicBlock bb2) {
      defOccursInBlock(def, bb1, v, _) and
      bb2 = getABasicBlockSuccessor(bb1)
      or
      exists(BasicBlock mid |
        varBlockReachesExt(def, v, bb1, mid) and
        ssaDefReachesThroughBlock(def, mid) and
        bb2 = getABasicBlockSuccessor(mid)
      )
    }

    pragma[nomagic]
    private predicate phiReadStep(DefinitionExt def, PhiReadNode phi, BasicBlock bb1, BasicBlock bb2) {
      exists(SourceVariable v |
        varBlockReachesExt(pragma[only_bind_into](def), v, bb1, pragma[only_bind_into](bb2)) and
        phi.definesAt(v, bb2, _, _) and
        not ref(bb2, _, v, _)
      )
    }

    pragma[nomagic]
    private predicate varBlockReachesExclPhiRead(
      DefinitionExt def, SourceVariable v, BasicBlock bb1, BasicBlock bb2
    ) {
      varBlockReachesExt(def, v, bb1, bb2) and
      ssaRefNonPhiRead(bb2, _, v)
      or
      exists(PhiReadNode phi, BasicBlock mid |
        varBlockReachesExclPhiRead(phi, v, mid, bb2) and
        phiReadStep(def, phi, bb1, mid)
      )
    }

    /**
     * Same as `varBlockReachesExt`, but ignores phi-reads, and furthermore
     * `bb2` is restricted to blocks in which the underlying variable `v` of
     * `def` is referenced (either a read or a write).
     */
    pragma[nomagic]
    predicate varBlockReachesRef(Definition def, SourceVariable v, BasicBlock bb1, BasicBlock bb2) {
      varBlockReachesExclPhiRead(getAnUltimateOutput(def), v, bb1, bb2) and
      ssaRefNonPhiRead(bb1, _, v)
    }

    pragma[nomagic]
    predicate defAdjacentReadExt(DefinitionExt def, BasicBlock bb1, BasicBlock bb2, int i2) {
      exists(SourceVariable v |
        varBlockReachesExt(def, v, bb1, bb2) and
        ssaRefRank(bb2, i2, v, SsaActualRead()) = 1
      )
    }

    pragma[nomagic]
    predicate defAdjacentRead(Definition def, BasicBlock bb1, BasicBlock bb2, int i2) {
      exists(SourceVariable v | varBlockReachesRef(def, v, bb1, bb2) |
        ssaRefRank(bb2, i2, v, SsaActualRead()) = 1
        or
        ssaRefRank(bb2, _, v, SsaPhiRead()) = 1 and
        ssaRefRank(bb2, i2, v, SsaActualRead()) = 2
      )
    }

    /**
     * Holds if `def` is accessed in basic block `bb` (either a read or a write),
     * `bb` can reach a transitive successor `bb2` where `def` is no longer live,
     * and `v` is neither read nor written in any block on the path between `bb`
     * and `bb2`.
     */
    pragma[nomagic]
    predicate varBlockReachesExitExt(DefinitionExt def, BasicBlock bb) {
      exists(BasicBlock bb2 | varBlockReachesExt(def, _, bb, bb2) |
        not defOccursInBlock(def, bb2, _, _) and
        not ssaDefReachesEndOfBlockExt(bb2, def, _)
      )
    }

    pragma[nomagic]
    private predicate varBlockReachesExitExclPhiRead(DefinitionExt def, BasicBlock bb) {
      exists(BasicBlock bb2, SourceVariable v |
        varBlockReachesExt(def, v, bb, bb2) and
        not defOccursInBlock(def, bb2, _, _) and
        not ssaDefReachesEndOfBlockExt(bb2, def, _) and
        not any(PhiReadNode phi).definesAt(v, bb2, _, _)
      )
      or
      exists(PhiReadNode phi, BasicBlock bb2 |
        varBlockReachesExitExclPhiRead(phi, bb2) and
        phiReadStep(def, phi, bb, bb2)
      )
    }

    /**
     * Same as `varBlockReachesExitExt`, but ignores phi-reads.
     */
    pragma[nomagic]
    predicate varBlockReachesExit(Definition def, BasicBlock bb) {
      varBlockReachesExitExclPhiRead(getAnUltimateOutput(def), bb)
    }
  }

  private import SsaDefReaches

  pragma[nomagic]
  private predicate liveThroughExt(BasicBlock bb, SourceVariable v) {
    liveAtExit(bb, v) and
    not ssaRef(bb, _, v, ssaDefExt())
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Holds if the SSA definition of `v` at `def` reaches the end of basic
   * block `bb`, at which point it is still live, without crossing another
   * SSA definition of `v`.
   */
  pragma[nomagic]
  predicate ssaDefReachesEndOfBlockExt(BasicBlock bb, DefinitionExt def, SourceVariable v) {
    exists(int last |
      last = maxSsaRefRank(pragma[only_bind_into](bb), pragma[only_bind_into](v)) and
      ssaDefReachesRank(bb, def, last, v) and
      liveAtExit(bb, v)
    )
    or
    // The construction of SSA form ensures that each read of a variable is
    // dominated by its definition. An SSA definition therefore reaches a
    // control flow node if it is the _closest_ SSA definition that dominates
    // the node. If two definitions dominate a node then one must dominate the
    // other, so therefore the definition of _closest_ is given by the dominator
    // tree. Thus, reaching definitions can be calculated in terms of dominance.
    ssaDefReachesEndOfBlockExt(getImmediateBasicBlockDominator(bb), def, pragma[only_bind_into](v)) and
    liveThroughExt(bb, pragma[only_bind_into](v))
  }

  pragma[nomagic]
  private predicate phiReadReachesEndOfBlock(BasicBlock pred, BasicBlock bb, SourceVariable v) {
    exists(PhiReadNode phi |
      ssaDefReachesEndOfBlockExt(bb, phi, v) and
      pred = getImmediateBasicBlockDominator(phi.getBasicBlock())
    )
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Same as `ssaDefReachesEndOfBlockExt`, but ignores phi-reads.
   */
  pragma[nomagic]
  predicate ssaDefReachesEndOfBlock(BasicBlock bb, Definition def, SourceVariable v) {
    ssaDefReachesEndOfBlockExt(bb, def, v)
    or
    exists(BasicBlock mid |
      ssaDefReachesEndOfBlock(mid, def, v) and
      phiReadReachesEndOfBlock(mid, bb, v)
    )
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Holds if `inp` is an input to the phi node `phi` along the edge originating in `bb`.
   */
  pragma[nomagic]
  predicate phiHasInputFromBlock(PhiNode phi, Definition inp, BasicBlock bb) {
    exists(SourceVariable v, BasicBlock bbDef |
      phi.definesAt(v, bbDef, _) and
      getABasicBlockPredecessor(bbDef) = bb and
      ssaDefReachesEndOfBlock(bb, inp, v)
    )
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Holds if `inp` is an input to the phi (read) node `phi` along the edge originating in `bb`.
   */
  pragma[nomagic]
  predicate phiHasInputFromBlockExt(DefinitionExt phi, DefinitionExt inp, BasicBlock bb) {
    exists(SourceVariable v, BasicBlock bbDef |
      phi.definesAt(v, bbDef, _, _) and
      getABasicBlockPredecessor(bbDef) = bb and
      ssaDefReachesEndOfBlockExt(bb, inp, v)
    |
      phi instanceof PhiNode or
      phi instanceof PhiReadNode
    )
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Holds if the SSA definition of `v` at `def` reaches a read at index `i` in
   * basic block `bb`, without crossing another SSA definition of `v`.
   */
  pragma[nomagic]
  predicate ssaDefReachesReadExt(SourceVariable v, DefinitionExt def, BasicBlock bb, int i) {
    ssaDefReachesReadWithinBlock(v, def, bb, i)
    or
    ssaRef(bb, i, v, SsaActualRead()) and
    ssaDefReachesEndOfBlockExt(getABasicBlockPredecessor(bb), def, v) and
    not ssaDefReachesReadWithinBlock(v, _, bb, i)
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Same as `ssaDefReachesReadExt`, but ignores phi-reads.
   */
  pragma[nomagic]
  predicate ssaDefReachesRead(SourceVariable v, Definition def, BasicBlock bb, int i) {
    ssaDefReachesReadWithinBlock(v, def, bb, i)
    or
    ssaRef(bb, i, v, SsaActualRead()) and
    ssaDefReachesEndOfBlock(getABasicBlockPredecessor(bb), def, v) and
    not exists(Definition other | ssaDefReachesReadWithinBlock(v, other, bb, i))
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Holds if `def` is accessed at index `i1` in basic block `bb1` (either a read
   * or a write), `def` is read at index `i2` in basic block `bb2`, and there is a
   * path between them without any read of `def`.
   */
  pragma[nomagic]
  predicate adjacentDefReadExt(
    DefinitionExt def, SourceVariable v, BasicBlock bb1, int i1, BasicBlock bb2, int i2
  ) {
    exists(int rnk |
      rnk = ssaDefRank(def, v, bb1, i1, _) and
      rnk + 1 = ssaDefRank(def, v, bb1, i2, SsaActualRead()) and
      variableRead(bb1, i2, v, _) and
      bb2 = bb1
    )
    or
    lastSsaRefExt(def, v, bb1, i1) and
    defAdjacentReadExt(def, bb1, bb2, i2)
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Same as `adjacentDefReadExt`, but ignores phi-reads.
   */
  pragma[nomagic]
  predicate adjacentDefRead(Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2) {
    exists(SourceVariable v |
      adjacentDefReadExt(getAnUltimateOutput(def), v, bb1, i1, bb2, i2) and
      ssaRefNonPhiRead(bb1, i1, v)
    )
    or
    lastSsaRef(def, _, bb1, i1) and
    defAdjacentRead(def, bb1, bb2, i2)
  }

  pragma[noinline]
  deprecated private predicate adjacentDefRead(
    Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2, SourceVariable v
  ) {
    adjacentDefRead(def, bb1, i1, bb2, i2) and
    v = def.getSourceVariable()
  }

  deprecated private predicate adjacentDefReachesRead(
    Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2
  ) {
    exists(SourceVariable v | adjacentDefRead(def, bb1, i1, bb2, i2, v) |
      ssaRef(bb1, i1, v, SsaDef())
      or
      variableRead(bb1, i1, v, true)
    )
    or
    exists(BasicBlock bb3, int i3 |
      adjacentDefReachesRead(def, bb1, i1, bb3, i3) and
      variableRead(bb3, i3, _, false) and
      adjacentDefRead(def, bb3, i3, bb2, i2)
    )
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Same as `adjacentDefRead`, but ignores uncertain reads.
   */
  pragma[nomagic]
  deprecated predicate adjacentDefNoUncertainReads(
    Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2
  ) {
    adjacentDefReachesRead(def, bb1, i1, bb2, i2) and
    variableRead(bb2, i2, _, true)
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Holds if the node at index `i` in `bb` is a last reference to SSA definition
   * `def`. The reference is last because it can reach another write `next`,
   * without passing through another read or write.
   */
  pragma[nomagic]
  predicate lastRefRedefExt(
    DefinitionExt def, SourceVariable v, BasicBlock bb, int i, DefinitionExt next
  ) {
    // Next reference to `v` inside `bb` is a write
    exists(int rnk, int j |
      rnk = ssaDefRank(def, v, bb, i, _) and
      next.definesAt(v, bb, j, _) and
      rnk + 1 = ssaRefRank(bb, j, v, ssaDefExt())
    )
    or
    // Can reach a write using one or more steps
    lastSsaRefExt(def, v, bb, i) and
    exists(BasicBlock bb2 |
      varBlockReachesExt(def, v, bb, bb2) and
      1 = ssaDefRank(next, v, bb2, _, ssaDefExt())
    )
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Same as `lastRefRedefExt`, but ignores phi-reads.
   */
  pragma[nomagic]
  predicate lastRefRedef(Definition def, BasicBlock bb, int i, Definition next) {
    exists(SourceVariable v |
      lastRefRedefExt(getAnUltimateOutput(def), v, bb, i, next) and
      ssaRefNonPhiRead(bb, i, v)
    )
    or
    // Can reach a write using one or more steps
    exists(SourceVariable v |
      lastSsaRef(def, v, bb, i) and
      exists(BasicBlock bb2 |
        varBlockReachesRef(def, v, bb, bb2) and
        1 = ssaDefRank(next, v, bb2, _, SsaDef())
      )
    )
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Holds if `inp` is an immediately preceding definition of uncertain definition
   * `def`. Since `def` is uncertain, the value from the preceding definition might
   * still be valid.
   */
  pragma[nomagic]
  predicate uncertainWriteDefinitionInput(UncertainWriteDefinition def, Definition inp) {
    lastRefRedef(inp, _, _, def)
  }

  deprecated private predicate adjacentDefReachesUncertainRead(
    Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2
  ) {
    adjacentDefReachesRead(def, bb1, i1, bb2, i2) and
    variableRead(bb2, i2, _, false)
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Same as `lastRefRedef`, but ignores uncertain reads.
   */
  pragma[nomagic]
  deprecated predicate lastRefRedefNoUncertainReads(
    Definition def, BasicBlock bb, int i, Definition next
  ) {
    lastRefRedef(def, bb, i, next) and
    not variableRead(bb, i, def.getSourceVariable(), false)
    or
    exists(BasicBlock bb0, int i0 |
      lastRefRedef(def, bb0, i0, next) and
      adjacentDefReachesUncertainRead(def, bb, i, bb0, i0)
    )
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Holds if the node at index `i` in `bb` is a last reference to SSA
   * definition `def`.
   *
   * That is, the node can reach the end of the enclosing callable, or another
   * SSA definition for the underlying source variable, without passing through
   * another read.
   */
  pragma[nomagic]
  predicate lastRefExt(DefinitionExt def, BasicBlock bb, int i) {
    // Can reach another definition
    lastRefRedefExt(def, _, bb, i, _)
    or
    lastSsaRefExt(def, _, bb, i) and
    (
      // Can reach exit directly
      bb instanceof ExitBasicBlock
      or
      // Can reach a block using one or more steps, where `def` is no longer live
      varBlockReachesExitExt(def, bb)
    )
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Same as `lastRefExt`, but ignores phi-reads.
   */
  pragma[nomagic]
  predicate lastRef(Definition def, BasicBlock bb, int i) {
    // Can reach another definition
    lastRefRedef(def, bb, i, _)
    or
    lastSsaRef(def, _, bb, i) and
    (
      // Can reach exit directly
      bb instanceof ExitBasicBlock
      or
      // Can reach a block using one or more steps, where `def` is no longer live
      varBlockReachesExit(def, bb)
    )
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Same as `lastRefRedef`, but ignores uncertain reads.
   */
  pragma[nomagic]
  deprecated predicate lastRefNoUncertainReads(Definition def, BasicBlock bb, int i) {
    lastRef(def, bb, i) and
    not variableRead(bb, i, def.getSourceVariable(), false)
    or
    exists(BasicBlock bb0, int i0 |
      lastRef(def, bb0, i0) and
      adjacentDefReachesUncertainRead(def, bb, i, bb0, i0)
    )
  }

  /** A static single assignment (SSA) definition. */
  class Definition extends TDefinition {
    /** Gets the source variable underlying this SSA definition. */
    SourceVariable getSourceVariable() { this.definesAt(result, _, _) }

    /**
     * Holds if this SSA definition defines `v` at index `i` in basic block `bb`.
     * Phi nodes are considered to be at index `-1`, while normal variable writes
     * are at the index of the control flow node they wrap.
     */
    final predicate definesAt(SourceVariable v, BasicBlock bb, int i) {
      this = TWriteDef(v, bb, i)
      or
      this = TPhiNode(v, bb) and i = -1
    }

    /** Gets the basic block to which this SSA definition belongs. */
    final BasicBlock getBasicBlock() { this.definesAt(_, result, _) }

    /** Gets a textual representation of this SSA definition. */
    string toString() { result = "SSA def(" + this.getSourceVariable() + ")" }
  }

  /** An SSA definition that corresponds to a write. */
  class WriteDefinition extends Definition, TWriteDef {
    private SourceVariable v;
    private BasicBlock bb;
    private int i;

    WriteDefinition() { this = TWriteDef(v, bb, i) }
  }

  /** A phi node. */
  class PhiNode extends Definition, TPhiNode {
    override string toString() { result = "SSA phi(" + this.getSourceVariable() + ")" }
  }

  /**
   * An SSA definition that represents an uncertain update of the underlying
   * source variable.
   */
  class UncertainWriteDefinition extends WriteDefinition {
    UncertainWriteDefinition() {
      exists(SourceVariable v, BasicBlock bb, int i |
        this.definesAt(v, bb, i) and
        variableWrite(bb, i, v, false)
      )
    }
  }

  /**
   * An extended static single assignment (SSA) definition.
   *
   * This is either a normal SSA definition (`Definition`) or a
   * phi-read node (`PhiReadNode`).
   */
  class DefinitionExt extends TDefinitionExt {
    /** Gets the source variable underlying this SSA definition. */
    SourceVariable getSourceVariable() { this.definesAt(result, _, _, _) }

    /**
     * Holds if this SSA definition defines `v` at index `i` in basic block `bb`.
     * Phi nodes are considered to be at index `-1`, while normal variable writes
     * are at the index of the control flow node they wrap.
     */
    final predicate definesAt(SourceVariable v, BasicBlock bb, int i, SsaRefKind kind) {
      this.(Definition).definesAt(v, bb, i) and
      kind = SsaDef()
      or
      this = TPhiReadNode(v, bb) and i = -1 and kind = SsaPhiRead()
    }

    /** Gets the basic block to which this SSA definition belongs. */
    final BasicBlock getBasicBlock() { this.definesAt(_, result, _, _) }

    /** Gets a textual representation of this SSA definition. */
    string toString() { result = this.(Definition).toString() }
  }

  /**
   * A phi-read node.
   *
   * Phi-read nodes are like normal phi nodes, but they are inserted based on reads
   * instead of writes, and only if the dominance-frontier block does not already
   * contain a normal phi node.
   *
   * The motivation for adding phi-reads is to improve performance of the use-use
   * calculation in cases where there is a large number of reads that can reach the
   * same join-point, and from there reach a large number of basic blocks. Example:
   *
   * ```cs
   * if (a)
   *   use(x);
   * else if (b)
   *   use(x);
   * else if (c)
   *   use(x);
   * else if (d)
   *   use(x);
   * // many more ifs ...
   *
   * // phi-read for `x` inserted here
   *
   * // program not mentioning `x`, with large basic block graph
   *
   * use(x);
   * ```
   *
   * Without phi-reads, the analysis has to replicate reachability for each of
   * the guarded uses of `x`. However, with phi-reads, the analysis will limit
   * each conditional use of `x` to reach the basic block containing the phi-read
   * node for `x`, and only that basic block will have to compute reachability
   * through the remainder of the large program.
   *
   * Another motivation for phi-reads is when a large number of reads can reach
   * another large number of reads:
   *
   * ```cs
   * if (a)
   *   use(x);
   * else if (b)
   *   use(x);
   * else if (c)
   *   use(x);
   * else if (d)
   *   use(x);
   * // many more ifs ...
   *
   * // phi-read for `x` inserted here
   *
   * if (a)
   *   use(x);
   * else if (b)
   *   use(x);
   * else if (c)
   *   use(x);
   * else if (d)
   *   use(x);
   * // many more ifs ...
   * ```
   *
   * Without phi-reads, one needs to add `n*m` data-flow edges (assuming `n` reads
   * before the phi-read and `m` reads after the phi-read), whereas if we include
   * phi-reads in the data-flow graph, we only need to add `n+m` edges.
   *
   * Like normal reads, each phi-read node `phi-read` can be reached from exactly
   * one SSA definition (without passing through another definition): Assume, for
   * the sake of contradiction, that there are two reaching definitions `def1` and
   * `def2`. Now, if both `def1` and `def2` dominate `phi-read`, then the nearest
   * dominating definition will prevent the other from reaching `phi-read`. So, at
   * least one of `def1` and `def2` cannot dominate `phi-read`; assume it is `def1`.
   * Then `def1` must go through one of its dominance-frontier blocks in order to
   * reach `phi-read`. However, such a block will always start with a (normal) phi
   * node, which contradicts reachability.
   *
   * Also, like normal reads, the unique SSA definition `def` that reaches `phi-read`,
   * will dominate `phi-read`. Assuming it doesn't means that the path from `def`
   * to `phi-read` goes through a dominance-frontier block, and hence a phi node,
   * which contradicts reachability.
   */
  class PhiReadNode extends DefinitionExt, TPhiReadNode {
    override string toString() { result = "SSA phi read(" + this.getSourceVariable() + ")" }
  }

  /** Provides a set of consistency queries. */
  module Consistency {
    /** A definition that is relevant for the consistency queries. */
    abstract class RelevantDefinition extends Definition {
      /** Override this predicate to ensure locations in consistency results. */
      abstract predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      );
    }

    /** A definition that is relevant for the consistency queries. */
    abstract class RelevantDefinitionExt extends DefinitionExt {
      /** Override this predicate to ensure locations in consistency results. */
      abstract predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      );
    }

    /** Holds if a read can be reached from multiple definitions. */
    query predicate nonUniqueDef(RelevantDefinition def, SourceVariable v, BasicBlock bb, int i) {
      ssaDefReachesRead(v, def, bb, i) and
      not exists(unique(Definition def0 | ssaDefReachesRead(v, def0, bb, i)))
    }

    /** Holds if a read can be reached from multiple definitions. */
    query predicate nonUniqueDefExt(
      RelevantDefinitionExt def, SourceVariable v, BasicBlock bb, int i
    ) {
      ssaDefReachesReadExt(v, def, bb, i) and
      not exists(unique(DefinitionExt def0 | ssaDefReachesReadExt(v, def0, bb, i)))
    }

    /** Holds if a read cannot be reached from a definition. */
    query predicate readWithoutDef(SourceVariable v, BasicBlock bb, int i) {
      variableRead(bb, i, v, _) and
      not ssaDefReachesRead(v, _, bb, i)
    }

    /** Holds if a read cannot be reached from a definition. */
    query predicate readWithoutDefExt(SourceVariable v, BasicBlock bb, int i) {
      variableRead(bb, i, v, _) and
      not ssaDefReachesReadExt(v, _, bb, i)
    }

    /** Holds if a definition cannot reach a read. */
    query predicate deadDef(RelevantDefinition def, SourceVariable v) {
      v = def.getSourceVariable() and
      not ssaDefReachesRead(_, def, _, _) and
      not phiHasInputFromBlock(_, def, _) and
      not uncertainWriteDefinitionInput(_, def)
    }

    /** Holds if a definition cannot reach a read. */
    query predicate deadDefExt(RelevantDefinitionExt def, SourceVariable v) {
      v = def.getSourceVariable() and
      not ssaDefReachesReadExt(_, def, _, _) and
      not phiHasInputFromBlockExt(_, def, _) and
      not uncertainWriteDefinitionInput(_, def)
    }

    /** Holds if a read is not dominated by a definition. */
    query predicate notDominatedByDef(RelevantDefinition def, SourceVariable v, BasicBlock bb, int i) {
      exists(BasicBlock bbDef, int iDef | def.definesAt(v, bbDef, iDef) |
        ssaDefReachesReadWithinBlock(v, def, bb, i) and
        (bb != bbDef or i < iDef)
        or
        ssaDefReachesRead(v, def, bb, i) and
        not ssaDefReachesReadWithinBlock(v, def, bb, i) and
        not def.definesAt(v, getImmediateBasicBlockDominator*(bb), _)
      )
    }

    /** Holds if a read is not dominated by a definition. */
    query predicate notDominatedByDefExt(
      RelevantDefinitionExt def, SourceVariable v, BasicBlock bb, int i
    ) {
      exists(BasicBlock bbDef, int iDef | def.definesAt(v, bbDef, iDef, _) |
        ssaDefReachesReadWithinBlock(v, def, bb, i) and
        (bb != bbDef or i < iDef)
        or
        ssaDefReachesReadExt(v, def, bb, i) and
        not ssaDefReachesReadWithinBlock(v, def, bb, i) and
        not def.definesAt(v, getImmediateBasicBlockDominator*(bb), _, _)
      )
    }
  }
}
