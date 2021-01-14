/**
 * Provides classes for working with static single assignment (SSA) form.
 */

import csharp

module Ssa {
  class BasicBlock = ControlFlow::BasicBlock;

  private module SourceVariableImpl {
    private import AssignableDefinitions

    /** A field or a property. */
    class FieldOrProp extends Assignable, Modifiable {
      FieldOrProp() {
        this instanceof Field
        or
        this instanceof Property
      }

      /** Holds if this is a volatile field. */
      predicate isVolatile() { this.(Field).isVolatile() }
    }

    /** An instance field or property. */
    class InstanceFieldOrProp extends FieldOrProp {
      InstanceFieldOrProp() { not this.isStatic() }
    }

    /** An access to a field or a property. */
    class FieldOrPropAccess extends AssignableAccess, QualifiableExpr {
      FieldOrPropAccess() { this.getTarget() instanceof FieldOrProp }
    }

    /** An access to a field or a property that reads the underlying value. */
    class FieldOrPropRead extends FieldOrPropAccess, AssignableRead { }

    cached
    private module Cached {
      cached
      newtype TSourceVariable =
        TLocalVar(Callable c, LocalScopeVariable v) {
          c = v.getCallable()
          or
          // Local scope variables can be captured
          c = v.getAnAccess().getEnclosingCallable()
        } or
        TPlainFieldOrProp(Callable c, FieldOrProp f) {
          exists(FieldOrPropRead fr | isPlainFieldOrPropAccess(fr, f, c)) and
          trackFieldOrProp(f)
        } or
        TQualifiedFieldOrProp(Callable c, SourceVariable q, InstanceFieldOrProp f) {
          exists(FieldOrPropRead fr | isQualifiedFieldOrPropAccess(fr, f, c, q)) and
          trackFieldOrProp(f)
        }

      /** Gets an access to source variable `v`. */
      cached
      AssignableAccess getAnAccess(SourceVariable v) {
        exists(Callable c |
          exists(LocalScopeVariable lsv | v = TLocalVar(c, lsv) |
            result = lsv.getAnAccess() and
            result.getEnclosingCallable() = c
          )
          or
          exists(FieldOrProp fp | v = TPlainFieldOrProp(c, fp) |
            isPlainFieldOrPropAccess(result, fp, c)
          )
          or
          exists(FieldOrProp fp, SourceVariable q | v = TQualifiedFieldOrProp(c, q, fp) |
            isQualifiedFieldOrPropAccess(result, fp, c, q)
          )
        )
      }

      cached
      AssignableDefinition getADefinition(ExplicitDefinition def) {
        exists(SourceVariable v, AssignableDefinition ad | explicitDefinition(def, v, ad) |
          result = ad or
          result = getASameOutRefDefAfter(v, ad)
        )
      }

      cached
      predicate implicitEntryDefinition(ControlFlow::BasicBlocks::EntryBlock bb, SourceVariable v) {
        exists(Callable c |
          c = bb.getCallable() and
          c = v.getEnclosingCallable()
        |
          // Captured variable
          exists(LocalScopeVariable lsv |
            v = any(LocalScopeSourceVariable lv | lsv = lv.getAssignable())
          |
            lsv.getCallable() != c
          )
          or
          // Each tracked field and property has an implicit entry definition
          v instanceof PlainFieldOrPropSourceVariable
        )
      }
    }

    import Cached

    /**
     * Holds if `fpa` is an access inside callable `c` of `this`-qualified or
     * static field or property `fp`.
     */
    predicate isPlainFieldOrPropAccess(FieldOrPropAccess fpa, FieldOrProp fp, Callable c) {
      fieldOrPropAccessInCallable(fpa, fp, c) and
      (ownFieldOrPropAccess(fpa) or fp.isStatic())
    }

    /**
     * Holds if `fpa` is an access inside callable `c` of instance field or property
     * `fp` with qualifier `q`.
     */
    predicate isQualifiedFieldOrPropAccess(
      FieldOrPropAccess fpa, InstanceFieldOrProp fp, Callable c, SourceVariable q
    ) {
      fieldOrPropAccessInCallable(fpa, fp, c) and
      fpa.getQualifier() = q.getAnAccess()
    }

    /** Holds if `fpa` is an access inside callable `c` of field or property `fp`. */
    private predicate fieldOrPropAccessInCallable(FieldOrPropAccess fpa, FieldOrProp fp, Callable c) {
      fp = fpa.getTarget() and
      c = fpa.getEnclosingCallable()
    }

    /** Holds if `fpa` is an access to an instance field or property of `this`. */
    predicate ownFieldOrPropAccess(FieldOrPropAccess fpa) {
      fpa.getQualifier() instanceof ThisAccess
    }

    /*
     * Liveness analysis to restrict the size of the SSA representation
     */

    /**
     * Holds if the `i`th node of basic block `bb` is assignable definition `ad`
     * targeting source variable `v`.
     */
    predicate variableDefinition(BasicBlock bb, int i, SourceVariable v, AssignableDefinition ad) {
      ad = v.getADefinition() and
      ad.getAControlFlowNode() = bb.getNode(i) and
      // In cases like `(x, x) = (0, 1)`, we discard the first (dead) definition of `x`
      not exists(TupleAssignmentDefinition first, TupleAssignmentDefinition second | first = ad |
        second.getAssignment() = first.getAssignment() and
        second.getEvaluationOrder() > first.getEvaluationOrder() and
        second = v.getADefinition()
      ) and
      // In cases like `M(out x, out x)`, there is no inherent evaluation order, so we
      // collapse the two definitions of `x`, using the first access as the representative,
      // and expose both definitions in `ExplicitDefinition.getADefinition()`
      not ad = getASameOutRefDefAfter(v, _)
    }

    /**
     * Gets an `out`/`ref` definition of the same source variable as the `out`/`ref`
     * definition `def`, belonging to the same call, at a position after `def`.
     */
    OutRefDefinition getASameOutRefDefAfter(SourceVariable v, OutRefDefinition def) {
      def = v.getADefinition() and
      result.getCall() = def.getCall() and
      result.getIndex() > def.getIndex() and
      result = v.getADefinition()
    }

    /**
     * Holds if the `i`th node of basic block `bb` is a (potential) write to source
     * variable `v`. The Boolean `certain` indicates whether the write is certain.
     *
     * This excludes implicit writes via calls.
     */
    predicate variableWriteDirect(BasicBlock bb, int i, SourceVariable v, boolean certain) {
      exists(AssignableDefinition ad | variableDefinition(bb, i, v, ad) |
        if
          any(AssignableDefinition ad0 | ad0 = ad or ad0 = getASameOutRefDefAfter(v, ad))
              .isCertain()
        then certain = true
        else certain = false
      )
      or
      variableWriteDirect(bb, i, v.(QualifiedFieldOrPropSourceVariable).getQualifier(), certain)
      or
      implicitEntryDefinition(bb, v) and
      i = -1 and
      certain = true
    }

    /**
     * A classification of variable reads.
     */
    newtype TReadKind =
      /** An actual read. */
      ActualRead() or
      /**
       * A pseudo read for a `ref` or `out` variable at the end of the variable's enclosing
       * callable. A pseudo read is inserted to make assignments to `out`/`ref` variables
       * live, for example line 1 in
       *
       * ```csharp
       * void M(out int i) {
       *   i = 0;
       * }
       * ```
       */
      OutRefExitRead() or
      /**
       * A pseudo read for a captured variable at the end of the capturing
       * callable. A write to a captured variable needs to be live for the same reasons
       * as a write to a `ref` or `out` variable (see above).
       */
      CapturedVarExitRead() or
      /**
       * A pseudo read for a captured variable via a call.
       */
      CapturedVarCallRead() or
      /**
       * A pseudo read for a `ref` variable, just prior to an update of the referenced value.
       * A pseudo read is inserted to make assignments to the `ref` variable live, for example
       * line 2 in
       *
       * ```csharp
       * void M() {
       *   ref int i = ref GetRef();
       *   i = 0;
       * }
       * ```
       *
       * The pseudo read is inserted at the CFG node `i` on the left-hand side of the
       * assignment on line 3.
       */
      RefReadBeforeWrite()

    class ReadKind extends TReadKind {
      string toString() {
        this = ActualRead() and
        result = "ActualRead"
        or
        this = OutRefExitRead() and
        result = "OutRefExitRead"
        or
        this = CapturedVarExitRead() and
        result = "CapturedVarExitRead"
        or
        this = CapturedVarCallRead() and
        result = "CapturedVarCallRead"
        or
        this = RefReadBeforeWrite() and
        result = "RefReadBeforeWrite"
      }

      /** Holds if this kind represents a pseudo read. */
      predicate isPseudo() { this != ActualRead() }
    }

    /**
     * Holds if the `i`th node `node` of basic block `bb` reads source variable `v`.
     * The read at `node` is of kind `rk`.
     *
     * This excludes implicit reads via calls.
     */
    predicate variableReadDirect(
      BasicBlock bb, int i, SourceVariable v, ControlFlow::Node node, ReadKind rk
    ) {
      v.getAnAccess().(AssignableRead) = node.getElement() and
      node = bb.getNode(i) and
      rk = ActualRead()
      or
      outRefExitRead(bb, i, v, node) and
      rk = OutRefExitRead()
      or
      refReadBeforeWrite(bb, i, v, node) and
      rk = RefReadBeforeWrite()
    }

    private predicate outRefExitRead(
      BasicBlock bb, int i, LocalScopeSourceVariable v, ControlFlow::Nodes::AnnotatedExitNode node
    ) {
      node.isNormal() and
      exists(LocalScopeVariable lsv |
        lsv = v.getAssignable() and
        bb.getNode(i) = node and
        node.getCallable() = lsv.getCallable()
      |
        lsv.(Parameter).isOutOrRef()
        or
        lsv.isRef() and
        strictcount(v.getAnAccess()) > 1
      )
    }

    private predicate refReadBeforeWrite(
      BasicBlock bb, int i, LocalScopeSourceVariable v, ControlFlow::Node node
    ) {
      exists(AssignableDefinitions::AssignmentDefinition def, LocalVariable lv |
        def.getTarget() = lv and
        lv.isRef() and
        lv = v.getAssignable() and
        node = def.getAControlFlowNode() and
        bb.getNode(i) = node
      )
    }

