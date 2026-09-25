/**
 * @name Cyclic join
 * @description Finds non-recursive predicate bodies and query `where` clauses whose
 *              join graph contains an irreducible cycle (a triangle or a chordless
 *              cycle of length 4, 5, 6, 7, 8, 9 or 10). Such alpha-cyclic conjunctive joins cannot
 *              be evaluated optimally by any binary join plan and are the canonical case
 *              that worst-case-optimal join algorithms (e.g. Leapfrog Triejoin) accelerate.
 * @id ql/cyclic-join
 * @tags performance
 *       join-order
 */

import ql
import codeql_ql.ast.internal.AstNodeNumbering

/**
 * A scope that gives rise to a conjunctive join: a predicate body or a query's
 * `from`/`where`. Atoms within the same scope are (positively) conjoined.
 */
class JoinScope extends AstNode {
  JoinScope() {
    this instanceof Predicate or
    this instanceof Select
  }
}

/** Gets the nearest enclosing predicate or select of `n`. */
JoinScope getScope(AstNode n) {
  result = n.getParent+() and
  not exists(JoinScope closer |
    closer = n.getParent+() and
    result = closer.getParent+()
  )
}

/** Holds if `f` combines sub-formulas, i.e. it is not a single join atom. */
predicate isConnective(Formula f) {
  f instanceof Conjunction or
  f instanceof Disjunction or
  f instanceof Negation or
  f instanceof Quantifier or
  f instanceof IfFormula or
  f instanceof Implication or
  f instanceof HigherOrderFormula
}

/**
 * An atomic formula: a leaf formula sitting in formula position inside a
 * conjunctive context (its parent is a connective, a `select`, or a predicate
 * body). Atoms nested inside an expression/another atom, or inside a `not`,
 * are excluded because they do not contribute positive join edges.
 */
class Atom extends Formula {
  Atom() {
    not isConnective(this) and
    exists(AstNode p | p = this.getParent() |
      isConnective(p) or
      p instanceof Select or
      p instanceof Predicate
    ) and
    not this.getParent+() instanceof Negation
  }
}

/** Holds if atom `a` references variable `v`. */
predicate touches(Atom a, VarDef v) {
  exists(VarAccess va | va = a.getAChild*() and va.getDeclaration() = v)
}

/** Holds if atom `a` uses a transitive-closure (`+`/`*`) call, i.e. is recursive. */
predicate isRecursiveAtom(Atom a) {
  exists(Call c | c = a.getAChild*() and c.isClosure(_))
}

/**
 * Holds if, within scope `s`, there is a (non-recursive) atom joining the two
 * distinct variables `u` and `v` -- an edge of the primal (join) graph.
 */
predicate primalEdge(JoinScope s, VarDef u, VarDef v) {
  u != v and
  exists(Atom a |
    getScope(a) = s and
    not isRecursiveAtom(a) and
    touches(a, u) and
    touches(a, v)
  )
}

/**
 * Holds if scope `s` contains an irreducible triangle over the distinct
 * variables `x < y < z`. "Irreducible" means no single atom covers all three
 * variables, so the three edges necessarily come from three different atoms and
 * the join is genuinely alpha-cyclic (not GYO-reducible).
 */
predicate triangle(JoinScope s, VarDef x, VarDef y, VarDef z) {
  getPreOrderId(x) < getPreOrderId(y) and
  getPreOrderId(y) < getPreOrderId(z) and
  primalEdge(s, x, y) and
  primalEdge(s, y, z) and
  primalEdge(s, x, z) and
  // conformality: no atom covers the whole clique (which would make it acyclic)
  not exists(Atom cover |
    getScope(cover) = s and
    touches(cover, x) and
    touches(cover, y) and
    touches(cover, z)
  )
}

