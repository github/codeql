private import codeql.util.Unit
private import codeql.util.Location
private import semmle.code.cpp.interproccontrolflow.shared.ControlFlow

module MakeImpl<LocationSig Location, InputSig<Location> Lang> {
  private import Lang
  private import ControlFlowMake<Location, Lang>

  signature module FullConfigSig {
    class Label;

    predicate isSource(Node src, Label l);

    predicate isSink(Node sink, Label l);

    predicate isBarrierEdge(Node n1, Node n2, Label l);

    predicate isBarrier(Node n, Label l);
  }

  module DefaultLabel<ConfigSig Config> {
    class Label = Unit;

    predicate isSource(Node source, Label l) { Config::isSource(source) and exists(l) }

    predicate isSink(Node sink, Label l) { Config::isSink(sink) and exists(l) }

    predicate isBarrierEdge(Node n1, Node n2, Label l) {
      Config::isBarrierEdge(n1, n2) and exists(l)
    }

    predicate isBarrier(Node n, Label l) { Config::isBarrier(n) and exists(l) }
  }

  module Impl<FullConfigSig Config> {
    class Label = Config::Label;

    private predicate splitEdge(Node n1, Node n2) {
      exists(Split split |
        split.entry(n1, n2) or
        split.exit(n1, n2) or
        split.blocked(n1, n2)
      )
    }

    private predicate bbFirst(Node bb) {
      not edge(_, bb) and edge(bb, _)
      or
      strictcount(Node pred | edge(pred, bb)) > 1
      or
      exists(Node pred | edge(pred, bb) | strictcount(Node succ | edge(pred, succ)) > 1)
      or
      splitEdge(_, bb)
    }

    private newtype TBasicBlock = TMkBlock(Node bb) { bbFirst(bb) }

    class BasicBlock extends TBasicBlock {
      Node first;

      BasicBlock() { this = TMkBlock(first) }

      string toString() { result = first.toString() }

      /**
       * Holds if this element is at the specified location.
       * The location spans column `startcolumn` of line `startline` to
       * column `endcolumn` of line `endline` in file `filepath`.
       * For more information, see
       * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
       */
      predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      ) {
        first.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      }

      /** Gets an immediate successor of this basic block. */
      cached
      BasicBlock getASuccessor() { edge(this.getLastNode(), result.getFirstNode()) }

      /** Gets an immediate predecessor of this basic block. */
      BasicBlock getAPredecessor() { result.getASuccessor() = this }

      /** Gets a control-flow node contained in this basic block. */
      Node getANode() { result = this.getNode(_) }

      /** Gets the control-flow node at a specific (zero-indexed) position in this basic block. */
      cached
      Node getNode(int pos) {
        result = first and pos = 0
        or
        exists(Node mid, int mid_pos | pos = mid_pos + 1 |
          this.getNode(mid_pos) = mid and
          edge(mid, result) and
          not bbFirst(result)
        )
      }

      /** Gets the first control-flow node in this basic block. */
      Node getFirstNode() { result = first }

      /** Gets the last control-flow node in this basic block. */
      Node getLastNode() { result = this.getNode(this.length() - 1) }

      /** Gets the number of control-flow nodes contained in this basic block. */
      cached
      int length() { result = strictcount(this.getANode()) }

      /** Holds if this basic block dominates `node`. (This is reflexive.) */
      predicate dominates(BasicBlock node) { bbDominates(this, node) }

      Callable getEnclosingCallable() { result = getEnclosingCallable(this.getFirstNode()) }
    }

    /*
     * Predicates for basic-block-level dominance.
     */

    /** Entry points for control-flow. */
    private predicate flowEntry(BasicBlock entry) { flowEntry(_, entry.getFirstNode()) }

    /** The successor relation for basic blocks. */
    private predicate bbSucc(BasicBlock pre, BasicBlock post) { post = pre.getASuccessor() }

    /** The immediate dominance relation for basic blocks. */
    cached
    predicate bbIDominates(BasicBlock dom, BasicBlock node) =
      idominance(flowEntry/1, bbSucc/2)(_, dom, node)

    /** Holds if `dom` strictly dominates `node`. */
    predicate bbStrictlyDominates(BasicBlock dom, BasicBlock node) { bbIDominates+(dom, node) }

