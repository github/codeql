/**
 * Provides a language-independent implementation of static single assignment
 * (SSA) form.
 */

private import codeql.util.Location
private import codeql.util.Unit

/** Provides the input specification of the SSA implementation. */
signature module InputSig<LocationSig Location> {
  /**
   * A basic block, that is, a maximal straight-line sequence of control flow nodes
   * without branches or joins.
   */
  class BasicBlock {
    /** Gets a textual representation of this basic block. */
    string toString();

    /** Gets the `i`th node in this basic block. */
    ControlFlowNode getNode(int i);

    /** Gets the length of this basic block. */
    int length();

    /** Gets the location of this basic block. */
    Location getLocation();
  }

  /** A control flow node. */
  class ControlFlowNode {
    /** Gets a textual representation of this control flow node. */
    string toString();

    /** Gets the location of this control flow node. */
    Location getLocation();
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

  /** A variable that can be SSA converted. */
  class SourceVariable {
    /** Gets a textual representation of this variable. */
    string toString();

    /** Gets the location of this variable. */
    Location getLocation();
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
module Make<LocationSig Location, InputSig<Location> Input> {
  private import Input

  private BasicBlock getABasicBlockPredecessor(BasicBlock bb) {
    getABasicBlockSuccessor(result) = bb
  }

  /**
   * A classification of variable references into reads and
   * (certain or uncertain) writes / definitions.
   */
  private newtype TRefKind =
    Read() or
    Write(boolean certain) { certain in [false, true] } or
    Def()

  private class RefKind extends TRefKind {
    string toString() {
      this = Read() and result = "read"
      or
      exists(boolean certain | this = Write(certain) and result = "write (" + certain + ")")
      or
      this = Def() and result = "def"
    }

    int getOrder() {
      this = Read() and
      result = 0
      or
      this = Write(_) and
      result = 1
      or
      this = Def() and
      result = 1
    }
  }

  /**
   * Holds if the `i`th node of basic block `bb` is a reference to `v` of kind `k`.
   */
  private signature predicate refSig(BasicBlock bb, int i, SourceVariable v, RefKind k);

  private module RankRefs<refSig/4 ref> {
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
    int refRank(BasicBlock bb, int i, SourceVariable v, RefKind k) {
      refOrd(bb, i, v, k, _) =
        rank[result](int j, int ord, OrderedRefIndex res |
          res = refOrd(bb, j, v, _, ord)
        |
          res order by j, ord
        )
    }

    int maxRefRank(BasicBlock bb, SourceVariable v) {
      result = refRank(bb, _, v, _) and
      not result + 1 = refRank(bb, _, v, _)
    }
  }

  /**
   * Liveness analysis (based on source variables) to restrict the size of the
   * SSA representation.
   */
  private module Liveness {
    /**
     * Holds if the `i`th node of basic block `bb` is a reference to `v` of kind `k`.
     */
    predicate varRef(BasicBlock bb, int i, SourceVariable v, RefKind k) {
      variableRead(bb, i, v, _) and k = Read()
      or
      exists(boolean certain | variableWrite(bb, i, v, certain) | k = Write(certain))
    }

    private import RankRefs<varRef/4>

    /**
     * Gets the (1-based) rank of the first reference to `v` inside basic block `bb`
     * that is either a read or a certain write.
     *
     * Note that uncertain writes have no impact on liveness: a variable is
     * live before an uncertain write if and only if it is live after.
     * The reference identified here therefore determines liveness at the
     * beginning of `bb`: if it is a read then the variable is live and if it
     * is a write then it is not. For basic blocks without reads or certain
     * writes, liveness at the beginning of the block is equivalent to liveness
     * at the end of the block.
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
      refRank(bb, _, v, Read()) = firstReadOrCertainWrite(bb, v)
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
     * Holds if variable `v` is live in basic block `bb` at rank `rnk`.
     */
    private predicate liveAtRank(BasicBlock bb, SourceVariable v, int rnk) {
      exists(RefKind kind | rnk = refRank(bb, _, v, kind) |
        rnk = maxRefRank(bb, v) and
        liveAtExit(bb, v)
        or
        kind = Read()
        or
        exists(RefKind nextKind |
          liveAtRank(bb, v, rnk + 1) and
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
      exists(int rnk | rnk = refRank(bb, i, v, Write(_)) | liveAtRank(bb, v, rnk))
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
      ssaDefReachesRead(v, _, readbb, _) and
      variableRead(readbb, _, v, true) and
      not variableWrite(readbb, _, v, _)
      or
      synthPhiRead(readbb, v) and
      not varRef(readbb, _, v, _)
    )
  }

  /**
   * Holds if we should synthesize a pseudo-read of `v` at the beginning of `bb`.
   *
   * These reads are named phi-reads, since they are constructed in the same
   * way as ordinary phi nodes except all reads are treated as potential
   * "definitions". This ensures that use-use flow has the same dominance
   * properties as def-use flow.
   */
  private predicate synthPhiRead(BasicBlock bb, SourceVariable v) {
    inReadDominanceFrontier(bb, v) and
    liveAtEntry(bb, v) and
    // no need to create a phi-read if there is already a normal phi
    not any(PhiNode def).definesAt(v, bb, _)
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
    TPhiReadNode(SourceVariable v, BasicBlock bb) { synthPhiRead(bb, v) }

  private class TDefinition = TWriteDef or TPhiNode;

  private module SsaDefReachesNew {
    /**
     * Holds if the `i`th node of basic block `bb` is a reference to `v`,
     * either a read (when `k` is `Read()`) or an SSA definition (when
     * `k` is `Def()`).
     *
     * Unlike `Liveness::varRef`, this includes `phi` nodes and pseudo-reads
     * associated with uncertain writes.
     */
    pragma[nomagic]
    predicate ssaRef(BasicBlock bb, int i, SourceVariable v, RefKind k) {
      variableRead(bb, i, v, _) and
      k = Read()
      or
      variableWrite(bb, i, v, false) and
      k = Read()
      or
      any(Definition def).definesAt(v, bb, i) and
      k = Def()
    }

    private import RankRefs<ssaRef/4>

    /**
     * Holds if the SSA definition `def` reaches rank index `rnk` in its own
     * basic block `bb`.
     */
    predicate ssaDefReachesRank(BasicBlock bb, Definition def, int rnk, SourceVariable v) {
      exists(int i |
        rnk = refRank(bb, i, v, Def()) and
        def.definesAt(v, bb, i)
      )
      or
      ssaDefReachesRank(bb, def, rnk - 1, v) and
      rnk = refRank(bb, _, v, Read())
    }

    /**
     * Holds if `v` is live at the end of basic block `bb` with the same value as at
     * the end of the immediate dominator, `idom`, of `bb`.
     */
    pragma[nomagic]
    private predicate liveThrough(BasicBlock idom, BasicBlock bb, SourceVariable v) {
      idom = getImmediateBasicBlockDominator(bb) and
      liveAtExit(bb, v) and
      not any(Definition def).definesAt(v, bb, _)
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches the end of basic
     * block `bb`, at which point it is still live, without crossing another
     * SSA definition of `v`.
     */
    pragma[nomagic]
    predicate ssaDefReachesEndOfBlock(BasicBlock bb, Definition def, SourceVariable v) {
      exists(int last |
        last = maxRefRank(pragma[only_bind_into](bb), pragma[only_bind_into](v)) and
        ssaDefReachesRank(bb, def, last, v) and
        liveAtExit(bb, v)
      )
      or
      exists(BasicBlock idom |
        // The construction of SSA form ensures that each read of a variable is
        // dominated by its definition. An SSA definition therefore reaches a
        // control flow node if it is the _closest_ SSA definition that dominates
        // the node. If two definitions dominate a node then one must dominate the
        // other, so therefore the definition of _closest_ is given by the dominator
        // tree. Thus, reaching definitions can be calculated in terms of dominance.
        ssaDefReachesEndOfBlock(idom, def, v) and
        liveThrough(idom, bb, v)
      )
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches index `i` in its own
     * basic block `bb`, without crossing another SSA definition of `v`.
     */
    predicate ssaDefReachesReadWithinBlock(SourceVariable v, Definition def, BasicBlock bb, int i) {
      exists(int rnk |
        ssaDefReachesRank(bb, def, rnk, v) and
        rnk = refRank(bb, i, v, Read())
      )
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches a read at index `i` in
     * basic block `bb`, without crossing another SSA definition of `v`.
     */
    pragma[nomagic]
    predicate ssaDefReachesRead(SourceVariable v, Definition def, BasicBlock bb, int i) {
      ssaDefReachesReadWithinBlock(v, def, bb, i)
      or
      ssaRef(bb, i, v, Read()) and
      ssaDefReachesEndOfBlock(getImmediateBasicBlockDominator(bb), def, v) and
      not ssaDefReachesReadWithinBlock(v, _, bb, i)
    }

    predicate uncertainWriteDefinitionInput(UncertainWriteDefinition def, Definition inp) {
      exists(SourceVariable v, BasicBlock bb, int i |
        def.definesAt(v, bb, i) and
        ssaDefReachesRead(v, inp, bb, i)
      )
    }
  }

  private module AdjacentSsaRefs {
    /**
     * Holds if the `i`th node of basic block `bb` is a reference to `v`,
     * either a read (when `k` is `Read()`) or an SSA definition (when
     * `k` is `Def()`).
     *
     * Unlike `Liveness::varRef`, this includes phi nodes, phi reads, and
     * pseudo-reads associated with uncertain writes, but excludes uncertain
     * reads.
     */
    pragma[nomagic]
    predicate ssaRef(BasicBlock bb, int i, SourceVariable v, RefKind k) {
      variableRead(bb, i, v, true) and
      k = Read()
      or
      variableWrite(bb, i, v, false) and
      k = Read()
      or
      any(Definition def).definesAt(v, bb, i) and
      k = Def()
      or
      synthPhiRead(bb, v) and i = -1 and k = Def()
    }

    private import RankRefs<ssaRef/4>

    /**
     * Holds if `v` is live at the end of basic block `bb`, which contains no
     * reference to `v`, and `idom` is the immediate dominator of `bb`.
     */
    pragma[nomagic]
    private predicate liveThrough(BasicBlock idom, BasicBlock bb, SourceVariable v) {
      idom = getImmediateBasicBlockDominator(bb) and
      liveAtExit(bb, v) and
      not ssaRef(bb, _, v, _)
    }

    pragma[nomagic]
    private predicate refReachesEndOfBlock(BasicBlock bbRef, int i, BasicBlock bb, SourceVariable v) {
      maxRefRank(bb, v) = refRank(bb, i, v, _) and
      liveAtExit(bb, v) and
      bbRef = bb
      or
      exists(BasicBlock idom |
        refReachesEndOfBlock(bbRef, i, idom, v) and
        liveThrough(idom, bb, v)
      )
    }

    /**
     * Holds if `v` has adjacent references at index `i1` in basic block `bb1`
     * and index `i2` in basic block `bb2`, that is, there is a path between
     * the first reference to the second without any other reference to `v` in
     * between. References include certain reads, SSA definitions, and
     * pseudo-reads in the form of phi-reads. The first reference can be any of
     * these kinds while the second is restricted to certain reads and
     * uncertain writes.
     *
     * Note that the placement of phi-reads ensures that the first reference is
     * uniquely determined by the second and that the first reference dominates
     * the second.
     */
    predicate adjacentRefRead(BasicBlock bb1, int i1, BasicBlock bb2, int i2, SourceVariable v) {
      bb1 = bb2 and
      refRank(bb1, i1, v, _) + 1 = refRank(bb2, i2, v, Read())
      or
      refReachesEndOfBlock(bb1, i1, getImmediateBasicBlockDominator(bb2), v) and
      1 = refRank(bb2, i2, v, Read())
    }

    /**
     * Holds if the phi node or phi-read for `v` in basic block `bbPhi` takes
     * input from basic block `input`, and that the reference to `v` at index
     * `i` in basic block `bb` reaches the end of `input` without going through
     * any other reference to `v`.
     */
    predicate adjacentRefPhi(
      BasicBlock bb, int i, BasicBlock input, BasicBlock bbPhi, SourceVariable v
    ) {
      refReachesEndOfBlock(bb, i, input, v) and
      input = getABasicBlockPredecessor(bbPhi) and
      1 = refRank(bbPhi, -1, v, _)
    }

    private predicate adjacentRefs(BasicBlock bb1, int i1, BasicBlock bb2, int i2, SourceVariable v) {
      adjacentRefRead(bb1, i1, bb2, i2, v)
      or
      adjacentRefPhi(bb1, i1, _, bb2, v) and i2 = -1
    }

    /**
     * Holds if the reference to `v` at index `i1` in basic block `bb1` reaches
     * the certain read at index `i2` in basic block `bb2` without going
     * through any other certain read. The boolean `samevar` indicates whether
     * the two references are to the same SSA variable.
     *
     * Note that since this relation skips over phi nodes and phi reads, it may
     * be quadratic in the number of variable references for certain access
     * patterns.
     */
    predicate firstUseAfterRef(
      BasicBlock bb1, int i1, BasicBlock bb2, int i2, SourceVariable v, boolean samevar
    ) {
      adjacentRefs(bb1, i1, bb2, i2, v) and
      variableRead(bb2, i2, v, _) and
      samevar = true
      or
      exists(BasicBlock bb0, int i0, boolean samevar0 |
        firstUseAfterRef(bb0, i0, bb2, i2, v, samevar0) and
        adjacentRefs(bb1, i1, bb0, i0, v) and
        not variableWrite(bb0, i0, v, true) and
        if any(Definition def).definesAt(v, bb0, i0)
        then samevar = false
        else (
          samevar = samevar0 and synthPhiRead(bb0, v) and i0 = -1
        )
      )
    }
  }

  /**
   * Holds if `def` reaches the certain read at index `i` in basic block `bb`
   * without going through any other certain read. The boolean `samevar`
   * indicates whether the read is a use of `def` or whether some number of phi
   * nodes and/or uncertain reads occur between `def` and the read.
   *
   * Note that since this relation skips over phi nodes and phi reads, it may
   * be quadratic in the number of variable references for certain access
   * patterns.
   */
  predicate firstUse(Definition def, BasicBlock bb, int i, boolean samevar) {
    exists(BasicBlock bb1, int i1, SourceVariable v |
      def.definesAt(v, bb1, i1) and
      AdjacentSsaRefs::firstUseAfterRef(bb1, i1, bb, i, v, samevar)
    )
  }

  /**
   * Holds if the certain read at index `i1` in basic block `bb1` reaches the
   * certain read at index `i2` in basic block `bb2` without going through any
   * other certain read. The boolean `samevar` indicates whether the two reads
   * are of the same SSA variable.
   *
   * Note that since this relation skips over phi nodes and phi reads, it may
   * be quadratic in the number of variable references for certain access
   * patterns.
   */
  predicate adjacentUseUse(
    BasicBlock bb1, int i1, BasicBlock bb2, int i2, SourceVariable v, boolean samevar
  ) {
    exists(boolean samevar0 |
      variableRead(bb1, i1, v, true) and
      not variableWrite(bb1, i1, v, true) and
      AdjacentSsaRefs::firstUseAfterRef(bb1, i1, bb2, i2, v, samevar0) and
      if any(Definition def).definesAt(v, bb1, i1) then samevar = false else samevar = samevar0
    )
  }

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
     * Unlike `Liveness::varRef`, this includes `phi` (read) nodes.
     */
    pragma[nomagic]
    predicate ssaRef(BasicBlock bb, int i, SourceVariable v, SsaRefKind k) {
      variableRead(bb, i, v, _) and
      k = SsaActualRead()
      or
      any(Definition def).definesAt(v, bb, i) and
      k = SsaDef()
      or
      synthPhiRead(bb, v) and i = -1 and k = SsaPhiRead()
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
    predicate ssaDefReachesThroughBlock(DefinitionExt def, BasicBlock bb) {
      exists(SourceVariable v |
        ssaDefReachesEndOfBlockExt0(bb, def, v) and
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
        not varRef(bb2, _, v, _)
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
        not ssaDefReachesEndOfBlockExt0(bb2, def, _)
      )
    }

    pragma[nomagic]
    private predicate varBlockReachesExitExclPhiRead(DefinitionExt def, BasicBlock bb) {
      exists(BasicBlock bb2, SourceVariable v |
        varBlockReachesExt(def, v, bb, bb2) and
        not defOccursInBlock(def, bb2, _, _) and
        not ssaDefReachesEndOfBlockExt0(bb2, def, _) and
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
  private predicate ssaDefReachesEndOfBlockExt0(BasicBlock bb, DefinitionExt def, SourceVariable v) {
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
    ssaDefReachesEndOfBlockExt0(getImmediateBasicBlockDominator(bb), def, pragma[only_bind_into](v)) and
    liveThroughExt(bb, pragma[only_bind_into](v))
  }

  deprecated predicate ssaDefReachesEndOfBlockExt = ssaDefReachesEndOfBlockExt0/3;

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Same as `ssaDefReachesEndOfBlockExt`, but ignores phi-reads.
   */
  predicate ssaDefReachesEndOfBlock = SsaDefReachesNew::ssaDefReachesEndOfBlock/3;

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
      ssaDefReachesEndOfBlockExt0(bb, inp, v)
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
    ssaDefReachesEndOfBlockExt0(getABasicBlockPredecessor(bb), def, v) and
    not ssaDefReachesReadWithinBlock(v, _, bb, i)
  }

  /**
   * NB: If this predicate is exposed, it should be cached.
   *
   * Same as `ssaDefReachesReadExt`, but ignores phi-reads.
   */
  predicate ssaDefReachesRead(SourceVariable v, Definition def, BasicBlock bb, int i) {
    SsaDefReachesNew::ssaDefReachesRead(v, def, bb, i) and
    variableRead(bb, i, v, _)
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

  private predicate lastRefRedefExtSameBlock(
    DefinitionExt def, SourceVariable v, BasicBlock bb, int i, DefinitionExt next
  ) {
    exists(int rnk, int j |
      rnk = ssaDefRank(def, v, bb, i, _) and
      next.definesAt(v, bb, j, _) and
      rnk + 1 = ssaRefRank(bb, j, v, ssaDefExt())
    )
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
    lastRefRedefExtSameBlock(def, v, bb, i, next)
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
   * Holds if the node at index `i` in `bb` is a last reference to SSA definition
   * `def`. The reference is last because it can reach another write `next`,
   * without passing through another read or write.
   *
   * The path from node `i` in `bb` to `next` goes via basic block `input`, which is
   * either a predecessor of the basic block of `next`, or `input = bb` in case `next`
   * occurs in basic block `bb`.
   */
  pragma[nomagic]
  predicate lastRefRedefExt(
    DefinitionExt def, SourceVariable v, BasicBlock bb, int i, BasicBlock input, DefinitionExt next
  ) {
    // Next reference to `v` inside `bb` is a write
    lastRefRedefExtSameBlock(def, v, bb, i, next) and
    input = bb
    or
    // Can reach a write using one or more steps
    lastSsaRefExt(def, v, bb, i) and
    exists(BasicBlock bb2 |
      input = getABasicBlockPredecessor(bb2) and
      1 = ssaDefRank(next, v, bb2, _, ssaDefExt())
    |
      input = bb
      or
      varBlockReachesExt(def, v, bb, input) and
      ssaDefReachesThroughBlock(def, pragma[only_bind_into](input))
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
  predicate uncertainWriteDefinitionInput = SsaDefReachesNew::uncertainWriteDefinitionInput/2;

  /** Holds if `bb` is a control-flow exit point. */
  private predicate exitBlock(BasicBlock bb) { not exists(getABasicBlockSuccessor(bb)) }

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
  deprecated predicate lastRefExt(DefinitionExt def, BasicBlock bb, int i) {
    // Can reach another definition
    lastRefRedefExt(def, _, bb, i, _)
    or
    lastSsaRefExt(def, _, bb, i) and
    (
      // Can reach exit directly
      exitBlock(bb)
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
  deprecated predicate lastRef(Definition def, BasicBlock bb, int i) {
    // Can reach another definition
    lastRefRedef(def, bb, i, _)
    or
    lastSsaRef(def, _, bb, i) and
    (
      // Can reach exit directly
      exitBlock(bb)
      or
      // Can reach a block using one or more steps, where `def` is no longer live
      varBlockReachesExit(def, bb)
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

    /** Gets the location of this SSA definition. */
    Location getLocation() {
      exists(BasicBlock bb, int i | this.definesAt(_, bb, i) |
        if i = -1 then result = bb.getLocation() else result = bb.getNode(i).getLocation()
      )
    }
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

    /** Gets the location of this SSA definition. */
    Location getLocation() { result = this.(Definition).getLocation() }
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

    override Location getLocation() { result = this.getBasicBlock().getLocation() }
  }

  /** Provides a set of consistency queries. */
  module Consistency {
    /** Holds if a read can be reached from multiple definitions. */
    query predicate nonUniqueDef(Definition def, SourceVariable v, BasicBlock bb, int i) {
      ssaDefReachesRead(v, def, bb, i) and
      not exists(unique(Definition def0 | ssaDefReachesRead(v, def0, bb, i)))
    }

    /** Holds if a read cannot be reached from a definition. */
    query predicate readWithoutDef(SourceVariable v, BasicBlock bb, int i) {
      variableRead(bb, i, v, _) and
      not ssaDefReachesRead(v, _, bb, i)
    }

    /** Holds if a definition cannot reach a read. */
    query predicate deadDef(Definition def, SourceVariable v) {
      v = def.getSourceVariable() and
      not ssaDefReachesRead(_, def, _, _) and
      not phiHasInputFromBlock(_, def, _) and
      not uncertainWriteDefinitionInput(_, def)
    }

    /** Holds if a read is not dominated by a definition. */
    query predicate notDominatedByDef(Definition def, SourceVariable v, BasicBlock bb, int i) {
      exists(BasicBlock bbDef, int iDef | def.definesAt(v, bbDef, iDef) |
        ssaDefReachesReadWithinBlock(v, def, bb, i) and
        (bb != bbDef or i < iDef)
        or
        ssaDefReachesRead(v, def, bb, i) and
        not ssaDefReachesReadWithinBlock(v, def, bb, i) and
        not def.definesAt(v, getImmediateBasicBlockDominator*(bb), _)
      )
    }

    /** Holds if the end of a basic block can be reached by multiple definitions. */
    query predicate nonUniqueDefReachesEndOfBlock(Definition def, SourceVariable v, BasicBlock bb) {
      ssaDefReachesEndOfBlock(bb, def, v) and
      not exists(unique(Definition def0 | ssaDefReachesEndOfBlock(bb, def0, v)))
    }

    /** Holds if a phi node has less than two inputs. */
    query predicate uselessPhiNode(PhiNode phi, int inputs) {
      inputs = count(Definition inp | phiHasInputFromBlock(phi, inp, _)) and
      inputs < 2
    }

    /** Holds if a certain read does not have a prior reference. */
    query predicate readWithoutPriorRef(SourceVariable v, BasicBlock bb, int i) {
      variableRead(bb, i, v, true) and
      not AdjacentSsaRefs::adjacentRefRead(_, _, bb, i, v)
    }

    /**
     * Holds if a certain read has multiple prior references. The introduction
     * of phi reads should make the prior reference unique.
     */
    query predicate readWithMultiplePriorRefs(
      SourceVariable v, BasicBlock bb1, int i1, BasicBlock bb2, int i2
    ) {
      AdjacentSsaRefs::adjacentRefRead(bb1, i1, bb2, i2, v) and
      2 <=
        strictcount(BasicBlock bb0, int i0 | AdjacentSsaRefs::adjacentRefRead(bb0, i0, bb1, i1, v))
    }

    /** Holds if `phi` has less than 2 immediately prior references. */
    query predicate phiWithoutTwoPriorRefs(PhiNode phi, int inputRefs) {
      exists(BasicBlock bbPhi, SourceVariable v |
        phi.definesAt(v, bbPhi, _) and
        inputRefs =
          count(BasicBlock bb, int i | AdjacentSsaRefs::adjacentRefPhi(bb, i, _, bbPhi, v)) and
        inputRefs < 2
      )
    }

    /**
     * Holds if the phi read for `v` at `bb` has less than 2 immediately prior
     * references.
     */
    query predicate phiReadWithoutTwoPriorRefs(BasicBlock bbPhi, SourceVariable v, int inputRefs) {
      synthPhiRead(bbPhi, v) and
      inputRefs = count(BasicBlock bb, int i | AdjacentSsaRefs::adjacentRefPhi(bb, i, _, bbPhi, v)) and
      inputRefs < 2
    }
  }

  /** Provides the input to `DataFlowIntegration`. */
  signature module DataFlowIntegrationInputSig {
    /**
     * An expression with a value. That is, we expect these expressions to be
     * represented in the data flow graph.
     */
    class Expr {
      /** Gets a textual representation of this expression. */
      string toString();

      /** Holds if the `i`th node of basic block `bb` evaluates this expression. */
      predicate hasCfgNode(BasicBlock bb, int i);
    }

    /**
     * Gets a read of SSA definition `def`.
     *
     * Override this with a cached version when applicable.
     */
    default Expr getARead(Definition def) {
      exists(SourceVariable v, BasicBlock bb, int i |
        ssaDefReachesRead(v, def, bb, i) and
        variableRead(bb, i, v, true) and
        result.hasCfgNode(bb, i)
      )
    }

    /**
     * Holds if `def` has some form of input flow. For example, the right-hand
     * side of an assignment or a parameter of an SSA entry definition.
     *
     * For such definitions, a flow step is added from a synthetic node
     * representing the source to the definition.
     */
    default predicate ssaDefHasSource(WriteDefinition def) { any() }

    /**
     * Holds if flow should be allowed into uncertain SSA definition `def` from
     * previous definitions or reads.
     */
    default predicate allowFlowIntoUncertainDef(UncertainWriteDefinition def) { none() }

    /** A (potential) guard. */
    class Guard {
      /** Gets a textual representation of this guard. */
      string toString();

      /**
       * Holds if the control flow branching from `bb1` is dependent on this guard,
       * and that the edge from `bb1` to `bb2` corresponds to the evaluation of this
       * guard to `branch`.
       */
      predicate controlsBranchEdge(BasicBlock bb1, BasicBlock bb2, boolean branch);
    }

    /** Holds if `guard` directly controls block `bb` upon evaluating to `branch`. */
    predicate guardDirectlyControlsBlock(Guard guard, BasicBlock bb, boolean branch);

    /** Holds if `guard` controls block `bb` upon evaluating to `branch`. */
    default predicate guardControlsBlock(Guard guard, BasicBlock bb, boolean branch) {
      guardDirectlyControlsBlock(guard, bb, branch)
    }

    /**
     * Holds if `WriteDefinition`s should be included as an intermediate node
     * between the assigned `Expr` or `Parameter` and the first read of the SSA
     * definition.
     */
    default predicate includeWriteDefsInFlowStep() { any() }

    /**
     * Holds if barrier guards should be supported on input edges to phi
     * nodes. Disable this only if barrier guards are not going to be used.
     */
    default predicate supportBarrierGuardsOnPhiEdges() { any() }

    /**
     * Holds if all phi input back edges should be kept in the data flow graph.
     *
     * This is ordinarily not necessary and causes the retention of superfluous
     * nodes.
     */
    default predicate keepAllPhiInputBackEdges() { none() }
  }

  /**
   * Constructs the type `Node` and associated value step relations, which are
   * intended to be included in the `DataFlow::Node` type and local step relations.
   *
   * Additionally, this module also provides a barrier guards implementation.
   */
  module DataFlowIntegration<DataFlowIntegrationInputSig DfInput> {
    private import codeql.util.Boolean

    final private class DefinitionExtFinal = DefinitionExt;

    /** An SSA definition which is either a phi node or a phi read node. */
    private class SsaPhiExt extends DefinitionExtFinal {
      SsaPhiExt() {
        this instanceof PhiNode
        or
        this instanceof PhiReadNode
      }
    }

    cached
    private Definition getAPhiInputDef(SsaPhiExt phi, BasicBlock bb) {
      exists(SourceVariable v, BasicBlock bbDef |
        phi.definesAt(v, bbDef, _, _) and
        getABasicBlockPredecessor(bbDef) = bb and
        ssaDefReachesEndOfBlock(bb, result, v)
      )
    }

    /**
     * Holds if the phi input edge from `input` to `phi` is a back edge and
     * must be kept.
     */
    private predicate relevantBackEdge(SsaPhiExt phi, BasicBlock input) {
      exists(BasicBlock bbPhi |
        DfInput::keepAllPhiInputBackEdges() and
        exists(getAPhiInputDef(phi, input)) and
        phi.getBasicBlock() = bbPhi and
        getImmediateBasicBlockDominator+(input) = bbPhi
      )
    }

    /**
     * Holds if the input to `phi` from the block `input` might be relevant for
     * barrier guards as a separately synthesized `TSsaInputNode`.
     *
     * Note that `TSsaInputNode`s have both unique predecessors and unique
     * successors, both of which are given by `adjacentRefPhi`, so we can
     * always skip them in the flow graph without increasing the number of flow
     * edges, if they are not needed for barrier guards.
     */
    private predicate relevantPhiInputNode(SsaPhiExt phi, BasicBlock input) {
      relevantBackEdge(phi, input)
      or
      DfInput::supportBarrierGuardsOnPhiEdges() and
      // If the input isn't explicitly read then a guard cannot check it.
      exists(DfInput::getARead(getAPhiInputDef(phi, input))) and
      (
        // The input node is relevant either if it sits directly on a branch
        // edge for a guard,
        exists(DfInput::Guard g | g.controlsBranchEdge(input, phi.getBasicBlock(), _))
        or
        // or if the unique predecessor is not an equivalent substitute in
        // terms of being controlled by the same guards.
        // Example:
        // ```
        // if (g1) {
        //   use(x); // A
        //   if (g2) { .. }
        //   // no need for an input node here, as the set of guards controlling
        //   // this block is the same as the set of guards controlling the prior
        //   // use of `x` at A.
        // }
        // // phi-read node for `x`
        // ```
        exists(BasicBlock prev |
          AdjacentSsaRefs::adjacentRefPhi(prev, _, input, phi.getBasicBlock(),
            phi.getSourceVariable()) and
          prev != input and
          exists(DfInput::Guard g, boolean branch |
            DfInput::guardDirectlyControlsBlock(g, input, branch) and
            not DfInput::guardDirectlyControlsBlock(g, prev, branch)
          )
        )
      )
    }

    /**
     * Holds if a next adjacent use of `phi` is as input to `phi2` through
     * `input`. The boolean `relevant` indicates whether the input edge might
     * be relevant for barrier guards.
     */
    private predicate phiStepsToPhiInput(
      SsaPhiExt phi, SsaPhiExt phi2, BasicBlock input, boolean relevant
    ) {
      exists(BasicBlock bb1, int i, SourceVariable v, BasicBlock bb2 |
        phi.definesAt(pragma[only_bind_into](v), bb1, i, _) and
        AdjacentSsaRefs::adjacentRefPhi(bb1, i, input, bb2, v) and
        phi2.definesAt(pragma[only_bind_into](v), bb2, _, _) and
        if relevantPhiInputNode(phi2, input) then relevant = true else relevant = false
      )
    }

    /**
     * Holds if a next adjacent use of `phi` occurs at index `i` in basic block
     * `bb`. The boolean `isUse` indicates whether the use is a read or an
     * uncertain write.
     */
    private predicate phiStepsToRef(SsaPhiExt phi, BasicBlock bb, int i, boolean isUse) {
      exists(SourceVariable v, BasicBlock bb1, int i1 |
        phi.definesAt(v, bb1, i1, _) and
        AdjacentSsaRefs::adjacentRefRead(bb1, i1, bb, i, v)
      |
        isUse = true and
        variableRead(bb, i, v, true)
        or
        isUse = false and
        exists(UncertainWriteDefinition def2 |
          DfInput::allowFlowIntoUncertainDef(def2) and
          def2.definesAt(v, bb, i)
        )
      )
    }

    /**
     * Holds if the next adjacent use of `phi` is unique. In this case, we can
     * skip the phi in the use-use step relation without increasing the number
     * flow edges.
     */
    private predicate phiHasUniqNextNode(SsaPhiExt phi) {
      not relevantBackEdge(phi, _) and
      exists(int nextPhiInput, int nextPhi, int nextRef |
        1 = nextPhiInput + nextPhi + nextRef and
        nextPhiInput =
          count(SsaPhiExt phi2, BasicBlock input | phiStepsToPhiInput(phi, phi2, input, true)) and
        nextPhi = count(SsaPhiExt phi2 | phiStepsToPhiInput(phi, phi2, _, false)) and
        nextRef = count(BasicBlock bb, int i, boolean isUse | phiStepsToRef(phi, bb, i, isUse))
      )
    }

    cached
    private newtype TNode =
      TWriteDefSource(WriteDefinition def) { DfInput::ssaDefHasSource(def) } or
      TExprNode(DfInput::Expr e, Boolean isPost) { e = DfInput::getARead(_) } or
      TSsaDefinitionNode(DefinitionExt def) { not phiHasUniqNextNode(def) } or
      TSsaInputNode(SsaPhiExt phi, BasicBlock input) { relevantPhiInputNode(phi, input) }

    /**
     * A data flow node that we need to reference in the value step relation.
     *
     * Note that only the `SsaNode` subclass is expected to be added as additional
     * nodes in `DataFlow::Node`. The other subclasses are expected to already be
     * present and are included here in order to reference them in the step relation.
     */
    abstract private class NodeImpl extends TNode {
      /** Gets the location of this node. */
      abstract Location getLocation();

      /** Gets a textual representation of this node. */
      abstract string toString();
    }

    final class Node = NodeImpl;

    /** A source of a write definition. */
    private class WriteDefSourceNodeImpl extends NodeImpl, TWriteDefSource {
      private WriteDefinition def;

      WriteDefSourceNodeImpl() { this = TWriteDefSource(def) }

      /** Gets the underlying definition. */
      WriteDefinition getDefinition() { result = def }

      override string toString() { result = def.toString() }

      override Location getLocation() { result = def.getLocation() }
    }

    final class WriteDefSourceNode = WriteDefSourceNodeImpl;

    /** A (post-update) expression node. */
    abstract private class ExprNodePreOrPostImpl extends NodeImpl, TExprNode {
      DfInput::Expr e;
      boolean isPost;

      ExprNodePreOrPostImpl() { this = TExprNode(e, isPost) }

      /** Gets the underlying expression. */
      DfInput::Expr getExpr() { result = e }

      override Location getLocation() {
        exists(BasicBlock bb, int i |
          e.hasCfgNode(bb, i) and
          result = bb.getNode(i).getLocation()
        )
      }
    }

    final class ExprNodePreOrPost = ExprNodePreOrPostImpl;

    /** An expression node. */
    private class ExprNodeImpl extends ExprNodePreOrPostImpl {
      ExprNodeImpl() { isPost = false }

      override string toString() { result = e.toString() }
    }

    final class ExprNode = ExprNodeImpl;

    /** A post-update expression node. */
    private class ExprPostUpdateNodeImpl extends ExprNodePreOrPostImpl {
      ExprPostUpdateNodeImpl() { isPost = true }

      /** Gets the pre-update expression node. */
      ExprNode getPreUpdateNode() { result = TExprNode(e, false) }

      override string toString() { result = e.toString() + " [postupdate]" }
    }

    final class ExprPostUpdateNode = ExprPostUpdateNodeImpl;

    private class ReadNodeImpl extends ExprNodeImpl {
      private BasicBlock bb_;
      private int i_;
      private SourceVariable v_;

      ReadNodeImpl() {
        variableRead(bb_, i_, v_, true) and
        this.getExpr().hasCfgNode(bb_, i_)
      }

      SourceVariable getVariable() { result = v_ }

      pragma[nomagic]
      predicate readsAt(BasicBlock bb, int i, SourceVariable v) {
        bb = bb_ and
        i = i_ and
        v = v_
      }
    }

    final private class ReadNode = ReadNodeImpl;

    /** A synthesized SSA data flow node. */
    abstract private class SsaNodeImpl extends NodeImpl {
      /** Gets the underlying SSA definition. */
      abstract deprecated DefinitionExt getDefinitionExt();

      /** Gets the SSA definition this node corresponds to, if any. */
      Definition asDefinition() { this = TSsaDefinitionNode(result) }

      /** Gets the basic block to which this node belongs. */
      abstract BasicBlock getBasicBlock();

      /**
       * INTERNAL: Do not use.
       *
       * Gets the basic block index of this node.
       */
      abstract int getIndex();

      /** Gets the underlying source variable that this node tracks flow for. */
      abstract SourceVariable getSourceVariable();
    }

    final class SsaNode = SsaNodeImpl;

    /** An SSA definition, viewed as a node in a data flow graph. */
    private class SsaDefinitionExtNodeImpl extends SsaNodeImpl, TSsaDefinitionNode {
      private DefinitionExt def;

      SsaDefinitionExtNodeImpl() { this = TSsaDefinitionNode(def) }

      /** Gets the corresponding `DefinitionExt`. */
      DefinitionExt getDefExt() { result = def }

      deprecated override DefinitionExt getDefinitionExt() { result = def }

      override BasicBlock getBasicBlock() { result = def.getBasicBlock() }

      override int getIndex() { def.definesAt(_, _, result, _) }

      override SourceVariable getSourceVariable() { result = def.getSourceVariable() }

      override Location getLocation() { result = def.getLocation() }

      override string toString() { result = def.toString() }
    }

    deprecated final class SsaDefinitionExtNode = SsaDefinitionExtNodeImpl;

    /** An SSA definition, viewed as a node in a data flow graph. */
    private class SsaDefinitionNodeImpl extends SsaDefinitionExtNodeImpl {
      private Definition def;

      SsaDefinitionNodeImpl() { this = TSsaDefinitionNode(def) }

      /** Gets the underlying SSA definition. */
      Definition getDefinition() { result = def }
    }

    final class SsaDefinitionNode = SsaDefinitionNodeImpl;

    /** A node that represents a synthetic read of a source variable. */
    final class SsaSynthReadNode extends SsaNode {
      SsaSynthReadNode() {
        this.(SsaDefinitionExtNodeImpl).getDefExt() instanceof PhiReadNode or
        this instanceof SsaInputNodeImpl
      }
    }

    /**
     * A node that represents an input to an SSA phi (read) definition.
     *
     * This allows for barrier guards to filter input to phi nodes. For example, in
     *
     * ```rb
     * x = taint
     * if x != "safe" then
     *     x = "safe"
     * end
     * sink x
     * ```
     *
     * the `false` edge out of `x != "safe"` guards the input from `x = taint` into the
     * `phi` node after the condition.
     *
     * It is also relevant to filter input into phi read nodes:
     *
     * ```rb
     * x = taint
     * if b then
     *     if x != "safe1" then
     *         return
     *     end
     * else
     *     if x != "safe2" then
     *         return
     *     end
     * end
     *
     * sink x
     * ```
     *
     * both inputs into the phi read node after the outer condition are guarded.
     */
    private class SsaInputNodeImpl extends SsaNodeImpl, TSsaInputNode {
      private SsaPhiExt def_;
      private BasicBlock input_;

      SsaInputNodeImpl() { this = TSsaInputNode(def_, input_) }

      /** Holds if this node represents input into SSA definition `def` via basic block `input`. */
      predicate isInputInto(DefinitionExt def, BasicBlock input) {
        def = def_ and
        input = input_
      }

      SsaPhiExt getPhi() { result = def_ }

      deprecated override SsaPhiExt getDefinitionExt() { result = def_ }

      override BasicBlock getBasicBlock() { result = input_ }

      override int getIndex() { result = input_.length() }

      override SourceVariable getSourceVariable() { result = def_.getSourceVariable() }

      override Location getLocation() { result = input_.getNode(input_.length() - 1).getLocation() }

      override string toString() { result = "[input] " + def_.toString() }
    }

    deprecated final class SsaInputNode = SsaInputNodeImpl;

    /**
     * Holds if `nodeFrom` corresponds to the reference to `v` at index `i` in
     * `bb`. The boolean `isUseStep` indicates whether `nodeFrom` is an actual
     * read. If it is false then `nodeFrom` may be any of the following: an
     * uncertain write, a certain write, a phi, or a phi read.
     */
    private predicate flowOutOf(
      Node nodeFrom, SourceVariable v, BasicBlock bb, int i, boolean isUseStep
    ) {
      exists(DefinitionExt def |
        nodeFrom.(SsaDefinitionExtNodeImpl).getDefExt() = def and
        def.definesAt(v, bb, i, _) and
        isUseStep = false and
        if DfInput::includeWriteDefsInFlowStep()
        then any()
        else (
          def instanceof PhiNode or
          def instanceof PhiReadNode or
          DfInput::allowFlowIntoUncertainDef(def)
        )
      )
      or
      [nodeFrom, nodeFrom.(ExprPostUpdateNode).getPreUpdateNode()].(ReadNode).readsAt(bb, i, v) and
      isUseStep = true
    }

    private predicate flowFromRefToNode(SourceVariable v, BasicBlock bb1, int i1, Node nodeTo) {
      // Flow from definition/read to next read
      exists(BasicBlock bb2, int i2 |
        AdjacentSsaRefs::adjacentRefRead(bb1, i1, bb2, i2, v) and
        nodeTo.(ReadNode).readsAt(bb2, i2, v)
      )
      or
      // Flow from definition/read to next uncertain write
      exists(BasicBlock bb2, int i2 |
        AdjacentSsaRefs::adjacentRefRead(bb1, i1, bb2, i2, v) and
        exists(UncertainWriteDefinition def2 |
          DfInput::allowFlowIntoUncertainDef(def2) and
          nodeTo.(SsaDefinitionNode).getDefinition() = def2 and
          def2.definesAt(v, bb2, i2)
        )
      )
      or
      // Flow from definition/read to phi input
      exists(BasicBlock input, BasicBlock bbPhi, DefinitionExt phi |
        AdjacentSsaRefs::adjacentRefPhi(bb1, i1, input, bbPhi, v) and
        phi.definesAt(v, bbPhi, -1, _)
      |
        if relevantPhiInputNode(phi, input)
        then nodeTo = TSsaInputNode(phi, input)
        else flowIntoPhi(phi, v, bbPhi, nodeTo)
      )
    }

    private predicate flowIntoPhi(DefinitionExt phi, SourceVariable v, BasicBlock bbPhi, Node nodeTo) {
      phi.definesAt(v, bbPhi, -1, _) and
      if phiHasUniqNextNode(phi)
      then flowFromRefToNode(v, bbPhi, -1, nodeTo)
      else nodeTo.(SsaDefinitionExtNodeImpl).getDefExt() = phi
    }

    /**
     * Holds if there is a local flow step from `nodeFrom` to `nodeTo`.
     *
     * `isUseStep` is `true` when `nodeFrom` is a (post-update) read node and
     * `nodeTo` is a read node or phi (read) node.
     */
    predicate localFlowStep(SourceVariable v, Node nodeFrom, Node nodeTo, boolean isUseStep) {
      exists(Definition def |
        // Flow from write definition source into SSA definition
        nodeFrom = TWriteDefSource(def) and
        isUseStep = false and
        if DfInput::includeWriteDefsInFlowStep()
        then
          nodeTo.(SsaDefinitionNode).getDefinition() = def and
          v = def.getSourceVariable()
        else
          exists(BasicBlock bb1, int i1 |
            def.definesAt(v, bb1, i1) and
            flowFromRefToNode(v, bb1, i1, nodeTo)
          )
      )
      or
      exists(BasicBlock bb1, int i1 |
        flowOutOf(nodeFrom, v, bb1, i1, isUseStep) and
        flowFromRefToNode(v, bb1, i1, nodeTo) and
        nodeFrom != nodeTo
      )
      or
      // Flow from input node to def
      exists(DefinitionExt phi |
        phi = nodeFrom.(SsaInputNodeImpl).getPhi() and
        isUseStep = false and
        nodeFrom != nodeTo and
        flowIntoPhi(phi, v, _, nodeTo)
      )
    }

    /** Holds if the value of `nodeTo` is given by `nodeFrom`. */
    predicate localMustFlowStep(SourceVariable v, Node nodeFrom, Node nodeTo) {
      exists(Definition def |
        // Flow from write definition source into SSA definition
        nodeFrom = TWriteDefSource(def) and
        v = def.getSourceVariable() and
        if DfInput::includeWriteDefsInFlowStep()
        then nodeTo.(SsaDefinitionNode).getDefinition() = def
        else nodeTo.(ExprNode).getExpr() = DfInput::getARead(def)
      )
      or
      // Flow from SSA definition to read
      exists(DefinitionExt def |
        nodeFrom.(SsaDefinitionExtNodeImpl).getDefExt() = def and
        nodeTo.(ExprNode).getExpr() = DfInput::getARead(def) and
        v = def.getSourceVariable()
      )
    }

    /**
     * Holds if the guard `g` validates the expression `e` upon evaluating to `branch`.
     *
     * The expression `e` is expected to be a syntactic part of the guard `g`.
     * For example, the guard `g` might be a call `isSafe(x)` and the expression `e`
     * the argument `x`.
     */
    signature predicate guardChecksSig(DfInput::Guard g, DfInput::Expr e, boolean branch);

    pragma[nomagic]
    private Definition getAPhiInputDef(SsaInputNodeImpl n) {
      exists(SsaPhiExt phi, BasicBlock bb |
        result = getAPhiInputDef(phi, bb) and
        n.isInputInto(phi, bb)
      )
    }

    bindingset[this]
    signature class StateSig;

    private module WithState<StateSig State> {
      /**
       * Holds if the guard `g` validates the expression `e` upon evaluating to `branch`, blocking
       * flow in the given `state`.
       *
       * The expression `e` is expected to be a syntactic part of the guard `g`.
       * For example, the guard `g` might be a call `isSafe(x)` and the expression `e`
       * the argument `x`.
       */
      signature predicate guardChecksSig(
        DfInput::Guard g, DfInput::Expr e, boolean branch, State state
      );

      /**
       * Holds if the guard `g` validates the SSA definition `def` upon
       * evaluating to `branch`, blocking flow in the given `state`.
       */
      signature predicate guardChecksDefSig(
        DfInput::Guard g, Definition def, boolean branch, State state
      );
    }

    /**
     * Provides a set of barrier nodes for a guard that validates an expression.
     *
     * This is expected to be used in `isBarrier`/`isSanitizer` definitions
     * in data flow and taint tracking.
     */
    module BarrierGuard<guardChecksSig/3 guardChecks> {
      private predicate guardChecksWithState(
        DfInput::Guard g, DfInput::Expr e, boolean branch, Unit state
      ) {
        guardChecks(g, e, branch) and exists(state)
      }

      private module StatefulBarrier = BarrierGuardWithState<Unit, guardChecksWithState/4>;

      /** Gets a node that is safely guarded by the given guard check. */
      pragma[nomagic]
      Node getABarrierNode() { result = StatefulBarrier::getABarrierNode(_) }
    }

    /**
     * Provides a set of barrier nodes for a guard that validates an expression.
     *
     * This is expected to be used in `isBarrier`/`isSanitizer` definitions
     * in data flow and taint tracking.
     */
    module BarrierGuardWithState<StateSig State, WithState<State>::guardChecksSig/4 guardChecks> {
      pragma[nomagic]
      private predicate guardChecksSsaDef(
        DfInput::Guard g, Definition def, boolean branch, State state
      ) {
        guardChecks(g, DfInput::getARead(def), branch, state)
      }

      private module Barrier = BarrierGuardDefWithState<State, guardChecksSsaDef/4>;

      predicate getABarrierNode = Barrier::getABarrierNode/1;
    }

    /**
     * Provides a set of barrier nodes for a guard that validates an expression.
     *
     * This is expected to be used in `isBarrier`/`isSanitizer` definitions
     * in data flow and taint tracking.
     */
    module BarrierGuardDefWithState<
      StateSig State, WithState<State>::guardChecksDefSig/4 guardChecksSsaDef>
    {
      /** Gets a node that is safely guarded by the given guard check. */
      pragma[nomagic]
      Node getABarrierNode(State state) {
        exists(DfInput::Guard g, boolean branch, Definition def, BasicBlock bb |
          guardChecksSsaDef(g, def, branch, state)
        |
          // guard controls a read
          exists(DfInput::Expr e |
            e = DfInput::getARead(def) and
            e.hasCfgNode(bb, _) and
            DfInput::guardControlsBlock(g, bb, branch) and
            result.(ExprNode).getExpr() = e
          )
          or
          // guard controls input block to a phi node
          exists(SsaPhiExt phi |
            def = getAPhiInputDef(result) and
            result.(SsaInputNodeImpl).isInputInto(phi, bb)
          |
            DfInput::guardControlsBlock(g, bb, branch)
            or
            g.controlsBranchEdge(bb, phi.getBasicBlock(), branch)
          )
        )
      }
    }
  }

  /**
   * Provides query predicates for testing adjacent SSA references and
   * insertion of phi reads.
   */
  module TestAdjacentRefs {
    private newtype TRef =
      TRefRead(BasicBlock bb, int i, SourceVariable v) { variableRead(bb, i, v, true) } or
      TRefDef(Definition def) or
      TRefPhiRead(BasicBlock bb, SourceVariable v) { synthPhiRead(bb, v) }

    /**
     * An SSA reference. This is either a certain read, a definition, or a
     * synthesized phi read.
     */
    class Ref extends TRef {
      /** Gets the source variable referenced by this reference. */
      SourceVariable getSourceVariable() {
        this = TRefRead(_, _, result)
        or
        exists(Definition def | this = TRefDef(def) and def.getSourceVariable() = result)
        or
        this = TRefPhiRead(_, result)
      }

      /** Holds if this reference is a synthesized phi read. */
      predicate isPhiRead() { this = TRefPhiRead(_, _) }

      /** Gets a textual representation of this SSA reference. */
      string toString() {
        this = TRefRead(_, _, _) and result = "SSA read(" + this.getSourceVariable() + ")"
        or
        exists(Definition def | this = TRefDef(def) and result = def.toString())
        or
        this = TRefPhiRead(_, _) and result = "SSA phi read(" + this.getSourceVariable() + ")"
      }

      /** Gets the location of this SSA reference. */
      Location getLocation() {
        exists(BasicBlock bb, int i |
          this = TRefRead(bb, i, _) and bb.getNode(i).getLocation() = result
        )
        or
        exists(Definition def | this = TRefDef(def) and def.getLocation() = result)
        or
        exists(BasicBlock bb | this = TRefPhiRead(bb, _) and bb.getLocation() = result)
      }

      /** Holds if this reference of `v` occurs in `bb` at index `i`. */
      predicate accessAt(BasicBlock bb, int i, SourceVariable v) {
        this = TRefRead(bb, i, v)
        or
        exists(Definition def | this = TRefDef(def) and def.definesAt(v, bb, i))
        or
        this = TRefPhiRead(bb, v) and i = -1
      }
    }

    /**
     * Holds if `r2` is a certain read or uncertain write, and `r1` is the
     * unique prior reference.
     */
    query predicate adjacentRefRead(Ref r1, Ref r2) {
      exists(BasicBlock bb1, int i1, BasicBlock bb2, int i2, SourceVariable v |
        r1.accessAt(bb1, i1, v) and
        r2.accessAt(bb2, i2, v) and
        AdjacentSsaRefs::adjacentRefRead(bb1, i1, bb2, i2, v)
      )
    }

    /**
     * Holds if `phi` is a phi definition or phi read and `input` is one its
     * inputs without any other reference in-between.
     */
    query predicate adjacentRefPhi(Ref input, Ref phi) {
      exists(BasicBlock bb, int i, BasicBlock bbPhi, SourceVariable v |
        input.accessAt(bb, i, v) and
        phi.accessAt(bbPhi, -1, v) and
        AdjacentSsaRefs::adjacentRefPhi(bb, i, _, bbPhi, v)
      )
    }
  }
}