/**
 * Holds if scope `s` contains a chordless 4-cycle `p0 - p1 - p2 - p3 - p0` over
 * four distinct variables. Chordlessness (no diagonal edge) guarantees the cycle
 * is irreducible/alpha-cyclic and that no atom covers it. `p0` is the minimum and
 * `p1 < p3` to report each such cycle once.
 */
predicate square(JoinScope s, VarDef p0, VarDef p1, VarDef p2, VarDef p3) {
  getPreOrderId(p0) < getPreOrderId(p1) and
  getPreOrderId(p0) < getPreOrderId(p2) and
  getPreOrderId(p0) < getPreOrderId(p3) and
  getPreOrderId(p1) < getPreOrderId(p3) and
  p1 != p2 and
  p2 != p3 and
  // the four sides
  primalEdge(s, p0, p1) and
  primalEdge(s, p1, p2) and
  primalEdge(s, p2, p3) and
  primalEdge(s, p3, p0) and
  // the two diagonals must be absent (chordless)
  not primalEdge(s, p0, p2) and
  not primalEdge(s, p1, p3)
}

/**
 * Holds if scope `s` contains a chordless 5-cycle `p0 - p1 - p2 - p3 - p4 - p0`
 * over five distinct variables. `p0` is the minimum and `p1 < p4` orients the
 * cycle so each one is reported once; all five chords are required absent, which
 * also rules out any covering atom (irreducible/alpha-cyclic).
 */
predicate pentagon(JoinScope s, VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4) {
  getPreOrderId(p0) < getPreOrderId(p1) and
  getPreOrderId(p0) < getPreOrderId(p2) and
  getPreOrderId(p0) < getPreOrderId(p3) and
  getPreOrderId(p0) < getPreOrderId(p4) and
  getPreOrderId(p1) < getPreOrderId(p4) and
  p1 != p3 and
  p2 != p4 and
  // the five sides
  primalEdge(s, p0, p1) and
  primalEdge(s, p1, p2) and
  primalEdge(s, p2, p3) and
  primalEdge(s, p3, p4) and
  primalEdge(s, p4, p0) and
  // all five chords must be absent (chordless)
  not primalEdge(s, p0, p2) and
  not primalEdge(s, p0, p3) and
  not primalEdge(s, p1, p3) and
  not primalEdge(s, p1, p4) and
  not primalEdge(s, p2, p4)
}

/**
 * Holds if scope `s` contains a chordless 6-cycle
 * `p0 - p1 - p2 - p3 - p4 - p5 - p0` over six distinct variables. `p0` is the
 * minimum and `p1 < p5` orients the cycle so each one is reported once; all nine
 * chords are required absent, which also rules out any covering atom.
 */
predicate hexagon(JoinScope s, VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4, VarDef p5) {
  getPreOrderId(p0) < getPreOrderId(p1) and
  getPreOrderId(p0) < getPreOrderId(p2) and
  getPreOrderId(p0) < getPreOrderId(p3) and
  getPreOrderId(p0) < getPreOrderId(p4) and
  getPreOrderId(p0) < getPreOrderId(p5) and
  getPreOrderId(p1) < getPreOrderId(p5) and
  p1 != p3 and
  p1 != p4 and
  p2 != p4 and
  p2 != p5 and
  p3 != p5 and
  // the six sides
  primalEdge(s, p0, p1) and
  primalEdge(s, p1, p2) and
  primalEdge(s, p2, p3) and
  primalEdge(s, p3, p4) and
  primalEdge(s, p4, p5) and
  primalEdge(s, p5, p0) and
  // all nine chords must be absent (chordless)
  not primalEdge(s, p0, p2) and
  not primalEdge(s, p0, p3) and
  not primalEdge(s, p0, p4) and
  not primalEdge(s, p1, p3) and
  not primalEdge(s, p1, p4) and
  not primalEdge(s, p1, p5) and
  not primalEdge(s, p2, p4) and
  not primalEdge(s, p2, p5) and
  not primalEdge(s, p3, p5)
}