    /**
     * A classification of variable references into reads (of a given kind) and
     * (certain or uncertain) writes.
     */
    private newtype TRefKind =
      Read(ReadKind rk) or
      Write(boolean certain) { certain = true or certain = false }

    private class RefKind extends TRefKind {
      string toString() {
        exists(ReadKind rk | this = Read(rk) and result = "read (" + rk + ")")
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
      exists(ReadKind rk | variableRead(bb, i, v, _, rk) | k = Read(rk))
      or
      exists(boolean certain | variableWrite(bb, i, v, certain) | k = Write(certain))
    }

    private newtype TaggedRefIndex =
      MkTaggedRefIndex(int i, int tag) {
        exists(RefKind rk | ref(_, i, _, rk) | tag = rk.getOrder())
      }

    /**
     * Gets the (1-based) rank of the reference to `v` at the `i`th node of basic block `bb`,
     * which has the given reference kind `k`.
     *
     * Reads are considered before writes when they happen at the same index.
     */
    int refRank(BasicBlock bb, int i, SourceVariable v, RefKind k) {
      MkTaggedRefIndex(i, k.getOrder()) =
        rank[result](int j, RefKind rk0, int tag |
          ref(bb, j, v, rk0) and
          tag = rk0.getOrder()
        |
          MkTaggedRefIndex(j, tag) order by j, tag
        ) and
      ref(bb, i, v, k)
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
     * The read that witnesses the liveness of `v` is of kind `rk`.
     */
    predicate liveAtEntry(BasicBlock bb, SourceVariable v, ReadKind rk) {
      // The first read or certain write to `v` inside `bb` is a read
      refRank(bb, _, v, Read(rk)) = firstReadOrCertainWrite(bb, v)
      or
      // There is no certain write to `v` inside `bb`, but `v` is live at entry
      // to a successor basic block of `bb`
      not exists(firstReadOrCertainWrite(bb, v)) and
      liveAtExit(bb, v, rk)
    }

    /**
     * Holds if source variable `v` is live at the end of basic block `bb`.
     * The read that witnesses the liveness of `v` is of kind `rk`.
     */
    predicate liveAtExit(BasicBlock bb, SourceVariable v, ReadKind rk) {
      liveAtEntry(bb.getASuccessor(), v, rk)
    }

    /**
     * Holds if variable `v` is live in basic block `bb` at index `i`.
     * The rank of `i` is `rnk` as defined by `refRank()`.
     */
    private predicate liveAtRank(BasicBlock bb, int i, SourceVariable v, int rnk, ReadKind rk) {
      exists(RefKind kind | rnk = refRank(bb, i, v, kind) |
        rnk = maxRefRank(bb, v) and
        liveAtExit(bb, v, rk)
        or
        ref(bb, i, v, kind) and
        kind = Read(rk)
        or
        exists(RefKind nextKind |
          liveAtRank(bb, _, v, rnk + 1, rk) and
          rnk + 1 = refRank(bb, _, v, nextKind) and
          nextKind != Write(true)
        )
      )
    }

    /**
     * Holds if variable `v` is live after the (certain or uncertain) write at
     * index `i` inside basic block `bb`. The read that witnesses the liveness of
     * `v` is of kind `rk`.
     */
    predicate liveAfterWrite(BasicBlock bb, int i, SourceVariable v, ReadKind rk) {
      exists(int rnk | rnk = refRank(bb, i, v, Write(_)) | liveAtRank(bb, i, v, rnk, rk))
    }

    /**
     * Holds if `fp` is a field or a property that is interesting as a basis for SSA.
     *
     * - A volatile field is never interesting, since all reads must reread from
     *   memory and we are forced to assume that the value can change at any point.
     * - A property is only interesting if it is "field-like", that is, it is a
     *   non-overridable trivial property.
     */
    predicate trackFieldOrProp(FieldOrProp fp) {
      not fp.isVolatile() and
      (
        fp instanceof Field
        or
        fp = any(TrivialProperty p | not p.isOverridableOrImplementable())
      )
    }
  }

  private import SourceVariableImpl

  /**
   * A variable that can be SSA converted.
   *
   * Either a local scope variable (`SourceVariables::LocalScopeSourceVariable`)
   * or a fully qualified field or property (`SourceVariables::FieldOrPropSourceVariable`),
   * `q.fp1.fp2....fpn`, where the base qualifier `q` is either `this`, a local
   * scope variable, or a type in case `fp1` is static.
   */
  class SourceVariable extends TSourceVariable {
    /**
     * Gets the assignable corresponding to this source variable. Either
     * a local scope variable, a field, or a property.
     */
    Assignable getAssignable() { none() }

    /** Gets an access to this source variable. */
    AssignableAccess getAnAccess() { result = getAnAccess(this) }

    /** Gets a definition of this source variable. */
    AssignableDefinition getADefinition() {
      result.getTargetAccess() = this.getAnAccess()
      or
      // Local variable declaration without initializer
      not exists(result.getTargetAccess()) and
      this =
        any(LocalScopeSourceVariable v |
          result.getTarget() = v.getAssignable() and
          result.getEnclosingCallable() = v.getEnclosingCallable()
        )
    }

    /**
     * Holds if this variable is captured by a nested callable.
     */
    predicate isCaptured() { this.getAssignable().(LocalScopeVariable).isCaptured() }

    /** Gets the callable in which this source variable is defined. */
    Callable getEnclosingCallable() { none() }

    /** Gets a textual representation of this source variable. */
    string toString() { none() }

    /** Gets the location of this source variable. */
    Location getLocation() { none() }

    /** Gets the type of this source variable. */
    Type getType() { result = this.getAssignable().getType() }

    /** Gets the qualifier of this source variable, if any. */
    SourceVariable getQualifier() { none() }

    /**
     * Gets an SSA definition that has this variable as its underlying
     * source variable.
     */
    Definition getAnSsaDefinition() { result.getSourceVariable() = this }
  }

  /** Provides different types of `SourceVariable`s. */
  module SourceVariables {
    /** A local scope variable. */
    class LocalScopeSourceVariable extends SourceVariable, TLocalVar {
      override LocalScopeVariable getAssignable() { this = TLocalVar(_, result) }

      override Callable getEnclosingCallable() { this = TLocalVar(result, _) }

      override string toString() { result = getAssignable().getName() }

      override Location getLocation() { result = getAssignable().getLocation() }
    }

    /** A fully qualified field or property. */
    class FieldOrPropSourceVariable extends SourceVariable {
      FieldOrPropSourceVariable() {
        this = TPlainFieldOrProp(_, _) or
        this = TQualifiedFieldOrProp(_, _, _)
      }

      override FieldOrProp getAssignable() {
        this = TPlainFieldOrProp(_, result) or
        this = TQualifiedFieldOrProp(_, _, result)
      }

      /**
       * Gets the first access to this field or property in terms of source
       * code location. This is used as the representative location.
       */
      private FieldOrPropAccess getFirstAccess() {
        result =
          min(this.getAnAccess() as a
            order by
              a.getLocation().getStartLine(), a.getLocation().getStartColumn()
          )
      }

      override Location getLocation() { result = getFirstAccess().getLocation() }
    }

    /** A plain field or property. */
    class PlainFieldOrPropSourceVariable extends FieldOrPropSourceVariable, TPlainFieldOrProp {
      override Callable getEnclosingCallable() { this = TPlainFieldOrProp(result, _) }

      override string toString() {
        exists(FieldOrProp f, string prefix |
          f = getAssignable() and
          result = prefix + "." + getAssignable()
        |
          if f.isStatic() then prefix = f.getDeclaringType().getQualifiedName() else prefix = "this"
        )
      }
    }

    /** A qualified field or property. */
    class QualifiedFieldOrPropSourceVariable extends FieldOrPropSourceVariable,
      TQualifiedFieldOrProp {
      override Callable getEnclosingCallable() { this = TQualifiedFieldOrProp(result, _, _) }

      override SourceVariable getQualifier() { this = TQualifiedFieldOrProp(_, result, _) }

      override string toString() { result = getQualifier() + "." + getAssignable() }
    }
  }

  private import SourceVariables

  private module SsaDefReaches {
    /**
     * A classification of SSA variable references into reads definitions.
     */
    private newtype TSsaRefKind =
      SsaRead() or
      SsaDef()

    private class SsaRefKind extends TSsaRefKind {
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
     */
    private predicate ssaRef(BasicBlock bb, int i, SourceVariable v, SsaRefKind k) {
      variableRead(bb, i, v, _, _) and
      k = SsaRead()
      or
      exists(Definition def | def.definesAt(v, bb, i)) and
      k = SsaDef()
    }

    private newtype TaggedSsaRefIndex =
      MkTaggedSsaRefIndex(int i, SsaRefKind k) { ssaRef(_, i, _, k) }

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
    private int ssaRefRank(BasicBlock bb, int i, SourceVariable v, SsaRefKind k) {
      MkTaggedSsaRefIndex(i, k) =
        rank[result](int j, SsaRefKind k0 |
          ssaRef(bb, j, v, k0)
        |
          MkTaggedSsaRefIndex(j, k0) order by j, k0.getOrder()
        ) and
      ssaRef(bb, i, v, k)
    }

    private int maxSsaRefRank(BasicBlock bb, SourceVariable v) {
      result = ssaRefRank(bb, _, v, _) and
      not result + 1 = ssaRefRank(bb, _, v, _)
    }

