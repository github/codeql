/**
 * Provides query predicates for testing the CFG in an inline expectation qltest.
 */
overlay[local?]
module;

private import codeql.controlflow.SuccessorType
private import codeql.util.Location

signature module CfgSig<LocationSig Location> {
  /** An AST node. */
  class AstNode {
    /** Gets a textual representation of this AST node. */
    string toString();

    /** Gets the location of this AST node. */
    Location getLocation();
  }

  /** A callable, for example a function, method, constructor, or top-level script. */
  class Callable;

  /** A control flow node. */
  class ControlFlowNode {
    /** Gets a textual representation of this control flow node. */
    string toString();

    /** Gets the location of this control flow node. */
    Location getLocation();

    /** Gets the basic block containing this control flow node. */
    BasicBlock getBasicBlock();

    /**
     * Holds if this is the unique control flow node that represents the
     * given AST node.
     */
    predicate injects(AstNode n);

    /** Gets the enclosing callable of this control flow node. */
    Callable getEnclosingCallable();
  }

  /**
   * A basic block, that is, a maximal straight-line sequence of control flow nodes
   * without branches or joins.
   */
  class BasicBlock {
    /** Gets a textual representation of this basic block. */
    string toString();

    /** Gets the location of this basic block. */
    Location getLocation();

    /** Gets the control flow node at a specific (zero-indexed) position in this basic block. */
    ControlFlowNode getNode(int pos);

    /** Gets an immediate successor of this basic block of a given type, if any. */
    BasicBlock getASuccessor(SuccessorType t);

    /** Gets the enclosing callable of this basic block. */
    Callable getEnclosingCallable();
  }
}

signature class TypSig;

signature module InputSig<TypSig AstNode, TypSig Callable> {
  /** Gets the parent of `node`. */
  AstNode getParent(AstNode node);

  /** Gets the immediately enclosing callable that contains `node`. */
  Callable getEnclosingCallable(AstNode node);
}

/**
 * Constructs several query predicates for testing the CFG in an inline expectation qltest.
 *
 * The output is based on basic block slices, that is, block segments cut by line boundaries.
 * Ordinary left-to-right intra-block control flow is elided, but everything else is represented.
 *
 * A nested module `BlockSlices` can be imported to dump all basic block slices.
 */
module Make<LocationSig Location, CfgSig<Location> Cfg, InputSig<Cfg::AstNode, Cfg::Callable> Input>
{
  private import Cfg

  /**
   * Gets the rank of `n` within `bb` restricted to nodes that are canonical
   * representatives of AST nodes.
   */
  private int bbRank(ControlFlowNode n, BasicBlock bb) {
    n =
      rank[result](ControlFlowNode n0, int i | n0.injects(_) and bb.getNode(i) = n0 | n0 order by i)
  }

  /** Gets the start line of `n`. */
  private int getLine(ControlFlowNode n) { n.getLocation().getStartLine() = result }

  /** Holds if `n` is the first node of a slice of `bb` at the given line. */
  private predicate sliceStart(int line, ControlFlowNode n, BasicBlock bb) {
    line = getLine(n) and
    1 = bbRank(n, bb)
    or
    exists(ControlFlowNode n0 |
      line = getLine(n) and
      bbRank(n0, bb) + 1 = bbRank(n, bb) and
      getLine(n0) != line
    )
  }

  private newtype TSlice =
    TMkSlice(int line, ControlFlowNode n, BasicBlock bb) { sliceStart(line, n, bb) }

  /** A slice of a basic block at a specific line. */
  private class Slice extends TSlice {
    private int line;
    private ControlFlowNode start;
    private BasicBlock bb;

    Slice() { this = TMkSlice(line, start, bb) }

    string toString() { result = start.toString() }

    int getLine() { result = line }

    ControlFlowNode getNode(int i) {
      i = 0 and result = start
      or
      bbRank(this.getNode(i - 1), bb) + 1 = bbRank(result, bb) and
      not sliceStart(_, result, bb)
    }

    ControlFlowNode getLast() {
      exists(int i | result = this.getNode(i) and not exists(this.getNode(i + 1)))
    }

    predicate step(ControlFlowNode n1, ControlFlowNode n2) {
      exists(int i | n1 = this.getNode(i) and n2 = this.getNode(i + 1))
    }
  }

  /**
   * A direction in the location-induced AST restricted to a single line, that
   * is, the tree arising from location-nesting.
   *
   * - `Up` and `Down` indicate location nesting.
   * - `Right` indicates a non-overlapping location to the right.
   * - `Id` indicates the same location.
   * - `Other` most likely indicates a non-overlapping location to the left,
   *    but remains a catch-all for any other case.
   */
  private newtype Dir =
    Down() or
    Up() or
    Right() or
    Id() or
    Other()

  /**
   * Holds if `n1` steps to `n2` within a basic block line slice and that the
   * corresponding AST nodes are related with one being a transitive parent of
   * the other. The direction in the AST is given by `dir`.
   */
  private predicate astUpDownStep(ControlFlowNode n1, ControlFlowNode n2, Dir dir) {
    exists(AstNode a1, AstNode a2 |
      n1.injects(a1) and
      n2.injects(a2) and
      any(Slice s).step(n1, n2)
    |
      if Input::getParent+(a1) = a2
      then dir = Up()
      else
        if Input::getParent+(a2) = a1
        then dir = Down()
        else none()
    )
  }