/**
 * Holds if scope `s` contains a chordless 7-cycle
 * `p0 - p1 - p2 - p3 - p4 - p5 - p6 - p0` over seven distinct variables. `p0` is
 * the minimum and `p1 < p6` orients the cycle so each one is reported once; all 14
 * chords are required absent, which also rules out any covering atom.
 */
predicate heptagon(
  JoinScope s, VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4, VarDef p5, VarDef p6
) {
  getPreOrderId(p0) < getPreOrderId(p1) and
  getPreOrderId(p0) < getPreOrderId(p2) and
  getPreOrderId(p0) < getPreOrderId(p3) and
  getPreOrderId(p0) < getPreOrderId(p4) and
  getPreOrderId(p0) < getPreOrderId(p5) and
  getPreOrderId(p0) < getPreOrderId(p6) and
  getPreOrderId(p1) < getPreOrderId(p6) and
  p1 != p3 and
  p1 != p4 and
  p1 != p5 and
  p2 != p4 and
  p2 != p5 and
  p2 != p6 and
  p3 != p5 and
  p3 != p6 and
  p4 != p6 and
  // the seven sides
  primalEdge(s, p0, p1) and
  primalEdge(s, p1, p2) and
  primalEdge(s, p2, p3) and
  primalEdge(s, p3, p4) and
  primalEdge(s, p4, p5) and
  primalEdge(s, p5, p6) and
  primalEdge(s, p6, p0) and
  // all 14 chords must be absent (chordless)
  not primalEdge(s, p0, p2) and
  not primalEdge(s, p0, p3) and
  not primalEdge(s, p0, p4) and
  not primalEdge(s, p0, p5) and
  not primalEdge(s, p1, p3) and
  not primalEdge(s, p1, p4) and
  not primalEdge(s, p1, p5) and
  not primalEdge(s, p1, p6) and
  not primalEdge(s, p2, p4) and
  not primalEdge(s, p2, p5) and
  not primalEdge(s, p2, p6) and
  not primalEdge(s, p3, p5) and
  not primalEdge(s, p3, p6) and
  not primalEdge(s, p4, p6)
}

/**
 * Holds if scope `s` contains a chordless 8-cycle
 * `p0 - p1 - p2 - p3 - p4 - p5 - p6 - p7 - p0` over eight distinct variables. `p0`
 * is the minimum and `p1 < p7` orients the cycle so each one is reported once; all
 * 20 chords are required absent, which also rules out any covering atom.
 */
predicate octagon(
  JoinScope s, VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4, VarDef p5, VarDef p6,
  VarDef p7
) {
  getPreOrderId(p0) < getPreOrderId(p1) and
  getPreOrderId(p0) < getPreOrderId(p2) and
  getPreOrderId(p0) < getPreOrderId(p3) and
  getPreOrderId(p0) < getPreOrderId(p4) and
  getPreOrderId(p0) < getPreOrderId(p5) and
  getPreOrderId(p0) < getPreOrderId(p6) and
  getPreOrderId(p0) < getPreOrderId(p7) and
  getPreOrderId(p1) < getPreOrderId(p7) and
  p1 != p3 and
  p1 != p4 and
  p1 != p5 and
  p1 != p6 and
  p2 != p4 and
  p2 != p5 and
  p2 != p6 and
  p2 != p7 and
  p3 != p5 and
  p3 != p6 and
  p3 != p7 and
  p4 != p6 and
  p4 != p7 and
  p5 != p7 and
  // the eight sides
  primalEdge(s, p0, p1) and
  primalEdge(s, p1, p2) and
  primalEdge(s, p2, p3) and
  primalEdge(s, p3, p4) and
  primalEdge(s, p4, p5) and
  primalEdge(s, p5, p6) and
  primalEdge(s, p6, p7) and
  primalEdge(s, p7, p0) and
  // all 20 chords must be absent (chordless)
  not primalEdge(s, p0, p2) and
  not primalEdge(s, p0, p3) and
  not primalEdge(s, p0, p4) and
  not primalEdge(s, p0, p5) and
  not primalEdge(s, p0, p6) and
  not primalEdge(s, p1, p3) and
  not primalEdge(s, p1, p4) and
  not primalEdge(s, p1, p5) and
  not primalEdge(s, p1, p6) and
  not primalEdge(s, p1, p7) and
  not primalEdge(s, p2, p4) and
  not primalEdge(s, p2, p5) and
  not primalEdge(s, p2, p6) and
  not primalEdge(s, p2, p7) and
  not primalEdge(s, p3, p5) and
  not primalEdge(s, p3, p6) and
  not primalEdge(s, p3, p7) and
  not primalEdge(s, p4, p6) and
  not primalEdge(s, p4, p7) and
  not primalEdge(s, p5, p7)
}