    /**
     * Holds if the SSA definition `def` reaches rank index `rankix` in its own
     * basic block `bb`.
     */
    private predicate ssaDefReachesRank(BasicBlock bb, Definition def, int rankix, SourceVariable v) {
      exists(int i |
        rankix = ssaRefRank(bb, i, v, SsaDef()) and
        def.definesAt(v, bb, i)
      )
      or
      ssaDefReachesRank(bb, def, rankix - 1, v) and
      rankix = ssaRefRank(bb, _, v, SsaRead())
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches `read` in the
     * same basic block without crossing another SSA definition of `v`.
     * The read at `node` is of kind `rk`.
     */
    private predicate ssaDefReachesReadWithinBlock(
      SourceVariable v, Definition def, ControlFlow::Node read, ReadKind rk
    ) {
      exists(BasicBlock bb, int rankix, int i |
        ssaDefReachesRank(bb, def, rankix, v) and
        rankix = ssaRefRank(bb, i, v, SsaRead()) and
        variableRead(bb, i, v, read, rk)
      )
    }

    /**
     * Holds if the SSA definition of `v` at `def` reaches uncertain SSA definition
     * `redef` in the same basic block, without crossing another SSA definition of `v`.
     */
    private predicate ssaDefReachesUncertainDefWithinBlock(
      SourceVariable v, Definition def, UncertainDefinition redef
    ) {
      exists(BasicBlock bb, int rankix, int i |
        ssaDefReachesRank(bb, def, rankix, v) and
        rankix = ssaRefRank(bb, i, v, SsaDef()) - 1 and
        redef.definesAt(v, bb, i)
      )
    }

    /**
     * Same as `ssaRefRank()`, but restricted to a particular SSA definition `def`.
     */
    private int ssaDefRank(Definition def, SourceVariable v, BasicBlock bb, int i, SsaRefKind k) {
      v = def.getSourceVariable() and
      result = ssaRefRank(bb, i, v, k) and
      (
        ssaDefReachesRead(_, def, bb.getNode(i), _)
        or
        def.definesAt(_, bb, i)
      )
    }

    private predicate varOccursInBlock(Definition def, BasicBlock bb, SourceVariable v) {
      exists(ssaDefRank(def, v, bb, _, _))
    }

    pragma[noinline]
    private BasicBlock getAMaybeLiveSuccessor(Definition def, BasicBlock bb) {
      result = bb.getASuccessor() and
      not varOccursInBlock(_, bb, def.getSourceVariable()) and
      ssaDefReachesEndOfBlock(bb, def, _)
    }

    /**
     * Holds if `def` is accessed in basic block `bb1` (either a read or a write),
     * `bb2` is a transitive successor of `bb1`, `def` is live at the end of `bb1`,
     * and the underlying variable for `def` is neither read nor written in any block
     * on the path between `bb1` and `bb2`.
     */
    private predicate varBlockReaches(Definition def, BasicBlock bb1, BasicBlock bb2) {
      varOccursInBlock(def, bb1, _) and
      bb2 = bb1.getASuccessor()
      or
      exists(BasicBlock mid | varBlockReaches(def, bb1, mid) |
        bb2 = getAMaybeLiveSuccessor(def, mid)
      )
    }

    /**
     * Holds if `def` is accessed in basic block `bb1` (either a read or a write),
     * `def` is read at `cfn`, `cfn` is in a transitive successor block of `bb1`,
     * and `def` is not read in any block on the path between `bb1` and `cfn`.
     */
    private predicate varBlockReachesRead(Definition def, BasicBlock bb1, ControlFlow::Node cfn) {
      exists(BasicBlock bb2, int i2 |
        varBlockReaches(def, bb1, bb2) and
        ssaRefRank(bb2, i2, def.getSourceVariable(), SsaRead()) = 1 and
        variableRead(bb2, i2, _, cfn, _)
      )
    }

    /**
     * Holds if `def` is accessed at index `i1` in basic block `bb1` (either a read
     * or a write), `def` is read at `cfn`, and there is a path between them without
     * any read of `def`.
     */
    private predicate adjacentVarRead(Definition def, BasicBlock bb1, int i1, ControlFlow::Node cfn) {
      exists(int rankix, int i2 |
        rankix = ssaDefRank(def, _, bb1, i1, _) and
        rankix + 1 = ssaDefRank(def, _, bb1, i2, SsaRead()) and
        variableRead(bb1, i2, _, cfn, _)
      )
      or
      exists(SourceVariable v | ssaDefRank(def, v, bb1, i1, _) = maxSsaRefRank(bb1, v)) and
      varBlockReachesRead(def, bb1, cfn)
    }

    cached
    private module Cached {
      /**
       * Holds if the node at index `i` in `bb` is a last reference to SSA
       * definition `def`.
       *
       * That is, the node can reach the end of the enclosing callable, or another
       * SSA definition for the underlying source variable, without passing through
       * another read.
       */
      cached
      predicate lastRef(Definition def, BasicBlock bb, int i) {
        exists(int rnk, SourceVariable v | rnk = ssaDefRank(def, v, bb, i, _) |
          // Next reference to `v` inside `bb` is a write
          rnk + 1 = ssaRefRank(bb, _, v, SsaDef())
          or
          // No more references to `v` inside `bb`
          rnk = maxSsaRefRank(bb, v) and
          (
            // Can reach exit directly
            bb instanceof ControlFlow::BasicBlocks::ExitBlock
            or
            exists(BasicBlock bb2 | varBlockReaches(def, bb, bb2) |
              // Can reach a write using one or more steps
              1 = ssaRefRank(bb2, _, def.getSourceVariable(), SsaDef())
              or
              // Can reach a block using one or more steps, where `def` is no longer live
              not varOccursInBlock(def, bb2, _) and
              not ssaDefReachesEndOfBlock(bb2, def, _)
            )
          )
        )
      }

      pragma[noinline]
      private predicate ssaDefReachesEndOfBlockRec(BasicBlock bb, Definition def, SourceVariable v) {
        exists(BasicBlock idom | ssaDefReachesEndOfBlock(idom, def, v) |
          // The construction of SSA form ensures that each read of a variable is
          // dominated by its definition. An SSA definition therefore reaches a
          // control flow node if it is the _closest_ SSA definition that dominates
          // the node. If two definitions dominate a node then one must dominate the
          // other, so therefore the definition of _closest_ is given by the dominator
          // tree. Thus, reaching definitions can be calculated in terms of dominance.
          idom = bb.getImmediateDominator()
        )
      }

      /**
       * Holds if the SSA definition of `v` at `def` reaches the end of a basic
       * block `bb`, at which point it is still live, without crossing another
       * SSA definition of `v`.
       */
      cached
      predicate ssaDefReachesEndOfBlock(BasicBlock bb, Definition def, SourceVariable v) {
        exists(int last | last = maxSsaRefRank(bb, v) |
          ssaDefReachesRank(bb, def, last, v) and
          liveAtExit(bb, v, _)
        )
        or
        ssaDefReachesEndOfBlockRec(bb, def, v) and
        liveAtExit(bb, v, _) and
        not ssaRef(bb, _, v, SsaDef())
      }

      /**
       * Holds if the SSA definition of `v` at `def` reaches `read` without crossing
       * another SSA definition of `v`. The read at `node` is of kind `rk`.
       */
      cached
      predicate ssaDefReachesRead(
        SourceVariable v, Definition def, ControlFlow::Node read, ReadKind rk
      ) {
        ssaDefReachesReadWithinBlock(v, def, read, rk)
        or
        exists(BasicBlock bb |
          variableRead(bb, _, v, read, rk) and
          ssaDefReachesEndOfBlock(bb.getAPredecessor(), def, v) and
          not ssaDefReachesReadWithinBlock(v, _, read, _)
        )
      }

      /**
       * Holds if the SSA definition of `v` at `def` reaches uncertain SSA definition
       * `redef` without crossing another SSA definition of `v`.
       */
      cached
      predicate ssaDefReachesUncertainDef(
        SourceVariable v, Definition def, UncertainDefinition redef
      ) {
        ssaDefReachesUncertainDefWithinBlock(v, def, redef)
        or
        exists(BasicBlock bb |
          redef.definesAt(v, bb, _) and
          ssaDefReachesEndOfBlock(bb.getAPredecessor(), def, v) and
          not ssaDefReachesUncertainDefWithinBlock(v, _, redef)
        )
      }

      /** Same as `adjacentVarRead`, but steps over pseudo reads. */
      private predicate adjacentVarActualRead(
        Definition def, BasicBlock bb1, int i1, ControlFlow::Node cfn
      ) {
        adjacentVarRead(def, bb1, i1, cfn)
        or
        exists(ControlFlow::Node mid, BasicBlock bb2, int i2 |
          adjacentVarActualRead(def, bb1, i1, mid) and
          variableRead(bb2, i2, _, mid, any(ReadKind rk | rk.isPseudo())) and
          adjacentVarRead(def, bb2, i2, cfn)
        )
      }

      /**
       * Holds if the value defined at SSA definition `def` can reach a read at `cfn`,
       * without passing through any other read.
       */
      cached
      predicate firstReadSameVar(Definition def, ControlFlow::Node cfn) {
        exists(BasicBlock bb1, int i1 |
          def.definesAt(_, bb1, i1) and
          adjacentVarActualRead(def, bb1, i1, cfn) and
          variableRead(_, _, _, cfn, ActualRead())
        )
      }

      /**
       * Holds if the read at `cfn2` is a read of the same SSA definition `def`
       * as the read at `cfn1`, and `cfn2` can be reached from `cfn1` without
       * passing through another read.
       */
      cached
      predicate adjacentReadPairSameVar(
        Definition def, ControlFlow::Node cfn1, ControlFlow::Node cfn2
      ) {
        exists(BasicBlock bb1, int i1 |
          variableRead(bb1, i1, _, cfn1, ActualRead()) and
          adjacentVarActualRead(def, bb1, i1, cfn2) and
          variableRead(_, _, _, cfn2, ActualRead())
        )
      }

      private predicate reachesLastRef(Definition def, BasicBlock bb, int i) {
        lastRef(def, bb, i)
        or
        exists(BasicBlock bb0, int i0, ControlFlow::Node cfn |
          reachesLastRef(def, bb0, i0) and
          variableRead(bb0, i0, _, cfn, any(ReadKind rk | rk.isPseudo())) and
          adjacentVarRead(def, bb, i, cfn)
        )
      }

      cached
      predicate lastReadSameVar(Definition def, ControlFlow::Node cfn) {
        exists(BasicBlock bb, int i |
          reachesLastRef(def, bb, i) and
          variableRead(bb, i, _, _, ActualRead()) and
          cfn = bb.getNode(i)
        )
      }
    }

    import Cached
  }

  private import SsaDefReaches

