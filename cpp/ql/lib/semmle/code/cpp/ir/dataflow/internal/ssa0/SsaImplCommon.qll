/**
 * Provides a language-independent implementation of static single assignment
 * (SSA) form.
 */

private import SsaImplSpecific

private BasicBlock getABasicBlockPredecessor(BasicBlock bb) { getABasicBlockSuccessor(result) = bb }

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
  private predicate ref(BasicBlock bb, int i, SourceVariable v, RefKind k) {
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

cached
newtype TDefinition =
  TWriteDef(SourceVariable v, BasicBlock bb, int i) {
    variableWrite(bb, i, v, _) and
    liveAfterWrite(bb, i, v)
  } or
  TPhiNode(SourceVariable v, BasicBlock bb) {
    inDefDominanceFrontier(bb, v) and
    liveAtEntry(bb, v)
  }

private module SsaDefReaches {
  newtype TSsaRefKind =
    SsaRead() or
    SsaDef()

  /**
   * A classification of SSA variable references into reads and definitions.
   */
  class SsaRefKind extends TSsaRefKind {
    string toString() {
      this = SsaRead() and
      result = "SsaRead"
      or
      this = SsaDef() and
      result = "SsaDef"
    }

    int getOrder() {
      this = SsaRead() and
      result = 0
      or
      this = SsaDef() and
      result = 1
    }
  }

  /**
   * Holds if the `i`th node of basic block `bb` is a reference to `v`,
   * either a read (when `k` is `SsaRead()`) or an SSA definition (when `k`
   * is `SsaDef()`).
   *
   * Unlike `Liveness::ref`, this includes `phi` nodes.
   */
  predicate ssaRef(BasicBlock bb, int i, SourceVariable v, SsaRefKind k) {
    variableRead(bb, i, v, _) and
    k = SsaRead()
    or
    exists(Definition def | def.definesAt(v, bb, i)) and
    k = SsaDef()
  }

  private newtype OrderedSsaRefIndex =
    MkOrderedSsaRefIndex(int i, SsaRefKind k) { ssaRef(_, i, _, k) }

  private OrderedSsaRefIndex ssaRefOrd(BasicBlock bb, int i, SourceVariable v, SsaRefKind k, int ord) {
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
  predicate ssaDefReachesRank(BasicBlock bb, Definition def, int rnk, SourceVariable v) {
    exists(int i |
      rnk = ssaRefRank(bb, i, v, SsaDef()) and
      def.definesAt(v, bb, i)
    )
    or
    ssaDefReachesRank(bb, def, rnk - 1, v) and
    rnk = ssaRefRank(bb, _, v, SsaRead())
  }

  /**
   * Holds if the SSA definition of `v` at `def` reaches index `i` in the same
   * basic block `bb`, without crossing another SSA definition of `v`.
   */
  predicate ssaDefReachesReadWithinBlock(SourceVariable v, Definition def, BasicBlock bb, int i) {
    exists(int rnk |
      ssaDefReachesRank(bb, def, rnk, v) and
      rnk = ssaRefRank(bb, i, v, SsaRead())
    )
  }

  /**
   * Same as `ssaRefRank()`, but restricted to a particular SSA definition `def`.
   */
  int ssaDefRank(Definition def, SourceVariable v, BasicBlock bb, int i, SsaRefKind k) {
    v = def.getSourceVariable() and
    result = ssaRefRank(bb, i, v, k) and
    (
      ssaDefReachesRead(_, def, bb, i)
      or
      def.definesAt(_, bb, i)
    )
  }

  /**
   * Holds if the reference to `def` at index `i` in basic block `bb` is the
   * last reference to `v` inside `bb`.
   */
  pragma[noinline]
  predicate lastSsaRef(Definition def, SourceVariable v, BasicBlock bb, int i) {
    ssaDefRank(def, v, bb, i, _) = maxSsaRefRank(bb, v)
  }

  predicate defOccursInBlock(Definition def, BasicBlock bb, SourceVariable v) {
    exists(ssaDefRank(def, v, bb, _, _))
  }

  pragma[noinline]
  private predicate ssaDefReachesThroughBlock(Definition def, BasicBlock bb) {
    ssaDefReachesEndOfBlock(bb, def, _) and
    not defOccursInBlock(_, bb, def.getSourceVariable())
  }

  /**
   * Holds if `def` is accessed in basic block `bb1` (either a read or a write),
   * `bb2` is a transitive successor of `bb1`, `def` is live at the end of `bb1`,
   * and the underlying variable for `def` is neither read nor written in any block
   * on the path between `bb1` and `bb2`.
   */
  predicate varBlockReaches(Definition def, BasicBlock bb1, BasicBlock bb2) {
    defOccursInBlock(def, bb1, _) and
    bb2 = getABasicBlockSuccessor(bb1)
    or
    exists(BasicBlock mid |
      varBlockReaches(def, bb1, mid) and
      ssaDefReachesThroughBlock(def, mid) and
      bb2 = getABasicBlockSuccessor(mid)
    )
  }

  /**
   * Holds if `def` is accessed in basic block `bb1` (either a read or a write),
   * `def` is read at index `i2` in basic block `bb2`, `bb2` is in a transitive
   * successor block of `bb1`, and `def` is neither read nor written in any block
   * on a path between `bb1` and `bb2`.
   */
  predicate defAdjacentRead(Definition def, BasicBlock bb1, BasicBlock bb2, int i2) {
    varBlockReaches(def, bb1, bb2) and
    ssaRefRank(bb2, i2, def.getSourceVariable(), SsaRead()) = 1
  }
}

private import SsaDefReaches

pragma[nomagic]
predicate liveThrough(BasicBlock bb, SourceVariable v) {
  liveAtExit(bb, v) and
  not ssaRef(bb, _, v, SsaDef())
}

/**
 * NB: If this predicate is exposed, it should be cached.
 *
 * Holds if the SSA definition of `v` at `def` reaches the end of basic
 * block `bb`, at which point it is still live, without crossing another
 * SSA definition of `v`.
 */
pragma[nomagic]
predicate ssaDefReachesEndOfBlock(BasicBlock bb, Definition def, SourceVariable v) {
  exists(int last | last = maxSsaRefRank(bb, v) |
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
  ssaDefReachesEndOfBlock(getImmediateBasicBlockDominator(bb), def, pragma[only_bind_into](v)) and
  liveThrough(bb, pragma[only_bind_into](v))
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
 * Holds if the SSA definition of `v` at `def` reaches a read at index `i` in
 * basic block `bb`, without crossing another SSA definition of `v`. The read
 * is of kind `rk`.
 */
pragma[nomagic]
predicate ssaDefReachesRead(SourceVariable v, Definition def, BasicBlock bb, int i) {
  ssaDefReachesReadWithinBlock(v, def, bb, i)
  or
  variableRead(bb, i, v, _) and
  ssaDefReachesEndOfBlock(getABasicBlockPredecessor(bb), def, v) and
  not ssaDefReachesReadWithinBlock(v, _, bb, i)
}

/**
 * NB: If this predicate is exposed, it should be cached.
 *
 * Holds if `def` is accessed at index `i1` in basic block `bb1` (either a read
 * or a write), `def` is read at index `i2` in basic block `bb2`, and there is a
 * path between them without any read of `def`.
 */
pragma[nomagic]
predicate adjacentDefRead(Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2) {
  exists(int rnk |
    rnk = ssaDefRank(def, _, bb1, i1, _) and
    rnk + 1 = ssaDefRank(def, _, bb1, i2, SsaRead()) and
    variableRead(bb1, i2, _, _) and
    bb2 = bb1
  )
  or
  lastSsaRef(def, _, bb1, i1) and
  defAdjacentRead(def, bb1, bb2, i2)
}

pragma[noinline]
private predicate adjacentDefRead(
  Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2, SourceVariable v
) {
  adjacentDefRead(def, bb1, i1, bb2, i2) and
  v = def.getSourceVariable()
}

private predicate adjacentDefReachesRead(
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
predicate adjacentDefNoUncertainReads(Definition def, BasicBlock bb1, int i1, BasicBlock bb2, int i2) {
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
predicate lastRefRedef(Definition def, BasicBlock bb, int i, Definition next) {
  exists(SourceVariable v |
    // Next reference to `v` inside `bb` is a write
    exists(int rnk, int j |
      rnk = ssaDefRank(def, v, bb, i, _) and
      next.definesAt(v, bb, j) and
      rnk + 1 = ssaRefRank(bb, j, v, SsaDef())
    )
    or
    // Can reach a write using one or more steps
    lastSsaRef(def, v, bb, i) and
    exists(BasicBlock bb2 |
      varBlockReaches(def, bb, bb2) and
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

private predicate adjacentDefReachesUncertainRead(
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
predicate lastRefRedefNoUncertainReads(Definition def, BasicBlock bb, int i, Definition next) {
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
predicate lastRef(Definition def, BasicBlock bb, int i) {
  lastRefRedef(def, bb, i, _)
  or
  lastSsaRef(def, _, bb, i) and
  (
    // Can reach exit directly
    bb instanceof ExitBasicBlock
    or
    // Can reach a block using one or more steps, where `def` is no longer live
    exists(BasicBlock bb2 | varBlockReaches(def, bb, bb2) |
      not defOccursInBlock(def, bb2, _) and
      not ssaDefReachesEndOfBlock(bb2, def, _)
    )
  )
}

/**
 * NB: If this predicate is exposed, it should be cached.
 *
 * Same as `lastRefRedef`, but ignores uncertain reads.
 */
pragma[nomagic]
predicate lastRefNoUncertainReads(Definition def, BasicBlock bb, int i) {
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
  string toString() { none() }
}

/** An SSA definition that corresponds to a write. */
class WriteDefinition extends Definition, TWriteDef {
  private SourceVariable v;
  private BasicBlock bb;
  private int i;

  WriteDefinition() { this = TWriteDef(v, bb, i) }

  override string toString() { result = "WriteDef" }
}

/** A phi node. */
class PhiNode extends Definition, TPhiNode {
  override string toString() { result = "Phi" }
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

/** Provides a set of consistency queries. */
module Consistency {
  abstract class RelevantDefinition extends Definition {
    abstract predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    );
  }

  query predicate nonUniqueDef(RelevantDefinition def, SourceVariable v, BasicBlock bb, int i) {
    ssaDefReachesRead(v, def, bb, i) and
    not exists(unique(Definition def0 | ssaDefReachesRead(v, def0, bb, i)))
  }

  query predicate readWithoutDef(SourceVariable v, BasicBlock bb, int i) {
    variableRead(bb, i, v, _) and
    not ssaDefReachesRead(v, _, bb, i)
  }

  query predicate deadDef(RelevantDefinition def, SourceVariable v) {
    v = def.getSourceVariable() and
    not ssaDefReachesRead(_, def, _, _) and
    not phiHasInputFromBlock(_, def, _) and
    not uncertainWriteDefinitionInput(_, def)
  }

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
}