/**
 * Holds if scope `s` contains a chordless 9-cycle
 * `p0 - p1 - p2 - p3 - p4 - p5 - p6 - p7 - p8 - p0` over nine distinct variables.
 * `p0` is the minimum and `p1 < p8` orients the cycle so each one is reported once;
 * all 27 chords are required absent, which also rules out any covering atom.
 */
predicate enneagon(
  JoinScope s, VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4, VarDef p5, VarDef p6,
  VarDef p7, VarDef p8
) {
  getPreOrderId(p0) < getPreOrderId(p1) and
  getPreOrderId(p0) < getPreOrderId(p2) and
  getPreOrderId(p0) < getPreOrderId(p3) and
  getPreOrderId(p0) < getPreOrderId(p4) and
  getPreOrderId(p0) < getPreOrderId(p5) and
  getPreOrderId(p0) < getPreOrderId(p6) and
  getPreOrderId(p0) < getPreOrderId(p7) and
  getPreOrderId(p0) < getPreOrderId(p8) and
  getPreOrderId(p1) < getPreOrderId(p8) and
  p1 != p3 and
  p1 != p4 and
  p1 != p5 and
  p1 != p6 and
  p1 != p7 and
  p2 != p4 and
  p2 != p5 and
  p2 != p6 and
  p2 != p7 and
  p2 != p8 and
  p3 != p5 and
  p3 != p6 and
  p3 != p7 and
  p3 != p8 and
  p4 != p6 and
  p4 != p7 and
  p4 != p8 and
  p5 != p7 and
  p5 != p8 and
  p6 != p8 and
  // the nine sides
  primalEdge(s, p0, p1) and
  primalEdge(s, p1, p2) and
  primalEdge(s, p2, p3) and
  primalEdge(s, p3, p4) and
  primalEdge(s, p4, p5) and
  primalEdge(s, p5, p6) and
  primalEdge(s, p6, p7) and
  primalEdge(s, p7, p8) and
  primalEdge(s, p8, p0) and
  // all 27 chords must be absent (chordless)
  not primalEdge(s, p0, p2) and
  not primalEdge(s, p0, p3) and
  not primalEdge(s, p0, p4) and
  not primalEdge(s, p0, p5) and
  not primalEdge(s, p0, p6) and
  not primalEdge(s, p0, p7) and
  not primalEdge(s, p1, p3) and
  not primalEdge(s, p1, p4) and
  not primalEdge(s, p1, p5) and
  not primalEdge(s, p1, p6) and
  not primalEdge(s, p1, p7) and
  not primalEdge(s, p1, p8) and
  not primalEdge(s, p2, p4) and
  not primalEdge(s, p2, p5) and
  not primalEdge(s, p2, p6) and
  not primalEdge(s, p2, p7) and
  not primalEdge(s, p2, p8) and
  not primalEdge(s, p3, p5) and
  not primalEdge(s, p3, p6) and
  not primalEdge(s, p3, p7) and
  not primalEdge(s, p3, p8) and
  not primalEdge(s, p4, p6) and
  not primalEdge(s, p4, p7) and
  not primalEdge(s, p4, p8) and
  not primalEdge(s, p5, p7) and
  not primalEdge(s, p5, p8) and
  not primalEdge(s, p6, p8)
}