  /**
   * The SSA construction for a field or a property `fp` relies on implicit
   * update nodes at every call site that conceivably could reach an update
   * of the field or property. For example, there is an implicit update of
   * `this.Field` on line 7 in
   *
   * ```csharp
   * int Field;
   *
   * void SetField(int i) { Field = i; }
   *
   * int M() {
   *   Field = 0;
   *   SetField(1); // implicit update of `this.Field`
   *   return Field;
   * }
   * ```
   *
   * At a first approximation, we need to find update paths of the form:
   *
   * ```
   *   Call --(callEdge)-->* Callable(setter of fp)
   * ```
   *
   * This can be improved by excluding paths ending in:
   *
   * ```
   *   Constructor --(intraInstanceCallEdge)-->+ Callable(setter of this.fp)
   * ```
   *
   * as these updates are guaranteed not to alias with the `fp` under
   * consideration.
   *
   * This set of paths can be expressed positively by noting that those
   * that set `this.fp`, end in zero or more `intraInstanceCallEdge`s between
   * callables, and before those is either the originating `Call`:
   *
   * ```
   *   Call --(intraInstanceCallEdge)-->* Callable(setter of this.fp)
   * ```
   *
   * or a `crossInstanceCallEdge`:
   *
   * ```
   *   Call --crossInstanceCallEdge--> Callable
   *        --(intraInstanceCallEdge)-->* Callable(setter of this.fp)
   * ```
   */
  private module FieldOrPropsImpl {
    private import semmle.code.csharp.dispatch.Dispatch

    /**
     * A callable that is neither static nor a constructor.
     */
    private class InstanceCallable extends Callable {
      InstanceCallable() {
        not this.(Modifiable).isStatic() and
        not this instanceof Constructor
      }
    }

    private class FieldOrPropDefinition extends AssignableDefinition {
      FieldOrPropDefinition() { this.getTarget() instanceof FieldOrProp }
    }

    /**
     * Holds if `fpdef` is a definition that is not relevant as an implicit
     * SSA update, since it is an initialization and therefore cannot alias.
     */
    private predicate init(FieldOrPropDefinition fpdef) {
      exists(FieldOrPropAccess access | access = fpdef.getTargetAccess() |
        fpdef.getEnclosingCallable() instanceof Constructor and
        ownFieldOrPropAccess(access)
        or
        exists(LocalVariable v |
          v.getAnAccess() = access.getQualifier() and
          not v.isCaptured() and
          forex(AssignableDefinition def | def.getTarget() = v and exists(def.getSource()) |
            def.getSource() instanceof ObjectCreation
          )
        )
      )
      or
      fpdef.(AssignableDefinitions::AssignmentDefinition).getAssignment() instanceof
        MemberInitializer
    }

    /**
     * Holds if `fpdef` is an update of `fp` in `c` that is relevant for SSA construction.
     */
    private predicate relevantDefinition(Callable c, FieldOrProp fp, FieldOrPropDefinition fpdef) {
      fpdef.getTarget() = fp and
      not init(fpdef) and
      fpdef.getEnclosingCallable() = c and
      exists(FieldOrPropSourceVariable tf | tf.getAssignable() = fp)
    }

    /**
     * Holds if callable `c` can change the value of `this.fp` and is relevant
     * for SSA construction.
     */
    private predicate setsOwnFieldOrProp(InstanceCallable c, FieldOrProp fp) {
      exists(FieldOrPropDefinition fpdef | relevantDefinition(c, fp, fpdef) |
        ownFieldOrPropAccess(fpdef.getTargetAccess())
      )
    }

    /**
     * Holds if callable `c` can change the value of `fp` and is relevant for SSA
     * construction excluding those cases covered by `setsOwnFieldOrProp`.
     */
    private predicate setsOtherFieldOrProp(Callable c, FieldOrProp fp) {
      exists(FieldOrPropDefinition fpdef | relevantDefinition(c, fp, fpdef) |
        not ownFieldOrPropAccess(fpdef.getTargetAccess())
      )
    }

    /**
     * Holds if `(c1,c2)` is a call edge to a callable that does not change the
     * value of `this`.
     *
     * Constructor-to-constructor calls can also be intra-instance, but are not
     * included, as this does not affect whether a call chain ends in
     *
     * ```
     *   Constructor --(intraInstanceCallEdge)-->+ Callable(setter of this.f)
     * ```
     */
    private predicate intraInstanceCallEdge(Callable c1, InstanceCallable c2) {
      exists(Call c |
        c.getEnclosingCallable() = c1 and
        c2 = getARuntimeTarget(c, _) and
        c.(QualifiableExpr).targetIsLocalInstance()
      )
    }

    /**
     * Gets a potential run-time target for the call `c`.
     *
     * This predicate differs from `Call.getARuntimeTarget()` in three ways:
     *
     * (1) The returned callable is always a source declaration,
     *
     * (2) a simpler analysis is applied for delegate calls (needed to avoid making
     *     the SSA library and `Call.getARuntimeTarget()` mutually recursive), and
     *
     * (3) indirect calls to delegates via calls to library callables are included.
     *
     * The Boolean `libraryDelegateCall` indicates whether `c` is a call to a library
     * method and the result is a delegate passed to `c`. For example, in
     *
     * ```csharp
     * Lazy<int> M1()
     * {
     *     return new Lazy<int>(M2);
     * }
     * ```
     *
     * the constructor call `new Lazy<int>(M2)` includes `M2` as a target.
     */
    Callable getARuntimeTarget(Call c, boolean libraryDelegateCall) {
      // Non-delegate call: use dispatch library
      exists(DispatchCall dc | dc.getCall() = c |
        result = dc.getADynamicTarget().getUnboundDeclaration() and
        libraryDelegateCall = false
      )
      or
      // Delegate call: use simple analysis
      result = SimpleDelegateAnalysis::getARuntimeDelegateTarget(c, libraryDelegateCall)
    }

    private module SimpleDelegateAnalysis {
      private import semmle.code.csharp.dataflow.internal.DelegateDataFlow
      private import semmle.code.csharp.dataflow.internal.Steps
      private import semmle.code.csharp.frameworks.system.linq.Expressions

      /**
       * Holds if `c` is a call that (potentially) calls the delegate expression `e`.
       * Either `c` is a delegate call and `e` is the qualifier, or `c` is a call to
       * a library callable and `e` is a delegate argument.
       */
      private predicate delegateCall(Call c, Expr e, boolean libraryDelegateCall) {
        c = any(DelegateCall dc | e = dc.getDelegateExpr()) and
        libraryDelegateCall = false
        or
        c.getTarget().fromLibrary() and
        e = c.getAnArgument() and
        e.getType() instanceof SystemLinqExpressions::DelegateExtType and
        libraryDelegateCall = true
      }

      /** Holds if expression `e` is a delegate creation for callable `c` of type `t`. */
      private predicate delegateCreation(
        Expr e, Callable c, SystemLinqExpressions::DelegateExtType dt
      ) {
        e =
          any(AnonymousFunctionExpr afe |
            dt = afe.getType() and
            c = afe
          )
        or
        e =
          any(CallableAccess ca |
            c = ca.getTarget().getUnboundDeclaration() and
            dt = ca.getType()
          )
      }

      private predicate delegateFlowStep(Expr pred, Expr succ) {
        Steps::stepClosed(pred, succ)
        or
        exists(Call call, Callable callable |
          callable.getUnboundDeclaration().canReturn(pred) and
          call = succ
        |
          callable = call.getTarget() or
          callable = call.getTarget().(Method).getAnOverrider+() or
          callable = call.getTarget().(Method).getAnUltimateImplementor() or
          callable = getARuntimeDelegateTarget(call, false)
        )
        or
        pred = succ.(DelegateCreation).getArgument()
        or
        exists(AssignableDefinition def, Assignable a |
          a instanceof Field or
          a instanceof Property
        |
          a = def.getTarget() and
          succ.(AssignableRead) = a.getAnAccess() and
          pred = def.getSource()
        )
        or
        exists(AddEventExpr ae | succ.(EventAccess).getTarget() = ae.getTarget() |
          pred = ae.getRValue()
        )
      }

      private predicate reachesDelegateCall(Expr e) {
        delegateCall(_, e, _)
        or
        exists(Expr mid | reachesDelegateCall(mid) | delegateFlowStep(e, mid))
      }

      pragma[nomagic]
      private predicate delegateFlowStepReaches(Expr pred, Expr succ) {
        delegateFlowStep(pred, succ) and
        reachesDelegateCall(succ)
      }

      private Expr delegateCallSource(Callable c) {
        delegateCreation(result, c, _)
        or
        delegateFlowStepReaches(delegateCallSource(c), result)
      }

      /** Gets a run-time target for the delegate call `c`. */
      Callable getARuntimeDelegateTarget(Call c, boolean libraryDelegateCall) {
        delegateCall(c, delegateCallSource(result), libraryDelegateCall)
      }
    }

    /** Holds if `(c1,c2)` is an edge in the call graph. */
    predicate callEdge(Callable c1, Callable c2) {
      exists(Call c | c.getEnclosingCallable() = c1 and c2 = getARuntimeTarget(c, _))
    }

    /**
     * Holds if `(c1,c2)` is an edge in the call graph excluding
     * `intraInstanceCallEdge`.
     */
    private predicate crossInstanceCallEdge(Callable c1, Callable c2) {
      callEdge(c1, c2) and
      not intraInstanceCallEdge(c1, c2)
    }

    pragma[noinline]
    predicate callAt(BasicBlock bb, int i, Call call) {
      bb.getNode(i) = call.getAControlFlowNode() and
      getARuntimeTarget(call, _).hasBody()
    }

    /**
     * Holds if `call` occurs in basic block `bb` at index `i`, `fp` has
     * an update somewhere, and `fp` is likely to be live in `bb` at index
     * `i`.
     */
    private predicate updateCandidate(BasicBlock bb, int i, FieldOrPropSourceVariable fp, Call call) {
      callAt(bb, i, call) and
      call.getEnclosingCallable() = fp.getEnclosingCallable() and
      relevantDefinition(_, fp.getAssignable(), _) and
      not variableWriteDirect(bb, i, fp, _)
    }