    /** Holds if `dom` dominates `node`. (This is reflexive.) */
    predicate bbDominates(BasicBlock dom, BasicBlock node) {
      bbStrictlyDominates(dom, node) or dom = node
    }

    private predicate callTargetUniq(CallNode call, Callable target) {
      target = unique(Callable tgt | callTarget(call, tgt))
    }

    private class JoinBlock extends BasicBlock {
      JoinBlock() { 2 <= strictcount(this.getAPredecessor()) }
    }

    private predicate barrierBlock(BasicBlock b, int i, Label l) {
      Config::isBarrier(b.getNode(i), l)
      or
      Config::isBarrierEdge(b.getNode(i - 1), b.getNode(i), l)
      or
      barrierCall(b.getNode(i), l)
    }

    private predicate barrierEdge(BasicBlock b1, BasicBlock b2, Label l) {
      Config::isBarrierEdge(b1.getLastNode(), b2.getFirstNode(), l)
    }

    private predicate callTargetUniq(Callable c1, Label l1, CallNode call, Callable c2, Label l2) {
      c1 = getEnclosingCallable(call) and
      callTargetUniq(call, c2) and
      l1 = l2
    }

    private predicate callTarget(Callable c1, Label l1, CallNode call, Callable c2, Label l2) {
      c1 = getEnclosingCallable(call) and
      callTarget(call, c2) and
      l1 = l2
    }

    private predicate candScopeFwd(Callable c, Label l, boolean cc) {
      exists(Node src |
        Config::isSource(src, l) and
        c = getEnclosingCallable(src) and
        cc = false
      )
      or
      exists(Callable mid, CallNode call, Label lmid |
        candScopeFwd(mid, lmid, _) and
        callTarget(mid, lmid, call, c, l) and
        cc = true
      )
      or
      exists(Callable mid, CallNode call, Label lmid |
        candScopeFwd(mid, lmid, cc) and
        callTarget(c, l, call, mid, lmid) and
        cc = false
      )
    }

    private predicate candScopeRev(Callable c, Label l, boolean cc) {
      candScopeFwd(c, l, _) and
      (
        exists(Node sink |
          Config::isSink(sink, l) and
          c = getEnclosingCallable(sink) and
          cc = false
        )
        or
        exists(Callable mid, Label lmid |
          candScopeRev(mid, lmid, _) and
          callTarget(mid, lmid, _, c, l) and
          cc = true
        )
        or
        exists(Callable mid, Label lmid |
          candScopeRev(mid, lmid, cc) and
          callTarget(c, l, _, mid, lmid) and
          cc = false
        )
      )
    }

    private predicate callTarget2(Callable c1, Label l1, CallNode call, Callable c2, Label l2) {
      callTarget(c1, l1, call, c2, l2) and
      candScopeRev(c1, l1, _) and
      candScopeRev(c2, l2, _)
    }

    private predicate candScopeBarrierFwd(Callable c, Label l) {
      candScopeRev(c, l, _)
      or
      exists(Callable mid, Label lmid |
        candScopeBarrierFwd(mid, lmid) and
        callTargetUniq(mid, lmid, _, c, l)
      )
    }

    private predicate candScopeBarrierRev(Callable c, Label l) {
      candScopeBarrierFwd(c, l) and
      (
        exists(BasicBlock b |
          barrierBlock(b, _, l) and
          c = getEnclosingCallable(b.getFirstNode())
        )
        or
        exists(BasicBlock b |
          barrierEdge(b, _, l) and
          c = getEnclosingCallable(b.getFirstNode())
        )
        or
        exists(Callable mid, Label lmid |
          candScopeBarrierRev(mid, lmid) and
          callTargetUniq(c, l, _, mid, lmid)
        )
      )
    }

    private predicate candLabel(BasicBlock b, Label l) {
      candScopeRev(getEnclosingCallable(b.getFirstNode()), l, _)
    }

    private predicate candNode(BasicBlock b, int i, Node n, Label l) {
      (
        Config::isSource(n, l) or
        Config::isSink(n, l) or
        callTarget2(_, l, n, _, _)
      ) and
      b.getNode(i) = n and
      not n = b.getFirstNode() and
      not n = b.getLastNode()
    }