/**
 * Holds if scope `s` contains a chordless 10-cycle
 * `p0 - p1 - p2 - p3 - p4 - p5 - p6 - p7 - p8 - p9 - p0` over ten distinct
 * variables. `p0` is the minimum and `p1 < p9` orients the cycle so each one is
 * reported once; all 35 chords are required absent, which also rules out any
 * covering atom.
 */
predicate decagon(
  JoinScope s, VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4, VarDef p5, VarDef p6,
  VarDef p7, VarDef p8, VarDef p9
) {
  getPreOrderId(p0) < getPreOrderId(p1) and
  getPreOrderId(p0) < getPreOrderId(p2) and
  getPreOrderId(p0) < getPreOrderId(p3) and
  getPreOrderId(p0) < getPreOrderId(p4) and
  getPreOrderId(p0) < getPreOrderId(p5) and
  getPreOrderId(p0) < getPreOrderId(p6) and
  getPreOrderId(p0) < getPreOrderId(p7) and
  getPreOrderId(p0) < getPreOrderId(p8) and
  getPreOrderId(p0) < getPreOrderId(p9) and
  getPreOrderId(p1) < getPreOrderId(p9) and
  p1 != p3 and
  p1 != p4 and
  p1 != p5 and
  p1 != p6 and
  p1 != p7 and
  p1 != p8 and
  p2 != p4 and
  p2 != p5 and
  p2 != p6 and
  p2 != p7 and
  p2 != p8 and
  p2 != p9 and
  p3 != p5 and
  p3 != p6 and
  p3 != p7 and
  p3 != p8 and
  p3 != p9 and
  p4 != p6 and
  p4 != p7 and
  p4 != p8 and
  p4 != p9 and
  p5 != p7 and
  p5 != p8 and
  p5 != p9 and
  p6 != p8 and
  p6 != p9 and
  p7 != p9 and
  // the ten sides
  primalEdge(s, p0, p1) and
  primalEdge(s, p1, p2) and
  primalEdge(s, p2, p3) and
  primalEdge(s, p3, p4) and
  primalEdge(s, p4, p5) and
  primalEdge(s, p5, p6) and
  primalEdge(s, p6, p7) and
  primalEdge(s, p7, p8) and
  primalEdge(s, p8, p9) and
  primalEdge(s, p9, p0) and
  // all 35 chords must be absent (chordless)
  not primalEdge(s, p0, p2) and
  not primalEdge(s, p0, p3) and
  not primalEdge(s, p0, p4) and
  not primalEdge(s, p0, p5) and
  not primalEdge(s, p0, p6) and
  not primalEdge(s, p0, p7) and
  not primalEdge(s, p0, p8) and
  not primalEdge(s, p1, p3) and
  not primalEdge(s, p1, p4) and
  not primalEdge(s, p1, p5) and
  not primalEdge(s, p1, p6) and
  not primalEdge(s, p1, p7) and
  not primalEdge(s, p1, p8) and
  not primalEdge(s, p1, p9) and
  not primalEdge(s, p2, p4) and
  not primalEdge(s, p2, p5) and
  not primalEdge(s, p2, p6) and
  not primalEdge(s, p2, p7) and
  not primalEdge(s, p2, p8) and
  not primalEdge(s, p2, p9) and
  not primalEdge(s, p3, p5) and
  not primalEdge(s, p3, p6) and
  not primalEdge(s, p3, p7) and
  not primalEdge(s, p3, p8) and
  not primalEdge(s, p3, p9) and
  not primalEdge(s, p4, p6) and
  not primalEdge(s, p4, p7) and
  not primalEdge(s, p4, p8) and
  not primalEdge(s, p4, p9) and
  not primalEdge(s, p5, p7) and
  not primalEdge(s, p5, p8) and
  not primalEdge(s, p5, p9) and
  not primalEdge(s, p6, p8) and
  not primalEdge(s, p6, p9) and
  not primalEdge(s, p7, p9)
}