    private predicate source(
      Call call, FieldOrPropSourceVariable fps, FieldOrProp fp, Callable c, boolean fresh
    ) {
      updateCandidate(_, _, fps, call) and
      c = getARuntimeTarget(call, _) and
      fp = fps.getAssignable() and
      if c instanceof Constructor then fresh = true else fresh = false
    }

    /**
     * A callable in a potential call-chain between a source that cares about the
     * value of some field `f` and a sink that may overwrite `f`. The Boolean
     * `fresh` indicates whether the instance `this` in `c` has been freshly
     * allocated along the call-chain.
     */
    private newtype TCallableNode =
      MkCallableNode(Callable c, boolean fresh) { source(_, _, _, c, fresh) or edge(_, c, fresh) }

    private predicate edge(TCallableNode n, Callable c2, boolean f2) {
      exists(Callable c1, boolean f1 | n = MkCallableNode(c1, f1) |
        intraInstanceCallEdge(c1, c2) and f2 = f1
        or
        crossInstanceCallEdge(c1, c2) and
        if c2 instanceof Constructor then f2 = true else f2 = false
      )
    }

    private predicate edge(TCallableNode n1, TCallableNode n2) {
      exists(Callable c2, boolean f2 |
        edge(n1, c2, f2) and
        n2 = MkCallableNode(c2, f2)
      )
    }

    pragma[noinline]
    private predicate source(
      Call call, FieldOrPropSourceVariable fps, FieldOrProp fp, TCallableNode n
    ) {
      exists(Callable c, boolean fresh |
        source(call, fps, fp, c, fresh) and
        n = MkCallableNode(c, fresh)
      )
    }

    private predicate sink(Callable c, FieldOrProp fp, TCallableNode n) {
      relevantDefinition(c, fp, _) and
      (
        setsOwnFieldOrProp(c, fp) and n = MkCallableNode(c, false)
        or
        setsOtherFieldOrProp(c, fp) and n = MkCallableNode(c, _)
      )
    }

    private predicate prunedNode(TCallableNode n) {
      sink(_, _, n)
      or
      exists(TCallableNode mid | edge(n, mid) and prunedNode(mid))
    }

    private predicate prunedEdge(TCallableNode n1, TCallableNode n2) {
      prunedNode(n1) and
      prunedNode(n2) and
      edge(n1, n2)
    }

    private predicate edgePlus(TCallableNode c1, TCallableNode c2) = fastTC(prunedEdge/2)(c1, c2)

    pragma[noopt]
    private predicate updatesNamedFieldOrProp(
      FieldOrPropSourceVariable fps, Call call, Callable setter
    ) {
      exists(TCallableNode src, TCallableNode sink, FieldOrProp fp |
        source(call, fps, fp, src) and
        sink(setter, fp, sink) and
        (src = sink or edgePlus(src, sink))
      )
    }

    /**
     * Holds if `call` may change the value of field or property `fp`. The actual
     * update occurs in `setter`.
     */
    cached
    predicate updatesNamedFieldOrProp(
      BasicBlock bb, int i, Call c, FieldOrPropSourceVariable fp, Callable setter
    ) {
      forceCachingInSameStage() and
      updateCandidate(bb, i, fp, c) and
      updatesNamedFieldOrProp(fp, c, setter)
    }
  }

  private import FieldOrPropsImpl

  /**
   * As in the SSA construction for fields and properties, SSA construction
   * for captured variables relies on implicit update nodes at every call
   * site that conceivably could reach an update of the captured variable.
   * For example, there is an implicit update of `v` on line 4 in
   *
   * ```csharp
   * int M() {
   *   int i = 0;
   *   Action a = () => { i = 1; };
   *   a(); // implicit update of `v`
   *   return i;
   * }
   * ```
   *
   * We find update paths of the form:
   *
   * ```
   *   Call --(callEdge)-->* Callable(update of v)
   * ```
   *
   * For simplicity, and for performance reasons, we ignore cases where a path
   * goes through the callable that introduces `v`; such a path does not
   * represent an actual update, as a new copy of `v` is updated.
   */
  private module CapturedVariableImpl {
    /**
     * A local scope variable that is captured, and updated by at least one capturer.
     */
    private class CapturedWrittenLocalScopeVariable extends LocalScopeVariable {
      CapturedWrittenLocalScopeVariable() {
        exists(AssignableDefinition def | def.getTarget() = this |
          def.getEnclosingCallable() != this.getCallable()
        )
      }
    }

    private class CapturedWrittenLocalScopeSourceVariable extends LocalScopeSourceVariable {
      CapturedWrittenLocalScopeSourceVariable() {
        this.getAssignable() instanceof CapturedWrittenLocalScopeVariable
      }
    }

    private class CapturedWrittenLocalScopeVariableDefinition extends AssignableDefinition {
      CapturedWrittenLocalScopeVariableDefinition() {
        this.getTarget() instanceof CapturedWrittenLocalScopeVariable
      }
    }

    /**
     * Holds if `vdef` is an update of captured variable `v` in callable `c`
     * that is relevant for SSA construction.
     */
    private predicate relevantDefinition(
      Callable c, CapturedWrittenLocalScopeVariable v,
      CapturedWrittenLocalScopeVariableDefinition vdef
    ) {
      exists(BasicBlock bb, int i, CapturedWrittenLocalScopeSourceVariable sv |
        vdef.getTarget() = v and
        vdef.getEnclosingCallable() = c and
        sv.getAssignable() = v and
        bb.getNode(i) = vdef.getAControlFlowNode() and
        c != v.getCallable()
      )
    }

    /**
     * Holds if `call` occurs in basic block `bb` at index `i`, captured variable
     * `v` has an update somewhere, and `v` is likely to be live in `bb` at index
     * `i`.
     */
    private predicate updateCandidate(
      BasicBlock bb, int i, CapturedWrittenLocalScopeSourceVariable v, Call call
    ) {
      callAt(bb, i, call) and
      call.getEnclosingCallable() = v.getEnclosingCallable() and
      exists(Assignable a |
        a = v.getAssignable() and
        relevantDefinition(_, a, _) and
        not exists(AssignableDefinitions::OutRefDefinition def |
          def.getCall() = call and
          def.getTarget() = a
        )
      )
    }

    private predicate source(
      Call call, CapturedWrittenLocalScopeSourceVariable v,
      CapturedWrittenLocalScopeVariable captured, Callable c, boolean libraryDelegateCall
    ) {
      updateCandidate(_, _, v, call) and
      c = getARuntimeTarget(call, libraryDelegateCall) and
      captured = v.getAssignable() and
      relevantDefinition(_, captured, _)
    }

    /**
     * Holds if `c` is a relevant part of the call graph for
     * `updatesCapturedVariable` based on following edges in forward direction.
     */
    private predicate reachbleFromSource(Callable c) {
      source(_, _, _, c, _)
      or
      exists(Callable mid | reachbleFromSource(mid) | callEdge(mid, c))
    }

    private predicate sink(Callable c, CapturedWrittenLocalScopeVariable captured) {
      reachbleFromSource(c) and
      relevantDefinition(c, captured, _)
    }

    private predicate prunedCallable(Callable c) {
      sink(c, _)
      or
      exists(Callable mid | callEdge(c, mid) and prunedCallable(mid))
    }

    private predicate prunedEdge(Callable c1, Callable c2) {
      prunedCallable(c1) and
      prunedCallable(c2) and
      callEdge(c1, c2)
    }

    private predicate edgePlus(Callable c1, Callable c2) = fastTC(prunedEdge/2)(c1, c2)

    /**
     * Holds if `call` may change the value of captured variable `v`. The actual
     * update occurs in `writer`. That is, `writer` can be reached from `call`
     * using zero or more additional calls (as indicated by `additionalCalls`).
     * One of the intermediate callables may be the callable that introduces `v`,
     * in which case `call` is not an actual update.
     */
    pragma[noopt]
    private predicate updatesCapturedVariableWriter(
      Call call, CapturedWrittenLocalScopeSourceVariable v, Callable writer, boolean additionalCalls
    ) {
      exists(Callable src, CapturedWrittenLocalScopeVariable captured, boolean libraryDelegateCall |
        source(call, v, captured, src, libraryDelegateCall) and
        sink(writer, captured) and
        (
          src = writer and additionalCalls = libraryDelegateCall
          or
          edgePlus(src, writer) and additionalCalls = true
        )
      )
    }

    /**
     * Holds if `call` may change the value of captured variable `v`. The actual
     * update occurs in `def`.
     */
    cached
    predicate updatesCapturedVariable(
      BasicBlock bb, int i, Call call, LocalScopeSourceVariable v, AssignableDefinition def,
      boolean additionalCalls
    ) {
      forceCachingInSameStage() and
      updateCandidate(bb, i, v, call) and
      exists(Callable writer | relevantDefinition(writer, v.getAssignable(), def) |
        updatesCapturedVariableWriter(call, v, writer, additionalCalls)
      )
    }
  }

  private import CapturedVariableImpl

  /**
   * Holds if the `i`th node of basic block `bb` is a (potential) write to source
   * variable `v`. The Boolean `certain` indicates whether the write is certain.
   *
   * This includes implicit writes via calls.
   */
  private predicate variableWrite(BasicBlock bb, int i, SourceVariable v, boolean certain) {
    variableWriteDirect(bb, i, v, certain)
    or
    variableWriteQualifier(bb, i, v, certain)
    or
    updatesNamedFieldOrProp(bb, i, _, v, _) and
    certain = false
    or
    updatesCapturedVariable(bb, i, _, v, _, _) and
    certain = false
  }

  cached
  private predicate variableWriteQualifier(
    BasicBlock bb, int i, QualifiedFieldOrPropSourceVariable v, boolean certain
  ) {
    forceCachingInSameStage() and
    variableWrite(bb, i, v.getQualifier(), certain) and
    // Eliminate corner case where a call definition can overlap with a
    // qualifier definition: if method `M` updates field `F`, then a call
    // to `M` is both an update of `x.M` and `x.M.M`, so the former call
    // definition should not give rise to an implicit qualifier definition
    // for `x.M.M`.
    not updatesNamedFieldOrProp(bb, i, _, v, _)
  }

