/**
 * @name Useless assignment to field
 * @description An assignment to a field that is not used later on has no effect.
 * @kind problem
 * @problem.severity warning
 * @id go/useless-assignment-to-field
 * @tags maintainability
 *       external/cwe/cwe-563
 * @precision very-high
 */

import go

/**
 * Holds if `nd` escapes, that is, its value flows into the heap or across
 * function boundaries.
 */
predicate escapes(DataFlow::Node nd) {
  // if `nd` is written to something that is not an SSA variable (such as
  // a global variable, a field or an array element), then it escapes
  exists(Write w |
    nd = w.getRhs() and
    not w.definesSsaVariable(_, _)
  )
  or
  // if `nd` is used as an index into an array or similar, then it escapes
  exists(IndexExpr idx | nd.asExpr() = idx.getIndex())
  or
  // if `nd` is used in an (in-)equality comparison, then it escapes
  exists(EqualityTestExpr eq | nd.asExpr() = eq.getAnOperand())
  or
  // if `nd` is returned from a function, then it escapes
  nd instanceof DataFlow::ResultNode
  or
  // if `nd` is sent over a channel, then it escapes
  exists(SendStmt s | nd.asExpr() = s.getValue())
  or
  // if `nd` is passed to a function, then it escapes
  nd instanceof DataFlow::ArgumentNode
  or
  // if `nd` has its address taken, then it escapes
  exists(AddressExpr ae | nd.asExpr() = ae.getOperand())
  or
  // if `nd` is used as to look up a method with a pointer receiver, then it escapes
  exists(SelectorExpr sel | nd.asExpr() = sel.getBase() |
    exists(Method m | sel = m.getAReference() | m.getReceiverType() instanceof PointerType)
    or
    // if we cannot resolve a reference, we make worst-case assumptions
    not exists(sel.(Name).getTarget())
  )
  or
  // if `nd` flows into something that escapes, then it escapes
  escapes(nd.getASuccessor())
}

from Write w, LocalVariable v, Field f
where
  // `w` writes `f` on `v`
  w.writesField(v.getARead(), f, _) and
  // but `f` is never read on `v`
  not exists(Read r | r.readsField(v.getARead(), f)) and
  // exclude pointer-typed `v`; there may be reads through an alias
  not v.getType().getUnderlyingType() instanceof PointerType and
  // exclude escaping `v`; there may be reads in other functions
  not exists(Read r | r.reads(v) | escapes(r))
select w, "This assignment to " + f + " is useless since its value is never read."