    /**
     * Holds if it is possible to step from `n1` to `n2`. This implies
     * - `n2` is not a barrier
     * - no node between `n1` and `n2` is a barrier node
     * - there is no edge barrier between `n1` and `n2`
     * Note that `n1` is allowed to be a barrier node, but that this does not occur when called from `flowFwd` below.
     */
    private predicate step(Node n1, Node n2, Label l) {
      n1 != n2 and
      (
        // intra-block step
        exists(BasicBlock b, int i, int j |
          candNode(b, i, n1, l) and
          candNode(b, j, n2, l) and
          i < j and
          not exists(int k | barrierBlock(b, k, l) and i < k and k <= j)
        )
        or
        // block entry -> node
        exists(BasicBlock b, int i |
          n1 = b.getFirstNode() and
          candNode(b, i, n2, l) and
          not exists(int j | barrierBlock(b, j, l) and j <= i)
        )
        or
        // node -> block end
        exists(BasicBlock b, int i |
          candNode(b, i, n1, l) and
          n2 = b.getLastNode() and
          not exists(int j | barrierBlock(b, j, l) and i < j)
        )
        or
        // block entry -> block end
        exists(BasicBlock b |
          n1 = b.getFirstNode() and
          n2 = b.getLastNode() and
          candLabel(b, l) and
          not barrierBlock(b, _, l)
        )
        or
        // block end -> block entry
        exists(BasicBlock b1, BasicBlock b2 |
          b1.getASuccessor() = b2 and
          n1 = b1.getLastNode() and
          n2 = b2.getFirstNode() and
          candLabel(b1, l) and
          not barrierEdge(b1, b2, l) and
          not barrierBlock(b2, 0, l)
        )
      )
    }

    private predicate flowFwd(Node n, Label l) {
      candScopeRev(getEnclosingCallable(n), l, _) and
      (
        Config::isSource(n, l) and
        not Config::isBarrier(n, l)
        or
        exists(Node mid | flowFwd(mid, l) and step(mid, n, l))
        or
        exists(Node call, Label lmid, Callable c |
          flowFwd(call, lmid) and
          callTarget2(_, lmid, call, c, l) and
          flowEntry(c, n)
        )
      )
    }

    private predicate flowRev(Node n, Label l) {
      flowFwd(n, l) and
      (
        Config::isSink(n, l)
        or
        exists(Node mid | flowRev(mid, l) and step(n, mid, l))
        or
        exists(Node entry, Label lmid, Callable c |
          flowRev(entry, lmid) and
          flowEntry(c, entry) and
          callTarget2(_, l, n, c, lmid)
        )
      )
    }

    BasicBlock barrierBlock(Label l) { barrierBlock(result, _, l) }

    /**
     * Holds if every path through `call` goes through at least one barrier node.
     * We require that `call` has a unique call target.
     */
    private predicate barrierCall(CallNode call, Label l) {
      exists(Callable c2, Label l2 |
        callTargetUniq(_, l, call, c2, l2) and
        barrierCallable(c2, l2)
      )
    }

    /** Holds if a barrier dominates the exit of the callable. */
    private predicate barrierDominatesExit(Callable callable, Label l) {
      exists(BasicBlock exit |
        flowExit(callable, exit.getLastNode()) and
        barrierBlock(l).dominates(exit)
      )
    }

    /** Gets a `BasicBlock` that contains a barrier that does not dominate the exit. */
    private BasicBlock nonDominatingBarrierBlock(Label l) {
      exists(BasicBlock exit |
        result = barrierBlock(l) and
        flowExit(result.getEnclosingCallable(), exit.getLastNode()) and
        not result.dominates(exit)
      )
    }

    /**
     * Holds if `bb` is a block that is collectively dominated by a set of one or
     * more barriers that individually do not dominate the exit.
     */
    private predicate postBarrierBlock(BasicBlock bb, Label l) {
      bb = nonDominatingBarrierBlock(l) // is `bb` dominated by a barrier whenever it contains one?
      or
      if bb instanceof JoinBlock
      then forall(BasicBlock pred | pred = bb.getAPredecessor() | postBarrierBlock(pred, l))
      else postBarrierBlock(bb.getAPredecessor(), l)
    }