  /**
   * Liveness analysis to restrict the size of the SSA representation for
   * captured variables.
   *
   * Example:
   *
   * ```csharp
   * void M() {
   *   int i = 0;
   *   void M2() {
   *     System.Console.WriteLine(i);
   *   }
   *   M2();
   * }
   * ```
   *
   * The definition of `i` on line 2 is live, because of the call to `M2` on
   * line 6. However, that call is not a direct read of `i`, so we account
   * for that by inserting an implicit read of `i` on line 6.
   *
   * The predicates in this module follow the same structure as those in
   * `CapturedVariableImpl`.
   */
  private module CapturedVariableLivenessImpl {
    /**
     * Holds if `c` is a callable that captures local scope variable `v`, and
     * `c` may read the value of the captured variable.
     */
    private predicate capturerReads(Callable c, LocalScopeVariable v) {
      exists(LocalScopeSourceVariable sv |
        variableReadDirect(_, _, sv, _, _) and
        c = sv.getEnclosingCallable() and
        v = sv.getAssignable() and
        v.getCallable() != c
      )
    }

    /**
     * A local scope variable that is captured, and read by at least one capturer.
     */
    private class CapturedReadLocalScopeVariable extends LocalScopeVariable {
      CapturedReadLocalScopeVariable() { capturerReads(_, this) }
    }

    private class CapturedReadLocalScopeSourceVariable extends LocalScopeSourceVariable {
      CapturedReadLocalScopeSourceVariable() {
        this.getAssignable() instanceof CapturedReadLocalScopeVariable
      }
    }

    /**
     * Holds if a write to captured source variable `v` may be read by a
     * callable reachable from the call `c`.
     */
    private predicate implicitReadCandidate(
      CapturedReadLocalScopeSourceVariable v, ControlFlow::Nodes::ElementNode c
    ) {
      exists(BasicBlock bb, int i | variableWriteDirect(bb, i, v, _) |
        c = bb.getNode(any(int j | j > i))
        or
        c = bb.getASuccessor+().getANode()
      )
    }

    private predicate source(
      ControlFlow::Nodes::ElementNode call, CapturedReadLocalScopeSourceVariable v,
      CapturedReadLocalScopeVariable captured, Callable c, boolean libraryDelegateCall
    ) {
      implicitReadCandidate(v, call) and
      c = getARuntimeTarget(call.getElement(), libraryDelegateCall) and
      captured = v.getAssignable() and
      capturerReads(_, captured)
    }

    /**
     * Holds if `c` is a relevant part of the call graph for
     * `readsCapturedVariable` based on following edges in forward direction.
     */
    private predicate reachbleFromSource(Callable c) {
      source(_, _, _, c, _)
      or
      exists(Callable mid | reachbleFromSource(mid) | callEdge(mid, c))
    }

    private predicate sink(Callable c, CapturedReadLocalScopeVariable captured) {
      reachbleFromSource(c) and
      capturerReads(c, captured)
    }

    private predicate prunedCallable(Callable c) {
      sink(c, _)
      or
      exists(Callable mid | callEdge(c, mid) and prunedCallable(mid))
    }

    private predicate prunedEdge(Callable c1, Callable c2) {
      prunedCallable(c1) and
      prunedCallable(c2) and
      callEdge(c1, c2)
    }

    private predicate edgePlus(Callable c1, Callable c2) = fastTC(prunedEdge/2)(c1, c2)

    /**
     * Holds if `call` may read the value of captured variable `v`. The actual
     * read occurs in `reader`. That is, `reader` can be reached from `call`
     * using zero or more additional calls (as indicated by `additionalCalls`).
     * One of the intermediate callables may be a callable that writes to `v`,
     * in which case `call` is not an actual read.
     */
    pragma[noopt]
    private predicate readsCapturedVariable(
      ControlFlow::Nodes::ElementNode call, CapturedReadLocalScopeSourceVariable v, Callable reader,
      boolean additionalCalls
    ) {
      exists(Callable src, CapturedReadLocalScopeVariable captured, boolean libraryDelegateCall |
        source(call, v, captured, src, libraryDelegateCall) and
        sink(reader, captured) and
        (
          src = reader and additionalCalls = libraryDelegateCall
          or
          edgePlus(src, reader) and additionalCalls = true
        )
      )
    }

    /**
     * Holds if captured local scope variable `v` is written inside the callable
     * to which `bb` belongs, and the value may be read via `call` using zero or
     * more additional calls (as indicated by `additionalCalls`).
     *
     * In this case a pseudo-read is inserted at the exit node `node`, at index
     * `i` in `bb`, in order to make the write live.
     *
     * Example:
     *
     * ```csharp
     * class C {
     *   void M1() {
     *     int i = 0;
     *     void M2() { i = 2; };
     *     M2();
     *     System.Console.WriteLine(i);
     *   }
     * }
     * ```
     *
     * The write to `i` inside `M2` on line 4 is live because of the implicit call
     * definition on line 5.
     */
    predicate capturedReadOut(
      BasicBlock bb, int i, LocalScopeSourceVariable v, ControlFlow::Nodes::AnnotatedExitNode node,
      LocalScopeSourceVariable outer, Call call, boolean additionalCalls
    ) {
      node.isNormal() and
      exists(BasicBlock pred, AssignableDefinition adef |
        variableDefinition(pred, _, v, adef) and
        updatesCapturedVariable(_, _, call, outer, adef, additionalCalls) and
        pred.getASuccessor*() = bb and
        node = bb.getNode(i)
      )
    }

    /**
     * Holds if a value written to captured local scope variable `outer` may be
     * read as `inner` via `call`, at index `i` in basic block `bb`, using one or
     * more calls (as indicated by `additionalCalls`).
     *
     * Example:
     *
     * ```csharp
     * class C {
     *   void M1() {
     *     int i = 0;
     *     void M2() => System.Console.WriteLine(i);
     *     i = 1;
     *     M2();
     *   }
     * }
     * ```
     *
     * The write to `i` on line 5 is live because of the call to `M2` on line 6, which
     * reaches the entry definition for `i` in `M2` on line 4.
     */
    predicate capturedReadIn(
      BasicBlock bb, int i, LocalScopeSourceVariable outer, LocalScopeSourceVariable inner,
      ControlFlow::Nodes::ElementNode call, boolean additionalCalls
    ) {
      exists(Callable reader |
        implicitReadCandidate(outer, call) and
        readsCapturedVariable(call, outer, reader, additionalCalls) and
        reader = inner.getEnclosingCallable() and
        outer.getAssignable() = inner.getAssignable() and
        call = bb.getNode(i)
      )
    }
  }

  private import CapturedVariableLivenessImpl

  /**
   * Holds if the `i`th node `node` of basic block `bb` reads source variable `v`.
   * The read at `node` is of kind `rk`.
   *
   * This includes implicit reads via calls.
   */
  private predicate variableRead(
    BasicBlock bb, int i, SourceVariable v, ControlFlow::Node node, ReadKind rk
  ) {
    variableReadDirect(bb, i, v, node, rk)
    or
    capturedReadOut(bb, i, v, node, _, _, _) and
    rk = CapturedVarExitRead()
    or
    capturedReadIn(bb, i, v, _, node, _) and
    rk = CapturedVarCallRead()
  }

  cached
  private module SsaImpl {
    cached
    predicate forceCachingInSameStage() { any() }

    cached
    newtype TDefinition =
      TWriteDef(SourceVariable v, BasicBlock bb, int i) {
        variableWrite(bb, i, v, _) and
        liveAfterWrite(bb, i, v, _)
      } or
      TPhiNode(SourceVariable v, ControlFlow::BasicBlocks::JoinBlock bb) {
        phiNodeMaybeLive(bb, v) and
        liveAtEntry(bb, v, _)
      }

    pragma[noinline]
    private predicate phiNodeMaybeLive(ControlFlow::BasicBlocks::JoinBlock bb, SourceVariable v) {
      exists(Definition def, BasicBlock bb1 | def.definesAt(v, bb1, _) |
        bb1.inDominanceFrontier(bb)
      )
    }

    cached
    predicate isCapturedVariableDefinitionFlowIn(
      ExplicitDefinition def, ImplicitEntryDefinition edef, ControlFlow::Nodes::ElementNode c,
      boolean additionalCalls
    ) {
      exists(Definition def0 |
        capturedReadIn(_, _, def.getSourceVariable(), edef.getSourceVariable(), c, additionalCalls) and
        def = def0.getAnUltimateDefinition() and
        ssaDefReachesRead(_, def0, c, CapturedVarCallRead())
      )
    }

    cached
    predicate isCapturedVariableDefinitionFlowOut(
      ExplicitDefinition def, ImplicitCallDefinition cdef, boolean additionalCalls
    ) {
      exists(Definition def0, BasicBlock bb, int i |
        def = def0.getAnUltimateDefinition() and
        lastRef(def0, bb, i) and
        capturedReadOut(bb, i, def0.getSourceVariable(), _, cdef.getSourceVariable(),
          cdef.getCall(), additionalCalls)
      )
    }

    cached
    predicate explicitDefinition(Definition def, SourceVariable v, AssignableDefinition ad) {
      exists(BasicBlock bb, int i |
        def = TWriteDef(v, bb, i) and
        variableDefinition(bb, i, v, ad)
      )
    }
  }

  private import SsaImpl

  private string getSplitString(Definition def) {
    exists(BasicBlock bb, int i, ControlFlow::Node cfn |
      def.definesAt(_, bb, i) and
      result = cfn.(ControlFlow::Nodes::ElementNode).getSplitsString()
    |
      cfn = bb.getNode(i)
      or
      not exists(bb.getNode(i)) and
      cfn = bb.getFirstNode()
    )
  }

  private string getToStringPrefix(Definition def) {
    result = "[" + getSplitString(def) + "] "
    or
    not exists(getSplitString(def)) and
    result = ""
  }

  /**
   * A static single assignment (SSA) definition. Either an explicit variable
   * definition (`ExplicitDefinition`), an implicit variable definition
   * (`ImplicitDefinition`), or a pseudo definition (`PseudoDefinition`).
   */
  class Definition extends TDefinition {
    /** Gets the source variable underlying this SSA definition. */
    SourceVariable getSourceVariable() { this.definesAt(result, _, _) }