  bindingset[l1, l2]
  pragma[inline_late]
  private predicate endsLessThan(Location l1, Location l2) {
    l1.getEndLine() < l2.getEndLine()
    or
    l1.getEndLine() = l2.getEndLine() and
    l1.getEndColumn() <= l2.getEndColumn()
  }

  private predicate oneline(Location l) { l.getStartLine() = l.getEndLine() }

  /**
   * Holds if `n1` steps to `n2` within a basic block line slice `slice` and
   * that the step in locations is given by `dir`. Some identical locations may
   * be further resolved by peeking at the AST structure.
   */
  private predicate singleLineBlockStep(Slice slice, ControlFlowNode n1, ControlFlowNode n2, Dir dir) {
    slice.step(n1, n2) and
    exists(Location l1, Location l2 | n1.getLocation() = l1 and n2.getLocation() = l2 |
      if oneline(l1) and l1.getEndColumn() < l2.getStartColumn()
      then dir = Right()
      else
        if
          l1.getStartColumn() <= l2.getStartColumn() and
          endsLessThan(l2, l1) and
          l1 != l2
        then dir = Down()
        else
          if
            l2.getStartColumn() <= l1.getStartColumn() and
            endsLessThan(l1, l2) and
            l1 != l2
          then dir = Up()
          else
            if l1 != l2
            then dir = Other()
            else (
              astUpDownStep(n1, n2, dir)
              or
              not astUpDownStep(n1, n2, _) and dir = Id()
            )
    )
  }

  /**
   * Holds if the slice `slice` is simple left-to-right evaluation order.
   *
   * Both pre-order and post-order traversal is allowed and allowed to be
   * mixed. `Up` indicates the last part of a post-order traversal, and `Down`
   * indicates the first part of a pre-order traversal, so an `Up` step
   * followed by a `Down` step is inconsistent with simple left-to-right
   * evaluation order.
   */
  private predicate simpleLeftToRightBlock(Slice slice) {
    forall(ControlFlowNode n1, ControlFlowNode n2 | singleLineBlockStep(slice, n1, n2, _) |
      exists(Dir dir | singleLineBlockStep(slice, n1, n2, dir) |
        dir != Other() and
        dir != Id() and
        (dir = Up() implies not singleLineBlockStep(slice, n2, _, Down()))
      )
    )
  }

  private string outgoingArrow(ControlFlowNode n) {
    exists(Dir dir | singleLineBlockStep(_, n, _, dir) |
      dir = Down() and result = " -V "
      or
      dir = Up() and result = " -^ "
      or
      dir = Right() and result = " -> "
      or
      dir = Id() and result = " -I "
      or
      dir = Other() and result = " -? "
    )
  }

  /** Provides a query for dumping every line-based slice of a basic block. */
  module BlockSlices {
    /**
     * Holds if `blockSlice` is a string representation of a `line` slice of a
     * basic block. `first` is the first node in the slice.
     */
    query predicate blockSlice(int line, ControlFlowNode first, string blockSlice) {
      exists(Slice slice |
        first = slice.getNode(0) and
        line = slice.getLine() and
        blockSlice =
          "'" +
            strictconcat(ControlFlowNode n, int i, int j, string s |
              slice.getNode(i) = n and
              (
                j = 0 and s = n.toString()
                or
                j = 1 and s = outgoingArrow(n)
              )
            |
              s order by i, j
            ) + "'"
      )
    }
  }

  final private class FinalControlFlowNode = ControlFlowNode;

  /** A `ControlFlowNode` with its location trimmed to a single line. */
  class ControlFlowNode1line extends FinalControlFlowNode {
    /**
     * Holds if this element is at the specified location.
     * The location spans column `sc` of line `sl` to
     * column `ec` of line `el` in file `file`.
     * For more information, see
     * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
     */
    predicate hasLocationInfo(string file, int sl, int sc, int el, int ec) {
      exists(int el0, int ec0 |
        super.getLocation().hasLocationInfo(file, sl, sc, el0, ec0) and
        if el0 != sl then el = sl and ec = sc else (el = el0 and ec = ec0)
      )
    }
  }

  /**
   * Holds if `blockSlice` is a string representation of a line slice of a
   * basic block that does not follow simple left-to-right evaluation order.
   * `first` is the first node in the slice.
   */
  query predicate nonSimple(ControlFlowNode1line first, string blockSlice) {
    exists(Slice slice |
      BlockSlices::blockSlice(_, first, blockSlice) and
      slice.getNode(0) = first and
      not simpleLeftToRightBlock(slice)
    )
  }

  /**
   * Holds if some AST node on `line` has a corresponding CFG node within the
   * callable `c`.
   */
  private predicate lineHasCfg(int line, Callable c) {
    exists(ControlFlowNode n, Location loc |
      n.getLocation() = loc and
      loc.getStartLine() = line and
      oneline(loc) and
      n.injects(_) and
      n.getEnclosingCallable() = c
    )
  }