    /** Holds if every path through `callable` goes through at least one barrier node. */
    private predicate barrierCallable(Callable callable, Label l) {
      barrierDominatesExit(callable, l)
      or
      exists(BasicBlock exit |
        flowExit(callable, exit.getLastNode()) and
        postBarrierBlock(exit, l)
      )
    }

    private predicate candSplit(Callable c, Split split) {
      exists(Node n1, Node n2, Label l |
        step(n1, n2, l) and
        flowRev(n1, l) and
        flowRev(n2, l) and
        split.entry(n1, n2) and
        c = getEnclosingCallable(n1)
      )
    }

    private predicate flowFwdEntry(Node n, Label l) {
      flowRev(n, l) and
      (
        Config::isSource(n, l) and
        not Config::isBarrier(n, l)
        or
        exists(Node call, Label lmid, Callable c |
          flowFwd2(call, lmid) and
          callTarget2(_, lmid, call, c, l) and
          flowEntry(c, n)
        )
      )
    }

    private predicate flowFwdNoSplit(Node n, Label l) {
      flowFwdEntry(n, l)
      or
      flowRev(n, l) and
      exists(Node mid |
        flowFwdNoSplit(mid, l) and
        step(mid, n, l)
      )
    }

    private predicate flowFwdSplit(Node n, Label l, Split s, boolean active) {
      flowFwdEntry(n, l) and
      candSplit(getEnclosingCallable(n), s) and
      active = false
      or
      flowRev(n, l) and
      exists(Node mid, boolean a |
        flowFwdSplit(mid, l, s, a) and
        step(mid, n, l) and
        not (a = true and s.blocked(mid, n)) and
        if s.exit(mid, n)
        then active = false
        else
          if s.entry(mid, n)
          then active = true
          else active = a
      )
    }

    private predicate flowFwd2(Node n, Label l) {
      flowFwdNoSplit(n, l) and
      forall(Split s | candSplit(getEnclosingCallable(n), s) | flowFwdSplit(n, l, s, _))
    }

    private newtype TPathNode = TPathNodeMk(Node n, Label l) { flowFwd2(n, l) }

    class PathNode extends TPathNode {
      Node n;
      Label l;

      PathNode() { this = TPathNodeMk(n, l) }

      Node getNode() { result = n }

      Label getLabel() { result = l }

      string toString() { result = this.getNode().toString() }

      /**
       * Holds if this element is at the specified location.
       * The location spans column `startcolumn` of line `startline` to
       * column `endcolumn` of line `endline` in file `filepath`.
       * For more information, see
       * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
       */
      predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      ) {
        this.getNode()
            .getLocation()
            .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      }

      private PathNode getASuccessorIfHidden() {
        this.isHidden() and
        result = this.getASuccessorImpl()
      }

      private PathNode getASuccessorFromNonHidden() {
        result = this.getASuccessorImpl() and
        not this.isHidden()
        or
        result = this.getASuccessorFromNonHidden().getASuccessorIfHidden()
      }

      final PathNode getANonHiddenSuccessor() {
        result = this.getASuccessorFromNonHidden() and not result.isHidden()
      }

      predicate isHidden() {
        hiddenNode(this.getNode()) and
        not this.isSource() and
        not this.isSink()
      }

      PathNode getASuccessorImpl() {
        exists(Node succ |
          step(n, succ, l) and
          result = TPathNodeMk(succ, l)
        )
        or
        exists(Node succ, Label lsucc, Callable c |
          callTarget2(_, l, n, c, lsucc) and
          flowEntry(c, succ) and
          result = TPathNodeMk(succ, lsucc)
        )
      }

      predicate isSource() { Config::isSource(n, l) }

      predicate isSink() { Config::isSink(n, l) }
    }

    module PathGraph {
      query predicate edges(PathNode n1, PathNode n2) { n1.getANonHiddenSuccessor() = n2 }
    }

    predicate flowPath(PathNode src, PathNode sink) {
      src.isSource() and
      sink.isSink() and
      src.getANonHiddenSuccessor+() = sink
    }
  }
}