    /**
     * Gets a read of the source variable underlying this SSA definition that
     * can be reached from this SSA definition without passing through any
     * other SSA definitions. Example:
     *
     * ```csharp
     * int Field;
     *
     * void SetField(int i) {
     *   this.Field = i;
     *   Use(this.Field);
     *   if (i > 0)
     *     this.Field = i - 1;
     *   else if (i < 0)
     *     SetField(1);
     *   Use(this.Field);
     *   Use(this.Field);
     * }
     * ```
     *
     * - The reads of `i` on lines 4, 6, 7, and 8 can be reached from the explicit
     *   SSA definition (wrapping an implicit entry definition) on line 3.
     * - The read of `this.Field` on line 5 can be reached from the explicit SSA
     *   definition on line 4.
     * - The reads of `this.Field` on lines 10 and 11 can be reached from the phi
     *   node between lines 9 and 10.
     */
    AssignableRead getARead() { result = this.getAReadAtNode(_) }

    /**
     * Gets a read of the source variable underlying this SSA definition at
     * control flow node `cfn` that can be reached from this SSA definition
     * without passing through any other SSA definitions. Example:
     *
     * ```csharp
     * int Field;
     *
     * void SetField(int i) {
     *   this.Field = i;
     *   Use(this.Field);
     *   if (i > 0)
     *     this.Field = i - 1;
     *   else if (i < 0)
     *     SetField(1);
     *   Use(this.Field);
     *   Use(this.Field);
     * }
     * ```
     *
     * - The reads of `i` on lines 4, 6, 7, and 8 can be reached from the implicit
     *   entry definition on line 3.
     * - The read of `this.Field` on line 5 can be reached from the explicit SSA
     *   definition on line 4.
     * - The reads of `this.Field` on lines 10 and 11 can be reached from the phi
     *   node between lines 9 and 10.
     */
    AssignableRead getAReadAtNode(ControlFlow::Node cfn) {
      ssaDefReachesRead(_, this, cfn, ActualRead()) and
      result.getAControlFlowNode() = cfn
    }

    /**
     * Gets a read of the source variable underlying this SSA definition that
     * can be reached from this SSA definition without passing through any
     * other SSA definition or read. Example:
     *
     * ```csharp
     * int Field;
     *
     * void SetField(int i) {
     *   this.Field = i;
     *   Use(this.Field);
     *   if (i > 0)
     *     this.Field = i - 1;
     *   else if (i < 0)
     *     SetField(1);
     *   Use(this.Field);
     *   Use(this.Field);
     * }
     * ```
     *
     * - The read of `i` on line 4 can be reached from the explicit SSA
     *   definition (wrapping an implicit entry definition) on line 3.
     * - The reads of `i` on lines 6 and 7 are not the first reads of any SSA
     *   definition.
     * - The read of `this.Field` on line 5 can be reached from the explicit SSA
     *   definition on line 4.
     * - The read of `this.Field` on line 10 can be reached from the phi node
     *   between lines 9 and 10.
     * - The read of `this.Field` on line 11 is not the first read of any SSA
     *   definition.
     *
     * Subsequent reads can be found by following the steps defined by
     * `AssignableRead.getANextRead()`.
     */
    AssignableRead getAFirstRead() { result = this.getAFirstReadAtNode(_) }

    /**
     * Gets a read of the source variable underlying this SSA definition at
     * control flow node `cfn` that can be reached from this SSA definition
     * without passing through any other SSA definition or read. Example:
     *
     * ```csharp
     * int Field;
     *
     * void SetField(int i) {
     *   this.Field = i;
     *   Use(this.Field);
     *   if (i > 0)
     *     this.Field = i - 1;
     *   else if (i < 0)
     *     SetField(1);
     *   Use(this.Field);
     *   Use(this.Field);
     * }
     * ```
     *
     * - The read of `i` on line 4 can be reached from the explicit SSA
     *   definition (wrapping an implicit entry definition) on line 3.
     * - The reads of `i` on lines 6 and 7 are not the first reads of any SSA
     *   definition.
     * - The read of `this.Field` on line 5 can be reached from the explicit SSA
     *   definition on line 4.
     * - The read of `this.Field` on line 10 can be reached from the phi node
     *   between lines 9 and 10.
     * - The read of `this.Field` on line 11 is not the first read of any SSA
     *   definition.
     *
     * Subsequent reads can be found by following the steps defined by
     * `AssignableRead.getANextRead()`.
     */
    AssignableRead getAFirstReadAtNode(ControlFlow::Node cfn) {
      firstReadSameVar(this, cfn) and
      result.getAControlFlowNode() = cfn
    }

    /**
     * Gets a last read of the source variable underlying this SSA definition.
     * That is, a read that can reach the end of the enclosing callable, or
     * another SSA definition for the source variable, without passing through
     * any other read. Example:
     *
     * ```csharp
     * int Field;
     *
     * void SetField(int i) {
     *   this.Field = i;
     *   Use(this.Field);
     *   if (i > 0)
     *     this.Field = i - 1;
     *   else if (i < 0)
     *     SetField(1);
     *   Use(this.Field);
     *   Use(this.Field);
     * }
     * ```
     *
     * - The reads of `i` on lines 7 and 8 are the last reads for the implicit
     *   parameter definition on line 3.
     * - The read of `this.Field` on line 5 is a last read of the definition on
     *   line 4.
     * - The read of `this.Field` on line 11 is a last read of the phi node
     *   between lines 9 and 10.
     */
    AssignableRead getALastRead() { result = this.getALastReadAtNode(_) }

    /**
     * Gets a last read of the source variable underlying this SSA definition at
     * control flow node `cfn`. That is, a read that can reach the end of the
     * enclosing callable, or another SSA definition for the source variable,
     * without passing through any other read. Example:
     *
     * ```csharp
     * int Field;
     *
     * void SetField(int i) {
     *   this.Field = i;
     *   Use(this.Field);
     *   if (i > 0)
     *     this.Field = i - 1;
     *   else if (i < 0)
     *     SetField(1);
     *   Use(this.Field);
     *   Use(this.Field);
     * }
     * ```
     *
     * - The reads of `i` on lines 7 and 8 are the last reads for the implicit
     *   parameter definition on line 3.
     * - The read of `this.Field` on line 5 is a last read of the definition on
     *   line 4.
     * - The read of `this.Field` on line 11 is a last read of the phi node
     *   between lines 9 and 10.
     */
    AssignableRead getALastReadAtNode(ControlFlow::Node cfn) {
      lastReadSameVar(this, cfn) and
      result.getAControlFlowNode() = cfn
    }

    /**
     * Gets a definition that ultimately defines this SSA definition and is
     * not itself a pseudo node. Example:
     *
     * ```csharp
     * int Field;
     *
     * void SetField(int i) {
     *   this.Field = i;
     *   Use(this.Field);
     *   if (i > 0)
     *     this.Field = i - 1;
     *   else if (i < 0)
     *     SetField(1);
     *   Use(this.Field);
     *   Use(this.Field);
     * }
     * ```
     *
     * - The explicit SSA definition (wrapping an implicit entry definition) of `i`
     *   on line 3 is defined in terms of itself.
     * - The explicit SSA definitions of `this.Field` on lines 4 and 7 are defined
     *   in terms of themselves.
     * - The implicit SSA definition of `this.Field` on line 9 is defined in terms
     *   of itself and the explicit definition on line 4.
     * - The phi node between lines 9 and 10 is defined in terms of the explicit
     *   definition on line 4, the explicit definition on line 7, and the implicit
     *   definition on line 9.
     */
    Definition getAnUltimateDefinition() {
      result = this.getAPseudoInputOrPriorDefinition*() and
      not result instanceof PseudoDefinition
    }

    /**
     * Gets an SSA definition whose value can flow to this one in one step. This
     * includes inputs to pseudo nodes and the prior definition of uncertain updates.
     */
    private Definition getAPseudoInputOrPriorDefinition() {
      result = this.(PseudoDefinition).getAnInput() or
      result = this.(UncertainDefinition).getPriorDefinition()
    }

    /**
     * Holds is this SSA definition is live at the end of basic block `bb`. That is,
     * this definition reaches the end of basic block `bb`, at which point it is still
     * live, without crossing another SSA definition of the same source variable.
     */
    predicate isLiveAtEndOfBlock(BasicBlock bb) { ssaDefReachesEndOfBlock(bb, this, _) }

    /**
     * DEPRECATED: Use `definesAt/3` instead.
     */
    deprecated predicate definesAt(BasicBlock bb, int i) { this.definesAt(_, bb, i) }

    /**
     * Holds if this SSA definition defines `v` at index `i` in basic block `bb`.
     * Phi nodes and entry nodes (captured variables and fields/properties) are
     * considered to be at index `-1`, while normal variable updates are at the
     * index of the control flow node they wrap.
     */
    predicate definesAt(SourceVariable v, BasicBlock bb, int i) {
      this = TWriteDef(v, bb, i)
      or
      this = TPhiNode(v, bb) and i = -1
    }

    /** Gets the basic block to which this SSA definition belongs. */
    BasicBlock getBasicBlock() { this.definesAt(_, result, _) }

    /**
     * Gets the control flow node of this SSA definition, if any. Phi nodes are examples
     * of SSA definitions without a control flow node, as they are modelled at index
     * `-1` in the relevant basic block.
     */
    ControlFlow::Node getControlFlowNode() {
      exists(BasicBlock bb, int i | this.definesAt(_, bb, i) | result = bb.getNode(i))
    }

    /**
     * Gets the syntax element associated with this SSA definition, if any.
     * This is either an expression, for example `x = 0`, a parameter, or a
     * callable. Pseudo nodes have no associated syntax element.
     */
    Element getElement() { result = this.getControlFlowNode().getElement() }

    /** Gets the callable to which this SSA definition belongs. */
    Callable getEnclosingCallable() { result = this.getSourceVariable().getEnclosingCallable() }

    /**
     * Holds if this SSA definition assigns to `out`/`ref` parameter `p`, and the
     * parameter may remain unchanged throughout the rest of the enclosing callable.
     */
    predicate isLiveOutRefParameterDefinition(Parameter p) {
      p.isOutOrRef() and
      exists(Definition def, BasicBlock bb, int i |
        this = def.getAnUltimateDefinition() and
        lastRef(def, bb, i) and
        variableRead(bb, i, def.getSourceVariable(), _, OutRefExitRead()) and
        p = def.getSourceVariable().getAssignable()
      )
    }