/** Gets a printable name for `v`. */
string varName(VarDef v) { result = v.getName() }

/**
 * Holds if scope `s` contains an irreducible cyclic join of length `len` over
 * the variables described by `vars`.
 */
predicate cyclicJoin(JoinScope s, int len, string vars) {
  exists(VarDef x, VarDef y, VarDef z |
    triangle(s, x, y, z) and
    len = 3 and
    vars = varName(x) + ", " + varName(y) + ", " + varName(z)
  )
  or
  exists(VarDef p0, VarDef p1, VarDef p2, VarDef p3 |
    square(s, p0, p1, p2, p3) and
    len = 4 and
    vars = varName(p0) + ", " + varName(p1) + ", " + varName(p2) + ", " + varName(p3)
  )
  or
  exists(VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4 |
    pentagon(s, p0, p1, p2, p3, p4) and
    len = 5 and
    vars =
      varName(p0) + ", " + varName(p1) + ", " + varName(p2) + ", " + varName(p3) + ", " +
        varName(p4)
  )
  or
  exists(VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4, VarDef p5 |
    hexagon(s, p0, p1, p2, p3, p4, p5) and
    len = 6 and
    vars =
      varName(p0) + ", " + varName(p1) + ", " + varName(p2) + ", " + varName(p3) + ", " +
        varName(p4) + ", " + varName(p5)
  )
  or
  exists(VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4, VarDef p5, VarDef p6 |
    heptagon(s, p0, p1, p2, p3, p4, p5, p6) and
    len = 7 and
    vars =
      varName(p0) + ", " + varName(p1) + ", " + varName(p2) + ", " + varName(p3) + ", " +
        varName(p4) + ", " + varName(p5) + ", " + varName(p6)
  )
  or
  exists(
    VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4, VarDef p5, VarDef p6, VarDef p7
  |
    octagon(s, p0, p1, p2, p3, p4, p5, p6, p7) and
    len = 8 and
    vars =
      varName(p0) + ", " + varName(p1) + ", " + varName(p2) + ", " + varName(p3) + ", " +
        varName(p4) + ", " + varName(p5) + ", " + varName(p6) + ", " + varName(p7)
  )
  or
  exists(
    VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4, VarDef p5, VarDef p6, VarDef p7,
    VarDef p8
  |
    enneagon(s, p0, p1, p2, p3, p4, p5, p6, p7, p8) and
    len = 9 and
    vars =
      varName(p0) + ", " + varName(p1) + ", " + varName(p2) + ", " + varName(p3) + ", " +
        varName(p4) + ", " + varName(p5) + ", " + varName(p6) + ", " + varName(p7) + ", " +
        varName(p8)
  )
  or
  exists(
    VarDef p0, VarDef p1, VarDef p2, VarDef p3, VarDef p4, VarDef p5, VarDef p6, VarDef p7,
    VarDef p8, VarDef p9
  |
    decagon(s, p0, p1, p2, p3, p4, p5, p6, p7, p8, p9) and
    len = 10 and
    vars =
      varName(p0) + ", " + varName(p1) + ", " + varName(p2) + ", " + varName(p3) + ", " +
        varName(p4) + ", " + varName(p5) + ", " + varName(p6) + ", " + varName(p7) + ", " +
        varName(p8) + ", " + varName(p9)
  )
}

from JoinScope s, int len, string vars
where cyclicJoin(s, len, vars)
select s,
  "This " + s.getAPrimaryQlClass() + " contains a non-recursive cyclic (" + len.toString() +
    "-cycle) join over variables: " + vars + "."