  /**
   * Holds if `n1` and `n2` are consecutive nodes in a basic block (skipping
   * over non-AST nodes), but are located on different lines, such that `n1`
   * and `n2` link two line slices of a basic block. Additionally, the link is
   * required to be non-trivial in the sense that it either goes backwards (the
   * `lineDelta` is negative) or it skips over some lines with other CFG nodes.
   */
  private predicate nonTrivialSliceLink(
    int line, ControlFlowNode n1, ControlFlowNode n2, int lineDelta
  ) {
    line = n1.getLocation().getStartLine() and
    exists(BasicBlock bb |
      n1 = any(Slice slice).getLast() and
      bbRank(n1, bb) + 1 = bbRank(n2, bb)
    ) and
    lineDelta = n2.getLocation().getStartLine() - n1.getLocation().getStartLine() and
    (lineDelta < 0 or lineHasCfg([line + 1 .. line + lineDelta - 1], n1.getEnclosingCallable()))
  }

  bindingset[lineDelta]
  private string ppDelta(int lineDelta) {
    if lineDelta < 0
    then result = "(" + lineDelta.toString() + ")"
    else result = "(+" + lineDelta.toString() + ")"
  }

  /**
   * Holds if the line slice ending at `n1` continues to another line slice via
   * a non-trivial link. That is, it does not simply continue to the next line.
   */
  query predicate bbContinues(ControlFlowNode1line n1, string link) {
    exists(ControlFlowNode n2, int lineDelta |
      nonTrivialSliceLink(_, n1, n2, lineDelta) and
      link = "'" + n1.toString() + " goto " + n2.toString() + ppDelta(lineDelta) + "'"
    )
  }

  /**
   * Holds if `bb` only includes synthetic nodes, that is, no AST nodes are
   * canonically represented in it.
   */
  private predicate synthBlock(BasicBlock bb) { not exists(bbRank(_, bb)) }

  /**
   * Holds if `bb1` transitively reaches `bb2` through a sequence of basic
   * block steps where `bb2` is the only non-`synthBlock`.
   */
  private predicate synthStep(BasicBlock bb1, BasicBlock bb2, string successorSuffix) {
    bb1 = bb2 and successorSuffix = "" and not synthBlock(bb2)
    or
    exists(BasicBlock mid, SuccessorType t, string s |
      synthBlock(bb1) and
      bb1.getASuccessor(t) = mid and
      synthStep(mid, bb2, s) and
      if t instanceof DirectSuccessor
      then successorSuffix = s
      else successorSuffix = "," + t.toString() + s
    )
  }

  /**
   * Holds if there is a basic block step from `n1` to `n2` with successor
   * type `t` originating at the given line.
   */
  private predicate bbStep(
    int line, ControlFlowNode n1, ControlFlowNode n2, SuccessorType t, string successorSuffix,
    int lineDelta
  ) {
    exists(int last, BasicBlock bb1, BasicBlock mid, BasicBlock bb2 |
      line = n1.getLocation().getStartLine() and
      last = bbRank(n1, bb1) and
      not last + 1 = bbRank(_, bb1) and
      bb1.getASuccessor(t) = mid and
      synthStep(mid, bb2, successorSuffix) and
      1 = bbRank(n2, bb2) and
      lineDelta = n2.getLocation().getStartLine() - n1.getLocation().getStartLine()
    )
  }

  /**
   * Holds if there is a basic block step from `n1` described by `next`.
   */
  query predicate bbStep(ControlFlowNode1line n1, string next) {
    exists(ControlFlowNode n2, SuccessorType t, string s, int lineDelta |
      bbStep(_, n1, n2, t, s, lineDelta) and
      next = "'" + n1.toString() + " : " + t + s + " -> " + n2.toString() + ppDelta(lineDelta) + "'"
    )
  }

  /**
   * Holds if no CFG nodes exist in `c` on `line` and `a` is an AST node on
   * that line.
   */
  private predicate unreachable(int line, Callable c, AstNode a) {
    oneline(a.getLocation()) and
    a.getLocation().getStartLine() = line and
    Input::getEnclosingCallable(a) = c and
    not exists(ControlFlowNode n |
      n.injects(_) and
      oneline(n.getLocation()) and
      n.getLocation().getStartLine() = line and
      n.getEnclosingCallable() = c
    )
  }

  /**
   * Holds if no CFG nodes exist in `c` on `line` and `a` is the first AST
   * node on that line.
   */
  private predicate firstUnreachable(int line, Callable c, AstNode a) {
    a =
      min(AstNode a0, Location loc |
        unreachable(line, c, a0) and loc = a0.getLocation()
      |
        a0 order by loc.getStartColumn(), loc.getEndColumn()
      )
  }

  /**
   * Holds if no CFG nodes exist in the callable of `a` on the same line as
   * `a`, and `a` is the first AST node on that line.
   */
  query predicate noCfg(AstNode a) { firstUnreachable(_, _, a) }
}