    /** Gets a textual representation of this SSA definition. */
    string toString() { none() }

    /** Gets the location of this SSA definition. */
    Location getLocation() { none() }
  }

  /**
   * An SSA definition that corresponds to an explicit assignable definition.
   */
  class ExplicitDefinition extends Definition, TWriteDef {
    SourceVariable sv;
    AssignableDefinition ad;

    ExplicitDefinition() { explicitDefinition(this, sv, ad) }

    /**
     * Gets an underlying assignable definition. The result is always unique,
     * except for pathological `out`/`ref` assignments like `M(out x, out x)`,
     * where there may be more than one underlying definition.
     */
    AssignableDefinition getADefinition() { result = getADefinition(this) }

    /**
     * Holds if this definition updates a captured local scope variable, and the updated
     * value may be read from the implicit entry definition `def` using one or more calls
     * (as indicated by `additionalCalls`), starting from call `c`.
     *
     * Example:
     *
     * ```csharp
     * class C {
     *   void M1() {
     *     int i = 0;
     *     void M2() => System.Console.WriteLine(i);
     *     i = 1;
     *     M2();
     *   }
     * }
     * ```
     *
     * If this definition is the update of `i` on line 5, then the value may be read inside
     * `M2` via the call on line 6.
     */
    predicate isCapturedVariableDefinitionFlowIn(
      ImplicitEntryDefinition def, ControlFlow::Nodes::ElementNode c, boolean additionalCalls
    ) {
      isCapturedVariableDefinitionFlowIn(this, def, c, additionalCalls)
    }

    /**
     * Holds if this definition updates a captured local scope variable, and the updated
     * value may be read from the implicit call definition `cdef` using one or more calls
     * (as indicated by `additionalCalls`).
     *
     * Example:
     *
     * ```csharp
     * class C {
     *   void M1() {
     *     int i = 0;
     *     void M2() { i = 2; };
     *     M2();
     *     System.Console.WriteLine(i);
     *   }
     * }
     * ```
     *
     * If this definition is the update of `i` on line 4, then the value may be read outside
     * of `M2` via the call on line 5.
     */
    predicate isCapturedVariableDefinitionFlowOut(
      ImplicitCallDefinition cdef, boolean additionalCalls
    ) {
      isCapturedVariableDefinitionFlowOut(this, cdef, additionalCalls)
    }

    override Element getElement() { result = ad.getElement() }

    override string toString() {
      if this.getADefinition() instanceof AssignableDefinitions::ImplicitParameterDefinition
      then result = getToStringPrefix(this) + "SSA param(" + this.getSourceVariable() + ")"
      else result = getToStringPrefix(this) + "SSA def(" + this.getSourceVariable() + ")"
    }

    override Location getLocation() { result = ad.getLocation() }
  }

  /**
   * An SSA definition that does not correspond to an explicit variable definition.
   * Either an implicit initialization of a variable at the beginning of a callable
   * (`ImplicitEntryDefinition`), an implicit definition via a call
   * (`ImplicitCallDefinition`), or an implicit definition where the qualifier is
   * updated (`ImplicitQualifierDefinition`).
   */
  class ImplicitDefinition extends Definition {
    ImplicitDefinition() {
      exists(BasicBlock bb, SourceVariable v, int i | this = TWriteDef(v, bb, i) |
        implicitEntryDefinition(bb, v) and
        i = -1
        or
        updatesNamedFieldOrProp(bb, i, _, v, _)
        or
        updatesCapturedVariable(bb, i, _, v, _, _)
        or
        variableWriteQualifier(bb, i, v, _)
      )
    }
  }

  /**
   * An SSA definition representing the implicit initialization of a variable
   * at the beginning of a callable. Either the variable is a local scope variable
   * captured by the callable, or a field or property accessed inside the callable.
   */
  class ImplicitEntryDefinition extends ImplicitDefinition, TWriteDef {
    ImplicitEntryDefinition() {
      exists(BasicBlock bb, SourceVariable v |
        this = TWriteDef(v, bb, -1) and
        implicitEntryDefinition(bb, v)
      )
    }

    /** Gets the callable that this entry definition belongs to. */
    Callable getCallable() {
      exists(BasicBlock bb |
        this = TWriteDef(_, bb, _) and
        result = bb.getCallable()
      )
    }

    override Callable getElement() { result = this.getCallable() }

    override string toString() {
      if this.getSourceVariable().getAssignable() instanceof LocalScopeVariable
      then result = getToStringPrefix(this) + "SSA capture def(" + this.getSourceVariable() + ")"
      else result = getToStringPrefix(this) + "SSA entry def(" + this.getSourceVariable() + ")"
    }

    override Location getLocation() { result = this.getCallable().getLocation() }
  }

  /**
   * An SSA definition representing the potential definition of a variable
   * via a call.
   */
  class ImplicitCallDefinition extends ImplicitDefinition, TWriteDef {
    private Call c;

    ImplicitCallDefinition() {
      exists(BasicBlock bb, SourceVariable v, int i | this = TWriteDef(v, bb, i) |
        updatesNamedFieldOrProp(bb, i, c, v, _)
        or
        updatesCapturedVariable(bb, i, c, v, _, _)
      )
    }

    Call getCall() { result = c }

    /**
     * Gets one of the definitions that may contribute to this implicit
     * call definition. That is, a definition that can be reached from
     * the target of this call following zero or more additional calls,
     * and which targets the same assignable as this SSA definition.
     */
    AssignableDefinition getAPossibleDefinition() {
      exists(Callable setter | updatesNamedFieldOrProp(_, _, getCall(), _, setter) |
        result.getEnclosingCallable() = setter and
        result.getTarget() = this.getSourceVariable().getAssignable()
      )
      or
      updatesCapturedVariable(_, _, getCall(), _, result, _) and
      result.getTarget() = this.getSourceVariable().getAssignable()
    }

    override string toString() {
      result = getToStringPrefix(this) + "SSA call def(" + getSourceVariable() + ")"
    }

    override Location getLocation() { result = getCall().getLocation() }
  }

  /**
   * An SSA definition representing the potential definition of a variable
   * via an SSA definition for the qualifier.
   */
  class ImplicitQualifierDefinition extends ImplicitDefinition, TWriteDef {
    private Definition q;

    ImplicitQualifierDefinition() {
      exists(BasicBlock bb, int i, QualifiedFieldOrPropSourceVariable v |
        this = TWriteDef(v, bb, i)
      |
        variableWriteQualifier(bb, i, v, _) and
        q.definesAt(v.getQualifier(), bb, i)
      )
    }

    /** Gets the SSA definition for the qualifier. */
    Definition getQualifierDefinition() { result = q }

    override string toString() {
      result = getToStringPrefix(this) + "SSA qualifier def(" + getSourceVariable() + ")"
    }

    override Location getLocation() { result = getQualifierDefinition().getLocation() }
  }

  /**
   * An SSA definition that has no actual semantics, but simply serves to
   * merge or filter data flow.
   *
   * Phi nodes are the canonical (and currently only) example.
   */
  class PseudoDefinition extends Definition {
    PseudoDefinition() { this = TPhiNode(_, _) }

    /**
     * Gets an input of this pseudo definition.
     */
    Definition getAnInput() { none() }
  }

  /**
   * An SSA phi node, that is, a pseudo definition for a variable at a point
   * in the flow graph where otherwise two or more definitions for the variable
   * would be visible.
   */
  class PhiNode extends PseudoDefinition, TPhiNode {
    /**
     * Gets an input of this phi node. Example:
     *
     * ```csharp
     * int Field;
     *
     * void SetField(int i) {
     *   this.Field = i;
     *   Use(this.Field);
     *   if (i > 0)
     *     this.Field = i - 1;
     *   else if (i < 0)
     *     SetField(1);
     *   Use(this.Field);
     *   Use(this.Field);
     * }
     * ```
     *
     * - The phi node for `this.Field` between lines 9 and 10 has the explicit
     *   definition on line 4, the explicit definition on line 7, and the implicit
     *   call definition on line 9 as inputs.
     */
    override Definition getAnInput() {
      exists(BasicBlock bb, BasicBlock phiPred, SourceVariable v |
        this.definesAt(v, bb, _) and
        bb.getAPredecessor() = phiPred and
        ssaDefReachesEndOfBlock(phiPred, result, v)
      )
    }

    /** Holds if `inp` is an input to the phi node along the edge originating in `bb`. */
    predicate hasInputFromBlock(Definition inp, BasicBlock bb) {
      this.getAnInput() = inp and
      this.getBasicBlock().getAPredecessor() = bb and
      inp.isLiveAtEndOfBlock(bb)
    }

    override string toString() {
      result = getToStringPrefix(this) + "SSA phi(" + getSourceVariable() + ")"
    }

    /*
     * The location of a phi node is the same as the location of the first node
     * in the basic block in which it is defined.
     *
     * Strictly speaking, the node is *before* the first node, but such a location
     * does not exist in the source program.
     */

    override Location getLocation() {
      exists(ControlFlow::BasicBlocks::JoinBlock bb |
        this = TPhiNode(_, bb) and
        result = bb.getFirstNode().getLocation()
      )
    }
  }

  /**
   * An SSA definition that represents an uncertain update of the underlying
   * assignable. Either an explicit update that is uncertain (`ref` assignments
   * need not be certain), an implicit non-local update via a call, or an
   * uncertain update of the qualifier.
   */
  class UncertainDefinition extends Definition {
    UncertainDefinition() {
      this =
        any(ExplicitDefinition def |
          forex(AssignableDefinition ad | ad = def.getADefinition() | not ad.isCertain())
        )
      or
      this instanceof ImplicitCallDefinition
      or
      this.(ImplicitQualifierDefinition).getQualifierDefinition() instanceof UncertainDefinition
    }

    /**
     * Gets the immediately preceding definition. Since this update is uncertain
     * the value from the preceding definition might still be valid.
     */
    Definition getPriorDefinition() { ssaDefReachesUncertainDef(_, result, this) }
  }

  /** INTERNAL: Do not use. */
  module Internal {
    import SsaDefReaches
  }
}
